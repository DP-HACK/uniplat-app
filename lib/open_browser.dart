import 'package:url_launcher/url_launcher.dart';

/// 外部ブラウザを開く
Future<void> openBrowser(String url) async {
  try {
    Uri _url = Uri.parse(url);
    await launchUrl(_url,
      mode: LaunchMode.externalApplication
    );
  } catch (e) {
    print(e);
  }
}
