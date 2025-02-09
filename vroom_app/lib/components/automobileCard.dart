import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../models/automobileAd.dart';
import '../screens/automobileDetailsScreen.dart';

class AutomobileCard extends StatelessWidget {
  final AutomobileAd automobileAd;
  final bool isGridView;

  const AutomobileCard({
    Key? key,
    required this.automobileAd,
    required this.isGridView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isHighlighted = automobileAd.highlightExpiryDate != null &&
        automobileAd.highlightExpiryDate!.isAfter(DateTime.now());
    bool isDone = automobileAd.status == "Done"; // Check if the status is Done

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AutomobileDetailsScreen(automobileAdId: automobileAd.id),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isHighlighted && !isDone
                  ? Colors.amber
                  : isDone
                      ? Colors.red
                      : Colors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----- Image Section -----
              if (automobileAd.images.isNotEmpty)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.network(
                      '${dotenv.env['BASE_URL']}${automobileAd.images.first.imageUrl}',
                      height: isGridView ? 140 : 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    if (isHighlighted && !isDone)
                      Positioned(
                        top: 4,
                        right: 2,
                        child: _buildHighlightBadge(),
                      ),
                    if (isDone) // Show "Završen" badge for Done status
                      Positioned(
                        top: 4,
                        right: 2,
                        child: _buildDoneBadge(),
                      ),
                    Positioned(
                      bottom: -8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.visibility,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${automobileAd.viewsCount}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              else
                Container(
                  height: isGridView ? 140 : 200,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.directions_car,
                        size: 40, color: Colors.grey),
                  ),
                ),

              // ----- Rest of the Content -----
              if (isGridView)
                Expanded(
                  child: _buildCardContent(context, isGridView),
                )
              else
                _buildCardContent(context, isGridView),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.amber,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            size: 16,
            color: Colors.black,
          ),
          const SizedBox(width: 4),
          Text(
            'Izdvojeno',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.7), // Semi-transparent red
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          const Text(
            'Završen',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, bool isGrid) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      // Ključ: Column s spaceBetween, da cena ide dole pri Grid
      child: Column(
        mainAxisAlignment:
            isGrid ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Naslov
          SizedBox(
            height: isGrid ? 40 : 60,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                automobileAd.title,
                style: TextStyle(
                  fontSize: isGrid ? 14 : 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 2),

          // Ikonice (gorivo, kilometraža, brand (samo u listu), godina)
          Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
            ),
            padding:
                const EdgeInsets.only(top: 6, left: 8, right: 8, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.local_gas_station,
                      size: isGrid ? 20 : 24,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      automobileAd.fuelType?.name ?? '-',
                      style: TextStyle(
                        fontSize: isGrid ? 10 : 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.speed,
                      size: isGrid ? 20 : 24,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${NumberFormat.decimalPattern().format(automobileAd.mileage)}',
                      style: TextStyle(
                        fontSize: isGrid ? 10 : 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                if (!isGrid)
                  Column(
                    children: [
                      Icon(
                        Icons.branding_watermark_outlined,
                        size: 24,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${automobileAd.carBrand?.name}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                Column(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: isGrid ? 20 : 24,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${automobileAd.yearOfManufacture}',
                      style: TextStyle(
                        fontSize: isGrid ? 10 : 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Cena pri dnu
          Text(
            // Napravi NumberFormat i formatiraj cijenu
            '${NumberFormat('#,##0').format(automobileAd.price)} KM',
            style: TextStyle(
              fontSize: isGrid ? 14 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
