import 'dart:ffi';

import 'package:flutter/material.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({super.key, required this.qrcodeId});
  final String qrcodeId;

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
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
      body: ListView(
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
                          widget.qrcodeId,
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
                    const Padding(padding: EdgeInsets.only(top: 6)),
                    const Text(
                      "Warning that this record will be refreshed every day.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 24)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        5,
                        (index) {
                          return singleCoin(true);
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        5,
                        (index) {
                          return singleCoin(false);
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SafeArea(
        child: FloatingActionButton.extended(
          onPressed: () {},
          label: Row(
            children: const [
              Text("Start AR Game"),
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
