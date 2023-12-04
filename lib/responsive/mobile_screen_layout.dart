import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:instagram_flutter/providers/user_provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }


  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        children: [
          Text("Feed"),
          Text("Search"),
          Text("Add"),
          Text("Notifications"),
          Text("Profile"),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,
          color: _page==0 ? primaryColor : secondaryColor,), label: 'Home', backgroundColor: primaryColor,),
          BottomNavigationBarItem(icon: Icon(Icons.search,
            color: _page==1 ? primaryColor : secondaryColor,), label: 'Search', backgroundColor: primaryColor,),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle,
            color: _page==2 ? primaryColor : secondaryColor,), label: 'Add', backgroundColor: primaryColor,),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,
            color: _page==3 ? primaryColor : secondaryColor,), label: 'Notifications', backgroundColor: primaryColor,),
          BottomNavigationBarItem(icon: Icon(Icons.person,
            color: _page==4 ? primaryColor : secondaryColor,), label: 'Profile', backgroundColor: primaryColor,),

        ],
        onTap: navigationTapped,
      ),
    );
  }
}
