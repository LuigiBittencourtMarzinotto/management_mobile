import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldForm extends StatefulWidget {
  final String label;
  final bool isPassword;
  final bool isNumber;
  final int? maxLength;
  final TextEditingController controller;

  FieldForm({
    required this.label,
    required this.isPassword,
    required this.controller,
    this.isNumber = false,
    this.maxLength,
    super.key,
  });

  @override
  FieldFormState createState() => FieldFormState();
}

class FieldFormState extends State<FieldForm> {
  late bool _isPasswordVisible;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isPassword;
    _errorMessage = null;
  }

  void _toggleObscureText() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _validateInput(String value) {
    if (widget.isNumber && widget.maxLength != null) {
      if (value.length != widget.maxLength) {
        setState(() {
          _errorMessage = "O campo deve ter exatamente ${widget.maxLength} dígitos.";
        });
      } else {
        setState(() {
          _errorMessage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: TextFormField(
            obscureText: widget.isPassword ? _isPasswordVisible : false,
            controller: widget.controller,
            keyboardType:
                widget.isNumber ? TextInputType.number : TextInputType.text,
            inputFormatters: [
              if (widget.isNumber) FilteringTextInputFormatter.digitsOnly,
              if (widget.maxLength != null)
                LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: widget.label,
              labelStyle: TextStyle(color: Colors.grey[600]),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFFCCCCCC)),
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      onPressed: _toggleObscureText,
                    )
                  : null,
            ),
            style: TextStyle(fontSize: 16),
            onChanged: _validateInput,
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
