/*
 * Copyright Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */


import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String key = '61da84456d2e1223634e30121bdff1c3';
  WeatherFactory ws;
  List<Weather> _data = [];
  double lat, lon;
  String des = " ";
  double temp ;
  LocationData _currentPosition;

  Location location = Location();


  @override
  void initState() {
    super.initState();
    getLoc();
    ws = new WeatherFactory(key);
  }



  void queryWeather() async {
    /// Removes keyboard
    ///
    print("hello query weather");
    FocusScope.of(context).requestFocus(FocusNode());
    // lat = 10.6609;
    // lon = 77.0048;
    print("$lat na $lon");
    Weather weather = await ws.currentWeatherByLocation(lat, lon);
    print("${weather.tempMax} , ${weather.temperature},  ${weather.weatherDescription},  ${weather.cloudiness}");
    setState(() {
      _data = [weather];
      temp = weather.tempMax.celsius.roundToDouble();
      print("${weather.tempMax.runtimeType} temp is================");
      des = weather.weatherDescription;
      print("$des des is================");

    });
  }

  Widget contentFinishedDownload() {
    return Center(
      child: ListView.separated(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_data[index].toString()),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  getLoc() async{
    print("22222222222im inside the get loc hello999999999999999999");
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        lat = (_currentPosition.latitude);
        lon = (_currentPosition.longitude);
        print("$lat and $lon  im inside the getloc");
        queryWeather();
      });
    });
  }

  // Widget contentDownloading() {
  //   return Container(
  //     margin: EdgeInsets.all(25),
  //     child: Column(children: [
  //       Text(
  //         'Fetching Weather...',
  //         style: TextStyle(fontSize: 20),
  //       ),
  //       Container(
  //           margin: EdgeInsets.only(top: 50),
  //           child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
  //     ]),
  //   );
  // }

  // Widget contentNotDownloaded() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Text(
  //           'Press the button to download the Weather forecast',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
  //     ? contentFinishedDownload()
  //     : _state == AppState.DOWNLOADING
  //     ? contentDownloading()
  //     : contentNotDownloaded();

  // void _saveLat(String input) {
  //   lat = double.tryParse(input);
  //   print(lat);
  // }
  //
  // void _saveLon(String input) {
  //   lon = double.tryParse(input);
  //   print(lon);
  // }

  // Widget _coordinateInputs() {
  //   return Row(
  //     children: <Widget>[
  //       Expanded(
  //         child: Container(
  //             margin: EdgeInsets.all(5),
  //             child: TextField(
  //                 decoration: InputDecoration(
  //                     border: OutlineInputBorder(), hintText: 'Enter latitude'),
  //                 keyboardType: TextInputType.number,
  //                 onChanged: _saveLat,
  //                 onSubmitted: _saveLat)),
  //       ),
  //       Expanded(
  //           child: Container(
  //               margin: EdgeInsets.all(5),
  //               child: TextField(
  //                   decoration: InputDecoration(
  //                       border: OutlineInputBorder(),
  //                       hintText: 'Enter longitude'),
  //                   keyboardType: TextInputType.number,
  //                   onChanged: _saveLon,
  //                   onSubmitted: _saveLon)))
  //     ],
  //   );
  // }

  // Widget _buttons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Container(
  //         margin: EdgeInsets.all(5),
  //         child: TextButton(
  //           child: Text(
  //             'Fetch weather',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           onPressed: queryWeather,
  //           style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all(Colors.blue)),
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.all(5),
  //         child: TextButton(
  //           child: Text(
  //             'Fetch forecast',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           onPressed: queryForecast,
  //           style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all(Colors.blue)),
  //         ),
  //       )
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather Example App'),
        ),
        body: Column(
          children: <Widget>[

            Text(
              'Output:',
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              height: 20.0,
              thickness: 2.0,
            ),
            Text(
              temp.toString(),
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              height: 20.0,
              thickness: 2.0,
            ),
            Text(
              des,
              style: TextStyle(fontSize: 20),
            ),
            Expanded(child: contentFinishedDownload())
          ],
        ),
      ),
    );
  }

}





