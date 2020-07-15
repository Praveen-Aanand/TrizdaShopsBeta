import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';

class CommonPage extends StatefulWidget {
  @override
  _CommonPageState createState() => _CommonPageState();
}

class _CommonPageState extends State<CommonPage> {
  TextEditingController _searchText = TextEditingController(text: "");
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;

  _search() async {
    setState(() {
      _searching = true;
    });

    Algolia algolia = Algolia.init(
      applicationId: '9A5F4ZZE3D',
      apiKey: 'd65f09a59c4bc3ffe27c985eb3ae5f2f',
    );

    AlgoliaQuery query = algolia.instance.index('testify');
    query = query.search(_searchText.text);

    _results = (await query.getObjects()).hits;

    setState(() {
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Algolia Search"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Search"),
            TextField(
              controller: _searchText,
              decoration: InputDecoration(hintText: "Search query here..."),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  color: Colors.blue,
                  child: Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _search,
                ),
              ],
            ),
            Expanded(
              child: _searching == true
                  ? Center(
                      child: Text("Searching, please wait..."),
                    )
                  : _results.length == 0
                      ? Center(
                          child: Text("No results found."),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            AlgoliaObjectSnapshot snap = _results[index];

                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  (index + 1).toString(),
                                ),
                              ),
                              title: Text(snap.data["name"]),
                              subtitle: Text(snap.data["salePrice"].toString()),
                            );
                          },
                        ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
