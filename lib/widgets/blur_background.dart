import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlurBackgroundPage extends StatefulWidget {
  const BlurBackgroundPage({super.key});

  @override
  State<BlurBackgroundPage> createState() => _BlurBackgroundPageState();
}

class _BlurBackgroundPageState extends State<BlurBackgroundPage> {
@override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(8, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-8, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -1.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    
                    color: Colors.amber
                  ),
                ),
              ),
              BackdropFilter(filter: ImageFilter.blur(
                sigmaX: 100.0,
                sigmaY: 100.0
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
              ),),
                
                SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📍 New Vaibhav Nagar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Good Morning',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              )
            
            ],
          ),
        ),
      ),
    );
  }

}
