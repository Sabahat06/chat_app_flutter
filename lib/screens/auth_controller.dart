import 'package:email_password_login/model/user_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  Rx<UserModel> userModel = UserModel().obs;
  // User user = FirebaseAuth.instance.currentUser;
  RxBool isLogedIn = false.obs;

  Future<void> onInit() async {
    userModel.value = await UserModel.fromCache();
    isLogedIn.value = userModel.value == null ? false : true;
    // TODO: implement onInit
    super.onInit();
  }

  // getUser() {
  //   FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((value) {
  //     userModel.value = UserModel.fromJson(value.data());
  //   });
  // }


}