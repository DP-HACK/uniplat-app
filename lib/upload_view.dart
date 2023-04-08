import 'package:flutter/material.dart';
import 'package:uniplat/common_web_view.dart';
import 'package:uniplat/constants/colors.dart';
import 'package:uniplat/constants/urls.dart';
import 'package:uniplat/open_browser.dart';

class UploadView extends StatelessWidget {
  UploadView({Key? key}) : super(key: key);

  List<String> uploadList = ["Live Streaming", "Video", "Document"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantsColors.mainColor,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            trailing: Icon(Icons.arrow_right),
            title: Text(uploadList[index]),
            onTap: () {
              String openUrl = "";
              switch (index) {
                case 0:
                  openUrl = getUrl(Urls.streamingNew);

                  break;
                case 1:
                  openUrl = getUrl(Urls.videoNew);
                  break;
                case 2:
                  openUrl = getUrl(Urls.documentNew);
                  break;
                default:
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return CommonWebView(
                      url: openUrl,
                      isBackbuttton: true,
                    );
                  },
                ),
              );
            },
          );
        },
        itemCount: uploadList.length,
      ),
    );
  }
}
