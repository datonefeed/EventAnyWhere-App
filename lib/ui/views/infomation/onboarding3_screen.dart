import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:go_router/go_router.dart';

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyTheme.backgroundcolor,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 100),
            child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 1000,
                  child: Image(
                    image: AssetImage('assets/images/onboarding3_pic.png'),
                    fit: BoxFit.contain,
                  ),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: MyTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(42),
                  topRight: Radius.circular(42),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40),
                  Text(
                    '    Can participate or \n live stream online discussions ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '  In publishing and graphic design, Lorem is \na placeholder text commonly  ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          context.go('/signin');
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white38,
                            maxRadius: 6,
                          ),
                          SizedBox(width: 10),
                          CircleAvatar(
                            backgroundColor: Colors.white38,
                            maxRadius: 6,
                          ),
                          SizedBox(width: 10),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            maxRadius: 6,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          context.go('/signin');
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
