// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:glassmorphism/glassmorphism.dart';
//
// class DynamicLinkScreen extends StatelessWidget {
//
//   final List<String> images = [
//     "https://imrans9.sg-host.com/app/images/products/1635764330.png",
//     "https://imrans9.sg-host.com/app/images/products/1639394535.jpg",
//     "https://imrans9.sg-host.com/app/images/products/1636304660.jpg",
//     "https://imrans9.sg-host.com/app/images/products/1639394351.jpg",
//     "https://imrans9.sg-host.com/app/images/products/1635765780.png",
//     "https://imrans9.sg-host.com/app/images/products/1635765013.png",
//     "https://imrans9.sg-host.com/app/images/products/1635766793.png",
//     "https://imrans9.sg-host.com/app/images/products/6WTANejerp6uzTWXveMo1qBoVPNa3I6OwI5dd58U.jpg",
//     "https://imrans9.sg-host.com/app/images/products/1635767243.jpg",
//     "https://imrans9.sg-host.com/app/images/products/1635766394.png",
//     "https://imrans9.sg-host.com/app/images/products/1635764957.png",
//     "https://imrans9.sg-host.com/app/images/products/1635764739.png",
//     "https://imrans9.sg-host.com/app/images/products/1635764836.png",
//     "https://imrans9.sg-host.com/app/images/products/1635765089.png",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         title: Text("Dynamic Link Page", style: TextStyle(fontSize: 18, color: Colors.greenAccent[400]),),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             NeumorphicText("I love flutter", style: NeumorphicStyle(depth: 4,  color: Colors.white,), textStyle: NeumorphicTextStyle(fontSize: 35,),),
//             NeumorphicIcon(Icons.add_circle, size: 60,),
//             NeumorphicButton(
//               child: Container(
//                 height: 60,
//                 width: 100,
//                 child: Center(child: Text('Neumorphic'),),
//               ),
//             ),
//             StaggeredGridView.countBuilder(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               padding: EdgeInsets.all(8),
//               staggeredTileBuilder: (index) => StaggeredTile.fit(2),
//               crossAxisCount: 4,
//               mainAxisSpacing: 4,
//               crossAxisSpacing: 4,
//               itemCount: images.length,
//               itemBuilder: (BuildContext context, int index) => Card(
//                 child: Image.network(
//                   images[index],
//                   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(
//                         value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
//                           : null,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// EXAMPLE use case for TextFieldSearch Widget
import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';
import 'dart:async';

class DynamicLinkScreen extends StatefulWidget {
  DynamicLinkScreen({Key key, this.title = 'My Home Page'}) : super(key: key);

  final String title;

  @override
  _DynamicLinkScreenState createState() => _DynamicLinkScreenState();
}

class _DynamicLinkScreenState extends State<DynamicLinkScreen> {
  final _testList = [
    'Test Item 1',
    'Test Item 2',
    'Test Item 3',
    'Test Item 4',
  ];

  TextEditingController myController = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();
  TextEditingController myController4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
    myController2.addListener(_printLatestValue);
    myController3.addListener(_printLatestValue);
    myController4.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print("text field: ${myController.text}");
    print("text field: ${myController2.text}");
    print("text field: ${myController3.text}");
    print("text field: ${myController4.text}");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    super.dispose();
  }

  // mocking a future
  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(milliseconds: 2000));
    List _list = <dynamic>[];
    // create a list from the text input of three items
    // to mock a list of items from an http call
    _list.add('Test' + ' Item 1');
    _list.add('Test' + ' Item 2');
    _list.add('Test' + ' Item 3');
    return _list;
  }

  // mocking a future that returns List of Objects
  Future<List> fetchComplexData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    List _list = <dynamic>[];
    List _jsonList = [
      {'label': 'Text' + ' Item 1', 'value': 30},
      {'label': 'Text' + ' Item 2', 'value': 31},
      {'label': 'Text' + ' Item 3', 'value': 32},
    ];
    // create a list from the text input of three items
    // to mock a list of items from an http call where
    // the label is what is seen in the textfield and something like an
    // ID is the selected value
    _list.add(new TestItem.fromJson(_jsonList[0]));
    _list.add(new TestItem.fromJson(_jsonList[1]));
    _list.add(new TestItem.fromJson(_jsonList[2]));

    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the DynamicLinkScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Form(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 16),
              TextFieldSearch(
                initialList: _testList,
                label: 'Simple Future List',
                controller: myController2,
                future: () {
                  return fetchSimpleData();
                }
              ),
              SizedBox(height: 16),
              TextFieldSearch(
                label: 'Complex Future List',
                controller: myController3,
                future: () {
                  return fetchComplexData();
                },
                getSelectedValue: (item) {
                  print(item);
                },
                minStringLength: 5,
                textStyle: TextStyle(color: Colors.red),
                decoration: InputDecoration(hintText: 'Search For Something'),
              ),
              SizedBox(height: 16),
              TextFieldSearch(
                  label: 'Future List with custom scrollbar theme',
                  controller: myController4,
                  scrollbarDecoration: ScrollbarDecoration(
                      controller: ScrollController(),
                      theme: ScrollbarThemeData(
                          radius: Radius.circular(30.0),
                          thickness: MaterialStateProperty.all(20.0),
                          isAlwaysShown: true,
                          trackColor: MaterialStateProperty.all(Colors.red))),
                  future: () {
                    return fetchSimpleData();
                  }),
              SizedBox(height: 16),
              TextFieldSearch(
                initialList: _testList,
                label: 'Simple List',
                controller: myController
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Mock Test Item Class
class TestItem {
  final String label;
  dynamic value;

  TestItem({this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}