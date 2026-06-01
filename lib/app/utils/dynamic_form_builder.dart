import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicFormBuilder {
  static Future<List<dynamic>> loadSchema(String path) async {
    String data = await rootBundle.loadString(path);
    return json.decode(data);
  }

  static List<Widget> buildFields(List<dynamic> schema, Map<String, dynamic> formData) {
    return schema.map<Widget>((field) {
      final key = field['key'];
      final label = field['label'];
      final type = field['type'];
      final required = field['required'] ?? false;

      if (type == 'text' || type == 'email' || type == 'number') {
        return TextFormField(
          initialValue: formData[key],
          decoration: InputDecoration(labelText: label),
          keyboardType: type == 'number' ? TextInputType.number : TextInputType.text,
          validator: required ? (value) => value!.isEmpty ? 'Required' : null : null,
          onSaved: (value) => formData[key] = value,
        );
      }

      if (type == 'dropdown') {
        final options = List<String>.from(field['options']);
        return DropdownButtonFormField<String>(
          value: formData[key],
          decoration: InputDecoration(labelText: label),
          items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
          validator: required ? (value) => value == null ? 'Required' : null : null,
          onChanged: (value) => formData[key] = value,
        );
      }

      return SizedBox.shrink();
    }).toList();
  }
}
