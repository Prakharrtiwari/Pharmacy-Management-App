import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pharmacy_management/core/routes/app_routes.dart';
import 'package:pharmacy_management/core/theme/app_theme.dart';
import 'package:pharmacy_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pharmacy_management/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:pharmacy_management/features/auth/presentation/widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSignUp = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSignUp() {
    setState(() {
      _isSignUp = !_isSignUp;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.3, 0.7, 1.0],
            colors: isDarkMode
                ? [
              AppTheme.cardBackgroundDark,
              AppTheme.oliveGreen.withOpacity(0.7),
              Colors.grey[900]!,
              AppTheme.oliveGreen.withOpacity(0.5),
            ]
                : [
              Colors.white,
              AppTheme.oliveGreen.withOpacity(0.3),
              AppTheme.oliveGreen.withOpacity(0.6),
              Colors.white,
            ],
          ),
        ),
        child: CustomPaint(
          painter: StethoscopePatternPainter(isDarkMode: isDarkMode),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Header
                              Text(
                                _isSignUp ? 'Create Account' : 'Welcome Back',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.08,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkMode ? AppTheme.white : AppTheme.charcoal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                _isSignUp
                                    ? 'Join the Pharmacy Management System'
                                    : 'Log in to manage your pharmacy',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkMode ? AppTheme.grey : AppTheme.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.04),

                              // Form Fields
                              if (_isSignUp)
                                CustomTextField(
                                  controller: _nameController,
                                  hintText: 'Pharmacy Name',
                                  icon: Icons.store,
                                ),
                              SizedBox(height: screenHeight * 0.02),
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: 'Password',
                                icon: Icons.lock,
                                isObscure: true,
                              ),
                              SizedBox(height: screenHeight * 0.02),

                              // Forgot Password
                              if (!_isSignUp)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      final email = _emailController.text.trim();
                                      if (email.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Please enter your email'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      // Implement forgot password logic
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Password reset link sent'),
                                          backgroundColor: AppTheme.oliveGreen,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: screenHeight * 0.02),

                              // Submit Button
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  if (state is AuthLoading) {
                                    return const SpinKitFadingCircle(
                                      color: AppTheme.oliveGreen,
                                      size: 50.0,
                                    );
                                  }
                                  return Column(
                                    children: [
                                      GradientButton(
                                        text: _isSignUp ? 'Sign Up' : 'Login',
                                        onPressed: () {
                                          if (_isSignUp) {
                                            context.read<AuthBloc>().add(SignUpEvent(
                                              email: _emailController.text,
                                              password: _passwordController.text,
                                              name: _nameController.text,
                                            ));
                                          } else {
                                            context.read<AuthBloc>().add(LoginEvent(
                                              email: _emailController.text,
                                              password: _passwordController.text,
                                            ));
                                          }
                                        },
                                      ),
                                      SizedBox(height: screenHeight * 0.02),

                                      // Google Sign-In Button
                                      GradientButton(
                                        text: 'Sign in with Google',
                                        icon: Icons.g_mobiledata,
                                        onPressed: () {
                                          context.read<AuthBloc>().add(GoogleSignInEvent());
                                        },
                                        gradient: const LinearGradient(
                                          colors: [Colors.blueAccent, Colors.cyan],
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.03),

                                      // Toggle Login/Sign-Up
                                      TextButton(
                                        onPressed: _toggleSignUp,
                                        child: Text(
                                          _isSignUp
                                              ? 'Already have an account? Login'
                                              : 'Create a new account',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w600,
                                            color: isDarkMode ? AppTheme.white : AppTheme.charcoal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for stethoscope pattern
class StethoscopePatternPainter extends CustomPainter {
  final bool isDarkMode;

  StethoscopePatternPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode ? Colors.white.withOpacity(0.1) : AppTheme.oliveGreen.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw a grid of stethoscope shapes
    const double spacing = 120.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Draw stethoscope shape
        // Circle for chest piece
        canvas.drawCircle(Offset(x + 20, y + 20), 6, paint);

        // Tubes (curved paths)
        final path = Path()
          ..moveTo(x + 20, y + 20) // Start at chest piece
          ..quadraticBezierTo(x + 20, y + 30, x + 15, y + 35) // Left tube
          ..moveTo(x + 20, y + 20)
          ..quadraticBezierTo(x + 20, y + 30, x + 25, y + 35); // Right tube
        canvas.drawPath(path, paint);

        // Earpieces
        canvas.drawCircle(Offset(x + 15, y + 35), 2, paint);
        canvas.drawCircle(Offset(x + 25, y + 35), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}