import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/settings/settings_provider.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';
import 'features/support/support_screen.dart';
import 'features/others/others_screen.dart';
import 'features/z_moves/z_moves_screen.dart';
import 'features/trainer_pass/trainer_pass_screen.dart';
import 'services/storage_service.dart';
import 'package:flutter/gestures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final storageService = container.read(storageServiceProvider);
  await storageService.init();
  await Hive.openBox(settingsBoxName);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MezaHelperApp(),
    ),
  );
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MezaHelperApp extends StatelessWidget {
  const MezaHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MezaHelper',
      theme: appTheme,
      home: const MainScaffold(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 2; // Default to Home (Center)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const TrainerPassScreen(),
    const SupportScreen(),
    const HomeScreen(),
    const ZMovesScreen(),
    const OthersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true, // Allow body to extend behind the FAB/BottomBar notch
      body: _screens[_currentIndex],
      floatingActionButton: SizedBox(
        width: 72, // "Not too big but bigger" (Standard is 56)
        height: 72,
        child: FloatingActionButton(
          onPressed: () => _onItemTapped(2), // Index 2 is Home
          elevation: 4,
          backgroundColor:
              _currentIndex == 2 ? colorScheme.secondary : colorScheme.surface,
          shape: const CircleBorder(),
          child: Icon(
            Icons.home_rounded,
            size: 36,
            color: _currentIndex == 2 ? Colors.black : Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: colorScheme.surface
            .withOpacity(0.95), // Slight transparency for premium feel
        elevation: 0,
        child: SizedBox(
          height: 56, // Reduced height to "move it down" visually
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.badge_outlined, Icons.badge, 'Trainer'),
              _buildNavItem(
                  1, Icons.handyman_outlined, Icons.handyman, 'Support'),
              const SizedBox(width: 48), // Spacer for the FAB
              _buildNavItem(
                  3, Icons.flash_on_outlined, Icons.flash_on, 'Z-Moves'),
              _buildNavItem(
                  4, Icons.grid_view, Icons.grid_view_rounded, 'Others'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData iconOutlined, IconData iconFilled, String label) {
    final isSelected = _currentIndex == index;
    final color =
        isSelected ? Theme.of(context).colorScheme.secondary : Colors.grey;
    final icon = isSelected ? iconFilled : iconOutlined;

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 2), // Reduced vertical padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
