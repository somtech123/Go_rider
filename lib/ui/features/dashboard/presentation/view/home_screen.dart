import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_rider/app/helper/local_state_helper.dart';
import 'package:go_rider/ui/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:go_rider/ui/features/dashboard/presentation/bloc/home_bloc_event.dart';
import 'package:go_rider/ui/features/dashboard/presentation/bloc/home_bloc_state.dart';
import 'package:go_rider/ui/features/dashboard/presentation/view/state_view.dart/my_loaded_state_view.dart';
import 'package:go_rider/ui/features/dashboard/presentation/view/state_view.dart/my_loading_state_view.dart';
import 'package:go_rider/ui/features/dashboard/presentation/view/state_view.dart/my_error_state_view.dart';
import 'package:go_rider/ui/features/dashboard/presentation/view/widget/home_screen_drawer.dart';
import 'package:go_rider/utils/app_constant/app_color.dart';
import 'package:go_rider/utils/app_constant/app_string.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomePageBloc>(context).add(GetUserDetails());

    BlocProvider.of<HomePageBloc>(context).add(RequestLocation());

    BlocProvider.of<HomePageBloc>(context).add(StoreFcmToken());
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // sendmail() async {
  //   // Note that using a username and password for gmail only works if
  //   // you have two-factor authentication enabled and created an App password.
  //   // Search for "gmail app password 2fa"
  //   // The alternative is to use oauth.
  //   String username = '';
  //   String password = 'password';

  //   final smtpServer = SmtpServer('smtp.domain.com', x);
  //   //gmail(username, password);
  //   // Use the SmtpServer class to configure an SMTP server:
  //   // final smtpServer = SmtpServer('smtp.domain.com');
  //   // See the named arguments of SmtpServer for further configuration
  //   // options.

  //   // Create our message.
  //   final message = Message()
  //     ..from = Address(username, 'Your name')
  //     ..recipients.add('oscarchisom11@gmail.com')
  //     ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
  //     ..bccRecipients.add(Address('bccAddress@example.com'))
  //     ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
  //     ..text = 'This is the plain text.\nThis is line 2 of the text part.'
  //     ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  //   try {
  //     final sendReport = await send(message, smtpServer);
  //     print('Message sent: ' + sendReport.toString());
  //   } on MailerException catch (e) {
  //     print('Message not sent.');
  //     for (var p in e.problems) {
  //       print('Problem: ${p.code}: ${p.msg}');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final HomePageBloc homeloc = BlocProvider.of<HomePageBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        title: Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.whiteColor),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.h),
            child: SvgPicture.asset(
              'assets/svgs/notification.svg',
              height: 20.h,
              width: 20.w,
            ),
          ),
        ],
        leadingWidth: 23.w,
        leading: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state.loadingState == LoadingState.loaded) {
              return SizedBox(
                width: 30.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.h),
                        child: GestureDetector(
                          onTap: () {
                            scaffoldKey.currentState!.openDrawer();
                          },
                          child: SvgPicture.asset(
                            'assets/svgs/handburger_svg.svg',
                            height: 25.h,
                            width: 25.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      drawer: HomeScreenDrawer(scaffoldKey: scaffoldKey),
      body: BlocListener<HomePageBloc, HomePageState>(
        listener: (context, state) {},
        bloc: homeloc,
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state.loadingState == LoadingState.loading) {
              return const MyHomeScreenLoadingView();
            } else if (state.loadingState == LoadingState.loaded) {
              return const MyHomeScreenLoadedStateView();
            } else if (state.loadingState == LoadingState.error) {
              return const MyHomeScreenErrorView();
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
