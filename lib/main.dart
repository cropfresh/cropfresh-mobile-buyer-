import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/constants/app_theme.dart';

// Screens
import 'src/screens/onboarding/splash_screen.dart';
import 'src/screens/onboarding/welcome_screen.dart';
import 'src/screens/auth/business_info_screen.dart';
import 'src/screens/auth/business_type_screen.dart';
import 'src/screens/auth/credentials_screen.dart';
import 'src/screens/auth/mobile_entry_screen.dart';
import 'src/screens/auth/otp_verification_screen.dart';
import 'src/screens/auth/location_setup_screen.dart';
import 'src/screens/auth/registration_success_screen.dart';
import 'src/screens/auth/login_screen.dart';
import 'src/screens/auth/forgot_password_screen.dart';
import 'src/screens/auth/reset_password_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const CropFreshBuyerApp());
}

class CropFreshBuyerApp extends StatelessWidget {
  const CropFreshBuyerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CropFresh Buyers',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // =====================================================
      // Onboarding Flow
      // =====================================================
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      
      // =====================================================
      // Registration Flow
      // =====================================================
      case '/business-info':
        return MaterialPageRoute(builder: (_) => const BusinessInfoScreen());
      
      case '/business-type':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BusinessTypeScreen(
            businessName: args?['businessName'] ?? '',
          ),
        );
      
      case '/credentials':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CredentialsScreen(
            businessName: args?['businessName'] ?? '',
            businessType: args?['businessType'] ?? '',
          ),
        );
      
      case '/mobile-entry':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MobileEntryScreen(
            businessName: args?['businessName'] ?? '',
            businessType: args?['businessType'] ?? '',
            email: args?['email'] ?? '',
            password: args?['password'] ?? '',
          ),
        );
      
      case '/otp-verification':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: args?['phoneNumber'] ?? '',
            registrationData: args?['registrationData'] ?? {},
          ),
        );
      
      case '/location-setup':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LocationSetupScreen(
            registrationData: args?['registrationData'] ?? {},
          ),
        );
      
      case '/registration-success':
        return MaterialPageRoute(builder: (_) => const RegistrationSuccessScreen());
      
      // =====================================================
      // Login Flow (for existing users)
      // =====================================================
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      
      case '/reset-password':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            token: args?['token'] ?? '',
          ),
        );
      
      // =====================================================
      // Dashboard (after authentication)
      // =====================================================
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('CropFresh Marketplace')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Welcome to CropFresh!', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 8),
                  Text('Marketplace coming soon...'),
                ],
              ),
            ),
          ),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
