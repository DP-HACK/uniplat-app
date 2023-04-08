import 'package:flutter/material.dart';
import 'package:uniplat/common_web_view.dart';
import 'package:uniplat/constants/colors.dart';
import 'package:uniplat/constants/urls.dart';
import 'package:uniplat/upload_view.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key, required this.isLogin}) : super(key: key);
  bool isLogin;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Widget> _screens = [];
  @override
  void initState() {
    super.initState();
    _screens = [
      CommonWebView(
        url: widget.isLogin ? getUrl(Urls.home) : getUrl(Urls.appLogin),
      ),
      CommonWebView(url: getUrl(Urls.mylab)),
      CommonWebView(url: getUrl(Urls.search)),
      UploadView(),
      CommonWebView(url: getUrl(Urls.notice)),
    ];
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        // body:_screens[_selectedIndex] ,
        bottomNavigationBar: BottomNavigationBar(
          enableFeedback: false,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:
                  Image.asset('assets/images/home.png', width: 24, height: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:
                  Image.asset('assets/images/myLab.png', width: 24, height: 24),
              label: 'Mylab',
            ),
            BottomNavigationBarItem(
                icon: Image.asset('assets/images/search.png',
                    width: 24, height: 24),
                label: 'Saerch'),
            BottomNavigationBarItem(
                icon: Image.asset('assets/images/upload.png',
                    width: 24, height: 24),
                label: 'Upload'),
            BottomNavigationBarItem(
                icon: Image.asset('assets/images/news.png',
                    width: 24, height: 24),
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
