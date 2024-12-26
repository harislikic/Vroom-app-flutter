import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../models/automobileAd.dart';
import '../services/AutomobileAdService.dart';
import '../components/automobileCard.dart';
import '../components/FilterForm.dart';
import '../components/SearchBarComponent.dart';

class AutomobileListScreen extends StatefulWidget {
  const AutomobileListScreen({Key? key}) : super(key: key);

  @override
  _AutomobileListScreenState createState() => _AutomobileListScreenState();
}

class _AutomobileListScreenState extends State<AutomobileListScreen> {
  final AutomobileAdService _automobileAdService = AutomobileAdService();

  static const _pageSize = 25;

  final PagingController<int, AutomobileAd> _pagingController =
      PagingController(firstPageKey: 0);

  String _searchTerm = ''; // For search
  bool _isSearchVisible = false; // To toggle search visibility
  bool _isFilterVisible = false; // To toggle filter visibility
  bool _isGridView = true; // To toggle between GridView and ListView

  // Filter parameters
  String _minPrice = '';
  String _maxPrice = '';
  String _minMileage = '';
  String _maxMileage = '';
  String _yearOfManufacture = '';
  bool _registered = false;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Simulate a delay for the loading effect
      await Future.delayed(const Duration(milliseconds: 500));

      final newAds = await _automobileAdService.fetchAutomobileAds(
        searchTerm: _searchTerm,
        page: pageKey,
        pageSize: _pageSize,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        minMileage: _minMileage,
        maxMileage: _maxMileage,
        yearOfManufacture: _yearOfManufacture,
        registered: _registered,
      );

      final isLastPage = newAds.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newAds);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newAds, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _onSearch(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      _pagingController.refresh();
    });
  }

  void _applyFilters(String minPrice, String maxPrice, String minMileage,
      String maxMileage, String yearOfManufacture, bool registered) {
    setState(() {
      _minPrice = minPrice;
      _maxPrice = maxPrice;
      _minMileage = minMileage;
      _maxMileage = maxMileage;
      _yearOfManufacture = yearOfManufacture;
      _registered = registered;
      _pagingController.refresh(); // Refresh data based on filters
      _isFilterVisible = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _minPrice = '';
      _maxPrice = '';
      _minMileage = '';
      _maxMileage = '';
      _yearOfManufacture = '';
      _registered = false;
      _pagingController.refresh(); // Refresh data after clearing filters
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.grid_on,
                color: _isGridView ? Colors.lightBlueAccent : Colors.blue,
                size: 26.0,
              ),
              onPressed: () {
                setState(() {
                  _isGridView = true;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.list,
                color: !_isGridView ? Colors.lightBlueAccent : Colors.blue,
                size: 30.0,
              ),
              onPressed: () {
                setState(() {
                  _isGridView = false;
                });
              },
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Oglasi',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: _isSearchVisible ? Colors.lightBlueAccent : Colors.blue,
                size: 30.0,
              ),
              onPressed: () {
                setState(() {
                  _isSearchVisible = !_isSearchVisible;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.filter_list,
                color: _isFilterVisible ? Colors.lightBlueAccent : Colors.blue,
                size: 30.0,
              ),
              onPressed: () {
                setState(() {
                  _isFilterVisible = !_isFilterVisible;
                });
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Offstage(
              offstage: !_isSearchVisible,
              child: AnimatedOpacity(
                opacity: _isSearchVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SearchBarComponent(onSearch: _onSearch),
                ),
              ),
            ),
            Offstage(
              offstage: !_isFilterVisible,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FilterForm(
                  onApplyFilters: _applyFilters,
                  onResetFilters: _resetFilters,
                ),
              ),
            ),
            Expanded(
              child: _isGridView
                  ? PagedGridView<int, AutomobileAd>(
                      pagingController: _pagingController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4 / 6,
                      ),
                      builderDelegate: PagedChildBuilderDelegate<AutomobileAd>(
                        itemBuilder: (context, item, index) =>
                            AutomobileCard(automobileAd: item, isGridView: true),
                        firstPageProgressIndicatorBuilder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        newPageProgressIndicatorBuilder: (context) =>
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        noItemsFoundIndicatorBuilder: (context) =>
                            const Center(child: Text('Nema dostupnih oglasa.')),
                      ),
                    )
                  : PagedListView<int, AutomobileAd>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<AutomobileAd>(
                        itemBuilder: (context, item, index) =>
                            AutomobileCard(automobileAd: item, isGridView: false),
                        firstPageProgressIndicatorBuilder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        newPageProgressIndicatorBuilder: (context) =>
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        noItemsFoundIndicatorBuilder: (context) =>
                            const Center(child: Text('Nema dostupnih oglasa.')),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
