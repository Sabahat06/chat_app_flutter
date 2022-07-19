import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsScreen extends StatefulWidget {
  const GoogleAdsScreen({Key key}) : super(key: key);

  @override
  State<GoogleAdsScreen> createState() => _GoogleAdsScreenState();
}

class _GoogleAdsScreenState extends State<GoogleAdsScreen> {
  BannerAd bannerAd;
  RxBool isAdLoaded = false.obs;

  @override
  initState() {
    initBannerAd();
    super.initState();
  }

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: BannerAd.testAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isAdLoaded.value = true;
        }
      ),
      request: AdRequest()
    );
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeeksforGeeks'),
        backgroundColor: Colors.greenAccent[400],
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}, tooltip: 'Menu',)
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          height: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          height: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: Container(
                          height: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          )
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: Container(
                          width: 380,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Container(
                          width: 180,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.cyan,
                          )
                        )
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ),
            ),
          )
        ),
      ),
      bottomNavigationBar: Obx(() => isAdLoaded.value
        ? Container(
            height: bannerAd.size.height.toDouble(),
            width: bannerAd.size.width.toDouble(),
            child: AdWidget(ad: bannerAd,),
          )
        : SizedBox()
      )
    );
  }
}
