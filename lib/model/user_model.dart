import 'package:cached_map/cached_map.dart';

class UserModel {
  String uid;
  String email;
  String firstName;
  String secondName;
  String phoneNumber;
  String imageUrl;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
    this.phoneNumber,
    this.imageUrl
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
    );
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    firstName = json['firstName'];
    secondName = json['secondName'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['secondName'] = this.secondName;
    data['phoneNumber'] = this.phoneNumber;
    data['imageUrl'] = this.imageUrl;
    return data;
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
    };
  }



  ///custom functions
  static Future<UserModel> fromCache() async {
    Mapped cacheJson = await Mapped.getInstance();
    var cachedUser = cacheJson.loadFile(cachedFileName: "user");
    print("user from cache: $cachedUser");
    if(cachedUser == null)
      return null;
    else
      return UserModel.fromJson(cachedUser);
  }

  /// member functions

  static Future<String> saveUserToCache(UserModel user) async{
    Mapped cacheJson = await Mapped.getInstance();
    try{
      cacheJson.saveFile(file: user.toJson(), cachedFileName: "user");
    }
    catch(e){
      return "Failed to save user due to: $e";
    }
    return "Save user to cache successfully ";
  }



  static Future<String> deleteCachedUser()async{
    Mapped cacheJson = await Mapped.getInstance();
    try{
      cacheJson.deleteFile(cachedFileName: "user");
    }
    catch(e){
      return "Some Problem accoured while deleting user File:$e";
    }
    return "Deleted user to cache successfully";

  }

}
