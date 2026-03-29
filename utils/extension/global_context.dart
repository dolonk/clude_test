import 'package:flutter/material.dart';

class GlobalContext {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;
}

/// example of declare context
//final context = GlobalContext.context;
/*
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InternetManager.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalContext.navigatorKey, // Global context Key
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isConnected = true;
  bool isLoading = false;

  Future<void> checkInternetConnection() async {
    isConnected = await InternetManager.instance.isConnected();
    setState(() {});
  }

  /// Retry button handler
  Future<void> handleRetry() async {
    isLoading = true;
    setState(() {});

    await Future.delayed(const Duration(seconds: 2));
    await checkInternetConnection();

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Internet Connectivity Example')),
      body: Center(
        child: isConnected
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are connected to the Internet!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        )
            : NoInternetWidget(
          width: 300,
          height: 300,
          onRetry: handleRetry,
          isLoading: isLoading,
        ),
      ),
    );
  }
}*/
