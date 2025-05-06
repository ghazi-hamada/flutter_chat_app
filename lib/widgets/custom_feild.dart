 
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

Widget customFeild(
  {
    required TextEditingController controller,
    required String labelText,
    required IconData? icon,
    required String? Function(String?)? validator,
  }
) {
  return TextFormField(
                        controller:
                           controller
                           ,
                        decoration: InputDecoration(
                          labelText: labelText,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon:   Icon(icon),
                        ),
                        validator:
                            validator,
                      );
}
