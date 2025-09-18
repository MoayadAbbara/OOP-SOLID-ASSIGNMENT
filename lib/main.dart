import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahwa/widgets/main_navigation.dart';
import 'package:ahwa/cubits/orders/order_cubit.dart';
import 'package:ahwa/services/orders/order_service_impl.dart';
import 'package:ahwa/services/reports/report_service_impl.dart';
import 'package:ahwa/constants/app_theme.dart';

void main() {
  runApp(const AhwaManagerApp());
}

class AhwaManagerApp extends StatelessWidget {
  const AhwaManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahwa Manager - Smart Ahwa System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: BlocProvider(
        create: (context) => OrderCubit(orderService: OrderServiceImpl(), reportService: ReportServiceImpl()),
        child: const MainNavigationScreen(),
      ),
    );
  }
}
