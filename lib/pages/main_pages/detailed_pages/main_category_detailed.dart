import 'package:flutter/material.dart';
import 'package:vff_group/global/vffglb.dart' as glb;

class MainCategoryDetailedScreen extends StatefulWidget {
  const MainCategoryDetailedScreen({super.key});

  @override
  State<MainCategoryDetailedScreen> createState() => _MainCategoryDetailedScreenState();
}

class _MainCategoryDetailedScreenState extends State<MainCategoryDetailedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(glb.mainCategoryName),
      ),
    );
  }
}