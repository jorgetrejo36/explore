import 'package:explore/schemas.dart';
import 'package:explore/screens/planet_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

class PlanetHomeScreen extends StatefulWidget {
  const PlanetHomeScreen({super.key});

  @override
  State<PlanetHomeScreen> createState() => _PlanetHomeScreenState();
}

class _PlanetHomeScreenState extends State<PlanetHomeScreen> {
  List<ExploreUser> users = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Open a Realm instance
      final realm = Realm(
        Configuration.local([ExploreUser.schema, Planet.schema, Level.schema]),
      );

      // Read all instances of the Person model
      final exploreUsers = realm.all<ExploreUser>();

      // Store the retrieved instances in the list
      setState(() {
        users = List.from(exploreUsers);
      });

      // Close the Realm instance when done
      // Error: code not working when realm is closed
      //realm.close();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Navigate back when the back button is pressed
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Planet Home Screen (choose one of the four planets).\n\nBelow is a list of all the created users just to showcase the ability to read from the DB.",
            ),
            users.isEmpty
                ? const Center(
                    child: Text('No data available'),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('ID: ${users[index].id}'),
                        );
                      },
                    ),
                  ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlanetMapScreen(),
                ),
              ),
              child: const Text("Choose Planet"),
            ),
          ],
        ),
      ),
    );
  }
}
