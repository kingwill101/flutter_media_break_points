import 'package:flutter/material.dart';
import 'package:media_break_points/media_break_points.dart';

void main() {
  // Initialize with custom configuration if needed
  initMediaBreakPoints(
    MediaBreakPointsConfig(
      considerOrientation: true,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Break Points Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Media Break Points Demo',
          style: ResponsiveTextStyle.of(
            context,
            xs: TextStyle(fontSize: 18),
            md: TextStyle(fontSize: 20),
            lg: TextStyle(fontSize: 22),
          ),
        ),
      ),
      drawer: context.isSmall || context.isMedium ? const AppDrawer() : null,
      body: ResponsiveLayoutBuilder(
        xs: (context, _) => const MobileLayout(),
        sm: (context, _) => const MobileLayout(),
        md: (context, _) => const TabletLayout(),
        lg: (context, _) => const DesktopLayout(),
        xl: (context, _) => const DesktopLayout(),
        xxl: (context, _) => const DesktopLayout(),
      ),
      bottomNavigationBar: ResponsiveVisibility(
        visibleWhen: {
          Condition.smallerThan(BreakPoint.md): true,
        },
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveTextStyle.fontSize(
                  context,
                  xs: 24,
                  md: 28,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Search'),
            leading: const Icon(Icons.search),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Profile'),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ResponsiveSpacing.padding(
          context,
          xs: EdgeInsets.all(16),
          md: EdgeInsets.all(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobile Layout',
              style: ResponsiveTextStyle.of(
                context,
                xs: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                md: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            ResponsiveSpacing.gap(context, xs: 16, md: 24),
            Text(
              'Current breakpoint: ${context.breakPoint.label}',
              style: TextStyle(fontSize: 16),
            ),
            ResponsiveSpacing.gap(context, xs: 16, md: 24),
            Text(
              'Device type: ${context.deviceType.toString().split('.').last}',
              style: TextStyle(fontSize: 16),
            ),
            ResponsiveSpacing.gap(context, xs: 24, md: 32),
            const CardGrid(columns: 1),
          ],
        ),
      ),
    );
  }
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ResponsiveSpacing.padding(
          context,
          md: EdgeInsets.all(24),
          lg: EdgeInsets.all(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tablet Layout',
              style: ResponsiveTextStyle.of(
                context,
                md: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                lg: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            ResponsiveSpacing.gap(context, md: 24, lg: 32),
            Text(
              'Current breakpoint: ${context.breakPoint.label}',
              style: TextStyle(fontSize: 18),
            ),
            ResponsiveSpacing.gap(context, md: 24, lg: 32),
            Text(
              'Device type: ${context.deviceType.toString().split('.').last}',
              style: TextStyle(fontSize: 18),
            ),
            ResponsiveSpacing.gap(context, md: 32, lg: 40),
            const CardGrid(columns: 2),
          ],
        ),
      ),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Side navigation
        SizedBox(
          width: 250,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveTextStyle.fontSize(
                        context,
                        lg: 28,
                        xl: 32,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Home'),
                  leading: const Icon(Icons.home),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Search'),
                  leading: const Icon(Icons.search),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Profile'),
                  leading: const Icon(Icons.person),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        // Main content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: ResponsiveSpacing.padding(
                context,
                lg: EdgeInsets.all(32),
                xl: EdgeInsets.all(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Desktop Layout',
                    style: ResponsiveTextStyle.of(
                      context,
                      lg: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      xl: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ResponsiveSpacing.gap(context, lg: 32, xl: 40),
                  Text(
                    'Current breakpoint: ${context.breakPoint.label}',
                    style: TextStyle(fontSize: 20),
                  ),
                  ResponsiveSpacing.gap(context, lg: 32, xl: 40),
                  Text(
                    'Device type: ${context.deviceType.toString().split('.').last}',
                    style: TextStyle(fontSize: 20),
                  ),
                  ResponsiveSpacing.gap(context, lg: 40, xl: 48),
                  const CardGrid(columns: 3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardGrid extends StatelessWidget {
  final int columns;

  const CardGrid({Key? key, required this.columns}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      columnSpacing: 16,
      rowSpacing: 16,
      children: List.generate(
        6,
        (index) => ResponsiveGridItem(
          xs: 12,
          sm: columns == 1 ? 12 : 6,
          md: columns == 1 ? 12 : columns == 2 ? 6 : 4,
          lg: columns == 1 ? 12 : columns == 2 ? 6 : 4,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card ${index + 1}',
                    style: TextStyle(
                      fontSize: ResponsiveTextStyle.fontSize(
                        context,
                        xs: 18,
                        md: 20,
                        lg: 22,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is a responsive card that adapts to different screen sizes.',
                    style: TextStyle(
                      fontSize: ResponsiveTextStyle.fontSize(
                        context,
                        xs: 14,
                        md: 16,
                        lg: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Learn More'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}