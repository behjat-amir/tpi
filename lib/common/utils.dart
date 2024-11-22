import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/cupertino.dart';

const defaultScrollPhysics = BouncingScrollPhysics();


String encryptString({required String text}) {
  var key = enc.Key.fromUtf8('fTjWnZr4u7w!z%C*F-JaNdRgUkXp2s5v');
  var iv = IV.fromUtf8('B&E)H+MbQeThWmZq');
  var encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  var encrypted = encrypter.encrypt(text, iv: iv);
  return encrypted.base64;
}
