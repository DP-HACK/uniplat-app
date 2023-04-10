import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplat/constants/colors.dart';
import 'package:uniplat/home_view.dart';
import 'package:uniplat/open_browser.dart';

import 'constants/urls.dart';

class CommonWebView extends HookConsumerWidget {
  final String url;
  bool isBackbuttton = false;
  InAppWebViewController? webViewController;
  int index;
  CommonWebView(
      {Key? key,
      required this.url,
      this.index = -1,
      this.isBackbuttton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CookieManager cookieManager = CookieManager.instance();
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          allowFileAccessFromFileURLs: true,
          allowUniversalAccessFromFileURLs: true,
          // userAgent: userAgent,
          useOnDownloadStart: true,
          useOnLoadResource: true,
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(
          allowContentAccess: true,
          allowFileAccess: true,
          thirdPartyCookiesEnabled: true,
        ));

    /// URI
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ConstantsColors.barColor,
          elevation: 0,
          leading: isBackbuttton
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: ConstantsColors.barColor,
        body:

            /// Webview widget
            WillPopScope(
                onWillPop: () async {
                  webViewController?.goBack();
                  return false;
                },
                child: SafeArea(
                  child: InAppWebView(
                    onWebViewCreated: (controller) async {
                      /// Set cookies
                      final prefs = await SharedPreferences.getInstance();
                      var cookiesNames = prefs.getKeys();
                      for (var element in cookiesNames) {
                        var cookieValue = prefs.getString(element);
                        print("uri");
                        print(Uri.parse(url));
                        print("element");
                        print(element);
                        print("cookieValue");
                        print(cookieValue);
                        cookieManager.setCookie(
                            url: Uri.parse(url),
                            name: element,
                            value: cookieValue!);
                      }
                      webViewController = controller;

                      if (ref.read(controllersProvider).length <= index) {
                        ref
                            .read(controllersProvider.notifier)
                            .state
                            .add(controller);
                      }
                    },
                    initialOptions: options,

                    /// On permission request
                    androidOnPermissionRequest:
                        (InAppWebViewController controller, String origin,
                            List<String> resources) async {
                      print('ORIGIN: $origin');
                      print('RESOURCES: $resources');
                    },
                    onLoadStart:
                        (InAppWebViewController controller, Uri? url) async {},
                    onLoadStop:
                        (InAppWebViewController controller, Uri? url) async {
                      if (url == getUrl(Urls.appLogin)) {
                        print("できた");
                      }
                      final prefs = await SharedPreferences.getInstance();
                      List<Cookie> cookies =
                          await cookieManager.getCookies(url: url!);
                      cookies.forEach((cookie) async {
                        // print("========coookies============");
                        // print(cookie.name + " " + cookie.value);
                        if (cookie == "SESSION") {
                          print(cookie.name + " " + cookie.value);

                          await prefs.setString(cookie.name, cookie.value);
                        }
                      });
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      print(
                          "++++++++++++++++++++++++++shouldOverrideUrlLoading++++++++++++++++++++++++++");

                      if (uri.toString().contains("metamask")) {
                        if (Platform.isAndroid) {
                          openBrowser(
                              "https://play.google.com/store/apps/details?id=io.metamask&hl=en_US&ref=producthunt&_branch_match_id=1050328800172439406&_branch_referrer=H4sIAAAAAAAAA8soKSkottLXz00tScxNLM7WSywo0MvJzMvWT6ooz3a1yHeztAQA/OIqTSQAAAA%3D&pli=1");
                        } else {
                          openBrowser(
                              "https://apps.apple.com/us/app/metamask/id1438144202?_branch_match_id=1173361122859666379&_branch_referrer=H4sIAAAAAAAAA8soKSkottLXz00tScxNLM7WSywo0MvJzMvWL8529DB2SnSztAQA5G46IyQAAAA%3D");
                        }
                        return NavigationActionPolicy.CANCEL;
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(url),
                    ),
                  ),
                )));
  }
}
