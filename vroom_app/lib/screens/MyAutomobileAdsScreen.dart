import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vroom_app/components/LoginButton.dart';
import 'package:vroom_app/services/AuthService.dart';
import '../components/MyAutomobileAdsCard.dart';
import '../models/automobileAd.dart';
import '../services/AutomobileAdService.dart';
import 'package:vroom_app/main.dart' show routeObserver;

class MyAutomobileAdsScreen extends StatefulWidget {
  const MyAutomobileAdsScreen({Key? key}) : super(key: key);

  @override
  _MyAutomobileAdsScreenState createState() => _MyAutomobileAdsScreenState();
}

class _MyAutomobileAdsScreenState extends State<MyAutomobileAdsScreen>
    with RouteAware {
  final AutomobileAdService _automobileAdService = AutomobileAdService();
  static const _pageSize = 25;

  final PagingController<int, AutomobileAd> _pagingController =
      PagingController(firstPageKey: 0);

  String _selectedTab = 'active';

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<bool> _checkIfLoggedIn() async {
    final userId = await AuthService.getUserId();
    return userId != null; // Check if user ID exists
  }

  Future<void> _fetchPage(int pageKey) async {
    final userId = await AuthService.getUserId();
    try {
      final myAutomobileAds =
          await _automobileAdService.fetchLoggedUserAutomobiles(
              userId: userId.toString(),
              page: pageKey,
              pageSize: _pageSize,
              status: _selectedTab == 'highlighted' ? null : _selectedTab,
              IsHighlighted: _selectedTab == 'highlighted');

      final isLastPage = myAutomobileAds.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(myAutomobileAds);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(myAutomobileAds, nextPageKey);
      }
    } catch (error) {
      print("Fetch Page Error: $error");
      _pagingController.error = error;
    }
  }

  Future<void> _removeAutomobile(int automobileId) async {
    final headers = await AuthService.getAuthHeaders();

    try {
      await _automobileAdService.removeAutomobile(automobileId, headers);
      _pagingController.refresh();

      Fluttertoast.showToast(
        msg: "Oglas je uspešno obrisan.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Greška prilikom brisanja oglasa: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // RouteAware: Refresh data when the screen is revisited
  @override
  void didPopNext() {
    super.didPopNext();
    _pagingController.refresh(); // Refresh data
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _pagingController.dispose();
    super.dispose();
  }

  void _onTabSelected(String tab) {
    setState(() {
      _selectedTab = tab;
      _pagingController.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moji Oglasi"),
      ),
      body: FutureBuilder<bool>(
        future: _checkIfLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && !snapshot.data!) {
            // If the user is NOT logged in
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Morate se prijaviti da biste vidjeli svoje oglase.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  LoginButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            );
          }

          // If the user is logged in
          return Column(
            children: [
              Container(
                color: Colors.grey.shade800,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTab("Aktivni", "active"),
                    _buildTab("Završeni", "done"),
                    _buildTab("Izdvojeni", "highlighted"),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PagedListView<int, AutomobileAd>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<AutomobileAd>(
                      itemBuilder: (context, item, index) {
                        return MyAutomobileAdsCard(
                          automobileAd: item,
                          onRemove: (id) async {
                            await _removeAutomobile(id);
                          },
                        );
                      },
                      firstPageProgressIndicatorBuilder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                      newPageProgressIndicatorBuilder: (context) =>
                          const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      noItemsFoundIndicatorBuilder: (context) => const Center(
                        child: Text('Nemate nijedan oglasa.'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab(String title, String tab) {
    final isSelected = _selectedTab == tab;
    return GestureDetector(
      onTap: () => _onTabSelected(tab),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade400,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (isSelected)
            Container(
              height: 2,
              width: 80,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}
