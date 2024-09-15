import 'package:im_mottu_mobile/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: FadeTransition(
        opacity: _animation,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Marvel API Explorer'),
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
            centerTitle: true,
            backgroundColor: Colors.yellow,
          ),
          body: Container(
            color: Colors.black,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 1200
                        ? 4
                        : constraints.maxWidth > 800
                            ? 3
                            : 2;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      shrinkWrap: true,
                      children: [
                        _buildCategoryButton(
                          context,
                          'Character',
                          Icons.person,
                          AppRoutes.characterList,
                        ),
                        _buildCategoryButton(
                          context,
                          'Comic',
                          Icons.book,
                          AppRoutes.comicList,
                        ),
                        _buildCategoryButton(
                          context,
                          'Creator',
                          Icons.create,
                          AppRoutes.creatorList,
                        ),
                        _buildCategoryButton(
                          context,
                          'Event',
                          Icons.event,
                          AppRoutes.eventList,
                        ),
                        _buildCategoryButton(
                          context,
                          'Series',
                          Icons.tv,
                          AppRoutes.seriesList,
                        ),
                        _buildCategoryButton(
                          context,
                          'Story',
                          Icons.library_books,
                          AppRoutes.storyList,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String title,
    IconData icon,
    String routeName,
  ) {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(routeName); // Use GetX for navigation
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red[900],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.0, color: Colors.red[900]),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(fontSize: 18.0, color: Colors.red[900]),
          ),
        ],
      ),
    );
  }
}
