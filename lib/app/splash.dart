import 'package:im_mottu_mobile/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 1), _navigateToHome);
  }

  void _navigateToHome() {
    Get.offNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Image.asset(
              'assets/images/marvel.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
