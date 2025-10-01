class Skill {
  final String name;
  final String level;
  final String imageUrl;

  const Skill({
    required this.name,
    required this.level,
    required this.imageUrl,
  });

  // Convert JSON to Skill object
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String,
      level: json['level'] as String,
      imageUrl: 'assets/${json['image'] as String}', // Add assets/ prefix
    );
  }

  // Convert Skill object to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'level': level,
        'image': imageUrl,
      };

  @override
  String toString() => 'Skill(name: $name, level: $level)';
}
