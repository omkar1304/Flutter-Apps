import 'package:flutter/material.dart';
import 'package:responsive_app/constant.dart';
import 'package:responsive_app/util/my_box.dart';
import 'package:responsive_app/util/my_tile.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      drawer: myDrawer,
      body: Padding(
        padding: const EdgeInsetsGeometry.all(8.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 4,
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) {
                    return MyBox();
                  },
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return MyTile();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
