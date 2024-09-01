import 'package:im_mottu_mobile/index.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl =
        '${event.thumbnail?.path}.${event.thumbnail?.extension}';
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen =
        screenWidth > 800; // Breakpoint for tablets and desktops

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding:
            EdgeInsets.all(isLargeScreen ? 32.0 : 16.0 // Responsive padding
                ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the event's thumbnail with placeholder and error handling
              SizedBox(
                width: double.infinity, // Make image take full width
                child: CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                event.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize:
                          isLargeScreen ? 36.0 : 24.0, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                event.description ?? 'No description',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Start Date: ${event.start?.toLocal().toIso8601String() ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'End Date: ${event.end?.toLocal().toIso8601String() ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
