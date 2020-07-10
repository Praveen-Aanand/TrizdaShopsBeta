import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_web_diary/product_card.dart';
import 'package:trizda_shops/product_entry_model.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:trizda_shops/pages/simple_prod.dart';

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
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit ?'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("NO"),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text("YES"),
                ),
              ],
            ),
          ) ??
          false;
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
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
                return Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                    ),
                  ]),
                  width: 100,
                  alignment: Alignment(0, 0),
                  child: Column(
                    children: [
                      Image.network(i.image.toString(),
                          width: 120, height: 120, fit: BoxFit.cover),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            i.title.toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                    ],
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
      Navigator.of(context, rootNavigator: true).pop();
      await Future.delayed(const Duration(milliseconds: 200), () {});
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
    onPressed: () {
      print('cow');
      // Navigator.of(context).pop();
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
