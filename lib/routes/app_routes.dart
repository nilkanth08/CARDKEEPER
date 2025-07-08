import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/biometric_authentication/biometric_authentication.dart';
import '../presentation/payment_reminders/payment_reminders.dart';
import '../presentation/card_list_dashboard/card_list_dashboard.dart';
import '../presentation/add_card/add_card.dart';
import '../presentation/card_details/card_details.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String biometricAuthentication = '/biometric-authentication';
  static const String paymentReminders = '/payment-reminders';
  static const String cardListDashboard = '/card-list-dashboard';
  static const String addCard = '/add-card';
  static const String cardDetails = '/card-details';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    biometricAuthentication: (context) => const BiometricAuthentication(),
    paymentReminders: (context) => const PaymentReminders(),
    cardListDashboard: (context) => const CardListDashboard(),
    addCard: (context) => const AddCard(),
    cardDetails: (context) => const CardDetails(),
    // TODO: Add your other routes here
  };
}
