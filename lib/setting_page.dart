import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:d_view/d_view.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'config/api.dart';
import 'dart:async';
import 'dart:convert';
import 'login_page.dart';
import 'dart:developer';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String category = "";
  String name_category = "";
  String full_name = "";
  String id_number = "";
  String unid_user = "";
  String unid_employee = "";
  bool isUpdate = false;

  bool _passwordVisible = false;

  var txtEditEmail = TextEditingController();
  TextEditingController lblNama = TextEditingController();
  TextEditingController lblidnumber = TextEditingController();
  TextEditingController lblposisi = TextEditingController();
  TextEditingController lblemail = TextEditingController();
  TextEditingController lblpassword = TextEditingController();
  TextEditingController lblpasswordre = TextEditingController();
  final GlobalKey<FormState> _formchangepassword = GlobalKey<FormState>();

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        category = pref.getString("category")!;
        full_name = pref.getString("full_name")!;
        unid_user = pref.getString("unid_user")!;
        unid_employee = pref.getString("unid_employee")!;
        //id_number = pref.getString("id_number")!;
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("is_login");
      preferences.remove("category");
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      ),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
        "Logout Successfuly",
        style: TextStyle(fontSize: 16),
      )),
    );
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: const Text("Setting", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 16,
              width: 16,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Text(
                "Pengaturan Profil",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  color: Color(0xff848588),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: ListTile(
                tileColor: Color(0x00ffffff),
                title: Text(
                  "Ubah Profil",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  textAlign: TextAlign.left,
                ),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                selected: false,
                selectedTileColor: Color(0x42000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                leading: Icon(Icons.person, color: Color(0xff7f8081), size: 24),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff808080),
                  size: 18,
                ),
                onTap: () {
                  //Navigator.of(context, rootNavigator: true).pop();
                  _DialogEdit(context, unid_employee, unid_user);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: ListTile(
                tileColor: Color(0x00ffffff),
                title: Text(
                  "Ubah Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  textAlign: TextAlign.left,
                ),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                selected: false,
                selectedTileColor: Color(0x42000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                leading:
                    Icon(Icons.vpn_key, color: Color(0xff7f8081), size: 24),
                trailing: Icon(Icons.arrow_forward_ios,
                    color: Color(0xff808080), size: 18),
                onTap: () {
                  _DialogEditPassword(context, unid_employee, unid_user);
                  //Navigator.of(context, rootNavigator: true).pop();
                  //_DialogEdit(context, unid_employee, unid_user);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Text(
                "Keluar Aplikasi",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  color: Color(0xff848588),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: ListTile(
                tileColor: Color(0x00ffffff),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff000000),
                  ),
                  textAlign: TextAlign.left,
                ),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                selected: false,
                selectedTileColor: Color(0x42000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                leading: Icon(Icons.logout, color: Color(0xffe83a3d), size: 24),
                trailing: Icon(Icons.arrow_forward_ios,
                    color: Color(0xff808080), size: 18),
                onTap: () {
                  logOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updatePassword(context, unid_employee) async {
    String strpass = lblpassword.text;
    String strpassre = lblpasswordre.text;

    final uri = Uri.parse("${Api.ChangePassword}");

    var request = http.MultipartRequest('POST', uri);

    request.fields["password"] = strpass;
    request.fields["re_password"] = strpassre;
    request.fields["unid_employee"] = unid_employee;

    await request.send().then((result) {
      //send data
      http.Response.fromStream(result).then((response) {
        Map<String, dynamic> message = jsonDecode(response.body);

        log('cek:${response.body}');

        print(response.body);

        if (message['status'] == 204) {
          Fluttertoast.showToast(
              msg: message['message'] + "!! \n ",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        } else {
          Fluttertoast.showToast(
              msg: message['message'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM);
          // labelDoc.text = "";

          Navigator.of(context, rootNavigator: true).pop();
          if (isUpdate == true) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          // dataDoc();
        }

        // if (message['status'] == 400) {
        //   Fluttertoast.showToast(
        //       msg: message['message'] + "!! \n " + message['errors'],
        //       toastLength: Toast.LENGTH_LONG,
        //       gravity: ToastGravity.TOP);
        // } else {
        //   Fluttertoast.showToast(
        //       msg: "Data berhasil diperbaharui!",
        //       toastLength: Toast.LENGTH_LONG,
        //       gravity: ToastGravity.BOTTOM);
        //   // labelDoc.text = "";

        //   Navigator.of(context, rootNavigator: true).pop();
        //   if (isUpdate == true) {
        //     Navigator.of(context, rootNavigator: true).pop();
        //   }
        //   // dataDoc();
        // }
      });
    }).catchError((e) {
      print(e);
    });
  }

  void updateProfile(context, unid_employee) async {
    String strLabelNama = lblNama.text;
    String strLabelIdnumber = lblidnumber.text;
    String strLabelPosisi = lblposisi.text;
    String strLabelEmail = lblemail.text;

    // print(strLabelEmail);

    final uri = Uri.parse("${Api.UpdateProfile}");

    var request = http.MultipartRequest('POST', uri);

    request.fields["full_name"] = strLabelNama;
    request.fields["id_number"] = strLabelIdnumber;
    request.fields["position"] = strLabelPosisi;
    request.fields["email"] = strLabelEmail;
    request.fields["unid"] = unid_employee;

    print("REQf  ${request.fields}");

    await request.send().then((result) {
      //send data
      http.Response.fromStream(result).then((response) {
        Map<String, dynamic> message = jsonDecode(response.body);

        log('cek:${response.body}');

        print(response.body);

        if (message['status'] == 400) {
          Fluttertoast.showToast(
              msg: message['message'] + "!! \n " + message['errors'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        } else {
          Fluttertoast.showToast(
              msg: "Data berhasil diperbaharui!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM);
          // labelDoc.text = "";

          Navigator.of(context, rootNavigator: true).pop();
          if (isUpdate == true) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          // dataDoc();
        }
      });
    }).catchError((e) {
      print(e);
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    //await pref.setString("id_number", strLabelIdnumber);
    await pref.setString("full_name", strLabelNama);

    setState(() {
      full_name = strLabelNama;
      //id_number = strLabelIdnumber;
    });
  }

  Future<void> _DialogEditPassword(
      BuildContext context, unid_employee, unid_user) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Change Password"),
            key: _formchangepassword,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: lblpassword,
                  textAlign: TextAlign.left,
                  obscureText: true,
                  validator: (String? arg) {
                    if (arg == null || arg.isEmpty) {
                      return 'Empty';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Password Baru",
                    hintText: '******',
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: lblpasswordre,
                  textAlign: TextAlign.left,
                  obscureText: true,
                  validator: (String? arg) {
                    if (arg == null || arg.isEmpty) {
                      return 'Empty';
                    }
                    ;

                    if (arg != lblpassword.text) {
                      return 'Not Match';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Ketik Ulang Password Baru",
                    hintText: '******',
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {updatePassword(context, unid_employee)},
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(double.infinity, 50)),
                    child: const Text("Update Password",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> _DialogEdit(
      BuildContext context, unid_employee, unid_user) async {
    //String? unid_employee;

    var result = await Dio().get("${Api.GetProfile}?unid=$unid_employee");

    //print(result.toString());

    var row_data = result.data;

    //print(row_data);

    lblNama.text = row_data["full_name"];
    lblidnumber.text = row_data["id_number"];
    lblposisi.text = row_data["position"];
    lblemail.text = row_data["email"];

    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Change Profile"),
            key: _formchangepassword,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: lblNama,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Nama Lengkap",
                    hintText: 'Input Nama Lengkap',
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: lblidnumber,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "NIP/NIK",
                    hintText: 'Input Nomor Pegawai',
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: lblposisi,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Posisi",
                    hintText: 'Input Posisi Jabatan',
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: lblemail,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "Email",
                    hintText: 'Input Email',
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => {updateProfile(context, unid_employee)},
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(double.infinity, 50)),
                    child: const Text("Update Profile"),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
