import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'data.dart';
import 'package:intl/intl.dart';

class SimPro extends StatefulWidget {
  SimPro({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SimProState createState() => _SimProState();
}

class _SimProState extends State<SimPro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Upload product',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ))),
          elevation: 0.5,
        ),
        body: SimpleProd());
  }
}

class SimpleProd extends StatefulWidget {
  @override
  _SimpleProdState createState() => _SimpleProdState();
}

class _SimpleProdState extends State<SimpleProd> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);
  @override
  Widget build(BuildContext context) {
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    var tstyle = TextStyle(
        color: Colors.black,
        fontFamily: 'Roboto-Regular',
        decoration: TextDecoration.underline,
        decorationColor: Colors.orange,
        decorationThickness: 2,
        fontSize: 20);
    pr.style(
        message: 'Downloading file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBuilder(
                key: _fbKey,
                // autovalidate: true,
                initialValue: {},
                readOnly: false,
                child: Column(children: <Widget>[
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Basic info",
                      style: tstyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 15),
                  // form options
                  FormBuilderImagePicker(
                    attribute: 'images',
                    decoration: const InputDecoration(
                      labelText: 'Images',
                    ),
                    maxImages: 5,
                    iconColor: Colors.orange,
                    // readOnly: true,
                    validators: [
                      FormBuilderValidators.required(),
                      (images) {
                        if (images.length < 2) {
                          return 'Two or more images required.';
                        }

                        return null;
                      }
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: 'product_name',
                    decoration: const InputDecoration(
                      labelText: "Product title",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          // borderRadius: new BorderRadius.circular(25.0),
                          // borderSide: new BorderSide(),
                          ),
                    ),
                    onChanged: _onChanged,
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(70),
                      FormBuilderValidators.minLength(2, allowEmpty: false),
                    ],
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                  ),

                  SizedBox(height: 15),
                  FormBuilderTypeAhead(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Category',
                    ),
                    attribute: 'category',
                    onChanged: _onChanged,
                    itemBuilder: (context, country) {
                      return ListTile(
                        title: Text(country),
                      );
                    },
                    controller: TextEditingController(text: ''),
                    initialValue: '',
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return allCat.where((country) {
                          return country.toLowerCase().contains(lowercaseQuery);
                        }).toList(growable: false)
                          ..sort((a, b) => a
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(
                                  b.toLowerCase().indexOf(lowercaseQuery)));
                      } else {
                        return allCat;
                      }
                    },
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: 'S_dis',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Short discription',
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.numeric(),

                      FormBuilderValidators.minLength(20, allowEmpty: false),
                    ],
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: 'F_dis',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full discription (optional)',
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      // FormBuilderValidators.numeric(),

                      FormBuilderValidators.minLength(20, allowEmpty: false),
                    ],
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Pricing and delivery",
                      style: tstyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 15),

                  FormBuilderTextField(
                      attribute: "price",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        // contentPadding: EdgeInsets.only(
                        //     top: 20), // add padding to adjust text
                        isDense: false,
                        labelText: "Price (₹)",
                        // prefixIcon: Padding(
                        //   padding: EdgeInsets.only(
                        //       top: 15), // add padding to adjust icon
                        //   child: Icon(Icons.attach_money),
                        // ),
                      ),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70000),
                      ],
                      keyboardType: TextInputType.number),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                      attribute: "sales_price",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        // contentPadding: EdgeInsets.only(
                        //     top: 20), // add padding to adjust text
                        isDense: false,
                        labelText: "Sales Price (₹)",
                        // prefixIcon: Padding(
                        //   padding: EdgeInsets.only(
                        //       top: 15), // add padding to adjust icon
                        //   child: Icon(Icons.attach_money),
                        // ),
                      ),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70000),
                      ],
                      keyboardType: TextInputType.number),
                  SizedBox(height: 5),
                  FormBuilderChoiceChip(
                    attribute: 'choice_chip',
                    decoration: const InputDecoration(
                      labelText: 'Select delivery vehicle',
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: '2', child: Text('two wheeler')),
                      FormBuilderFieldOption(
                          value: '4', child: Text('four wheeler')),
                    ],
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Stack Management",
                      style: tstyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                      attribute: "num_stacks",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(
                            top: 20), // add padding to adjust text
                        isDense: true,
                        labelText: "Number of stacks",
                        prefixIcon: Icon(Icons.format_list_numbered_rtl),
                      ),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(1000),
                      ],
                      keyboardType: TextInputType.number),

                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Offer coupon (optional)",
                      style: tstyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 15),

                  FormBuilderTextField(
                    attribute: 'coupon_code',
                    decoration: const InputDecoration(
                      labelText: "Coupon code",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          // borderRadius: new BorderRadius.circular(25.0),
                          // borderSide: new BorderSide(),
                          ),
                    ),
                    onChanged: _onChanged,
                    validators: [
                      FormBuilderValidators.max(10),
                      FormBuilderValidators.minLength(4),
                    ],
                    maxLines: 1,
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: 'D_price',
                    decoration: const InputDecoration(
                      labelText: "Discount price",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          // borderRadius: new BorderRadius.circular(25.0),
                          // borderSide: new BorderSide(),
                          ),
                    ),
                    onChanged: _onChanged,
                    validators: [
                      FormBuilderValidators.max(70),
                      FormBuilderValidators.minLength(2),
                    ],
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                  ),
                  SizedBox(height: 15),
                  FormBuilderDateRangePicker(
                    attribute: 'date_range',
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 20)),
                    format: DateFormat('dd-mm-yyyy'),
                    onChanged: _onChanged,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Validity',
                    ),
                  ),
                  FormBuilderSwitch(
                    label: Text('I Accept the tems and conditions'),
                    attribute: 'accept_terms_switch',
                    initialValue: false,
                    onChanged: _onChanged,
                  ),
                ])),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    var data = _fbKey.currentState;
                    StorageReference storageReference =
                        await FirebaseStorage.instance.ref();
                    var _images = data.fields['images'].currentState.value;
                    var imgurl = null;

                    DocumentReference ref = Firestore.instance
                        .collection("my_collection")
                        .document();
                    String prod_Id = ref.documentID;

                    //function to call

                    addImageToFirebase(index, image) async {
                      //CreateRefernce to path.
                      StorageReference ref =
                          storageReference.child("product_pics/$prod_Id/");
                      print("hello");
                      StorageUploadTask storageUploadTask =
                          ref.child("img$index.jpg").putFile(image);

                      if (storageUploadTask.isSuccessful ||
                          storageUploadTask.isComplete) {
                        final String url = await ref.getDownloadURL();
                        print("The download URL is " + url);
                      } else if (storageUploadTask.isInProgress) {
                        storageUploadTask.events.listen((event) {
                          double percentage = 100 *
                              (event.snapshot.bytesTransferred.toDouble() /
                                  event.snapshot.totalByteCount.toDouble());
                          print("THe percentage " + percentage.toString());
                        });

                        StorageTaskSnapshot storageTaskSnapshot =
                            await storageUploadTask.onComplete;
                        var downloadUrl1 =
                            await storageTaskSnapshot.ref.getDownloadURL();
                        print("Download URL " + downloadUrl1.toString());
                        return downloadUrl1.toString();
                      } else {
                        //Catch any cases here that might come up like canceled, interrupted
                      }
                    }

                    //get url of thumnail
                    getUrl() async {
                      // ignore: avoid_init_to_null
                      String url = null;
                      StorageReference ref = FirebaseStorage.instance
                          .ref()
                          .child(
                              "product_pics/$prod_Id/images/img0_120x120.jpg");
                               await Future.delayed(
                                      const Duration(seconds: 2), () {}),
                      try {
                        await ref
                            .getDownloadURL()
                            .then((value) => {url = value.toString()})
                            .catchError((error) async => {
                                  await Future.delayed(
                                      const Duration(seconds: 2), () {}),
                                  await ref
                                      .getDownloadURL()
                                      .then((value) => {url = value.toString()})
                                      .catchError((error) async => {
                                            await Future.delayed(
                                                const Duration(seconds: 5),
                                                () {}),
                                            url = (await ref.getDownloadURL())
                                                .toString()
                                          })
                                });
                      } on Exception catch (_) {
                        print('never reached');
                      }

                      return url;
                    }

                    if (data.saveAndValidate()) {
                      await pr.show();
                      for (var i = 0; i < _images.length; i++) {
                        await addImageToFirebase(i, _images[i]);
                      }
                      imgurl = await getUrl();
                      print(_fbKey.currentState.value);
                      await Firestore.instance
                          .collection('products')
                          .document("$prod_Id")
                          .setData({
                        "title": data.fields['product_name'].currentState.value,
                        "cato": data.fields['category'].currentState.value,
                        "price": data.fields['price'].currentState.value,
                        "s_price":
                            data.fields['sales_price'].currentState.value,
                        "image": imgurl,
                      });
                      await pr.hide();
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      print('validation failed');
                      // Firestore.instance
                      //     .collection('products')
                      //     .document("there")
                      //     .setData({
                      //   "prod_n":
                      //       data.fields['product_name'].currentState.value,
                      //   "cato": data.fields['category'].currentState.value,
                      //   "price": data.fields['price'].currentState.value,
                      //   "s_price":
                      //       data.fields['sales_price'].currentState.value,
                      //   "image": imgurl,
                      //   // "clr":data.fields['color_picker'].currentState.value,
                      // });
                    }
                  },
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: MaterialButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _fbKey.currentState.reset();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
