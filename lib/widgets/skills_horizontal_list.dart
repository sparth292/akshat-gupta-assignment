import 'package:flutter/material.dart';
import '../models/skill.dart';
import 'skill_card.dart';

class SkillsHorizontalList extends StatelessWidget {
  final String level;
  final List<Skill> skills;
  final Color? levelColor;

  const SkillsHorizontalList({
    Key? key,
    required this.level,
    required this.skills,
    this.levelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Level Header with improved styling
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Level title with accent line
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: levelColor ?? Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    level.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              // Skills count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[800]!.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[700]!,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  '${skills.length} Skills',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Horizontal List of Skills with custom scroll physics
        SizedBox(
          height: 200, // Increased height for better card display
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 16.0),
            physics: const BouncingScrollPhysics(),
            itemCount: skills.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SkillCard(
                  skill: skills[index],
                  onTap: () {
                    // Show a more polished snackbar on tap
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Selected: ${skills[index].name.toUpperCase()}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: levelColor?.withOpacity(0.9) ?? Theme.of(context).primaryColor,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        
        // Divider between sections
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Divider(
            color: Colors.grey[800],
            height: 1,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}
