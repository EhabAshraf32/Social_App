// ignore_for_file: camel_case_types, prefer_const_constructors, non_constant_identifier_names, sized_box_for_whitespace, unnecessary_string_interpolations, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../helper/local/sharedPref.dart';
import '../model/onboardingModel.dart';
import 'Login.dart';

class OnBoarding extends StatelessWidget {
  List<OnboardingModel> Onboard = [
    OnboardingModel(
        image: "assets/onboard1.png",
        title: "Online shopping",
        content:
            "This text is an example of text that can be replaced in the same space. This text was generated from the Arabic text generator."),
    OnboardingModel(
        image: "assets/onboard2.png",
        title: "Offers and discounts",
        content:
            "This text is an example of text that can be replaced in the same space. This text was generated from the Arabic text generator."),
    OnboardingModel(
        image: "assets/onboard3.png",
        title: "secure payment",
        content:
            "This text is an example of text that can be replaced in the same space. This text was generated from the Arabic text generator.")
  ];

  PageController controller = PageController();
  bool islast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                OnSubmit();
              },
              child: Container(
                  alignment: Alignment.center,
                  width: 72,
                  height: 31,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(13)),
                  child: Text(
                    "Skip",
                    style: TextStyle(color: Colors.white),
                  )))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                physics: BouncingScrollPhysics(),
                onPageChanged: (i) {
                  if (i == Onboard.length - 1) {
                    islast = true;
                  } else {
                    islast = false;
                  }
                },
                controller: controller,
                itemCount: Onboard.length,
                itemBuilder: (context, index) =>
                    OnboardingWidget(context, Onboard[index])),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 60),
            color: Colors.white,
            child: Column(
              children: [
                SmoothPageIndicator(
                    controller: controller, // PageController
                    count: Onboard.length,
                    effect: ExpandingDotsEffect(
                        dotHeight: 10,
                        expansionFactor: 4,
                        dotWidth: 10,
                        spacing: 5,
                        dotColor: Colors.grey,
                        activeDotColor: Colors.black), // your preferred effect
                    onDotClicked: (index) {}),
                SizedBox(
                  height: 40,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {
                    if (islast) {
                      OnSubmit();
                    } else {
                      controller.nextPage(
                          duration: Duration(microseconds: 750),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack OnboardingWidget(BuildContext context, OnboardingModel model) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 1.5,
          width: double.infinity,
          child: Image(
            image: AssetImage("${model.image}"),
            fit: BoxFit.fill,
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 25,
              bottom: MediaQuery.of(context).size.height / 25),
          alignment: Alignment.center,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset("assets/Logo.png"),
            SizedBox(
              height: 10,
            ),
            Text(
              "${model.title}",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  fontFamily: "Almarai"),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              textAlign: TextAlign.center,
              "${model.content}",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  fontFamily: "Rubik"),
              maxLines: 2,
            ),
          ]),
        )
      ],
    );
  }

  OnSubmit() {
    return SharedPref.setData(key: "OnBoarding", value: true).then((value) {
      if (value) {
        Get.offAll(Login());
      }
    });
  }
}
