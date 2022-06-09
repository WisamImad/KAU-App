import 'package:flutter/material.dart';

class RoadMapPage extends StatefulWidget {
  @override
  _RoadMapPageState createState() => _RoadMapPageState();
}

class _RoadMapPageState extends State<RoadMapPage> {
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/children/road_map_task_background.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image(
                      image: AssetImage('assets/children/road_map.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: height! / 3,
                  left: width! / 2,
                  child: Container(
                    height: height! / 10,
                    width: height! / 10,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/children/child_default_avatar.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: SizedBox(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Image(
                        image: AssetImage('assets/children/close_btn_2.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
