import 'dart:ffi';

import 'package:flutter/material.dart';

import 'arGameApi.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({super.key, required this.qrcodeId});
  final String qrcodeId;

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  @override
  void initState() {
    super.initState();
    createUser(widget.qrcodeId);
  }

  Future<CtcUser> _getUser() async {
    var apiUser = await getUser(widget.qrcodeId);
    if (apiUser == null) {
      return CtcUser(qrId: widget.qrcodeId);
    }
    return apiUser;
  }

  Future<void> _redeemReward() async {
    await redeemReward(widget.qrcodeId);
  }

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Game'),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              Icons.gamepad_rounded,
              size: 26.0,
            ),
          ),
        ],
      ),
      body: FutureBuilder<CtcUser>(
          future: _getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var collection = [];
              var collectionBool = [];
              var isRedeem = false;
              if (snapshot.data!.isRedeem != null) {
                isRedeem = snapshot.data!.isRedeem!;
              }
              if (snapshot.data!.collection != null) {
                collection = snapshot.data!.collection!;
                for (var e in collection) {
                  collectionBool.add(true);
                }
              }
              var totalLeft = 10 - collectionBool.length;
              for (var i = 0; i < totalLeft; i++) {
                collectionBool.add(false); // filled
              }
              return ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 24, 10, 0),
                    width: double.maxFinite,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "User ID",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  snapshot.data!.qrId,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 4)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Today",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${dt.day.toString()}/${dt.month.toString()}/${dt.year.toString()}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                    width: double.maxFinite,
                    child: Card(
                      elevation: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset("images/ar-game-poster.png"),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                    width: double.maxFinite,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Your Collection",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 12)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total ${collection.length}/10",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Text(
                                      "Warning that this record \nwill be refreshed every day.",
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                if (!isRedeem) ...[
                                  ElevatedButton.icon(
                                    onPressed: (collection.length < 10)
                                        ? null
                                        : _redeemReward,
                                    // onPressed: _redeemReward,
                                    icon: const Icon(
                                      Icons.swap_horiz_rounded,
                                      size: 16.0,
                                    ),
                                    label: const Text('Redeem'),
                                  ),
                                ] else ...[
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 36,
                                  ),
                                ],
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 16)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: collectionBool
                                  .sublist(0, collectionBool.length ~/ 2)
                                  .map((e) => singleCoin(e))
                                  .toList(),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 12)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: collectionBool
                                  .sublist(collectionBool.length ~/ 2,
                                      collectionBool.length)
                                  .map((e) => singleCoin(e))
                                  .toList(),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SafeArea(
        child: FloatingActionButton.extended(
          onPressed: () {},
          label: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text("Start AR Game"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(Icons.open_in_new_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Image singleCoin(bool isActive) {
    return Image.asset(
      isActive ? 'images/ctc-coin-active.png' : 'images/ctc-coin-grey.png',
      height: 50,
      width: 50,
    );
  }
}
