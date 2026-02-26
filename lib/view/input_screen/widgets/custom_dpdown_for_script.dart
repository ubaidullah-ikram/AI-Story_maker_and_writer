import 'package:ai_story_writer/view/api_request_%20controller/api_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDpdownForScript extends StatefulWidget {
  @override
  _CustomDpdownForScriptState createState() => _CustomDpdownForScriptState();
}

class _CustomDpdownForScriptState extends State<CustomDpdownForScript> {
  String selectedscriptType1 = 'YouTube Video';
  String selectedscriptType2= 'Comedy';

  var apiController = Get.find<GeminiApiServiceController>();
  final List<String> scriptTone = [
    'YouTube Video',
    "Short Film",
    'Advertisement',
    'Podcast',
    'Reel', 
    "Tiktok Video",
    "Movie",
  ];

  final List<String> scriptType = [
    'Comedy',
    'Drama',
    'Horror',
    'Action',
    'Romance',
    "Motivational",
    "Mystery",
    "Fairy Tale",
    "Thriller",
   
  ];

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [ 
        
        // Academic Level Dropdown
        _buildDropdown(
          label: 'Script Tone',
          value: selectedscriptType1,
          items: scriptTone,
          onChanged: (value) {
            setState(() {
              selectedscriptType1 = value!;
              apiController.selectedScriptTone.value = selectedscriptType1;
            });
          },
        ),
        
        SizedBox(height: 24),
        
        // Type of Paper Dropdown
        _buildDropdown(
          label: 'Script Type',
          value: selectedscriptType2,
          items: scriptType,
          onChanged: (value) {
            setState(() {
              selectedscriptType2 = value!;
              apiController.selectedScriptType2.value = selectedscriptType2;
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
          Container(
            height: 40,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(iconEnabledColor: Colors.white,iconDisabledColor:  Colors.white,
                value: value,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                dropdownColor: Colors.black,
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