import 'package:flutter/material.dart';

class Weight {
  final double value;
  final bool valid;

  Weight({required this.value, required this.valid});
  factory Weight.fromJson(Map<dynamic, dynamic> json){
    return Weight(
      valid: json["valid"],
      value: json["value"],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "valid": valid,
      "value": value,
    };
  }
}