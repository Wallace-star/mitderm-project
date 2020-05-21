
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenHeight, screenWidth;
  List location;
  bool _visible = false;
   String curtype = "Recent";
  String titlecenter = "No location found";
  String dropdownValue = 'Kedah';

   @override
  void initState() {
    super.initState();
    _loadData();
    }
  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();

    return Scaffold(
          appBar: AppBar(
            title: Text(
              'Location List',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: _visible
                    ? new Icon(Icons.expand_more)
                    : new Icon(Icons.expand_less),
                onPressed: () {
                  setState(() {
                    if (_visible) {
                      _visible = false;
                    } else {
                      _visible = true;
                    }
                  });
                },
              ),
              //
            ],
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: _visible,
                  child: Card(
                      elevation: 10,
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                
                                Column(
                                  children: <Widget>[
                                    DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: <String>['Kedah', 'Kelantan', 'Perlis']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                    
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                
                                
                              ],
                            ),
                          ))),
                ),
                Visibility(
                    visible: _visible,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: screenHeight / 12.5,
                        margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Flexible(
                                child: Container(
                              height: 30,
                              child: TextField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  autofocus: false,
                                  controller: _prdController,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.search),
                                      border: OutlineInputBorder())),
                            )),
                            Flexible(
                                child: MaterialButton(
                                    color: Color.fromARGB(101, 255, 218, 50),
                                    onPressed: () =>
                                        {(_prdController.text)},
                                    elevation: 5,
                                    child: Text(
                                      "Search Location",
                                      style: TextStyle(color: Colors.black),
                                    )))
                          ],
                        ),
                      ),
                    )),
                Text(curtype,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                location == null
                    ? Flexible(
                        child: Container(
                            child: Center(
                                child: Text(
                        titlecenter,
                        style: TextStyle(
                            color: Color.fromARGB(101, 255, 218, 50),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ))))
           :Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio:
                                (screenWidth / screenHeight) / 0.8,
                            children:
                                List.generate(location.length, (index) {
                              return Container(
                                  child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () =>
                                                  _onImageDisplay(index),
                                              child: Container(
                                                height: screenHeight / 5.9,
                                                width: screenWidth / 3.5,
                                                child: ClipOval(
                                                    child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl:
                                                      "http://slumberjer.com/visitmalaysia/images/<imagename.jpg>",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                )),
                                              ),
                                            ),
                                            Text("image" + location[index]['imagename'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            Text(
                                              "state:" +
                                                  location[index]['state'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "location name:" +
                                                  location[index]
                                                      ['address'],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),

                                          ],
                                        ),
                                      )));
                            })))
              ]
            ),
    ));
          
          
  }
  void _loadData() {
    String urlLoadJobs = "http://slumberjer.com/visitmalaysia/load_destinations.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        location = extractdata["locations"];
      });
    }).catchError((err) {
      print(err);
    });
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: Colors.white,
              height: screenHeight / 2.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth / 1.5,
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                          //border: Border.all(color: Colors.black),
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: NetworkImage(
                                  "http://slumberjer.com/visitmalaysia/images/<imagename.jpg>")))),
                ],
              ),
            ));
      },
    );
  }
}
