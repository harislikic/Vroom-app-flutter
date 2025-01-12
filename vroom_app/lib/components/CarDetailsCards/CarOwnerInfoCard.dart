import 'package:flutter/material.dart';
import 'package:vroom_app/screens/OwnerScreen.dart';
import '../../models/automobileAd.dart';

class CarOwnerInfoCard extends StatefulWidget {
  final AutomobileAd automobileAd;

  const CarOwnerInfoCard({Key? key, required this.automobileAd})
      : super(key: key);

  @override
  _CarOwnerInfoCardState createState() => _CarOwnerInfoCardState();
}

class _CarOwnerInfoCardState extends State<CarOwnerInfoCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Animation curve
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section to indicate owner profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Vlasnik',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded =
                            !_isExpanded; // Toggle expansion state on arrow click
                      });
                    },
                    child: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up // Icon for collapse
                          : Icons.keyboard_arrow_down, // Icon for expand
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12), // Spacing below header

                // User Profile Row
                Row(
                  children: [
                    // Avatar or user's profile picture
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnerScreen(
                              owner: widget.automobileAd.user!,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'http://localhost:5194${widget.automobileAd.user?.profilePicture}',
                        ), // User's profile picture
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 16), // Spacing between image and text

                    // User information
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OwnerScreen(
                                owner: widget.automobileAd.user!,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User's full name
                            Text(
                              '${widget.automobileAd.user?.firstName} ${widget.automobileAd.user?.lastName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                                height: 8), // Small spacing below name

                            // Contact number
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.automobileAd.user?.phoneNumber ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4), // Small spacing

                            // Label indicating contact information
                            const Text(
                              'Kontakt broj',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Spacing between sections

                // City and Canton Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Owner's city
                          Text(
                            'Grad: ${widget.automobileAd.user?.city?.title ?? ''}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Owner's canton
                          Text(
                            'Kanton: ${widget.automobileAd.user?.city?.canton.title ?? ''}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
