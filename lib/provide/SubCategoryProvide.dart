import 'package:flutter/material.dart';
import '../model/SubCategory.dart';
import 'package:provide/provide.dart';

class SubCategoryProvide with ChangeNotifier{
  List<SubCategory> subCategoryList=[];

  getSubCategory(List list){
    subCategoryList=list;
    notifyListeners();
  }
}