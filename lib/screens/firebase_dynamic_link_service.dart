
import 'package:email_password_login/screens/screen_for_dynamic_links.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseDynamicLinkService{

  static Future<String> createDynamicLink(bool short) async {
    String _linkMessage;

    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.emailpasswordlogin.com/"),
      uriPrefix: "https://emailpasswordlogin.page.link",
      androidParameters: AndroidParameters(
        packageName: "com.sbs.email_password_login",
        minimumVersion: 30,
      ),
    );

    Uri url;
    if(short) {
      final ShortDynamicLink shortDynamicLink = await dynamicLinkParams.buildShortLink();
      url = shortDynamicLink.shortUrl;
    }
    else {
      url = await dynamicLinkParams.buildUrl();
    }
    _linkMessage = url.toString();
    return _linkMessage;
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData pendingDynamicLinkData) async {
        final Uri deepLink = pendingDynamicLinkData.link;

        ///When you have data like ID in deep link
        // var isData = deepLink.pathSegments.contains('product');
        // if(isData) {
        //   String id = deepLink.queryParameters["id"];
        // }

        if(deepLink!=null) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => DynamicLinkScreen()), (Route<dynamic> route) => false);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => DynamicLinkScreen()));
          // Get.to(() => DynamicLinkScreen());
        }
      },
      onError: (OnLinkErrorException e) async {
        print(e);
      },
    );

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data.link;

    if(deepLink!=null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => DynamicLinkScreen()), (Route<dynamic> route) => false);
    } else {
      return null;
    }
  }
}