import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/widgets.dart';
import 'package:flutter_auth/constants.dart';

final db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

class SalonDocs {
  final String outsideSalonUrl;
  final String insideSalonUrl;
  final String businessPermitUrl;
  final String secondLicenseUrl;

  SalonDocs(
      {required this.outsideSalonUrl,
      required this.insideSalonUrl,
      required this.businessPermitUrl,
      required this.secondLicenseUrl});

  factory SalonDocs.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return SalonDocs(
        outsideSalonUrl: data['outsideSalon'] as String,
        insideSalonUrl: data['insideSalon'] as String,
        businessPermitUrl: data['businessPermit'] as String,
        secondLicenseUrl: data['secondaryLicense'] as String);
  }
}

class SalonIDs extends StatefulWidget {
  final String currentID;
  const SalonIDs({super.key, required this.currentID});

  @override
  State<SalonIDs> createState() => _SalonIDsState();
}

class _SalonIDsState extends State<SalonIDs> {
  Future<SalonDocs> getSalonDocsWithDownloadUrls() async {
    final docRef = db
        .collection('users')
        .doc(widget.currentID)
        .collection('portfolio')
        .doc('requirements');

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final List<String> downloadUrls = [];

      final outsideSalonUrl = docSnapshot.get('outsideSalon') as String;
      final insideSalonUrl = docSnapshot.get('insideSalon') as String;
      final businessPermitUrl = docSnapshot.get('businessPermit') as String;
      final secondLicenseUrl = docSnapshot.get('secondaryLicense') as String;

      //Efficiently download URLs in parallel (if applicable)
      final futures = [
        outsideSalonUrl.isNotEmpty
            ? storage.refFromURL(outsideSalonUrl).getDownloadURL()
            : Future.value(""),
        insideSalonUrl.isNotEmpty
            ? storage.refFromURL(insideSalonUrl).getDownloadURL()
            : Future.value(""),
        businessPermitUrl.isNotEmpty
            ? storage.refFromURL(businessPermitUrl).getDownloadURL()
            : Future.value(""),
        secondLicenseUrl.isNotEmpty
            ? storage.refFromURL(secondLicenseUrl).getDownloadURL()
            : Future.value(""),
      ];

      downloadUrls.addAll(await Future.wait(futures));

      // if (outsideSalonUrl.isNotEmpty) {
      // downloadUrls
      // .add(await storage.refFromURL(outsideSalonUrl).getDownloadURL());
      // } else {
      // downloadUrls.add('');
      // }

      return SalonDocs(
          outsideSalonUrl: downloadUrls[0],
          insideSalonUrl: downloadUrls[1],
          businessPermitUrl: downloadUrls[2],
          secondLicenseUrl: downloadUrls[3]);
    } else {
      return SalonDocs(
          outsideSalonUrl: 'no outsideSalonUrl',
          insideSalonUrl: 'no insideSalonUrl',
          businessPermitUrl: 'no businessPermitUrl',
          secondLicenseUrl: 'no secondLicenseUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalonDocs>(
        future: getSalonDocsWithDownloadUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final salonDocs = snapshot.data!;
            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                // adminHeading('Salon Images'),
                Image.network(
                  salonDocs.outsideSalonUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: ((context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return const Icon(Icons.check);
                    } else {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: kPrimaryColor));
                    }
                  }),
                  errorBuilder: ((context, error, stackTrace) =>
                      const Icon(Icons.error)),
                ),
                Image.network(
                  salonDocs.insideSalonUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: ((context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return const Icon(Icons.check);
                    } else {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: kPrimaryColor));
                    }
                  }),
                  errorBuilder: ((context, error, stackTrace) =>
                      const Icon(Icons.error)),
                ),
                // adminHeading('Legal Documents'),
                Image.network(
                  salonDocs.businessPermitUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: ((context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return const Icon(Icons.check);
                    } else {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: kPrimaryColor));
                    }
                  }),
                  errorBuilder: ((context, error, stackTrace) =>
                      const Icon(Icons.error)),
                ),
                Image.network(
                  salonDocs.secondLicenseUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: ((context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return const Icon(Icons.check);
                    } else {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: kPrimaryColor));
                    }
                  }),
                  errorBuilder: ((context, error, stackTrace) =>
                      const Icon(Icons.error)),
                ),
              ],
            );
            // return Expanded(
            // child: Container(
            // padding: EdgeInsets.fromLTRB(50, 30, 50, 0),
            // child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            // children: [
            // SizedBox(
            // height: 40,
            // ),
            // adminHeading('Salon Images'),
            // SizedBox(
            // height: 20,
            // ),
            // Row(
            // children: [
            // Image.network(salonDoc.insideSalonUrl)
            // Expanded(
            // child: adminImageContainer(
            // 'Inside Picture', salonDoc.insideSalonUrl))
            // ],
            // )
            // ],
            // ),
            // ));
          }
        });
  }
}
