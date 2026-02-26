import 'dart:developer';

import 'package:ai_story_writer/view/api_request_%20controller/api_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownScreen extends StatefulWidget {
  @override
  _CustomDropdownScreenState createState() => _CustomDropdownScreenState();
}

class _CustomDropdownScreenState extends State<CustomDropdownScreen> {
  String selectedAcademicLevel = 'High School';
  String selectedPaperType = 'Expository';

  var apiController = Get.find<GeminiApiServiceController>();
  final List<String> academicLevels = [
    'High School',
    "College",
    'University',
    'Masters',
    'Custom', 
  ];

  final List<String> paperTypes = [
    'Expository',
    'Argumentative',
    'Narrative',
    'Descriptive',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [ 
        
        // Academic Level Dropdown
        _buildDropdown(
          label: 'Academic Level',
          value: selectedAcademicLevel,
          items: academicLevels,
          onChanged: (value) {
            setState(() {
              selectedAcademicLevel = value!;
              apiController.selectedAcademicLevel.value = selectedAcademicLevel;
              log('the selected academic level is : $selectedAcademicLevel');
            });
          },
        ),
        
        SizedBox(height: 24),
        
        // Type of Paper Dropdown
        _buildDropdown(
          label: 'Type of Paper',
          value: selectedPaperType,
          items: paperTypes,
          onChanged: (value) {
            setState(() {
              selectedPaperType = value!;   
              apiController.selectedPaperType.value = selectedPaperType;
              log('the selected paper type is : $selectedPaperType');
           });
          },
        ),
      ],
    )
   ;
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container( 
      decoration: BoxDecoration(
        // color: Colors.amber,
        color: Color(0xFF1A1A1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF34343C),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.tr,
            style: TextStyle(
              color: Color(0xff787878),
              fontSize: 14,
            ),
          ),
          Container(height: 40,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(iconEnabledColor: Colors.white,iconDisabledColor:  Colors.white,
                value: value,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                dropdownColor: const Color.fromARGB(255, 42, 41, 41),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item.tr),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}