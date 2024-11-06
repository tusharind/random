import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>> fetchRandomJoke() async {
    final response = await http
        .get(Uri.parse('https://official-joke-api.appspot.com/random_joke'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('failed to fetch a random joke');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Joke'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchRandomJoke(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final joke = snapshot.data;
            final setup = joke!['setup'];
            final punchline = joke['punchline'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlipCard(
                    front: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text('Joke'),
                            const SizedBox(height: 15),
                            Text('$setup'),
                          ],
                        ),
                      ),
                    ),
                    back: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text('Punchline'),
                            const SizedBox(height: 25),
                            Text('$punchline'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Refresh Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Refresh Joke'),
                  )
                ],
              ),
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
