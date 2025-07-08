import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _loadingController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    _logoController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Hide system UI for immersive experience
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      // Simulate initialization steps
      await _performInitializationSteps();

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 2500));

      // Navigate based on app state
      await _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  Future<void> _performInitializationSteps() async {
    // Step 1: Check biometric authentication availability
    setState(() {
      _initializationStatus = 'Checking security features...';
    });
    await Future.delayed(const Duration(milliseconds: 500));

    // Step 2: Load encrypted card data
    setState(() {
      _initializationStatus = 'Loading secure data...';
    });
    await Future.delayed(const Duration(milliseconds: 600));

    // Step 3: Initialize notification service
    setState(() {
      _initializationStatus = 'Setting up reminders...';
    });
    await Future.delayed(const Duration(milliseconds: 400));

    // Step 4: Prepare cached images
    setState(() {
      _initializationStatus = 'Finalizing setup...';
    });
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isInitializing = false;
      _initializationStatus = 'Ready!';
    });
  }

  Future<void> _navigateToNextScreen() async {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Mock logic for navigation decision
    final bool hasExistingCards = await _checkForExistingCards();
    final bool isBiometricSetup = await _checkBiometricSetup();
    final bool isFirstLaunch = await _checkFirstLaunch();

    if (!mounted) return;

    if (isFirstLaunch) {
      // First time users - show biometric setup
      Navigator.pushReplacementNamed(context, '/biometric-authentication');
    } else if (hasExistingCards && isBiometricSetup) {
      // Existing users with cards and biometric setup
      Navigator.pushReplacementNamed(context, '/card-list-dashboard');
    } else if (hasExistingCards && !isBiometricSetup) {
      // Users with cards but no biometric setup
      Navigator.pushReplacementNamed(context, '/biometric-authentication');
    } else {
      // Users without cards - go to add card
      Navigator.pushReplacementNamed(context, '/add-card');
    }
  }

  Future<bool> _checkForExistingCards() async {
    // Mock implementation - check sqflite database
    await Future.delayed(const Duration(milliseconds: 100));
    return false; // Simulate no existing cards for demo
  }

  Future<bool> _checkBiometricSetup() async {
    // Mock implementation - check biometric availability
    await Future.delayed(const Duration(milliseconds: 100));
    return false; // Simulate no biometric setup for demo
  }

  Future<bool> _checkFirstLaunch() async {
    // Mock implementation - check shared preferences
    await Future.delayed(const Duration(milliseconds: 100));
    return true; // Simulate first launch for demo
  }

  void _handleInitializationError(dynamic error) {
    setState(() {
      _isInitializing = false;
      _initializationStatus = 'Initialization failed';
    });

    // Show error dialog and recovery options
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Initialization Error',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Failed to initialize the app. Please try again.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Animated Logo Section
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoFadeAnimation.value,
                      child: _buildLogoSection(),
                    ),
                  );
                },
              ),

              SizedBox(height: 8.h),

              // Loading Section
              _buildLoadingSection(),

              // Spacer to balance layout
              const Spacer(flex: 3),

              // Status Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  _initializationStatus,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // App Logo with Security Icon
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 8.w,
              ),
              SizedBox(height: 1.h),
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // App Name
        Text(
          'CardKeeper',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),

        SizedBox(height: 1.h),

        // App Tagline
        Text(
          'Secure • Simple • Smart',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary
                .withValues(alpha: 0.8),
            fontSize: 11.sp,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading Indicator
        AnimatedBuilder(
          animation: _loadingAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _loadingAnimation.value,
              child: SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 2.h),

        // Security Features List
        if (_isInitializing) ...[
          _buildSecurityFeature('Bank-level encryption'),
          SizedBox(height: 1.h),
          _buildSecurityFeature('Biometric protection'),
          SizedBox(height: 1.h),
          _buildSecurityFeature('Offline storage'),
        ] else ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.successLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successLight,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Ready to secure your cards',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSecurityFeature(String feature) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: 'shield',
          color:
              AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
          size: 3.w,
        ),
        SizedBox(width: 2.w),
        Text(
          feature,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary
                .withValues(alpha: 0.7),
            fontSize: 9.sp,
          ),
        ),
      ],
    );
  }
}
