import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const DefaultLayout({
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.title,
    this.backgroundColor,
    required this.child,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      backgroundColor: backgroundColor ?? Colors.white,
      appBar : renderAppbar(),
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? renderAppbar () {
    if(title == null){
      return null;
    }else{
      return AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title!,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
