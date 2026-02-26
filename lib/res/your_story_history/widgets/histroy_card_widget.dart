// import 'package:flutter/material.dart';

// class StoryCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final String bottomLabel;
//   final String timeAgo;
//   final Color labelColor;
//   final VoidCallback? onTap;

//   const StoryCard({
//     Key? key,
//     required this.title,
//     required this.description,
//     required this.bottomLabel,
//     required this.timeAgo,
//     this.labelColor = Colors.red,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E1E1E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFF2A2A2A),
//           width: 1,
//         ),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                     letterSpacing: -0.3,
//                   ),
//                 ),
                
//                 const SizedBox(height: 16),
                
//                 // Description
//                 Text(
//                   description,
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.7),
//                     fontSize: 15,
//                     height: 1.5,
//                     letterSpacing: -0.2,
//                   ),
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                 ),
                
//                 const SizedBox(height: 16),
                
//                 // Divider
//                 Container(
//                   height: 1,
//                   color: const Color(0xFF2A2A2A),
//                 ),
                
//                 const SizedBox(height: 16),
                
//                 // Bottom row with label and time
//                 Row(
//                   children: [
//                     // Dot indicator
//                     Container(
//                       width: 8,
//                       height: 8,
//                       decoration: BoxDecoration(
//                         color: labelColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
                    
//                     const SizedBox(width: 12),
                    
//                     // Label
//                     Text(
//                       bottomLabel,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
                    
//                     const Spacer(),
                    
//                     // Time ago
//                     Text(
//                       timeAgo,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.5),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
