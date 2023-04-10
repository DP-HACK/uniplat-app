import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              icon: SvgPicture.asset(
                'assets/svg/home.svg',
                color: _selectedIndex == 0 ? Colors.blue : Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/mylab.svg',
                color: _selectedIndex == 1 ? Colors.blue : Colors.black,
              ),
              label: 'Mylab',
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svg/search.svg',
                  color: _selectedIndex == 2 ? Colors.blue : Colors.black,
                ),
                label: 'Saerch'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svg/upload.svg',
                  color: _selectedIndex == 2 ? Colors.blue : Colors.black,
                ),
                label: 'Upload'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/svg/news.svg',
                  color: _selectedIndex == 4 ? Colors.blue : Colors.black,
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
