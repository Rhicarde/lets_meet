// import 'package:flutter/material.dart';
// import 'package:weather/weather.dart';
//
// WeatherFactory wf = WeatherFactory("3199aa90be7e6cdf53f25ea0565568e5");
//
// class Locations extends StatefulWidget {
//   Locations({this.locationWeather});
//   final locationWeather;
//   @override
//   _LocationsState createState() => _LocationsState();
// }
//
// class _LocationsState extends State<Locations> {
//   int temperature;
//   int condition;
//   String cityName;
//   String weatherIcon;
//   String tempIcon;
//   WeatherModel weatherModel = WeatherModel();
//
//   @override
//   void initState() {
//     super.initState();
//     updateUI(widget.locationWeather);
//   }
//
//   void updateUI(dynamic weather) {
//     setState(() {
//       if (weather == null) {
//         temperature = 0;
//         weatherIcon = 'Error';
//         tempIcon = 'Unable to get weather data';
//         cityName = '';
//         return;
//       }
//       var condition = weather['weather'][0]['id'];
//       weatherIcon = weatherModel.getWeatherIcon(condition);
//       double temp = weather['main']['temp'];
//       temperature = temp.toInt();
//       tempIcon = weatherModel.getMessage(temperature);
//
//       cityName = weather['name'];
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Weather App'),
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 TextButton(
//                     onPressed: () async {
//                       var weatherData = await weatherModel.getLocationWeather();
//                       updateUI(weatherData);
//                     },
//                     child: Icon(
//                       Icons.near_me,
//                       color: Colors.white,
//                       size: 50.0,
//                     )),
//               ],
//             ),
//             Container(
//               padding: EdgeInsets.all(5.0),
//               child: TextField(
//                 style: TextStyle(color: Colors.black),
//                 decoration: textFieldDecoration,
//                 onChanged: (value) {
//                   cityName = value;
//                 },
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (cityName != null) {
//                   var weatherData = await weatherModel.getCityWeather(cityName);
//                   updateUI(weatherData);
//                 }
//               },
//               child: Text(
//                 'Get Weather',
//                 style: kButtonTextStyle,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 15.0),
//               child: Row(
//                 children: <Widget>[
//                   Text(
//                     '$temperature°  ',
//                     style: kTempTextStyle,
//                   ),
//                   Text(
//                     '$weatherIcon',
//                     style: kConditionTextStyle,
//                   ),
//                 ],
//               ),
//             ),
//             Flexible(
//               child: Padding(
//                 padding: EdgeInsets.only(right: 15.0),
//                 child: Text(
//                   '$tempIcon in $cityName',
//                   //textAlign: TextAlign.center,
//                   style: kMessageTextStyle,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }