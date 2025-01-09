import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vroom_app/components/RecommendedCarousel.dart';
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
  String _carBrandId = '';
  String _carCategoryId = '';
  String _carModelId = '';
  String _cityId = '';

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  bool _hasActiveFilters() {
    return _minPrice.isNotEmpty ||
        _maxPrice.isNotEmpty ||
        _minMileage.isNotEmpty ||
        _maxMileage.isNotEmpty ||
        _yearOfManufacture.isNotEmpty ||
        _registered ||
        _carBrandId.isNotEmpty ||
        _carCategoryId.isNotEmpty ||
        _carModelId.isNotEmpty ||
        _cityId.isNotEmpty || _searchTerm.isNotEmpty;
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
        carBrandId: _carBrandId,
        carCategoryId: _carCategoryId,
        carModelId: _carModelId,
        cityId: _cityId,
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

  void _applyFilters(
      String minPrice,
      String maxPrice,
      String minMileage,
      String maxMileage,
      String yearOfManufacture,
      bool registered,
      String carBrandId,
      String carCategoryId,
      String carModelId,
      String cityId) {
    setState(() {
      _minPrice = minPrice;
      _maxPrice = maxPrice;
      _minMileage = minMileage;
      _maxMileage = maxMileage;
      _yearOfManufacture = yearOfManufacture;
      _registered = registered;
      _isFilterVisible = false;
      _carBrandId = carBrandId;
      _carCategoryId = carCategoryId;
      _carModelId = carModelId;
      _cityId = cityId;
      _pagingController.refresh(); // Refresh data based on filters
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
      _carBrandId = '';
      _carCategoryId = '';
      _carModelId = '';
      _cityId = '';
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
              child: CustomScrollView(
                slivers: [
                  // Prikazati Recommended Carousel samo ako Search ili Filter nisu aktivni
                  if (!_isSearchVisible && !_isFilterVisible && !_hasActiveFilters())
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: SizedBox(
                          child: RecommendedCarousel(),
                        ),
                      ),
                    ),

                  // Dodajte razmak ispod carousel-a samo ako je carousel prikazan
                  if (!_isSearchVisible && !_isFilterVisible && !_hasActiveFilters())
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 16.0),
                    ),

                  // Prikazati "Ostali oglasi" samo ako Search ili Filter nisu aktivni
                  if (!_isSearchVisible && !_isFilterVisible && !_hasActiveFilters())
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Ostali oglasi',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),

                  // Either a grid view or a list view based on _isGridView
                  if (_isGridView)
                    PagedSliverGrid<int, AutomobileAd>(
                      pagingController: _pagingController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4 / 6,
                      ),
                      builderDelegate: PagedChildBuilderDelegate<AutomobileAd>(
                        itemBuilder: (context, item, index) => AutomobileCard(
                          automobileAd: item,
                          isGridView: true,
                        ),
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
                  else
                    PagedSliverList<int, AutomobileAd>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<AutomobileAd>(
                        itemBuilder: (context, item, index) => AutomobileCard(
                          automobileAd: item,
                          isGridView: false,
                        ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
