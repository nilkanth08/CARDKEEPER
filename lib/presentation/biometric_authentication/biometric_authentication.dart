import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/authentication_actions_widget.dart';
import './widgets/authentication_header_widget.dart';
import './widgets/biometric_icon_widget.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({Key? key}) : super(key: key);

  @override
  State<BiometricAuthentication> createState() =>
      _BiometricAuthenticationState();
}

class _BiometricAuthenticationState extends State<BiometricAuthentication>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isAuthenticating = false;
  bool _isLoading = false;
  String _errorMessage = '';
  int _failedAttempts = 0;
  bool _isCooldownActive = false;
  String _biometricType = 'fingerprint'; // fingerprint, face, none

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
    _startBiometricAuthentication();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  void _checkBiometricAvailability() {
    // Mock biometric availability check
    setState(() {
      _biometricType = 'fingerprint'; // Default to fingerprint for demo
    });
  }

  void _startBiometricAuthentication() {
    if (_isCooldownActive) return;

    setState(() {
      _isAuthenticating = true;
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate biometric authentication
    Future.delayed(const Duration(seconds: 2), () {
      _handleBiometricResult();
    });
  }

  void _handleBiometricResult() {
    // Mock authentication result - 70% success rate for demo
    final bool isSuccess = DateTime.now().millisecond % 10 < 7;

    if (isSuccess) {
      _onAuthenticationSuccess();
    } else {
      _onAuthenticationFailure();
    }
  }

  void _onAuthenticationSuccess() {
    setState(() {
      _isAuthenticating = false;
      _isLoading = false;
      _errorMessage = '';
      _failedAttempts = 0;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Navigate to dashboard
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/card-list-dashboard');
    });
  }

  void _onAuthenticationFailure() {
    setState(() {
      _isAuthenticating = false;
      _isLoading = false;
      _failedAttempts++;
      _errorMessage = _getErrorMessage();
    });

    // Haptic feedback for error
    HapticFeedback.heavyImpact();

    // Check if cooldown should be activated
    if (_failedAttempts >= 3) {
      _activateCooldown();
    }
  }

  String _getErrorMessage() {
    if (_failedAttempts >= 3) {
      return 'Too many failed attempts. Please use PIN instead.';
    }
    switch (_biometricType) {
      case 'face':
        return 'Face ID not recognized. Please try again.';
      case 'fingerprint':
        return 'Fingerprint not recognized. Please try again.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  void _activateCooldown() {
    setState(() {
      _isCooldownActive = true;
      _errorMessage = 'Too many failed attempts. Try again in 30 seconds.';
    });

    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _isCooldownActive = false;
          _failedAttempts = 0;
          _errorMessage = '';
        });
      }
    });
  }

  void _usePinInstead() {
    // For demo purposes, simulate PIN entry success
    HapticFeedback.selectionClick();
    Navigator.pushReplacementNamed(context, '/card-list-dashboard');
  }

  String _getBiometricInstructions() {
    switch (_biometricType) {
      case 'face':
        return 'Use your face to access your cards securely.';
      case 'fingerprint':
        return 'Use your fingerprint to access your cards securely.';
      default:
        return 'Use biometric authentication to access your cards securely.';
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.scaffoldBackgroundColor,
              AppTheme.lightTheme.scaffoldBackgroundColor
                  .withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header with logo and security badge
                AuthenticationHeaderWidget(),

                SizedBox(height: 6.h),

                // Main unlock message
                Text(
                  'Unlock CardKeeper',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 2.h),

                // Biometric icon with pulse animation
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isAuthenticating ? _pulseAnimation.value : 1.0,
                      child: BiometricIconWidget(
                        biometricType: _biometricType,
                        isAuthenticating: _isAuthenticating,
                        isLoading: _isLoading,
                        onTap: _isLoading || _isCooldownActive
                            ? null
                            : _startBiometricAuthentication,
                      ),
                    );
                  },
                ),

                SizedBox(height: 4.h),

                // Instructions text
                Text(
                  _getBiometricInstructions(),
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 2.h),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onErrorContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                SizedBox(height: 6.h),

                // Authentication actions
                AuthenticationActionsWidget(
                  isLoading: _isLoading,
                  isCooldownActive: _isCooldownActive,
                  failedAttempts: _failedAttempts,
                  onUsePinInstead: _usePinInstead,
                  onRetry: _startBiometricAuthentication,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
