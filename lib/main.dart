import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notifi/model/message.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

Future<dynamic> myBackgroundHandler(Map<String, dynamic> message) {
  return MyAppState()._showNotification(message);
}

class MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();



  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Messages> messages = [];
  String title;
  String body;
  String imageLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Column(
        children: [
          Image.network(imageLink ?? 'https://i.stack.imgur.com/y9DpT.jpg') ,
          Text(
            '$body', textAlign: TextAlign.center,),
        ],
      )
    );
  }

  // Widget buildMessage(Messages message) => ListTile(
  //   title: Text(message.title),
  //   subtitle: Text(message.body),
  // );

  Future _showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel color',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'new message arived',
      'i want ${message['data']['title']} for ${message['data']['price']}',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future selectNotification(String payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  void initState() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    super.initState();

    _firebaseMessaging.configure(
      onBackgroundMessage: myBackgroundHandler,
      //App in Foreground
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
          title = message['notification']['title'] ?? '';
          body = message['notification']['body'] ?? '';
          imageLink = message['data']['image_link'] ?? '';
        });
      },
      //App Terminated
      onLaunch: (Map<String, dynamic> message) async{
        print('onLaunch: $message');
        final data = message['data'];
        setState(() {
          messages.add(Messages(
              title: data['title'], body: data['body'], imageLink: data['image_link']));
        });
      },
      //App in Background
      onResume: (Map<String, dynamic> message) async{
        print('onResume: $message');
        setState(() {
          title = message['data']['title'] ?? '';
          body = message['data']['body'] ?? '';
          imageLink = message['data']['image_link'] ?? '';
        });
      },
    );

    getTokenz() async {
      String token = await _firebaseMessaging.getToken();
      print(token);
    }

    getTokenz();
  }
}
