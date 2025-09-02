import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final bool isLocal;
  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    this.isLocal = false,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.isLocal
        ? VideoPlayerController.file(File(widget.videoUrl))
        : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
      _isPlaying = true;
    });

    _controller.addListener(() {
      setState(() {}); 
    });
  }

  @override 
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() { 
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              color: Colors.black,
              child: _controller.value.isInitialized
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _showControls = !_showControls;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: _controller.value.size.width,
                                height: _controller.value.size.height,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                          ),

                          if (_showControls)
                            IconButton(
                              iconSize: 60,
                              color: Colors.white,
                              icon: Icon(
                                _isPlaying ? Icons.pause_circle : Icons.play_circle,
                              ),
                              onPressed: _togglePlayPause,
                            ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: Colors.red,
                                bufferedColor: Colors.grey,
                                backgroundColor: Colors.black38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(75)),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "The Rings of Power - Official Trailer",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "1.4M views • 3 days ago",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _VideoAction(
                          icon: Icons.thumb_up_alt_outlined, label: "1.4K"),
                      _VideoAction(
                          icon: Icons.thumb_down_alt_outlined, label: "3.8K"),
                      _VideoAction(icon: Icons.send_outlined, label: "Share"),
                      _VideoAction(
                          icon: Icons.download_outlined, label: "Download"),
                      _VideoAction(icon: Icons.save_alt_rounded, label: "Save"),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 34, 12, 10),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.notifications_outlined,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Subscribe",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Maybe you like",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 100,
                      color: Colors.grey[800],
                    ),
                    title: const Text('Suggested Video',
                        style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Channel • 1M views',
                        style: TextStyle(color: Colors.grey)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _VideoAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
