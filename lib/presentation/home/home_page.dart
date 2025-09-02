import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:youtube/presentation/home/ChannelsPage.dart';
import 'package:youtube/presentation/home/ExplorePage.dart';
import '../widgets/custom_bottom_nav.dart';
import '../video_player/video_player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategory = 0;
  int selectedNavIndex = 0;
  File? selectedVideo;
  final List<String> categories = ["All", "Game UI", "Figma", "Design", "Other"];

  List<File> userVideos = [];

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        userVideos.add(File(result.files.single.path!));
      });
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      selectedNavIndex = index;
    });
  }

  Widget _buildVideoItem({
  required String thumbnail,
  required String title,
  required String views,
  required String time,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(thumbnail),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: -10, 
            right: 0, 
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 23, 22, 22), 
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6), 
              child: const Icon(
                Icons.play_arrow,
                color: Colors.red,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(thumbnail),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "$views • $time",
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.more_vert, color: Colors.white),
      ),
    ],
  );
}


  Widget _buildHomeContent() {
    return ListView(
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[700],
                      backgroundImage: const AssetImage(''),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Channel',
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              bool isSelected = selectedCategory == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.grey[800] : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categories[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return _buildVideoItem(
              thumbnail: 'assets/img.png',
              title: 'Video Title Example #$index',
              views: '${(index + 1) * 100}K views',
              time: '${index + 1} days ago',
            );
          },
        ),

        if (userVideos.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userVideos.length,
            itemBuilder: (context, index) {
              final video = userVideos[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedVideo = video;
                    selectedNavIndex = 5;
                  });
                },
                child: _buildVideoItem(
                  thumbnail: 'assets/logo.png',
                  title: video.path.split('/').last,
                  views: 'Local Video',
                  time: '',
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      const ExplorePage(),
      const SizedBox.shrink(),
      Channelspage(
        onOpenPage: (pageWidget) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => pageWidget),
          );
        },
      ),
      const Center(child: Text("Library", style: TextStyle(color: Colors.white))),
      if (selectedVideo != null)
        VideoPlayerPage(videoUrl: selectedVideo!.path, isLocal: true)
      else
        const Center(child: Text("No Video Selected", style: TextStyle(color: Colors.white))),
    ];

    return Scaffold(
      appBar: (selectedNavIndex == 1 || selectedNavIndex == 3)
          ? null
          : AppBar(
              title: Row(
                children: [
                  Image.asset('assets/imageyoutube.png', height: 30),
                  const SizedBox(width: 8),
                  const Text('YouTube',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
              actions: const [
                Icon(Icons.search),
                SizedBox(width: 10),
                Icon(Icons.notifications_outlined),
                SizedBox(width: 10),
                CircleAvatar(radius: 26, backgroundColor: Colors.grey),
                SizedBox(width: 10),
              ],
            ),
      body: IndexedStack(
        index: selectedNavIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        onAddVideo: _pickVideo,
        currentIndex: selectedNavIndex > 4 ? 0 : selectedNavIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }
}
