import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_web_diary/product_card.dart';
import 'package:trizda_shops/product_entry_model.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:trizda_shops/pages/simple_prod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trizda_shops/pages/common.dart';

class ManagePro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productEntries =
        Firestore.instance.collection('products').snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => ProductEntry.fromDoc(doc))
          .toList();
    });
    return StreamProvider<List<ProductEntry>>(
      create: (_) => productEntries,
      child: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final productEntries = Provider.of<List<ProductEntry>>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'My Products',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ))),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          child: ResponsiveGridList(
              desiredItemWidth: 100,
              minSpacing: 10,
              children: [for (var i in productEntries) i].map((i) {
                return GestureDetector(
                  onTap: () {
                    _modalBottomSheetMenu(context, i);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2.0,
                          ),
                        ]),
                    width: 100,
                    alignment: Alignment(0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            width: 150,
                            height: 120,
                            fit: BoxFit.cover,
                            imageUrl: i.image.toString(),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  i.title.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        elevation: 1.5,
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => SimPro()),
          // );

          // _onBackPressed();
          showAlertDialog(context);
        },
        tooltip: 'Add products',
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the list options
  const style = TextStyle(fontSize: 21);
  Widget optionOne = SimpleDialogOption(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Own products',
        style: style,
      ),
    ),
    onPressed: () async {
      await Future.delayed(const Duration(milliseconds: 150), () {});
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(context, SlideRightRoute(page: SimPro()));
    },
  );
  Widget optionTwo = SimpleDialogOption(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Common products',
        style: style,
      ),
    ),
    onPressed: () async {
      await Future.delayed(const Duration(milliseconds: 150), () {});
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(context, SlideRightRoute(page: CommonPage()));
    },
  );
  Widget optionThree = SimpleDialogOption(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Grouped products',
        style: style,
      ),
    ),
    onPressed: () {
      print('camel');
      // Navigator.of(context).pop();
    },
  );
  Widget optionFour = SimpleDialogOption(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Offer products',
        style: style,
      ),
    ),
    onPressed: () {
      print('sheep');
      // Navigator.of(context).pop();
    },
  );
  Widget optionFive = SimpleDialogOption(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text(
        'Booking products',
        style: style,
      ),
    ),
    onPressed: () {
      print('goat');
      // Navigator.of(context).pop();
    },
  );

  // set up the SimpleDialog
  SimpleDialog dialog = SimpleDialog(
    title: const Text(
      'Add Products',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Roboto-Regular',
          decoration: TextDecoration.underline,
          decorationColor: Colors.orange,
          decorationThickness: 2,
          fontSize: 20),
    ),
    children: <Widget>[
      optionOne,
      optionTwo,
      optionThree,
      optionFour,
      optionFive,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class SizeRoute extends PageRouteBuilder {
  final Widget page;
  SizeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          ),
        );
}

void _showDeleteDialog(BuildContext context, {Function onDelete}) {
  showDialog(
    context: context,
    child: AlertDialog(
      title: Text('Are you sure you want to delete?'),
      content: Text('Deleted products are permanent and not retrievable.'),
      actions: <Widget>[
        FlatButton(
          color: Colors.redAccent,
          onPressed: onDelete,
          child: Text('Delete'),
        )
      ],
    ),
  );
}

void _modalBottomSheetMenu(context, i) {
  final height = MediaQuery.of(context).size.height;
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (builder) {
        return new Container(
          height: 0.6 * height,
          color: Colors.transparent,
          child: ListView(children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                ),
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              imageUrl: i.image.toString(),
                              placeholder: (context, url) => Icon(Icons.image),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3.0, left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Text(
                                    i.title.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Text(
                                      i.cato.toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    if (i.price.toString().trim().isNotEmpty)
                                      Text(
                                        "₹${i.price.toString()}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey),
                                      ),
                                    if (i.price != null)
                                      SizedBox(
                                        width: 10,
                                      ),
                                    Text(
                                      "₹${i.s_price.toString()}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.lightGreen),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => {
                                _showDeleteDialog(
                                  context,
                                  onDelete: () {
                                    Firestore.instance
                                        .collection('products')
                                        .document(i.documentId)
                                        .delete();
                                    Navigator.of(context).pop();
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                ),
                              },
                            ))
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Discription",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      i.s_dis.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black38,
                      ),
                    ),
                    if (i.f_dis != null)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Full Discription",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            i.f_dis.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Product ID",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      i.documentId.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      });
}
