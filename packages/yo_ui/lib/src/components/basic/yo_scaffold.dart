import 'package:flutter/material.dart';

/// Opinionated Scaffold with safe-area, resizeToAvoidBottomInset=true by default,
/// and optional padding/margin for the body.
class YoScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? bodyPadding;
  final EdgeInsetsGeometry? bodyMargin;

  const YoScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.bodyPadding,
    this.bodyMargin,
  });

  @override
  Widget build(BuildContext context) {
    Widget? current = body;

    if (bodyPadding != null) {
      current = Padding(padding: bodyPadding!, child: current);
    }

    if (bodyMargin != null) {
      current = Container(margin: bodyMargin!, child: current);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: current,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
    );
  }
}
