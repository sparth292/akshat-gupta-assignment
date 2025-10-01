import 'package:flutter/material.dart';
import 'package:football/data/skills_data.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/skill.dart';
import '../widgets/skills_horizontal_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 1.0;
  final double _maxScrollExtent = 100.0; // Adjust this value to control when the fade completes
  DateTime _lastUpdate = DateTime.now();
  bool _isUpdating = false;
  late Future<Map<String, List<Skill>>> _groupedSkillsFuture;
  final SkillsRepository _skillsRepository = SkillsRepository();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _loadSkills();
    
    // Add optimized scroll listener
    _scrollController.addListener(() {
      final now = DateTime.now();
      // Only update at most once per frame (16ms for 60fps)
      if (now.difference(_lastUpdate).inMilliseconds < 16 || _isUpdating) return;
      
      _isUpdating = true;
      _lastUpdate = now;
      
      // Schedule the update for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final double offset = _scrollController.offset;
        final newOpacity = 1.0 - (offset / _maxScrollExtent).clamp(0.0, 1.0);
        
        // Only update if opacity actually changed
        if ((newOpacity - _opacity).abs() > 0.01) {
          setState(() {
            _opacity = newOpacity;
          });
        }
        _isUpdating = false;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSkills() async {
    try {
      final skills = await _skillsRepository.getSkills();
      final groupedSkills = _skillsRepository.groupSkillsByLevel(skills);
      
      if (mounted) {
        setState(() {
          _groupedSkillsFuture = Future.value(groupedSkills);
          _animationController.forward();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _groupedSkillsFuture = Future.error(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar with gradient background
          SliverAppBar(
            expandedHeight: 160.0,
            pinned: true,
            floating: false,
            backgroundColor: Colors.black,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/back.png'),
                  fit: BoxFit.cover,
                  opacity: _opacity * 0.7, // Fade image based on scroll position
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF121212).withOpacity(0.9 * _opacity),
                    const Color(0xFF000000).withOpacity(0.9 * _opacity),
                  ],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Text(
                    'FOT MOB',
                    style: GoogleFonts.exo2(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      shadows: const [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Main content
          SliverToBoxAdapter(
            child: FutureBuilder<Map<String, List<Skill>>>(
              future: _groupedSkillsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red[400],
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load skills',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please check your connection and try again',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadSkills,
                            icon: const Icon(Icons.refresh, size: 20),
                            label: const Text('TRY AGAIN'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final groupedSkills = snapshot.data ?? {};
                
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Skills
                      SkillsHorizontalList(
                        level: 'Basic',
                        skills: groupedSkills['Basic'] ?? [],
                        levelColor: const Color(0xFF4CAF50), // Green
                      ),
                      
                      // Intermediate Skills
                      SkillsHorizontalList(
                        level: 'Intermediate',
                        skills: groupedSkills['Intermediate'] ?? [],
                        levelColor: const Color(0xFFFF9800), // Orange
                      ),
                      
                      // Advanced Skills
                      SkillsHorizontalList(
                        level: 'Advanced',
                        skills: groupedSkills['Advanced'] ?? [],
                        levelColor: const Color(0xFFF44336), // Red
                      ),
                      
                      // Bottom padding
                      const SizedBox(height: 32),
                      
                      // Footer
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'Made with <3 by Parth',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
