import 'package:flutter/material.dart';

class ReserveTrainInputProvider extends ChangeNotifier {
  String name = "";
  String phone = "";
  String pwd1 = "";
  String pwd2 = "";
  bool isButtonEnabled = false;

  String get getName => name;
  String get getPhone => phone;
  String get getPwd1 => pwd1;
  String get getPwd2 => pwd2;

  void setName(String name) {
    this.name = name;
    setButtonEnabled();
  }

  void setPhone(String phone) {
    this.phone = phone;
    setButtonEnabled();
  }

  void setPwd1(String pwd1) {
    this.pwd1 = pwd1;
    setButtonEnabled();
  }

  void setPwd2(String pwd2) {
    this.pwd2 = pwd2;
    setButtonEnabled();
  }

  bool isSamePwd() {
    return pwd1 == pwd2;
  }

  void setButtonEnabled() {
    if (name.isNotEmpty &&
        phone.isNotEmpty &&
        pwd1.isNotEmpty &&
        pwd2.isNotEmpty &&
        isSamePwd()) {
      isButtonEnabled = true;
    } else {
      isButtonEnabled = false;
    }
    notifyListeners();
  }
}
