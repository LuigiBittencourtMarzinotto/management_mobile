import 'package:flutter/material.dart';

class FieldForm extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  FieldForm({
    required this.label,
    required this.isPassword,
    required this.controller,
    super.key,
  });

  @override
  FieldFormState createState() => FieldFormState();
}

class FieldFormState extends State<FieldForm> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: TextFormField(
        obscureText: _isPasswordVisible,
        controller: widget.controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.grey[600]),  // Cor do label
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]!)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: const Color(0xFFCCCCCC)),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[700],
                    size: 20,
                  ),
                  onPressed: _toggleObscureText,
                )
              : SizedBox(),
        ),
        style: TextStyle(fontSize: 16),  // Ajuste o tamanho do texto conforme necessário
      ),
    );
  }
}
