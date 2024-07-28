import 'package:app_car_rental/const/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;
  const NavBar({
    super.key,
    required this.onTap,
    required this.pageIndex
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: BottomAppBar(
        color: Color(light_green),
        shadowColor: Colors.black,
        // color: Colors.black.withOpacity(1),
        elevation: 2.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 60,
            color: Colors.white,
            child: Row(
              children: [
                navItem(
                    Icons.home,
                    pageIndex == 0,
                    onTap: () => onTap(0)
                ),
                navItem(
                    Icons.notifications,
                    pageIndex == 1,
                    onTap: () => onTap(1)
                ),
                navItem(
                    Icons.car_crash,
                    pageIndex == 2,
                    onTap: () => onTap(2)
                ),
                navItem(
                    Icons.contact_support,
                    pageIndex == 3,
                    onTap: () => onTap(3)
                ),
                navItem(
                    Icons.supervised_user_circle_rounded,
                    pageIndex == 4,
                    onTap: () => onTap(4)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget navItem (IconData icon, bool selected, {Function()? onTap}){
    return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            color: selected ? Color(dart_green) : Colors.black,
          ),
        )
    );
  }
}
