import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const HackTrackApp());
}

class HackTrackApp extends StatelessWidget {
  const HackTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF8B5CF6),
          surface: Color(0xFF1D1E33),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ============================================================
// SPLASH SCREEN
// ============================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const OnboardingScreen(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.rocket_launch_rounded, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'HackTrack',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
              ),
            ),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text('Never Miss a Hackathon', style: TextStyle(fontSize: 14, color: Colors.grey[400], letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ONBOARDING SCREEN
// ============================================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.explore_rounded,
      'title': 'Discover Hackathons',
      'description': 'AI-powered engine finds hackathons tailored to your skills and interests',
      'colors': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
    },
    {
      'icon': Icons.notifications_active_rounded,
      'title': 'Never Miss Deadlines',
      'description': 'Smart reminders for registration, submission and result announcements',
      'colors': [const Color(0xFFF093FB), const Color(0xFFF5576C)],
    },
    {
      'icon': Icons.trending_up_rounded,
      'title': 'Track Your Journey',
      'description': 'Manage multiple hackathons and stay organized with your dashboard',
      'colors': [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: Text('Skip', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: page['colors'], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [BoxShadow(color: (page['colors'][0] as Color).withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 5)],
                          ),
                          child: Icon(page['icon'] as IconData, size: 70, color: Colors.white),
                        ),
                        const SizedBox(height: 50),
                        Text(page['title'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        Text(page['description'], style: TextStyle(fontSize: 16, color: Colors.grey[400], height: 1.5), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? const Color(0xFF6366F1) : Colors.grey[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      _navigateToLogin();
                    } else {
                      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// ============================================================
// LOGIN SCREEN
// ============================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text('Welcome to', style: TextStyle(fontSize: 24, color: Colors.grey[400])),
                const SizedBox(height: 8),
                const Text('HackTrack', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 50),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your email';
                    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
                    if (!emailRegex.hasMatch(v)) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey[400]),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter your password';
                    if (v.length < 8) return 'Password must be at least 8 characters';
                    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Must contain an uppercase letter';
                    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Must contain a digit';
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen())),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.grey[400]),
                        children: const [
                          TextSpan(text: 'Sign Up', style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF1D1E33),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[800]!)),
        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Color(0xFF6366F1), width: 2)),
        errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Colors.red)),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _isLoading = false);
        // TODO: Replace with real auth backend (e.g. Firebase Auth)
        final email = _emailController.text.trim();
        final password = _passwordController.text;
        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Invalid credentials. Please try again.'),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          return;
        }
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ============================================================
// PROFILE SETUP SCREEN
// ============================================================
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _degreeController = TextEditingController();
  final List<String> _selectedSkills = [];
  final List<String> _selectedInterests = [];

  final List<String> _skills = ['Python', 'Flutter', 'React', 'Node.js', 'Java', 'C++', 'Go', 'Swift', 'Kotlin', 'TypeScript', 'JavaScript', 'Machine Learning', 'Data Science', 'Cloud Computing', 'DevOps', 'Blockchain', 'UI/UX Design', 'Cybersecurity'];
  final List<String> _interests = ['Artificial Intelligence', 'Machine Learning', 'Web Development', 'Mobile Development', 'Blockchain & Web3', 'Fintech', 'Healthcare Tech', 'EdTech', 'IoT', 'AR/VR', 'Cybersecurity', 'Data Science', 'Cloud Computing', 'Social Impact'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildBasicInfo(), _buildEducation(), _buildSkillsStep(), _buildInterestsStep()],
              ),
            ),
            _buildNavButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentStep > 0)
            GestureDetector(onTap: _previousStep, child: const Icon(Icons.arrow_back, color: Colors.white)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(4, (i) => Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                decoration: BoxDecoration(
                  color: i <= _currentStep ? const Color(0xFF6366F1) : Colors.grey[800],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )),
          ),
          const SizedBox(height: 12),
          Text('Step ${_currentStep + 1} of 4', style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() => _buildStep('Let\'s get to know you', 'Tell us about yourself', [
    _buildField(_nameController, 'Full Name', Icons.person_outline, hint: 'John Doe'),
    const SizedBox(height: 20),
    _buildField(_emailController, 'Email', Icons.email_outlined, hint: 'john@example.com', keyboardType: TextInputType.emailAddress),
  ]);

  Widget _buildEducation() => _buildStep('Your Education', 'What are you currently studying?', [
    _buildField(_degreeController, 'Degree / Program', Icons.school_outlined, hint: 'B.Tech Computer Science'),
  ]);

  Widget _buildSkillsStep() => _buildChipStep('Your Skills', 'Select all that apply', _skills, _selectedSkills);
  Widget _buildInterestsStep() => _buildChipStep('Your Interests', 'What areas excite you?', _interests, _selectedInterests);

  Widget _buildStep(String title, String subtitle, List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.grey[400])),
          const SizedBox(height: 40),
          ...children,
        ],
      ),
    );
  }

  Widget _buildChipStep(String title, String subtitle, List<String> options, List<String> selected) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.grey[400])),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((item) {
              final isSelected = selected.contains(item);
              return GestureDetector(
                onTap: () => setState(() => isSelected ? selected.remove(item) : selected.add(item)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? const Color(0xFF6366F1) : Colors.grey[800]!),
                  ),
                  child: Text(item, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[300])),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {String? hint, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.grey[400]),
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFF1D1E33),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[800]!)),
        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Color(0xFF6366F1), width: 2)),
      ),
    );
  }

  Widget _buildNavButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF6366F1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Back', style: TextStyle(color: Color(0xFF6366F1), fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == 3 ? _completeSetup : _nextStep,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 16)),
              child: Text(_currentStep == 3 ? 'Complete' : 'Continue', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    // Validate current step before proceeding
    if (_currentStep == 0) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      if (name.isEmpty || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please fill in all fields before continuing.'),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
      final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
      if (!emailRegex.hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enter a valid email address.'),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
    } else if (_currentStep == 1 && _degreeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your degree / program.'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() => _currentStep++);
    _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _previousStep() {
    setState(() => _currentStep--);
    _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _completeSetup() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _degreeController.dispose();
    super.dispose();
  }
}

// ============================================================
// HOME SCREEN
// ============================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  List<Map<String, dynamic>> _aiRecommended = [];
  List<Map<String, dynamic>> _endingSoon = [];
  List<Map<String, dynamic>> _allLive = [];

  final List<List<Color>> _gradientPool = [
    [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
    [const Color(0xFFF093FB), const Color(0xFFF5576C)],
    [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
    [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
  ];

  @override
  void initState() {
    super.initState();
    _fetchLiveHackathons();
  }

  Future<void> _fetchLiveHackathons() async {
    try {
      final response = await http.get(Uri.parse('https://devpost.com/api/hackathons?status=open'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> hackathonsData = data['hackathons'] ?? [];

        List<Map<String, dynamic>> formattedList = [];
        
        for (int i = 0; i < hackathonsData.length; i++) {
          final h = hackathonsData[i];
          
          // Parse themes
          List<String> tags = [];
          if (h['themes'] != null) {
            for (var theme in h['themes']) {
              tags.add(theme['name']);
            }
          }
          
          // Extract prize text from HTML span using regex (if possible) or just fallback
          String prize = 'Swag/Other';
          if (h['prize_amount'] != null) {
             final prizeStr = h['prize_amount'].toString();
             final match = RegExp(r'>([^<]+)<').firstMatch(prizeStr);
             prize = match != null ? '\$${match.group(1)}' : prizeStr.replaceAll(RegExp(r'<[^>]*>'), '');
          }

          formattedList.add({
            'title': h['title'] ?? 'Unknown',
            'organizer': h['organization_name'] ?? 'Organizer',
            'tags': tags.isNotEmpty ? tags.take(3).toList() : ['Hackathon'],
            'deadline': h['submission_period_dates'] != null ? h['submission_period_dates'].toString().split('-').last.trim() : 'Unknown',
            'prize': prize,
            // Assign fake AI match score between 70 - 99
            'matchScore': 99 - (i % 25), 
            'source': 'Devpost',
            'colors': _gradientPool[i % _gradientPool.length],
            'url': h['url'],
            'thumbnail_url': h['thumbnail_url']?.toString().replaceAll('//', 'https://'),
          });
        }

        setState(() {
          _allLive = List.from(formattedList);
          
          // AI Recommended: Top 5 by match score
          _aiRecommended = List.from(formattedList)..sort((a, b) => (b['matchScore'] as int).compareTo(a['matchScore'] as int));
          _aiRecommended = _aiRecommended.take(5).toList();

          // Ending Soon: Simulate by taking a slice
          _endingSoon = List.from(formattedList);
          if (_endingSoon.length > 5) {
             _endingSoon = _endingSoon.sublist(5, 10);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      // print('Error fetching hackathons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.rocket_launch_rounded, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text('HackTrack', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.account_circle_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: const Color(0xFF1D1E33), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[800]!)),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey[400]),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(hintText: 'Search hackathons...', hintStyle: TextStyle(color: Colors.grey[500]), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 16)),
                          ),
                        ),
                        Icon(Icons.tune, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildStatCard('${_allLive.length}', 'Live Now', const Color(0xFF6366F1)),
                      const SizedBox(width: 12),
                      _buildStatCard('0', 'Registered', const Color(0xFF10B981)),
                      const SizedBox(width: 12),
                      _buildStatCard('${_endingSoon.length}', 'Ending Soon', const Color(0xFFF59E0B)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Track 1: AI Recommended
                _buildTrackHeader('⚡ Top Matches for You', 'Curated by AI'),
                const SizedBox(height: 12),
                _buildHorizontalTrack(_aiRecommended),
                const SizedBox(height: 24),

                // Track 2: Ending Soon
                _buildTrackHeader('⏳ Ending Soon', 'Don\'t miss out'),
                const SizedBox(height: 12),
                _buildHorizontalTrack(_endingSoon),
                const SizedBox(height: 24),
                
                // Track 3: All Live
                _buildTrackHeader('🌐 All Live Hackathons', 'Explore everything'),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: _allLive.take(10).map((h) => _buildHackathonListItem(h)).toList(),
                  ),
                ),
              ],
            ),
          ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHackathonScreen())),
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Hackathon', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1D1E33),
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_rounded), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            ],
          ),
          TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: Color(0xFF6366F1)))),
        ],
      ),
    );
  }

  Widget _buildHorizontalTrack(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final h = items[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HackathonDetailScreen(hackathon: h))),
            child: Container(
              width: 280,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(color: const Color(0xFF1D1E33), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[800]!)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80, 
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: h['colors']), 
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      image: h['thumbnail_url'] != null 
                        ? DecorationImage(image: NetworkImage(h['thumbnail_url']), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.4), BlendMode.darken))
                        : null,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                        child: Text('${h['matchScore']}% Match', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Text(h['organizer'], style: TextStyle(fontSize: 12, color: Colors.grey[400]), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Expanded(child: Text(h['deadline'], style: TextStyle(fontSize: 12, color: Colors.grey[400]), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHackathonListItem(Map<String, dynamic> h) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HackathonDetailScreen(hackathon: h))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: const Color(0xFF1D1E33), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[800]!)),
        child: Column(
          children: [
            Container(height: 6, decoration: BoxDecoration(gradient: LinearGradient(colors: h['colors']), borderRadius: const BorderRadius.vertical(top: Radius.circular(20)))),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(h['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: h['source'] == 'AI' ? const Color(0xFF6366F1).withValues(alpha: 0.2) : const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          h['source'] == 'AI' ? '🤖 AI' : '✋ Manual',
                          style: TextStyle(fontSize: 11, color: h['source'] == 'AI' ? const Color(0xFF6366F1) : const Color(0xFF10B981), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(h['organizer'], style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: (h['tags'] as List<String>).map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF0A0E21), borderRadius: BorderRadius.circular(8)),
                      child: Text(tag, style: const TextStyle(fontSize: 11, color: Color(0xFF6366F1))),
                    )).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(h['deadline'], style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                      const Spacer(),
                      Icon(Icons.emoji_events_outlined, size: 14, color: Colors.amber[400]),
                      const SizedBox(width: 4),
                      Text(h['prize'], style: TextStyle(fontSize: 13, color: Colors.amber[400], fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(gradient: LinearGradient(colors: h['colors']), borderRadius: BorderRadius.circular(20)),
                        child: Text('${h['matchScore']}% Match', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HACKATHON DETAIL SCREEN
// ============================================================
class HackathonDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hackathon;
  const HackathonDetailScreen({super.key, required this.hackathon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: const Color(0xFF0A0E21),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: hackathon['colors'], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  image: hackathon['thumbnail_url'] != null 
                    ? DecorationImage(image: NetworkImage(hackathon['thumbnail_url']), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.5), BlendMode.darken))
                    : null,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      if (hackathon['thumbnail_url'] == null)
                        const Icon(Icons.rocket_launch_rounded, size: 60, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(hackathon['organizer'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hackathon['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  _buildDetailCard('📅 Registration Deadline', hackathon['deadline']),
                  _buildDetailCard('🏆 Prize Pool', hackathon['prize']),
                  _buildDetailCard('🤖 Match Score', '${hackathon['matchScore']}% match with your profile'),
                  _buildDetailCard('📌 Source', hackathon['source'] == 'AI' ? 'AI Discovered' : 'Manually Added'),
                  const SizedBox(height: 20),
                  const Text('Tags', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: (hackathon['tags'] as List<String>).map((tag) => Chip(
                      label: Text(tag, style: const TextStyle(color: Colors.white)),
                      backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    )).toList(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity, height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('✅ Reminder set!'), backgroundColor: const Color(0xFF10B981), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                      icon: const Icon(Icons.notifications_active, color: Colors.white),
                      label: const Text('Set Reminder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity, height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Would open: ${hackathon['url']}'), backgroundColor: const Color(0xFF6366F1), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        );
                      },
                      icon: const Icon(Icons.open_in_browser, color: Color(0xFF6366F1)),
                      label: const Text('Visit Website', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF6366F1)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1D1E33), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[800]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
    );
  }
}

// ============================================================
// ADD HACKATHON SCREEN
// ============================================================
class AddHackathonScreen extends StatefulWidget {
  const AddHackathonScreen({super.key});

  @override
  State<AddHackathonScreen> createState() => _AddHackathonScreenState();
}

class _AddHackathonScreenState extends State<AddHackathonScreen> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _organizerController = TextEditingController();
  final _prizeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Add Hackathon', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manual Entry', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Add a hackathon not discovered by AI', style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 30),
            _buildField(_urlController, 'Hackathon URL', Icons.link, hint: 'https://devpost.com/hackathon...'),
            const SizedBox(height: 16),
            _buildField(_titleController, 'Title', Icons.title, hint: 'AI Innovation Challenge'),
            const SizedBox(height: 16),
            _buildField(_organizerController, 'Organizer', Icons.business_outlined, hint: 'TechCorp Global'),
            const SizedBox(height: 16),
            _buildField(_prizeController, 'Prize Pool', Icons.emoji_events_outlined, hint: '\$10,000'),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  final title = _titleController.text.trim();
                  final url = _urlController.text.trim();
                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Please enter a hackathon title.'), backgroundColor: Colors.red[700], behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    );
                    return;
                  }
                  if (url.isNotEmpty && !Uri.tryParse(url)!.hasScheme) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Please enter a valid URL (e.g. https://...).'), backgroundColor: Colors.red[700], behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('✅ Hackathon added successfully!'), backgroundColor: const Color(0xFF10B981), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Hackathon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {String? hint}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.grey[400]),
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFF1D1E33),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[800]!)),
        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide(color: Color(0xFF6366F1), width: 2)),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _organizerController.dispose();
    _prizeController.dispose();
    super.dispose();
  }
}