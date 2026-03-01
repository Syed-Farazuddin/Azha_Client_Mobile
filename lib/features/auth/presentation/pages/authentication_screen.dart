import 'package:flutter/material.dart';
import 'package:mobile/common/widgets/server_text.dart';
import 'package:mobile/common/widgets/simple_app_bar.dart';
import 'package:mobile/routes/app_router.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppbar(title: "BASE PROJECT"),
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                router.pushNamed('test');
              },
              child: ServerText('Navigation Test', textStyleName: 'eb18'),
            ),
          ],
        ),
      ),
    );
  }
}
