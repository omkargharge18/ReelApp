import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ContentWidget extends StatefulWidget {
  final String src;
  const ContentWidget({super.key, required this.src});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    final Uri videoUri = Uri.parse(widget.src);
    _videoPlayerController = VideoPlayerController.networkUrl(videoUri);
    await Future.wait([_videoPlayerController!.initialize()]);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        showControls: false);
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoPlayerController!.dispose();
    // _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : Container(
              height: 50,
              width: 50,
              child:const Center(child:  CircularProgressIndicator())), // Show a loading indicator if not initialized
      ],
    );
  }
}
