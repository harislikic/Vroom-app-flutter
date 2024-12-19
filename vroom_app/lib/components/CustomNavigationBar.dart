import 'package:flutter/material.dart';

class CustomNavigationBarWithButton extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddPressed;

  const CustomNavigationBarWithButton({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85, // Smanjena visina celog navigacionog bara
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.blueGrey[900], // Metalik plava pozadina
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: currentIndex == 0 ? Colors.blue : Colors.grey[400],
                  ),
                  onPressed: () => onTap(0),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: currentIndex == 1 ? Colors.blue : Colors.grey[400],
                  ),
                  onPressed: () => onTap(1),
                ),
                const SizedBox(width: 40), // Prostor za centralno dugme
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: currentIndex == 3 ? Colors.blue : Colors.grey[400],
                  ),
                  onPressed: () => onTap(3),
                ),
              ],
            ),
            Positioned(
              bottom: 0, // Podešavanje visine FloatingActionButton
              child: Container(
                height: 50, // Smanjena visina centralnog dugmeta
                width: 50, // Smanjena širina centralnog dugmeta
                decoration: BoxDecoration(
                  color: Colors.lightBlue, // Svetlo plava pozadina
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.lightBlue,
                  elevation: 5,
                  onPressed: onAddPressed,
                  child: const Icon(Icons.add,
                      size: 20,
                      color: Colors.white), // Ikona centralnog dugmeta
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
