import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/CustomerHome/components/area.dart';
import 'package:flutter_auth/Screens/CustomerHome/components/navbar.dart';
import 'package:flutter_auth/Screens/CustomerHome/components/services.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Responsive(mobile: MobileHomeScreen(), desktop: Row()),
    ));
  }
}

class MobileHomeScreen extends StatefulWidget {
  @override
  _MobileHomeScreenState createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  int navbarIndex = 0;
  final services = ['Hair', 'Makeup', 'Spa', 'Nails', 'Lashes', 'Wax'];
  // final screens [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          children: [
            Expanded(
                child: Column(
              children: <Widget>[
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.navigation)),
                    SizedBox(width: defaultPadding),
                    Area(
                        city: "Damosa, Davao City",
                        area:
                            "#789, Venus St., Victoria Heights, Damosa, Davao"),
                    SizedBox(height: defaultPadding)
                  ],
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: kPrimaryLightColor),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: CustomSearchDelegate(),
                                );
                              },
                              icon: Icon(Icons.search)),
                          Text("Search")
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < services.length; i++)
                        Expanded(child: Services(svcType: services[i]))
                    ]),
                Container(
                  child: Text("data"),
                ),
                NavBar()
              ],
            ))
          ],
        )
      ],
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = ['item 1', 'item 2', 'item 3'];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: (() {
          var query = '';
        }),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var i in searchTerms) {
      if (i.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(i);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var i in searchTerms) {
      if (i.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(i);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
