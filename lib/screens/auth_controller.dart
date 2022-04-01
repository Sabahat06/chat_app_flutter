import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:email_password_login/model/user_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  Rx<UserModel> userModel = UserModel().obs;
  String imageFromFirebase;
  String imageFromFirebaseChat;
  // User user = FirebaseAuth.instance.currentUser;
  RxBool isLogedIn = false.obs;
  Rx<File> file = File('').obs;
  bool updateProfileImageUploaded = false;
  Rx<File> updateProfileFile = File('').obs;

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

  Future<void> openGallery(bool openGallary)  {
    ImagePicker().getImage(
        source: openGallary ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 15).then((imageFile) {
      file.value = File(imageFile.path);
      if(file.value != null) {
        uploadFileInFirebase();
      }
    });
  }

  Future<void> openGalleryForChat(bool openGallary)  {
    ImagePicker().getImage(
        source: openGallary ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 15).then((imageFile) {
      file.value = File(imageFile.path);
      if(file.value != null) {
        uploadFileInFirebaseChat();
      }
    });
  }

  Future<void> openGalleryForUpdateProfile(bool openGallary)  {
    ImagePicker().getImage(
        source: openGallary ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 15).then((imageFile) {
      updateProfileFile.value = File(imageFile.path);
      if(updateProfileFile.value != null) {
        updateProfileImageUploaded = true;
        uploadFileInFirebase();
      }
    });
  }

  Future uploadFileInFirebase() async {
    if (file.value == null) return;
    final fileName = basename(file.value.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('file/');

      UploadTask uploadTask;
      uploadTask = ref.child(fileName).putFile(file.value);
      // now get the url of image and store in firebase
      var imageUrl;
      imageUrl = await (await uploadTask).ref.getDownloadURL();
      String url = imageUrl.toString();
      print(url);
      imageFromFirebase = url;

      // await ref.putFile(file.value);
      // String url = ref.getDownloadURL();
      // print(url);
      // UploadTask uploadTask;

    } catch (e) {
      print('error occured');
    }
  }

  Future uploadFileInFirebaseChat() async {
    if (file.value == null) return;
    final fileName = basename(file.value.path);
    final destination = '${DateTime.now()}/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('file/');

      UploadTask uploadTask;
      uploadTask = ref.child(fileName).putFile(file.value);
      // now get the url of image and store in firebase
      var imageUrl;
      imageUrl = await (await uploadTask).ref.getDownloadURL();
      String url = imageUrl.toString();
      print(url);
      imageFromFirebaseChat = url;

      // await ref.putFile(file.value);
      // String url = ref.getDownloadURL();
      // print(url);
      // UploadTask uploadTask;

    } catch (e) {
      print('error occured');
    }
  }

}