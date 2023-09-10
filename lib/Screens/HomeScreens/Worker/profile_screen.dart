import 'package:flutter/material.dart';
import 'package:flutter_auth/components/background.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Background(
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 35, 15, 0),
          child: Column(
            children: [
              Text(
                "Profile".toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: Container(
                  height: height * 0.4,
                  color: Colors.transparent,
                  child: LayoutBuilder(builder: (contex, constraints) {
                    double innerHeight = constraints.maxHeight;
                    double innerWidth = constraints.maxWidth;
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: innerHeight * 0.65,
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: kPrimaryLightColor,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 65),
                                const Text(
                                  "@username",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 8),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SizedBox(
                              width: innerWidth * 0.35,
                              child: ClipOval(
                                  child: Image.asset('assets/avatars/2.jpg')),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: defaultPadding),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // padding: const EdgeInsets.only(right: defaultPadding),
                child: Row(
                  children: [
                    profileStats('Transactions\nDone', body: '123'),
                    const SizedBox(width: defaultPadding),
                    profileStats('Last\nTransaction', body: 'Jasper'),
                    const SizedBox(width: defaultPadding),
                    InkWell(
                      child: profileStats('Credentials',
                          body: 'View', underline: true),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Theme(
                            data: ThemeData(
                              colorScheme: Theme.of(context)
                                  .colorScheme
                                  .copyWith(primary: kPrimaryColor),
                            ),
                            child: AlertDialog(
                              title: const Text('List of Credentials'),
                              content: const SingleChildScrollView(
                                child: Text('list of images'),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: defaultPadding),
                    profileStats('Profile Visits', body: '123'),
                    const SizedBox(width: defaultPadding),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              const Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: defaultPadding),
              const Text(
                  'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non semper suscipit posuere a pede.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non semper suscipit posuere a pede.'),
              const SizedBox(height: defaultPadding)
            ],
          ),
        ),
      ),
    );
  }

  Container profileStats(String title, {String? body, bool underline = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 120,
      width: 120,
      decoration: const BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(),
          Align(
              alignment: Alignment.bottomRight,
              child: body != null
                  ? Text(
                      body,
                      style: TextStyle(
                        decoration: underline ? TextDecoration.underline : null,
                        color: underline ? kPrimaryColor : null,
                      ),
                    )
                  : null)
        ],
      ),
    );
  }
}