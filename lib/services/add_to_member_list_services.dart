import 'package:capstone2_project_management_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/member_model.dart';

class AddToListServices extends GetxController {
  Rx<List<MemberModel>> members = Rx<List<MemberModel>>([]);
  late MemberModel memberModel;
  var controller = TextEditingController();
  var itemCount = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  addItemToList() {}
}
