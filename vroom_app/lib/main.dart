import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:vroom_app/screens/AutomobileListScreen.dart';
import 'package:vroom_app/screens/AdAutomobileScreen.dart';
import 'package:vroom_app/screens/FavoritesScreen.dart';
import 'package:vroom_app/screens/LoginScreen.dart';
import 'package:vroom_app/screens/MyAutomobileAdsScreen.dart';
import 'package:vroom_app/screens/ProfileScreen.dart';
import 'package:vroom_app/screens/RegisterScreen.dart';
import 'components/CustomNavigationBar.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("⚠️ Greška pri učitavanju `.env`: $e");
  }

  String stripePublishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  Stripe.publishableKey = stripePublishableKey;
  //Stripe.publishableKey = ApiConfig.publishableKey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Automobili Oglasi',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900],
          elevation: 2,
          toolbarHeight: 50,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // 2. Dodajemo routeObserver u navigatorObservers
      navigatorObservers: [routeObserver],

      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/favorites': (context) => const MainScreen(initialIndex: 1),
        '/my-ads': (context) => const MyAutomobileAdsScreen(),
        '/profile': (context) => const MainScreen(initialIndex: 3),
        '/add-ad': (context) => const AddAutomobileScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen()
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const AutomobileListScreen(),
    const FavoritesScreen(),
    const MyAutomobileAdsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomNavigationBarWithButton(
        currentIndex: _currentIndex,
        onTap: _onItemSelected,
        onAddPressed: () {
          Navigator.pushNamed(context, '/add-ad');
        },
      ),
    );
  }
}
