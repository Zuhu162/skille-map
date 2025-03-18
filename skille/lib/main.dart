import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/mock_api_service.dart';
import 'services/service_locator.dart';
import 'views/splash_screen.dart';
import 'views/home_screen.dart' hide ProfileScreen;
import 'views/profile/profile_screen.dart';
import 'views/auth/login_screen.dart';

void main() {
  // Choose which API implementation to use
  final bool useMockApi = true; // Set to false to use the real API

  if (useMockApi) {
    // Use mock API for testing
    ServiceLocator.switchApiImplementation(MockApiService());
  } else {
    // Use real API for production
    ServiceLocator.switchApiImplementation(ApiService());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ServiceLocator.getProviders(),
      child: MaterialApp(
        title: 'Skille',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            primary: Colors.green,
            secondary: Colors.green.shade700,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
