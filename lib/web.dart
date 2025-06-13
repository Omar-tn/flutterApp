import 'package:flutter/material.dart'; // For mobile
import 'package:flutter/foundation.dart' ;//show kIsWeb; //
// For web-specific imports

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Default Screen'), // Title for the AppBar
      ),
      body:

      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Recommended for Web
            Text(
              'Welcome to our Web App!',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall, // Using Theme for consistency
              textAlign: TextAlign.center, // Center-aligned for web
            ),
            const SizedBox(height: 20),
            // Recommended: Add spacing between widgets
            // Using Flexible for responsiveness - Recommended
            Flexible(
              child: Image.network(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.5, // 50% of screen width
                fit: BoxFit.contain,


              ),
            ),
            const SizedBox(height: 20),
            // Recommended spacing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // Best practice for spacing
              child: Text(
                'This is a sample responsive web layout built with Flutter.',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall,
                textAlign: TextAlign.center, // For better alignment
              ),
            ),
            const SizedBox(height: 30),
            // Adding more spacing
            // Recommended Button for Actions
            ElevatedButton.icon(
              onPressed: () {
                // Add functionality as neededd

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewScreen()),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Get Started'),
            ),
          ],
        ),
      ),




      // Web-specific adaptations can go here
      // For instance, adapting layout or behaviors for web
    );
  }
}

class NewScreen extends StatefulWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  // Example states
  bool _isDarkMode = false;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Feature Screen'),
        actions: [
          // Action button to toggle dark mode
          IconButton(
            icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: _toggleDarkMode,
          ),
        ],

        // Remove the back button for a cleaner look

        leading: Container(), // Removes the back button for a cleaner look
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 600;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Responsive Layout Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Colors.black54 : Colors.blue
                            .shade100,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          'Welcome to the Enhanced Page!',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                            color:
                            _isDarkMode ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Counter Example Widget
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: _isDarkMode
                            ? Colors.black12
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Counter Value: $_counter',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                              _isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _incrementCounter,
                                child: const Text('Increment'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _decrementCounter,
                                child: const Text('Decrement'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Responsive Image Section
                    SizedBox(
                      // width: isWideScreen ? screenWidth * 0.4 : screenWidth *
                      //   0.7,
                      // height: screenHeight * 0.9,

                      child: Flexible(

                        child: Image.network(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',

                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Information Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'This page demonstrates responsive design, state management features (like the counter and dark mode toggle), and actions users can perform.',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Navigation Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(
                              context); // Go back to the previous screen
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('Go Back to Home'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetCounter,
        child: const Icon(Icons.refresh),
        tooltip: 'Reset Counter',
      ),
    );
  }
  // State actions
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--; // Prevent negative counters
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }
}

