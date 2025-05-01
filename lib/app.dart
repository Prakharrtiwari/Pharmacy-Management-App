import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pharmacy_management/core/routes/app_routes.dart';
import 'package:pharmacy_management/core/theme/app_theme.dart';
import 'package:pharmacy_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pharmacy_management/features/auth/presentation/screens/login_screen.dart';
import 'package:pharmacy_management/features/medicine/presentation/bloc/medicine_bloc.dart';
import 'package:pharmacy_management/features/medicine/presentation/screens/medicine_screen.dart';
import 'package:pharmacy_management/features/order/presentation/bloc/order_bloc.dart';
import 'package:pharmacy_management/features/order/presentation/screens/order_screen.dart';
import 'package:get_it/get_it.dart';

import 'features/medicine/presentation/bloc/medicine_event.dart';
import 'features/order/presentation/bloc/order_event.dart';

final GetIt getIt = GetIt.instance;

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Pharmacy Management',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.home: (context) => const MainScreen(),
          AppRoutes.order: (context) => const MainScreen(initialIndex: 1),
          AppRoutes.pharmacy: (context) => const MainScreen(initialIndex: 2),
          AppRoutes.alerts: (context) => const MainScreen(initialIndex: 3),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuad,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuad,
      ),
    );
    _animationController.forward();

    _screens = [
      BlocProvider(
        create: (context) {
          final authState = context.read<AuthBloc>().state;
          final pharmacyId = authState is AuthAuthenticated ? authState.pharmacy.id : '';
          return MedicineBloc(pharmacyId: pharmacyId)..add(LoadMedicinesEvent());
        },
        child: const MedicineScreen(),
      ),
      BlocProvider(
        create: (context) {
          final authState = context.read<AuthBloc>().state;
          final pharmacyId = authState is AuthAuthenticated ? authState.pharmacy.id : '';
          return OrderBloc(pharmacyId: pharmacyId)..add(LoadOrdersEvent());
        },
        child: const OrderScreen(),
      ),
      const Center(child: Text('Pharmacy Screen (Placeholder)')),
      const Center(child: Text('Alerts Screen (Placeholder)')),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmacy Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.charcoal,
                AppTheme.oliveGreen,
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.white),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: GNav(
              backgroundColor: AppTheme.white,
              color: AppTheme.grey,
              activeColor: AppTheme.oliveGreen,
              tabBackgroundColor: Colors.transparent,
              tabBorderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              tabMargin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              gap: 0,
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
              tabs: [
                GButton(
                  icon: Icons.medical_services_outlined,
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HighlightedIcon(
                        icon: Icons.medical_services_outlined,
                        isSelected: _selectedIndex == 0,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Add Medicine',
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          fontWeight: _selectedIndex == 0 ? FontWeight.w600 : FontWeight.w400,
                          color: _selectedIndex == 0 ? AppTheme.oliveGreen : AppTheme.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GButton(
                  icon: Icons.shopping_cart_outlined,
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HighlightedIcon(
                        icon: Icons.shopping_cart_outlined,
                        isSelected: _selectedIndex == 1,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Order',
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          fontWeight: _selectedIndex == 1 ? FontWeight.w600 : FontWeight.w400,
                          color: _selectedIndex == 1 ? AppTheme.oliveGreen : AppTheme.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GButton(
                  icon: Icons.store_outlined,
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HighlightedIcon(
                        icon: Icons.store_outlined,
                        isSelected: _selectedIndex == 2,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pharmacy',
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          fontWeight: _selectedIndex == 2 ? FontWeight.w600 : FontWeight.w400,
                          color: _selectedIndex == 2 ? AppTheme.oliveGreen : AppTheme.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GButton(
                  icon: Icons.notifications_outlined,
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HighlightedIcon(
                        icon: Icons.notifications_outlined,
                        isSelected: _selectedIndex == 3,
                        screenWidth: screenWidth,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Alerts',
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          fontWeight: _selectedIndex == 3 ? FontWeight.w600 : FontWeight.w400,
                          color: _selectedIndex == 3 ? AppTheme.oliveGreen : AppTheme.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HighlightedIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final double screenWidth;

  const HighlightedIcon({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.1,
      height: screenWidth * 0.07,
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.oliveGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        icon,
        size: isSelected ? screenWidth * 0.06 : screenWidth * 0.055,
        color: isSelected ? AppTheme.white : AppTheme.grey,
      ),
    );
  }
}