import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_drawer.dart';
import '../models/playlist_provider.dart';
import '../models/song.dart';
import 'song_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // get the playlist provider
  late final PlaylistProvider playlistProvider;

  @override
  void initState() {
    super.initState();

    // get playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  // go to song
  void goToSong(int songIndex) {
    // update current song index
    playlistProvider.currentSongIndex = songIndex;

    // navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute<Route<dynamic>>(
          builder: (BuildContext context) => const SongPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('P L A Y L I S T'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
          builder: (BuildContext context, PlaylistProvider value, _) {
        // get the playlist
        final List<Song> playlist = value.playlist;

        // return list view UI
        return ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (BuildContext context, int index) {
            // get individual song
            final Song song = playlist[index];

            // return list tile UI
            return ListTile(
              title: Text(song.songName),
              subtitle: Text(song.artistName),
              leading: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(song.albumArtImagePath, fit: BoxFit.cover),
              ),
              onTap: () => goToSong(index),
            );
          },
        );
      }),
    );
  }
}
