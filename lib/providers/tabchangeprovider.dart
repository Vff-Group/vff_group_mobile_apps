import 'package:flutter/material.dart';
import 'package:vff_group/global/vffglb.dart' as glb;

class TabProvider with ChangeNotifier {
  int pageIndex = 0;

  void changeTab(int index) {
    pageIndex = index;
    glb.pageIndex = index;
    print(glb.pageIndex);
    notifyListeners();
  }
}