//
// /*
//  * Copyright Copenhagen Center for Health Technology (CACHET) at the
//  * Technical University of Denmark (DTU).
//  * Use of this source code is governed by a MIT-style license that can be
//  * found in the LICENSE file.
//  */
// import 'package:flutter/material.dart';
// import 'package:weather/weather.dart';
//
// //enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String key = '856822fd8e22db5e1ba48c0e7d69844a';
//    WeatherFactory ws;
//   List<Weather> _data = [];
//   //AppState _state = AppState.NOT_DOWNLOADED;
//   double lat, lon;
//
//   @override
//   void initState() {
//     super.initState();
//     ws = new WeatherFactory(key);
//   }
//
//   void queryForecast() async {
//     /// Removes keyboard
//     FocusScope.of(context).requestFocus(FocusNode());
//     // setState(() {
//     //   _state = AppState.DOWNLOADING;
//     // });
//
//     List<Weather> forecasts = await ws.fiveDayForecastByLocation(lat, lon);
//     setState(() {
//       _data = forecasts;
//       //_state = AppState.FINISHED_DOWNLOADING;
//     });
//   }
//
//   void queryWeather() async {
//     /// Removes keyboard
//     FocusScope.of(context).requestFocus(FocusNode());
//
//     // setState(() {
//     //   _state = AppState.DOWNLOADING;
//     // });
//
//     Weather weather = await ws.currentWeatherByLocation(lat, lon);
//     setState(() {
//       _data = [weather];
//       //_state = AppState.FINISHED_DOWNLOADING;
//     });
//   }
//
//   Widget contentFinishedDownload() {
//     return Center(
//       child: ListView.separated(
//         itemCount: _data.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(_data[index].toString()),
//           );
//         },
//         separatorBuilder: (context, index) {
//           return Divider();
//         },
//       ),
//     );
//   }
//
//   Widget contentDownloading() {
//     return Container(
//       margin: EdgeInsets.all(25),
//       child: Column(children: [
//         Text(
//           'Fetching Weather...',
//           style: TextStyle(fontSize: 20),
//         ),
//         Container(
//             margin: EdgeInsets.only(top: 50),
//             child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
//       ]),
//     );
//   }
//
//   Widget contentNotDownloaded() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Press the button to download the Weather forecast',
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
//   //     ? contentFinishedDownload()
//   //     : _state == AppState.DOWNLOADING
//   //     ? contentDownloading()
//   //     : contentNotDownloaded();
//
//   void _saveLat(String input) {
//     lat = double.tryParse(input);
//     print(lat);
//   }
//
//   void _saveLon(String input) {
//     lon = double.tryParse(input);
//     print(lon);
//   }
//
//   Widget _coordinateInputs() {
//     return Row(
//       children: <Widget>[
//         Expanded(
//           child: Container(
//               margin: EdgeInsets.all(5),
//               child: TextField(
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(), hintText: 'Enter latitude'),
//                   keyboardType: TextInputType.number,
//                   onChanged: _saveLat,
//                   onSubmitted: _saveLat)),
//         ),
//         Expanded(
//             child: Container(
//                 margin: EdgeInsets.all(5),
//                 child: TextField(
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Enter longitude'),
//                     keyboardType: TextInputType.number,
//                     onChanged: _saveLon,
//                     onSubmitted: _saveLon)))
//       ],
//     );
//   }
//
//   Widget _buttons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           margin: EdgeInsets.all(5),
//           child: TextButton(
//             child: Text(
//               'Fetch weather',
//               style: TextStyle(color: Colors.white),
//             ),
//             onPressed: queryWeather,
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.blue)),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.all(5),
//           child: TextButton(
//             child: Text(
//               'Fetch forecast',
//               style: TextStyle(color: Colors.white),
//             ),
//             onPressed: queryForecast,
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.blue)),
//           ),
//         )
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Weather Example App'),
//         ),
//         body: Column(
//           children: <Widget>[
//             _coordinateInputs(),
//             _buttons(),
//             Text(
//               'Output:',
//               style: TextStyle(fontSize: 20),
//             ),
//             Divider(
//               height: 20.0,
//               thickness: 2.0,
//             ),
//             Expanded(child: contentFinishedDownload())
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//









//
// void main(){
//   runApp(MaterialApp(home: MyLocation()));
// }
// class MyLocation extends StatefulWidget {
//   @override
//   _MyLocationState createState() => _MyLocationState();
// }
//
//
// class _MyLocationState extends State<MyLocation> {
//
//
//   LocationData _currentPosition;
//
//   Location location = Location();
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getLoc();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: SafeArea(
//           child: Container(
//             color: Colors.blueGrey.withOpacity(.8),
//             child: Center(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 3,
//                   ),
//                   if (_currentPosition != null)
//                     Text(
//                       "Latitude: ${_currentPosition.latitude}, Longitude: ${_currentPosition.longitude}",
//                       style: TextStyle(
//                           fontSize: 22,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   SizedBox(
//                     height: 3,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//
//     );
//   }
//
//
//   getLoc() async{
//
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     _currentPosition = await location.getLocation();
//     location.onLocationChanged.listen((LocationData currentLocation) {
//       print("${currentLocation.longitude} : ${currentLocation.longitude}");
//       setState(() {
//         _currentPosition = currentLocation;
//       });
//     });
//   }
//
//
//
// }