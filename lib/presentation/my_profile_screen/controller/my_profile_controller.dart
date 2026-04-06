import 'package:get/get.dart';

class MyProfileController extends GetxController {
  var name = "Md Abu Ubayda".obs;
  var email = "ubayda@example.com".obs;
  var profilePic = "https://i.pravatar.cc/150".obs;

  void updateProfile(String newName, String newEmail) {
    name.value = newName;
    email.value = newEmail;
    Get.back();
  }
}
