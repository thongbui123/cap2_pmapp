import 'package:capstone2_project_management_app/views/dashboard_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

class intro_screen extends StatelessWidget {
  const intro_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Dashboard_screen()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, fontFamily: 'MontMed');

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.w700, fontFamily: 'MontMed'),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('Logo.png', 100),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\'s go right away!',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'MontMed'),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Project Managing",
          body: "Keep tracks of tasks and progress of projects",
          image: Container(
            width: 300,
            height: 300,
            margin:
                EdgeInsets.only(top: 70.0), // Adjust the top margin as needed
            child: Image.asset('intro01.png'),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Tasks and Requirements",
          body: "Set up requirements and tasks to complete a project",
          image: Container(
            width: 300,
            height: 300,
            margin:
                EdgeInsets.only(top: 70.0), // Adjust the top margin as needed
            child: Image.asset('intro02.png'),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Members and Roles",
          body: "Manage members and adjust roles in a project",
          image: Container(
            width: 300,
            height: 300,
            margin:
                EdgeInsets.only(top: 70.0), // Adjust the top margin as needed
            child: Image.asset('intro03.png'),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Become a member",
          body: "Join us now to start your own or to join a project",
          image: Container(
            width: 300,
            height: 300,
            margin:
                EdgeInsets.only(top: 70.0), // Adjust the top margin as needed
            child: Image.asset('intro04.png'),
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 6,
            imageFlex: 6,
            safeArea: 80,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip',
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'MontMed')),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done',
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'MontMed')),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
