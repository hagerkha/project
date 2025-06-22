import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final String videoTitle;

  const VideoPlayerScreen({super.key, required this.videoPath, required this.videoTitle});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.asset(widget.videoPath);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      showControlsOnInitialize: true,
      fullScreenByDefault: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.deepPurple,
        handleColor: Colors.purpleAccent,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _seekForward() {
    final newPosition = _videoPlayerController.value.position + const Duration(seconds: 10);
    _videoPlayerController.seekTo(newPosition);
  }

  void _seekBackward() {
    final newPosition = _videoPlayerController.value.position - const Duration(seconds: 10);
    _videoPlayerController.seekTo(newPosition);
  }

  void _playVideo() {
    _videoPlayerController.play();
  }

  void _pauseVideo() {
    _videoPlayerController.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.videoTitle),
        backgroundColor: const Color(0xFF8E9AFE),
      ),
      body: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
          ? Column(
        children: [
          Expanded(child: Center(child: Chewie(controller: _chewieController!))),
          const SizedBox(height: 10),
          _buildCustomControls(),
          const SizedBox(height: 20),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildCustomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(onPressed: _seekBackward, icon: const Icon(Icons.replay_10, color: Colors.white), tooltip: 'ترجيع 10 ثواني'),
        IconButton(onPressed: _playVideo, icon: const Icon(Icons.play_arrow, color: Colors.greenAccent), tooltip: 'تشغيل'),
        IconButton(onPressed: _pauseVideo, icon: const Icon(Icons.pause, color: Colors.yellowAccent), tooltip: 'إيقاف مؤقت'),
        IconButton(onPressed: _seekForward, icon: const Icon(Icons.forward_10, color: Colors.white), tooltip: 'تقديم 10 ثواني'),
      ],
    );
  }
}