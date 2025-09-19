import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:unisphere/config/routes/app_router.dart';
import 'package:unisphere/core/cubits/fullscreen_cubit.dart';
import 'package:unisphere/gen/assets.gen.dart';
import 'package:unisphere/l10n/app_localizations.dart';

import '../widgets/custom_onboard_button.dart';
import '../bloc/page_index_cubit.dart'; // Import your cubit

class FixedPageController extends PageController {
  final int pageIndex;

  FixedPageController(this.pageIndex);

  @override
  double get page => pageIndex.toDouble();
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FullscreenCubit>().enterFullscreen();
    final localizations = AppLocalizations.of(context)!;
    final assets = Assets.animations.lotties;

    final pages = [
      PageViewModel(
        title: "ยินดีต้อนรับสู่ UNISPHERE.",
        body: '"จัดการชีวิตในมหาวิทยาลัยได้ง่ายขึ้นในแอปเดียว – ตารางเรียน, กิจกรรม, กลุ่มเรียน และอื่นๆ"',
        image: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: SizedBox(
        height: 200,
        child: Lottie.asset(
          assets.logoAnimation.path,
          fit: BoxFit.contain,
        ),
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        title: "พก Schedule ไปกับคุณทุกที่ ทุกเวลา",
        body: '"จัดการ และดูตารางเรียนรายวัน หรือราย session พร้อมแจ้งเตือนก่อนเข้าเรียน"',
        image: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: SizedBox(
        height: 200,
        child: Lottie.asset(
          assets.scheduleAnimation.path,
          fit: BoxFit.contain,
        ),
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        title: "Event เด็ด เด็กมหา’ลัยไม่ควรพลาด !",
        body: '"พบกับกิจกรรมสนุก ๆ ที่จัดขึ้นภายในมหาวิทยาลัย ติดตามและเข้าร่วมกิจกรรมที่คุณไม่ควรพลาด เพื่อประสบการณ์มหาลัยที่สมบูรณ์แบบ"',
        image: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: SizedBox(
        height: 200,
        child: Lottie.asset(
          assets.eventAnimation.path,
          fit: BoxFit.contain,
        ),
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        title: "ไปด้วยกันไปได้ไกล กับ Study Group ที่ใช่ !",
        body: '"ไม่ต้องเรียนคนเดียวอีกต่อไป! ค้นหา หรือสร้างกลุ่มติว  พูดคุย และเตรียมสอบไปพร้อมกับเพื่อนในคณะ หรือวิชาเดียวกัน"',
        image: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: SizedBox(
        height: 200,
        child: Lottie.asset(
          assets.groupAnmation.path,
          fit: BoxFit.contain,
        ),
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        title: "หลงก็ไม่กลัว เพราะมี Campus Map อยู่ข้าง ๆ",
        body: '"หาตึกเรียนไม่เจอ? ไม่ต้องกังวล ! ดูแผนที่มหาวิทยาลัยแบบโต้ตอบ พร้อมเส้นทางเดิน อาคารสำคัญ และข้อมูลสถานที่ใช้งานได้ทันที"',
        image: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: SizedBox(
        height: 200,
        child: Lottie.asset(
          assets.mapAnimation.path,
          fit: BoxFit.contain,
        ),
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        title: "ไม่พลาดทุก Announce ที่สำคัญ !",
        body: '"รับข่าวสารและประกาศแบบเรียลไทม์ พร้อมระบบแจ้งเตือนให้คุณไม่พลาดสิ่งที่สำคัญที่สุดในชีวิตมหาลัย"',
        image: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: SizedBox(
        height: 200,
        child: Lottie.asset(
          assets.annouceAnimation.path,
          fit: BoxFit.contain,
        ),
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
      PageViewModel(
        title: "พร้อมทุกเวลา แม้อยู่นอกเครือข่าย",
        body: '"ตารางเรียน ประกาศ หรือแผนที่ — ดาวน์โหลดไว้ดูได้ทุกที่ แม้ไม่มีอินเทอร์เน็ต แอปพร้อมให้คุณเข้าถึงข้อมูลสำคัญเสมอ"',
        image: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: SizedBox(
        height: 200,
        child: Lottie.asset(
          assets.offlineAnimation.path,
          fit: BoxFit.contain,
        ),
          ),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
          ),
          bodyTextStyle: TextStyle(fontSize: 16.0),
          bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          pageColor: Colors.white,
          imagePadding: EdgeInsets.zero,
        ),
      ),
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Center(
          child: IntroductionScreen(
            bodyPadding: EdgeInsets.only(top: 100),
            globalBackgroundColor: Colors.white,
            allowImplicitScrolling: true,
            autoScrollDuration: 3000,
            infiniteAutoScroll: true,
            showSkipButton: true,
            next: CustomOnboardButton(
              nameButton: localizations.onboarding_name_button_next,
            ),
            skip: Text(
              localizations.onboarding_name_button_skip,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            done: CustomOnboardButton(
              nameButton: localizations.onboarding_name_button_done,
              smallPadding: true,
            ),
            onDone: () {
              DashboardRoute().go(context);
              context.read<FullscreenCubit>().exitFullscreen();
            },
            onSkip: () {
              DashboardRoute().go(context);
              context.read<FullscreenCubit>().exitFullscreen();
            },
            onChange: (index) {
              context.read<PageIndexCubit>().updatePage(index);
            },
            pages: pages,
            dotsDecorator: const DotsDecorator(
              activeColor: Colors.transparent,
              color: Colors.transparent,
              size: Size.zero,
              activeSize: Size.zero,
            ),
          ),
        ),

        Positioned(
          bottom: 100,
          child: BlocBuilder<PageIndexCubit, int>(
            builder: (context, currentPageIndex) {
              return SmoothPageIndicator(
                count: pages.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  activeDotColor: Colors.deepPurple,
                  dotColor: Colors.grey,
                ),
                controller: FixedPageController(currentPageIndex),
              );
            },
          ),
        ),
      ],
    );
  }
}
