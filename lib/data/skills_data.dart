import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/skill.dart';

class SkillsRepository {
  static const String _jsonPath = 'assets/data/skills.json';

  Future<List<Skill>> getSkills() async {
    try {
      // Load the JSON file as a string
      final String response = await rootBundle.loadString(_jsonPath);
      
      // Parse the JSON string into a list of dynamic objects
      final List<dynamic> jsonData = json.decode(response);
      
      // Convert each JSON object into a Skill object
      return jsonData.map((skill) => Skill.fromJson(skill)).toList();
    } catch (e) {
      // In case of any error (e.g., file not found, invalid JSON),
      // return an empty list or rethrow the error as needed
      print('Error loading skills data: $e');
      return [];
    }
  }

  // Helper method to group skills by level
  Map<String, List<Skill>> groupSkillsByLevel(List<Skill> skills) {
    final Map<String, List<Skill>> grouped = {};
    
    // Initialize lists for each level to maintain order
    grouped['Basic'] = [];
    grouped['Intermediate'] = [];
    grouped['Advanced'] = [];
    
    // Group skills by level
    for (var skill in skills) {
      if (grouped.containsKey(skill.level)) {
        grouped[skill.level]!.add(skill);
      }
    }
    
    return grouped;
  }
}

// Can use this to test the app

  // final String response = '''
  //   [
  //     {"name": "Dribbling", "level": "Basic", "image": "https://via.placeholder.com/150"},
  //     {"name": "Passing", "level": "Basic", "image": "https://via.placeholder.com/150"},
  //     {"name": "Shooting", "level": "Basic", "image": "https://via.placeholder.com/150"},
  //     {"name": "Vault", "level": "Intermediate", "image": "https://via.placeholder.com/150"},
  //     {"name": "Tackling", "level": "Intermediate", "image": "https://via.placeholder.com/150"},
  //     {"name": "Heading", "level": "Intermediate", "image": "https://via.placeholder.com/150"},
  //     {"name": "Agility", "level": "Advanced", "image": "https://via.placeholder.com/150"},
  //     {"name": "Free Kicks", "level": "Advanced", "image": "https://via.placeholder.com/150"},
  //     {"name": "Penalty Kicks", "level": "Advanced", "image": "https://via.placeholder.com/150"}
  //   ]
  //   ''';