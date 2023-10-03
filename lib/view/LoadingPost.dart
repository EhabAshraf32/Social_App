import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Constants {
  static const double cardMarginHorizontal = 16.0;
  static const double padding = 8.0;
  static const double cornerRadius = 30.0;
  static const double textUserHeight = 28.0;
  static const double textUserWidth = 300.0;
  static const double textCommentHeight = 20.0;
  static const double textCommentWidth = 240.0;
  static const double imageHeight = 200.0;
  static const double minRadius = 8.0;
  static const double paddingExLarge = 16.0;
  static const TextStyle kTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );
  static const List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Colors.grey,
      offset: Offset(0, 2),
      blurRadius: 4.0,
    ),
  ];
}

class LoadingPost extends StatelessWidget {
  const LoadingPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Shimmer',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 24,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const LoadingItem();
        },
      ),
    );
  }
}

class LoadingItem extends StatelessWidget {
  const LoadingItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.cardMarginHorizontal,
      ),
      child: Shimmer.fromColors(
        highlightColor: Colors.grey[100]!,
        baseColor: Colors.grey[300]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User widget
            const SizedBox(
              height: Constants.cardMarginHorizontal,
            ),
            Container(
              height: Constants.textUserHeight,
              width: Constants.textUserWidth,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Constants.minRadius),
                ),
                color: Colors.white,
              ),
            ),
            // image widget
            const SizedBox(
              height: Constants.cardMarginHorizontal,
            ),
            Container(
              height: Constants.imageHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Constants.minRadius),
                ),
                color: Colors.white,
              ),
            ),
            // leading post widget
            const SizedBox(height: Constants.padding),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Constants.minRadius),
                ),
                color: Colors.white,
              ),
              height: Constants.textCommentHeight,
              width: Constants.textCommentWidth,
            ),
            const SizedBox(
              height: Constants.cardMarginHorizontal,
            ),
          ],
        ),
      ),
    );
  }
}
