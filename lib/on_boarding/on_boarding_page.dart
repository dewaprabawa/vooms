import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/shareds/general_helper/ui_asset_constant.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';


class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController _pageController = PageController();

  final List<Map<String, String>> onboardingData = [
    {
      'image': UIAssetConstants.onBoardingImage1,
      'title': 'Kejar ilmu yang kamu sukai dimana saja.',
      'subtitle': 'This is the first screen of the onboarding process',
    },
    {
      'image': UIAssetConstants.onBoardingImage2,
      'title': 'Belajar dengan guru berpengalaman.',
      'subtitle': 'Swipe left to learn more about what MyApp can do',
    },
    {
      'image': UIAssetConstants.onBoardingImage3,
      'title': 'Muali belajar dengan mentor terbaik.',
      'subtitle': 'Tap the button below to start using MyApp',
    },
  ];

  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  final ValueNotifier<String> _stateValueIdentifierNotifier =
      ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    _stateValueIdentifierNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: PageView.builder(
                    itemCount: onboardingData.length,
                    controller: _pageController,
                    onPageChanged: (int index) {
                      _currentPageNotifier.value = index;
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            onboardingData[index]['image'] ?? "",
                            width: 400,
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.only(left:20.0, right: 20.0),
                            child: Text(onboardingData[index]['title'] ?? "", textAlign:TextAlign.center,
                                style: GoogleFonts.dmMono().copyWith(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            onboardingData[index]['subtitle'] ?? "",
                            style: GoogleFonts.dmMono().copyWith(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < onboardingData.length; i++)
                  _buildDot(i, context),
              ],
            ),
            ValueListenableBuilder<int>(
                valueListenable: _currentPageNotifier,
                builder: (context, currentPage, widget) {
                  return Row(
                    children: [
                      OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(const BorderSide(
                                color: UIColorConstant.primaryRed)),
                          ),
                          child: Text("Kembali",
                              style: GoogleFonts.dmMono().copyWith(
                                  color: UIColorConstant.materialPrimaryRed)),
                          onPressed: () {
                            _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }),
                      const Spacer(),
                      MaterialButton(
                          color: UIColorConstant.materialPrimaryBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          child: Text("Selanjutnya",
                              style: GoogleFonts.dmMono().copyWith(
                                  color: Colors.white)),
                          onPressed: () {
                            if (currentPage < onboardingData.length - 1) {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            }
                          })
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentPageNotifier,
      builder: (BuildContext context, int currentPage, Widget? child) {
        Color color;
        if (index == currentPage) {
          color = Theme.of(context).primaryColor;
        } else {
          color = Colors.grey;
        }
        return Container(
          margin: EdgeInsets.all(4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        );
      },
    );
  }
}
