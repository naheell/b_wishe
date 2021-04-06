import 'package:b_wishes/constant/constant.dart';
import 'package:b_wishes/pages/add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeFire extends StatefulWidget {
  @override
  _HomeFireState createState() => _HomeFireState();
}

class _HomeFireState extends State<HomeFire> {
  final String documentId = 'AXAlblAp4Neuy4F0MXnO';
  CollectionReference users = FirebaseFirestore.instance.collection('wishes');
  @override
  Widget build(BuildContext context) {
    final double padding = MediaQuery.of(context).size.width / 1.5;
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset('assets/svg/accueil.svg'),
        title: Text('Liste de souhait'),
        backgroundColor: primaryPinkColor,
      ),
      backgroundColor: Color(0xFFF6F7F8),
      body: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Verifier votre acces internet'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: new ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return Card(
                  elevation: 2.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 8.0),
                          child: Text(
                            '${document.data()['par'] == null ? '' : document.data()['par']} souhaite  un heureux anniversaire a ${document.data()['pour']}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: padding),
                          child: Divider(
                            color: primaryRainBColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, bottom: 8.0),
                              child: Text(
                                'le ${document.data()['jour']}  ${document.data()['mois']}',
                                style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, bottom: 8.0),
                              child: Chip(
                                backgroundColor: primaryRainBColor,
                                label: Text(
                                  'Photos ${document.data()['urls'].toList().length}',
                                  style: TextStyle(color: primarySnowColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            height: 200.0,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    document.data()['urls'].toList().length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: document.data()['urls'][index]),
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryRainBColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return new MultiplePick();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
