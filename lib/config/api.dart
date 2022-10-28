import 'dart:convert';

class Api {
  static const _baseUrl = 'http://kpu-cimahi.com';

  static const Login = '$_baseUrl/api/auth/login';
  static const ListDocs = '$_baseUrl/api/document/list';
  static const PhotoLink = '$_baseUrl/uploads/profile/doraemon.png';
  static const UploadPhoto = '$_baseUrl/api/employee/updatefoto';
  static const UploadDoc = '$_baseUrl/api/document/upload';
  static const DeleteDoc = '$_baseUrl/api/document/remove';
  static const GetProfile = '$_baseUrl/api/employee/getprofile/';
  static const UpdateProfile = '$_baseUrl/api/employee/updateprofile';
  static const ChangePassword = '$_baseUrl/api/auth/changepassword';
}
