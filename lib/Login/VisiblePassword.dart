import 'package:flutter/material.dart';

//ignore: must_be_immutable
class VisiblePassword extends StatefulWidget {
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function()? toggleVisibility;
  bool visible;
  VisiblePassword({Key? key, this.toggleVisibility, this.validator, this.onChanged, required this.visible}) : super(key: key);
  @override
  State<VisiblePassword> createState() => _VisiblePasswordState();
}

class _VisiblePasswordState extends State<VisiblePassword> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: widget.visible,
        decoration: InputDecoration(
            hintText: "Password",
            fillColor: Colors.blue,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.pink, width: 2.0)
            ),
            suffixIcon: GestureDetector(
                onTap: widget.toggleVisibility,
                child: Icon(
                    widget.visible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded
                )
            )
        ),

        validator: widget.validator,
        onChanged: widget.onChanged,
    );
  }
}
