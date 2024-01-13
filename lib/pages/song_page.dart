import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/neu_box.dart';
import '../models/playlist_provider.dart';
import '../models/song.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  // get the playlist provider
  late final PlaylistProvider playlistProvider;

  @override
  void initState() {
    super.initState();

    // get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // pause current song
    playlistProvider.pause();
    super.dispose();
  }

  // convert duration into min:sec
  String formatTime(Duration duration) {
    final String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final String formattedTime = '${duration.inMinutes}:$twoDigitSeconds';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
        builder: (BuildContext context, PlaylistProvider value, _) {
      // get playlist
      final List<Song> playlist = value.playlist;

      // get current song index
      final Song currentSong = playlist[value.currentSongIndex ?? 0];

      // return scaffold UI
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('P L A Y L I S T'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            // menu button
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 25),
                // album artwork
                NeuBox(
                  child: Column(
                    children: <Widget>[
                      // image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            currentSong.albumArtImagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // song and artist name and icon
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // song and artist name
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  currentSong.songName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(currentSong.artistName)
                              ],
                            ),
                            // heart icon
                            const Icon(Icons.favorite, color: Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // song duration progress
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // start time
                          Text(formatTime(value.currentDuration)),

                          // shuffle icon
                          const Icon(Icons.shuffle),

                          // repeat icon
                          const Icon(Icons.repeat),

                          // end time
                          Text(formatTime(value.totalDuration)),
                        ],
                      ),
                    ),

                    // song duration progress
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 0),
                      ),
                      child: Slider(
                        max: value.totalDuration.inSeconds.toDouble(),
                        value: value.currentDuration.inSeconds.toDouble(),
                        activeColor: Colors.green,
                        onChanged: (double val) {
                          // during when the user is sliding around
                        },
                        onChangeEnd: (double val) {
                          // sliding has finished, go to that position in song duration
                          value.seek(Duration(seconds: val.toInt()));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // playback controls
                Row(
                  children: <Widget>[
                    // skip previous
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playPreviousSong,
                        child: const NeuBox(
                          child: Icon(Icons.skip_previous),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // play pause
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: value.pauseOrResume,
                        child: NeuBox(
                          child: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // skip forward
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playNextSong,
                        child: const NeuBox(
                          child: Icon(Icons.skip_next),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
