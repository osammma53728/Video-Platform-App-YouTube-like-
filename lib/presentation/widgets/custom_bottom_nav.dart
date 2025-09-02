import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final VoidCallback onAddVideo;
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.onAddVideo,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: Container(
                color: const Color(0xFF1E1E1E),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: Colors.red,
                  unselectedItemColor: Colors.grey,
                  currentIndex: currentIndex,
                  onTap: (index) {
                    if (index == 2) return;
                    onItemTapped(index);
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.explore), label: 'Explore'),
                    BottomNavigationBarItem(
                        icon: SizedBox.shrink(), label: ''), 
                    BottomNavigationBarItem(
                        icon: Icon(Icons.subscriptions), label: 'Channels'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.video_library), label: 'Library'),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -22,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    spreadRadius: -4,
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: onAddVideo,
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                elevation: 0,
                mini: true,
                child: const Icon(Icons.add, size: 24, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
