import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:glassmorphism/glassmorphism.dart';

class DynamicLinkScreen extends StatelessWidget {

  final List<String> images = [
    "https://imrans9.sg-host.com/app/images/products/1635764330.png",
    "https://imrans9.sg-host.com/app/images/products/1639394535.jpg",
    "https://imrans9.sg-host.com/app/images/products/1636304660.jpg",
    "https://imrans9.sg-host.com/app/images/products/1639394351.jpg",
    "https://imrans9.sg-host.com/app/images/products/1635765780.png",
    "https://imrans9.sg-host.com/app/images/products/1635765013.png",
    "https://imrans9.sg-host.com/app/images/products/1635766793.png",
    "https://imrans9.sg-host.com/app/images/products/6WTANejerp6uzTWXveMo1qBoVPNa3I6OwI5dd58U.jpg",
    "https://imrans9.sg-host.com/app/images/products/1635767243.jpg",
    "https://imrans9.sg-host.com/app/images/products/1635766394.png",
    "https://imrans9.sg-host.com/app/images/products/1635764957.png",
    "https://imrans9.sg-host.com/app/images/products/1635764739.png",
    "https://imrans9.sg-host.com/app/images/products/1635764836.png",
    "https://imrans9.sg-host.com/app/images/products/1635765089.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Dynamic Link Page", style: TextStyle(fontSize: 18, color: Colors.greenAccent[400]),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            NeumorphicText("I love flutter", style: NeumorphicStyle(depth: 4,  color: Colors.white,), textStyle: NeumorphicTextStyle(fontSize: 35,),),
            NeumorphicIcon(Icons.add_circle, size: 60,),
            NeumorphicButton(
              child: Container(
                height: 60,
                width: 100,
                child: Center(child: Text('Neumorphic'),),
              ),
            ),
            StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              staggeredTileBuilder: (index) => StaggeredTile.fit(2),
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) => Card(
                child: Image.network(
                  images[index],
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                          : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
