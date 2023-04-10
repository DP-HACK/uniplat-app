import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uniplat/common_web_view.dart';
import 'package:uniplat/constants/colors.dart';
import 'package:uniplat/constants/urls.dart';
import 'package:uniplat/upload_view.dart';

final controllersProvider =
    StateProvider<List<InAppWebViewController>>((ref) => []);

class HomeView extends HookConsumerWidget {
  final tabUrlList = [
    getUrl(Urls.home),
    getUrl(Urls.mylab),
    getUrl(Urls.search),
    getUrl(Urls.notice)
  ];
  final List<Widget> _screens = [
    CommonWebView(
      url: getUrl(Urls.home),
      index: 0,
    ),
    CommonWebView(url: getUrl(Urls.mylab), index: 1),
    CommonWebView(url: getUrl(Urls.search), index: 2),
    UploadView(),
    CommonWebView(url: getUrl(Urls.notice), index: 3),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedIndex = useState(0);

    void _onItemTapped(int index) {
      if (_selectedIndex.value == index) {
        if (index == 4) {
          index = 3;
        }
        ref.read(controllersProvider)[index].loadUrl(
              urlRequest: URLRequest(
                url: Uri.parse(tabUrlList[index]),
              ),
            );
      } else {
        _selectedIndex.value = index;
      }
    }

    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex.value,
          children: _screens,
        ),
        // body:_screens[_selectedIndex] ,
        bottomNavigationBar: BottomNavigationBar(
          enableFeedback: false,
          currentIndex: _selectedIndex.value,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/home.svg',
                color: _selectedIndex.value == 0 ? Colors.blue : Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/mylab.svg',
                color: _selectedIndex.value == 1 ? Colors.blue : Colors.black,
              ),
              label: 'Mylab',
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svg/search.svg',
                  color: _selectedIndex.value == 2 ? Colors.blue : Colors.black,
                ),
                label: 'Saerch'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svg/upload.svg',
                  color: _selectedIndex.value == 3 ? Colors.blue : Colors.black,
                ),
                label: 'Upload'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svg/news.svg',
                  color: _selectedIndex.value == 4 ? Colors.blue : Colors.black,
                ),
                label: 'News'),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: ConstantsColors.tabBarBackGroundColor,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(fontSize: 14, color: Colors.black),
          unselectedLabelStyle: TextStyle(fontSize: 14, color: Colors.grey),
        ));
  }
}
