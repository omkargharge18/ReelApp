import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:reelapp/content.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<String> reel = [
    'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-pov-of-a-basket-of-easter-eggs-48595-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-young-woman-missing-a-bowling-shot-49115-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-two-avenues-with-many-cars-traveling-at-night-34562-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-road-of-a-city-with-many-cars-at-night-34561-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-avenue-with-trees-buildings-and-fast-cars-at-dusk-34563-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-man-runs-past-ground-level-shot-32809-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-sun-setting-or-rising-over-palm-trees-1170-large.mp4',
  ];

  PageController? _pageController;
   CacheManager? _videoCacheManager;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
     _videoCacheManager = DefaultCacheManager();
    // Preload the first video and start preloading the second
    _preloadVideo(1);
    _preloadVideo(2);
    _preloadVideo(3);
  }

  // Preload video at the specified index
  Future<void> _preloadVideo(int index) async {
    if (index >= 0 && index < reel.length) {
      final _videoCacheManager = DefaultCacheManager();
      await _videoCacheManager.getSingleFile(reel[index]);
    }
  }

  Future<void> _deleteCachedVideos(int currentIndex) async {
  if (currentIndex > 0) {
    final int startIndex = 0;
    final int endIndex = currentIndex - 2; // Adjust as needed

    for (int i = startIndex; i <= endIndex; i++) {
      if (i >= 0 && i < reel.length) {
        final videoUrl = reel[i];
        try {
          await _videoCacheManager!.removeFile(videoUrl);
          print('Deleted video: $videoUrl');
        } catch (e) {
          print('Error deleting cached video: $e');
        }
      }
    }
  }
}


  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necessary to keep the state alive
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reels"),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: reel.length,
        itemBuilder: (context, index) {
          // Initialize and play the video when it's the current page
          return ContentWidget(src: reel[index]);
        },
        onPageChanged: (int index) {
          // Preload the next video when the user changes pages
          _preloadVideo(index);

          // Delete cached videos before the current index
          _deleteCachedVideos(index);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
