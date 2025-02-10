import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vroom_app/screens/automobileDetailsScreen.dart';
import 'package:vroom_app/services/config.dart';
import 'package:vroom_app/utils/helpers.dart';
import '../../models/automobileAd.dart';
import '../../models/user.dart';
import '../../services/automobileAdService.dart';

class OwnerScreen extends StatefulWidget {
  final User owner;

  const OwnerScreen({Key? key, required this.owner}) : super(key: key);

  @override
  _OwnerScreenState createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AutomobileAdService _automobileAdService = AutomobileAdService();

  static const int _pageSize = 10;
  final PagingController<int, AutomobileAd> _pagingController =
      PagingController(firstPageKey: 0);

  String _selectedTab = 'active'; // Default tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final myAutomobileAds = await _automobileAdService.fetchUserAutomobiles(
          userId: widget.owner.id.toString(),
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
        title: Text('Profil Vlasnika'),
        iconTheme: const IconThemeData(
          color: Colors.blueAccent,
        ),
      ),
      body: Column(
        children: [
          // User Information Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blueGrey[50],
            child: Row(
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    '$baseUrl${widget.owner.profilePicture}',
                  ),
                ),
                const SizedBox(width: 16), // Space between image and text
                // User Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.owner.firstName} ${widget.owner.lastName}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vroom ID: ${widget.owner.id}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Space below profile section
          // Additional User Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfoRow(Icons.location_city, 'Grad',
                    widget.owner.city?.title ?? 'N/A'),
                _buildUserInfoRow(Icons.map, 'Kanton',
                    widget.owner.city?.canton?.title ?? 'N/A'),
                _buildUserInfoRow(
                    Icons.home, 'Adresa', widget.owner.address ?? 'N/A'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfoRow(
                  Icons.phone,
                  'Broj telefona',
                  widget.owner.phoneNumber != null
                      ? formatPhoneNumber(widget.owner.phoneNumber!)
                      : 'N/A',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Tab Section for Ads
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
          // Tab Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PagedListView<int, AutomobileAd>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<AutomobileAd>(
                  itemBuilder: (context, ad, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            ad.images.isNotEmpty
                                ? '$baseUrl${ad.images.first.imageUrl}'
                                : 'https://via.placeholder.com/150', // Fallback URL
                          ),
                          backgroundColor: Colors.grey.shade300,
                        ),
                        title: Text(ad.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cijena: ${formatPrice(ad.price)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          // Navigate to ad details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AutomobileDetailsScreen(
                                  automobileAdId: ad.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  newPageProgressIndicatorBuilder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: Text('Nema oglasa za prikaz.'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
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
