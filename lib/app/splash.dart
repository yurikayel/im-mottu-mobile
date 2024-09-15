import 'package:im_mottu_mobile/index.dart';

/// A splash screen that displays a fade-in and fade-out animation before navigating to the home screen.
///
/// The splash screen displays a Marvel logo image with a fade-in effect followed by a fade-out effect.
/// After the animation completes, the application navigates to the home screen.
class SplashScreen extends StatefulWidget {
  /// Creates an instance of [SplashScreen].
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController with a duration of 2 seconds.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );

    // Initialize CurvedAnimation for smooth fading effect.
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the fade-in animation.
    _controller.forward().then((_) {
      // Start the fade-out animation after the fade-in is complete.
      Future.delayed(const Duration(milliseconds: 750), () {
        _controller.reverse().whenComplete(() {
          // Navigate to the home screen after the fade-out animation completes.
          Get.offNamed(AppRoutes.home);
        });
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the AnimationController to free resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color of the splash screen.
      body: FadeTransition(
        opacity: _fadeAnimation, // Apply fade transition using animation.
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Image.asset(
              'assets/images/marvel.jpg', // Path to the image asset.
              fit: BoxFit.cover, // Ensure the image covers the available space.
            ),
          ),
        ),
      ),
    );
  }
}
