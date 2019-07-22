import 'package:image/image.dart' as IO;
import 'dart:io';
 import 'package:flutter/material.dart';

 //this is just a class for random testing purposes ;)

void test(File image) {
    IO.Image i = IO.decodeImage(new File('test.webp').readAsBytesSync());

}