import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //runApp(App());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/screen0.jpg"), fit: BoxFit.cover)),
            ),
            Positioned(
              top: 350,
              left:500,
              child: Container(
                alignment: Alignment.center,
                child: TextButton(
                  child: Text('Area A'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScreenA()));
                  },
                ),
              ),
            ),
            Positioned(
              top: 350,
              right: 500,
              child:  Container(
                alignment: Alignment.center,
                child: TextButton(
                  child: Text('Area B'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScreenB()));
                  },
                ),
              ),
            ),
          ],
      )
    );
  }
}

class ScreenA extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
                body: Center(
                    child: Text(snapshot.error.toString(),
                        textDirection: TextDirection.ltr))),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          log("Firebase is connected yay!");
          return Screen1();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take A Seat',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TAKE A SEAT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter1 = 140;
  int _counter2 = 140;
  List<Color> _seats1 = List.filled(140, Colors.lightGreenAccent);
  List<Color> _seats2 = List.filled(140, Colors.lightGreenAccent);

  List<int> train1 = List.filled(140, 0);
  List<int> train2 = List.filled(140, 0);

  @override
  void initState() {
    super.initState();

    // defines a timer
    Timer _everySecond = Timer.periodic(Duration(seconds: 3), (Timer t) async {
      FirebaseDatabase database = FirebaseDatabase.instance;
      DatabaseReference ref = database.ref("test");
      final event = await ref.once(DatabaseEventType.value);
      if (event.snapshot.exists) {
        //log(event.snapshot.value.toString());
        Map data = event.snapshot.value as Map;

        for (var i=0 ; i<140 ; i++){
          train1[i] = data['chair_$i'];
        }
      }

      DatabaseReference ref2 = database.ref("train1");
      final event2 = await ref2.once(DatabaseEventType.value);
      if (event2.snapshot.exists) {
        //log(event.snapshot.value.toString());
        Map data = event2.snapshot.value as Map;

        for (var i=0 ; i<140 ; i++){
          train2[i] = data['chair_$i'];
        }
      }


      setState(() {
        _counter1 = 140;
        _counter2 = 140;
        int i = 0;

        for (int seat in train1) {
          _counter1 -= seat;

          if (train1[i] == 0){
            _seats1[i] = Colors.lightGreenAccent;
          }
          else{
            _seats1[i] = Colors.redAccent;
          }

          i++;
        }

        i = 0;
        for (int seat in train2) {
          _counter2 -= seat;

          if (train2[i] == 0){
            _seats2[i] = Colors.lightGreenAccent;
          }
          else{
            _seats2[i] = Colors.redAccent;
          }

          i++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
    body:
    Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/screenA.jpg"), fit: BoxFit.cover)),
        ),
        Positioned(
          bottom: 30,
          right: 360,
          child: Text(_counter1.toString(), style: TextStyle(fontSize: 30, color: Colors.white)),
        ),
        Positioned(
            top: 415,
            right: 563,
            child:   Container(width: 15,height: 15,color: _seats1[0])
        ),
        Positioned(
            top: 435,
            right: 563,
            child:   Container(width: 15,height: 15,color: _seats1[1])
        ),
        Positioned(
            top: 455,
            right: 563,
            child:   Container(width: 15,height: 15,color: _seats1[2])
        ),
        Positioned(
            top: 475,
            right: 563,
            child:   Container(width: 15,height: 15,color: _seats1[3])
        ),
        Positioned(
            top: 495,
            right: 563,
            child:   Container(width: 15,height: 15,color: _seats1[4])
        ),
        Positioned(
            top: 515,
            right: 563,
            child:   Container(width: 15,height: 15,color: _seats1[5])
        ),
        Positioned(
            top: 535,
            right: 563,
            child:   Container(width: 15,height: 15,color: _seats1[6])
        ),
        Positioned(
            top: 415,
            right: 541,
            child:   Container(width: 15,height: 15,color: _seats1[7])
        ),
        Positioned(
            top: 435,
            right: 541,
            child:   Container(width: 15,height: 15,color: _seats1[8])
        ),
        Positioned(
            top: 455,
            right: 541,
            child:   Container(width: 15,height: 15,color: _seats1[9])
        ),
        Positioned(
            top: 475,
            right: 541,
            child:   Container(width: 15,height: 15,color: _seats1[10])
        ),
        Positioned(
            top: 495,
            right: 541,
            child:   Container(width: 15,height: 15,color: _seats1[11])
        ),
        Positioned(
            top: 515,
            right: 541,
            child:   Container(width: 15,height: 15,color: _seats1[12])
        ),
        Positioned(
            top: 535,
            right: 541,
            child:   Container(width: 15,height: 15,color: _seats1[13])
        ),
        Positioned(
            top: 415,
            right: 519,
            child:   Container(width: 15,height: 15,color: _seats1[14])
        ),
        Positioned(
            top: 435,
            right: 519,
            child:   Container(width: 15,height: 15,color: _seats1[15])
        ),
        Positioned(
            top: 455,
            right: 519,
            child:   Container(width: 15,height: 15,color: _seats1[16])
        ),
        Positioned(
            top: 475,
            right: 519,
            child:   Container(width: 15,height: 15,color: _seats1[17])
        ),
        Positioned(
            top: 495,
            right: 519,
            child:   Container(width: 15,height: 15,color: _seats1[18])
        ),
        Positioned(
            top: 515,
            right: 519,
            child:   Container(width: 15,height: 15,color: _seats1[19])
        ),
        Positioned(
            top: 535,
            right: 519,
            child:   Container(width: 15,height: 15,color: _seats1[20])
        ),
        Positioned(
            top: 415,
            right: 497,
            child:   Container(width: 15,height: 15,color: _seats1[21])
        ),
        Positioned(
            top: 435,
            right: 497,
            child:   Container(width: 15,height: 15,color: _seats1[22])
        ),
        Positioned(
            top: 455,
            right: 497,
            child:   Container(width: 15,height: 15,color: _seats1[23])
        ),
        Positioned(
            top: 475,
            right: 497,
            child:   Container(width: 15,height: 15,color: _seats1[24])
        ),
        Positioned(
            top: 495,
            right: 497,
            child:   Container(width: 15,height: 15,color: _seats1[25])
        ),
        Positioned(
            top: 515,
            right: 497,
            child:   Container(width: 15,height: 15,color: _seats1[26])
        ),
        Positioned(
            top: 535,
            right: 497,
            child:   Container(width: 15,height: 15,color: _seats1[27])
        ),
        Positioned(
            top: 415,
            right: 475,
            child:   Container(width: 15,height: 15,color: _seats1[28])
        ),
        Positioned(
            top: 435,
            right: 475,
            child:   Container(width: 15,height: 15,color: _seats1[29])
        ),
        Positioned(
            top: 455,
            right: 475,
            child:   Container(width: 15,height: 15,color: _seats1[30])
        ),
        Positioned(
            top: 475,
            right: 475,
            child:   Container(width: 15,height: 15,color: _seats1[31])
        ),
        Positioned(
            top: 495,
            right: 475,
            child:   Container(width: 15,height: 15,color: _seats1[32])
        ),
        Positioned(
            top: 515,
            right: 475,
            child:   Container(width: 15,height: 15,color: _seats1[33])
        ),
        Positioned(
            top: 535,
            right: 475,
            child:   Container(width: 15,height: 15,color: _seats1[34])
        ),
        Positioned(
            top: 415,
            right: 453,
            child:   Container(width: 15,height: 15,color: _seats1[35])
        ),
        Positioned(
            top: 435,
            right: 453,
            child:   Container(width: 15,height: 15,color: _seats1[36])
        ),
        Positioned(
            top: 455,
            right: 453,
            child:   Container(width: 15,height: 15,color: _seats1[37])
        ),
        Positioned(
            top: 475,
            right: 453,
            child:   Container(width: 15,height: 15,color: _seats1[38])
        ),
        Positioned(
            top: 495,
            right: 453,
            child:   Container(width: 15,height: 15,color: _seats1[39])
        ),
        Positioned(
            top: 515,
            right: 453,
            child:   Container(width: 15,height: 15,color: _seats1[40])
        ),
        Positioned(
            top: 535,
            right: 453,
            child:   Container(width: 15,height: 15,color: _seats1[41])
        ),
        Positioned(
            top: 415,
            right: 431,
            child:   Container(width: 15,height: 15,color: _seats1[42])
        ),
        Positioned(
            top: 435,
            right: 431,
            child:   Container(width: 15,height: 15,color: _seats1[43])
        ),
        Positioned(
            top: 455,
            right: 431,
            child:   Container(width: 15,height: 15,color: _seats1[44])
        ),
        Positioned(
            top: 475,
            right: 431,
            child:   Container(width: 15,height: 15,color: _seats1[45])
        ),
        Positioned(
            top: 495,
            right: 431,
            child:   Container(width: 15,height: 15,color: _seats1[46])
        ),
        Positioned(
            top: 515,
            right: 431,
            child:   Container(width: 15,height: 15,color: _seats1[47])
        ),
        Positioned(
          top: 535,
            right: 431,
            child:   Container(width: 15,height: 15,color: _seats1[48])
        ),
        Positioned(
            top: 415,
            right: 410,
            child:   Container(width: 15,height: 15,color: _seats1[49])
        ),
        Positioned(
            top: 435,
            right: 410,
            child:   Container(width: 15,height: 15,color: _seats1[50])
        ),
        Positioned(
            top: 455,
            right: 410,
            child:   Container(width: 15,height: 15,color: _seats1[51])
        ),
        Positioned(
            top: 475,
            right: 410,
            child:   Container(width: 15,height: 15,color: _seats1[52])
        ),
        Positioned(
            top: 495,
            right: 410,
            child:   Container(width: 15,height: 15,color: _seats1[53])
        ),
        Positioned(
            top: 515,
            right: 410,
            child:   Container(width: 15,height: 15,color: _seats1[54])
        ),
        Positioned(
            top: 535,
            right: 410,
            child:   Container(width: 15,height: 15,color: _seats1[55])
        ),
        Positioned(
            top: 415,
            right: 388,
            child:   Container(width: 15,height: 15,color: _seats1[56])
        ),
        Positioned(
            top: 435,
            right: 388,
            child:   Container(width: 15,height: 15,color: _seats1[57])
        ),
        Positioned(
            top: 455,
            right: 388,
            child:   Container(width: 15,height: 15,color: _seats1[58])
        ),
        Positioned(
            top: 475,
            right: 388,
            child:   Container(width: 15,height: 15,color: _seats1[59])
        ),
        Positioned(
            top: 495,
            right: 388,
            child:   Container(width: 15,height: 15,color: _seats1[60])
        ),
        Positioned(
            top: 515,
            right: 388,
            child:   Container(width: 15,height: 15,color: _seats1[61])
        ),
        Positioned(
            top: 535,
            right: 388,
            child:   Container(width: 15,height: 15,color: _seats1[62])
        ),
        Positioned(
            top: 415,
            right: 365,
            child:   Container(width: 15,height: 15,color: _seats1[63])
        ),
        Positioned(
            top: 435,
            right: 365,
            child:   Container(width: 15,height: 15,color: _seats1[64])
        ),
        Positioned(
            top: 455,
            right: 365,
            child:   Container(width: 15,height: 15,color: _seats1[65])
        ),
        Positioned(
            top: 475,
            right: 365,
            child:   Container(width: 15,height: 15,color: _seats1[66])
        ),
        Positioned(
            top: 495,
            right: 365,
            child:   Container(width: 15,height: 15,color: _seats1[67])
        ),
        Positioned(
            top: 515,
            right: 365,
            child:   Container(width: 15,height: 15,color: _seats1[68])
        ),
        Positioned(
            top: 535,
            right: 365,
            child:   Container(width: 15,height: 15,color: _seats1[69])
        ),
        Positioned(
            top: 415,
            right: 343,
            child:   Container(width: 15,height: 15,color: _seats1[70])
        ),
        Positioned(
            top: 435,
            right: 343,
            child:   Container(width: 15,height: 15,color: _seats1[71])
        ),
        Positioned(
            top: 455,
            right: 343,
            child:   Container(width: 15,height: 15,color: _seats1[72])
        ),
        Positioned(
            top: 475,
            right: 343,
            child:   Container(width: 15,height: 15,color: _seats1[73])
        ),
        Positioned(
            top: 495,
            right: 343,
            child:   Container(width: 15,height: 15,color: _seats1[74])
        ),
        Positioned(
            top: 515,
            right: 343,
            child:   Container(width: 15,height: 15,color: _seats1[75])
        ),
        Positioned(
            top: 535,
            right: 343,
            child:   Container(width: 15,height: 15,color: _seats1[76])
        ),
        Positioned(
            top: 415,
            right: 321,
            child:   Container(width: 15,height: 15,color: _seats1[77])
        ),
        Positioned(
            top: 435,
            right: 321,
            child:   Container(width: 15,height: 15,color: _seats1[78])
        ),
        Positioned(
            top: 455,
            right: 321,
            child:   Container(width: 15,height: 15,color: _seats1[79])
        ),
        Positioned(
            top: 475,
            right: 321,
            child:   Container(width: 15,height: 15,color: _seats1[80])
        ),
        Positioned(
            top: 495,
            right: 321,
            child:   Container(width: 15,height: 15,color: _seats1[81])
        ),
        Positioned(
            top: 515,
            right: 321,
            child:   Container(width: 15,height: 15,color: _seats1[82])
        ),
        Positioned(
            top: 535,
            right: 321,
            child:   Container(width: 15,height: 15,color: _seats1[83])
        ),
        Positioned(
            top: 415,
            right: 299,
            child:   Container(width: 15,height: 15,color: _seats1[84])
        ),
        Positioned(
            top: 435,
            right: 299,
            child:   Container(width: 15,height: 15,color: _seats1[85])
        ),
        Positioned(
            top: 455,
            right: 299,
            child:   Container(width: 15,height: 15,color: _seats1[86])
        ),
        Positioned(
            top: 475,
            right: 299,
            child:   Container(width: 15,height: 15,color: _seats1[87])
        ),
        Positioned(
            top: 495,
            right: 299,
            child:   Container(width: 15,height: 15,color: _seats1[88])
        ),
        Positioned(
            top: 515,
            right: 299,
            child:   Container(width: 15,height: 15,color: _seats1[89])
        ),
        Positioned(
            top: 535,
            right: 299,
            child:   Container(width: 15,height: 15,color: _seats1[90])
        ),
        Positioned(
            top: 415,
            right: 277,
            child:   Container(width: 15,height: 15,color: _seats1[91])
        ),
        Positioned(
            top: 435,
            right: 277,
            child:   Container(width: 15,height: 15,color: _seats1[92])
        ),
        Positioned(
            top: 455,
            right: 277,
            child:   Container(width: 15,height: 15,color: _seats1[93])
        ),
        Positioned(
            top: 475,
            right: 277,
            child:   Container(width: 15,height: 15,color: _seats1[94])
        ),
        Positioned(
            top: 495,
            right: 277,
            child:   Container(width: 15,height: 15,color: _seats1[95])
        ),
        Positioned(
            top: 515,
            right: 277,
            child:   Container(width: 15,height: 15,color: _seats1[96])
        ),
        Positioned(
            top: 535,
            right: 277,
            child:   Container(width: 15,height: 15,color: _seats1[97])
        ),
        Positioned(
            top: 415,
            right: 255,
            child:   Container(width: 15,height: 15,color: _seats1[98])
        ),
        Positioned(
            top: 435,
            right: 255,
            child:   Container(width: 15,height: 15,color: _seats1[99])
        ),
        Positioned(
            top: 455,
            right: 255,
            child:   Container(width: 15,height: 15,color: _seats1[100])
        ),
        Positioned(
            top: 475,
            right: 255,
            child:   Container(width: 15,height: 15,color: _seats1[101])
        ),
        Positioned(
            top: 495,
            right: 255,
            child:   Container(width: 15,height: 15,color: _seats1[102])
        ),
        Positioned(
            top: 515,
            right: 255,
            child:   Container(width: 15,height: 15,color: _seats1[103])
        ),
        Positioned(
            top: 535,
            right: 255,
            child:   Container(width: 15,height: 15,color: _seats1[104])
        ),
        Positioned(
            top: 415,
            right: 233,
            child:   Container(width: 15,height: 15,color: _seats1[105])
        ),
        Positioned(
            top: 435,
            right: 233,
            child:   Container(width: 15,height: 15,color: _seats1[106])
        ),
        Positioned(
            top: 455,
            right: 233,
            child:   Container(width: 15,height: 15,color: _seats1[107])
        ),
        Positioned(
            top: 475,
            right: 233,
            child:   Container(width: 15,height: 15,color: _seats1[108])
        ),
        Positioned(
            top: 495,
            right: 233,
            child:   Container(width: 15,height: 15,color: _seats1[109])
        ),
        Positioned(
            top: 515,
            right: 233,
            child:   Container(width: 15,height: 15,color: _seats1[110])
        ),
        Positioned(
            top: 535,
            right: 233,
            child:   Container(width: 15,height: 15,color: _seats1[111])
        ),
        Positioned(
            top: 415,
            right: 211,
            child:   Container(width: 15,height: 15,color: _seats1[112])
        ),
        Positioned(
            top: 435,
            right: 211,
            child:   Container(width: 15,height: 15,color: _seats1[113])
        ),
        Positioned(
            top: 455,
            right: 211,
            child:   Container(width: 15,height: 15,color: _seats1[114])
        ),
        Positioned(
            top: 475,
            right: 211,
            child:   Container(width: 15,height: 15,color: _seats1[115])
        ),
        Positioned(
            top: 495,
            right: 211,
            child:   Container(width: 15,height: 15,color: _seats1[116])
        ),
        Positioned(
            top: 515,
            right: 211,
            child:   Container(width: 15,height: 15,color: _seats1[117])
        ),
        Positioned(
            top: 535,
            right: 211,
            child:   Container(width: 15,height: 15,color: _seats1[118])
        ),
        Positioned(
            top: 415,
            right: 189,
            child:   Container(width: 15,height: 15,color: _seats1[119])
        ),
        Positioned(
            top: 435,
            right: 189,
            child:   Container(width: 15,height: 15,color: _seats1[120])
        ),
        Positioned(
            top: 455,
            right: 189,
            child:   Container(width: 15,height: 15,color: _seats1[121])
        ),
        Positioned(
            top: 475,
            right: 189,
            child:   Container(width: 15,height: 15,color: _seats1[122])
        ),
        Positioned(
            top: 495,
            right: 189,
            child:   Container(width: 15,height: 15,color: _seats1[123])
        ),
        Positioned(
            top: 515,
            right: 189,
            child:   Container(width: 15,height: 15,color: _seats1[124])
        ),
        Positioned(
            top: 535,
            right: 189,
            child:   Container(width: 15,height: 15,color: _seats1[125])
        ),
        Positioned(
            top: 415,
            right: 167,
            child:   Container(width: 15,height: 15,color: _seats1[126])
        ),
        Positioned(
            top: 435,
            right: 167,
            child:   Container(width: 15,height: 15,color: _seats1[127])
        ),
        Positioned(
            top: 455,
            right: 167,
            child:   Container(width: 15,height: 15,color: _seats1[128])
        ),
        Positioned(
            top: 475,
            right: 167,
            child:   Container(width: 15,height: 15,color: _seats1[129])
        ),
        Positioned(
            top: 495,
            right: 167,
            child:   Container(width: 15,height: 15,color: _seats1[130])
        ),
        Positioned(
            top: 515,
            right: 167,
            child:   Container(width: 15,height: 15,color: _seats1[131])
        ),
        Positioned(
            top: 535,
            right: 167,
            child:   Container(width: 15,height: 15,color: _seats1[132])
        ),
        Positioned(
            top: 415,
            right: 145,
            child:   Container(width: 15,height: 15,color: _seats1[133])
        ),
        Positioned(
            top: 435,
            right: 145,
            child:   Container(width: 15,height: 15,color: _seats1[134])
        ),
        Positioned(
            top: 455,
            right: 145,
            child:   Container(width: 15,height: 15,color: _seats1[135])
        ),
        Positioned(
            top: 475,
            right: 145,
            child:   Container(width: 15,height: 15,color: _seats1[136])
        ),
        Positioned(
            top: 495,
            right: 145,
            child:   Container(width: 15,height: 15,color: _seats1[137])
        ),
        Positioned(
            top: 515,
            right: 145,
            child:   Container(width: 15,height: 15,color: _seats1[138])
        ),
        Positioned(
            top: 535,
            right: 145,
            child:   Container(width: 15,height: 15,color: _seats1[139])
        ),


        Positioned(
          bottom: 30,
          left: 320,
          child: Text(_counter2.toString(), style: TextStyle(fontSize: 30, color: Colors.white)),
        ),
        Positioned(
            top: 416,
            left: 567,
            child:   Container(width: 15,height: 15,color: _seats2[0])
        ),
        Positioned(
            top: 436,
            left: 567,
            child:   Container(width: 15,height: 15,color: _seats2[1])
        ),
        Positioned(
            top: 456,
            left: 567,
            child:   Container(width: 15,height: 15,color: _seats2[2])
        ),
        Positioned(
            top: 476,
            left: 567,
            child:   Container(width: 15,height: 15,color: _seats2[3])
        ),
        Positioned(
            top: 496,
            left: 567,
            child:   Container(width: 15,height: 15,color: _seats2[4])
        ),
        Positioned(
            top: 516,
            left: 567,
            child:   Container(width: 15,height: 15,color: _seats2[5])
        ),
        Positioned(
            top: 537,
            left: 567,
            child:   Container(width: 15,height: 15,color: _seats2[6])
        ),
        Positioned(
            top: 416,
            left: 545,
            child:   Container(width: 15,height: 15,color: _seats2[7])
        ),
        Positioned(
            top: 436,
            left: 545,
            child:   Container(width: 15,height: 15,color: _seats2[8])
        ),
        Positioned(
            top: 456,
            left: 545,
            child:   Container(width: 15,height: 15,color: _seats2[9])
        ),
        Positioned(
            top: 476,
            left: 545,
            child:   Container(width: 15,height: 15,color: _seats2[10])
        ),
        Positioned(
            top: 496,
            left: 545,
            child:   Container(width: 15,height: 15,color: _seats2[11])
        ),
        Positioned(
            top: 516,
            left: 545,
            child:   Container(width: 15,height: 15,color: _seats2[12])
        ),
        Positioned(
            top: 537,
            left: 545,
            child:   Container(width: 15,height: 15,color: _seats2[13])
        ),
        Positioned(
            top: 416,
            left: 523,
            child:   Container(width: 15,height: 15,color: _seats2[14])
        ),
        Positioned(
            top: 436,
            left: 523,
            child:   Container(width: 15,height: 15,color: _seats2[15])
        ),
        Positioned(
            top: 456,
            left: 523,
            child:   Container(width: 15,height: 15,color: _seats2[16])
        ),
        Positioned(
            top: 476,
            left: 523,
            child:   Container(width: 15,height: 15,color: _seats2[17])
        ),
        Positioned(
            top: 496,
            left: 523,
            child:   Container(width: 15,height: 15,color: _seats2[18])
        ),
        Positioned(
            top: 516,
            left: 523,
            child:   Container(width: 15,height: 15,color: _seats2[19])
        ),
        Positioned(
            top: 537,
            left: 523,
            child:   Container(width: 15,height: 15,color: _seats2[20])
        ),
        Positioned(
            top: 416,
            left: 501,
            child:   Container(width: 15,height: 15,color: _seats2[21])
        ),
        Positioned(
            top: 436,
            left: 501,
            child:   Container(width: 15,height: 15,color: _seats2[22])
        ),
        Positioned(
            top: 456,
            left: 501,
            child:   Container(width: 15,height: 15,color: _seats2[23])
        ),
        Positioned(
            top: 476,
            left: 501,
            child:   Container(width: 15,height: 15,color: _seats2[24])
        ),
        Positioned(
            top: 496,
            left: 501,
            child:   Container(width: 15,height: 15,color: _seats2[25])
        ),
        Positioned(
            top: 516,
            left: 501,
            child:   Container(width: 15,height: 15,color: _seats2[26])
        ),
        Positioned(
            top: 537,
            left: 501,
            child:   Container(width: 15,height: 15,color: _seats2[27])
        ),
        Positioned(
            top: 416,
            left: 479,
            child:   Container(width: 15,height: 15,color: _seats2[28])
        ),
        Positioned(
            top: 436,
            left: 479,
            child:   Container(width: 15,height: 15,color: _seats2[29])
        ),
        Positioned(
            top: 456,
            left: 479,
            child:   Container(width: 15,height: 15,color: _seats2[30])
        ),
        Positioned(
            top: 476,
            left: 479,
            child:   Container(width: 15,height: 15,color: _seats2[31])
        ),
        Positioned(
            top: 496,
            left: 479,
            child:   Container(width: 15,height: 15,color: _seats2[32])
        ),
        Positioned(
            top: 516,
            left: 479,
            child:   Container(width: 15,height: 15,color: _seats2[33])
        ),
        Positioned(
            top: 537,
            left: 479,
            child:   Container(width: 15,height: 15,color: _seats2[34])
        ),
        Positioned(
            top: 416,
            left: 457,
            child:   Container(width: 15,height: 15,color: _seats2[35])
        ),
        Positioned(
            top: 436,
            left: 457,
            child:   Container(width: 15,height: 15,color: _seats2[36])
        ),
        Positioned(
            top: 456,
            left: 457,
            child:   Container(width: 15,height: 15,color: _seats2[37])
        ),
        Positioned(
            top: 476,
            left: 457,
            child:   Container(width: 15,height: 15,color: _seats2[38])
        ),
        Positioned(
            top: 496,
            left: 457,
            child:   Container(width: 15,height: 15,color: _seats2[39])
        ),
        Positioned(
            top: 516,
            left: 457,
            child:   Container(width: 15,height: 15,color: _seats2[40])
        ),
        Positioned(
            top: 536,
            left: 457,
            child:   Container(width: 15,height: 15,color: _seats2[41])
        ),
        Positioned(
            top: 416,
            left: 434,
            child:   Container(width: 15,height: 15,color: _seats2[42])
        ),
        Positioned(
            top: 436,
            left: 434,
            child:   Container(width: 15,height: 15,color: _seats2[43])
        ),
        Positioned(
            top: 456,
            left: 434,
            child:   Container(width: 15,height: 15,color: _seats2[44])
        ),
        Positioned(
            top: 476,
            left: 434,
            child:   Container(width: 15,height: 15,color: _seats2[45])
        ),
        Positioned(
            top: 496,
            left: 434,
            child:   Container(width: 15,height: 15,color: _seats2[46])
        ),
        Positioned(
            top: 516,
            left: 434,
            child:   Container(width: 15,height: 15,color: _seats2[47])
        ),
        Positioned(
            top: 536,
            left: 434,
            child:   Container(width: 15,height: 15,color: _seats2[48])
        ),
        Positioned(
            top: 416,
            left: 412,
            child:   Container(width: 15,height: 15,color: _seats2[49])
        ),
        Positioned(
            top: 436,
            left: 412,
            child:   Container(width: 15,height: 15,color: _seats2[50])
        ),
        Positioned(
            top: 456,
            left: 412,
            child:   Container(width: 15,height: 15,color: _seats2[51])
        ),
        Positioned(
            top: 476,
            left: 412,
            child:   Container(width: 15,height: 15,color: _seats2[52])
        ),
        Positioned(
            top: 496,
            left: 412,
            child:   Container(width: 15,height: 15,color: _seats2[53])
        ),
        Positioned(
            top: 516,
            left: 412,
            child:   Container(width: 15,height: 15,color: _seats2[54])
        ),
        Positioned(
            top: 536,
            left: 412,
            child:   Container(width: 15,height: 15,color: _seats2[55])
        ),
        Positioned(
            top: 416,
            left: 391,
            child:   Container(width: 15,height: 15,color: _seats2[56])
        ),
        Positioned(
            top: 436,
            left: 391,
            child:   Container(width: 15,height: 15,color: _seats2[57])
        ),
        Positioned(
            top: 456,
            left: 391,
            child:   Container(width: 15,height: 15,color: _seats2[58])
        ),
        Positioned(
            top: 476,
            left: 391,
            child:   Container(width: 15,height: 15,color: _seats2[59])
        ),
        Positioned(
            top: 496,
            left: 391,
            child:   Container(width: 15,height: 15,color: _seats2[60])
        ),
        Positioned(
            top: 516,
            left: 391,
            child:   Container(width: 15,height: 15,color: _seats2[61])
        ),
        Positioned(
            top: 536,
            left: 391,
            child:   Container(width: 15,height: 15,color: _seats2[62])
        ),
        Positioned(
            top: 416,
            left: 369,
            child:   Container(width: 15,height: 15,color: _seats2[63])
        ),
        Positioned(
            top: 436,
            left: 369,
            child:   Container(width: 15,height: 15,color: _seats2[64])
        ),
        Positioned(
            top: 456,
            left: 369,
            child:   Container(width: 15,height: 15,color: _seats2[65])
        ),
        Positioned(
            top: 476,
            left: 369,
            child:   Container(width: 15,height: 15,color: _seats2[66])
        ),
        Positioned(
            top: 496,
            left: 369,
            child:   Container(width: 15,height: 15,color: _seats2[67])
        ),
        Positioned(
            top: 516,
            left: 369,
            child:   Container(width: 15,height: 15,color: _seats2[68])
        ),
        Positioned(
            top: 536,
            left: 369,
            child:   Container(width: 15,height: 15,color: _seats2[69])
        ),
        Positioned(
            top: 416,
            left: 347,
            child:   Container(width: 15,height: 15,color: _seats2[70])
        ),
        Positioned(
            top: 436,
            left: 347,
            child:   Container(width: 15,height: 15,color: _seats2[71])
        ),
        Positioned(
            top: 456,
            left: 347,
            child:   Container(width: 15,height: 15,color: _seats2[72])
        ),
        Positioned(
            top: 476,
            left: 347,
            child:   Container(width: 15,height: 15,color: _seats2[73])
        ),
        Positioned(
            top: 496,
            left: 347,
            child:   Container(width: 15,height: 15,color: _seats2[74])
        ),
        Positioned(
            top: 516,
            left: 347,
            child:   Container(width: 15,height: 15,color: _seats2[75])
        ),
        Positioned(
            top: 536,
            left: 347,
            child:   Container(width: 15,height: 15,color: _seats2[76])
        ),
        Positioned(
            top: 416,
            left: 325,
            child:   Container(width: 15,height: 15,color: _seats2[77])
        ),
        Positioned(
            top: 436,
            left: 325,
            child:   Container(width: 15,height: 15,color: _seats2[78])
        ),
        Positioned(
            top: 456,
            left: 325,
            child:   Container(width: 15,height: 15,color: _seats2[79])
        ),
        Positioned(
            top: 476,
            left: 325,
            child:   Container(width: 15,height: 15,color: _seats2[80])
        ),
        Positioned(
            top: 496,
            left: 325,
            child:   Container(width: 15,height: 15,color: _seats2[81])
        ),
        Positioned(
            top: 516,
            left: 325,
            child:   Container(width: 15,height: 15,color: _seats2[82])
        ),
        Positioned(
            top: 536,
            left: 325,
            child:   Container(width: 15,height: 15,color: _seats2[83])
        ),
        Positioned(
            top: 416,
            left: 303,
            child:   Container(width: 15,height: 15,color: _seats2[84])
        ),
        Positioned(
            top: 436,
            left: 303,
            child:   Container(width: 15,height: 15,color: _seats2[85])
        ),
        Positioned(
            top: 456,
            left: 303,
            child:   Container(width: 15,height: 15,color: _seats2[86])
        ),
        Positioned(
            top: 476,
            left: 303,
            child:   Container(width: 15,height: 15,color: _seats2[87])
        ),
        Positioned(
            top: 496,
            left: 303,
            child:   Container(width: 15,height: 15,color: _seats2[88])
        ),
        Positioned(
            top: 516,
            left: 303,
            child:   Container(width: 15,height: 15,color: _seats2[89])
        ),
        Positioned(
            top: 536,
            left: 303,
            child:   Container(width: 15,height: 15,color: _seats2[90])
        ),
        Positioned(
            top: 416,
            left: 281,
            child:   Container(width: 15,height: 15,color: _seats2[91])
        ),
        Positioned(
            top: 436,
            left: 281,
            child:   Container(width: 15,height: 15,color: _seats2[92])
        ),
        Positioned(
            top: 456,
            left: 281,
            child:   Container(width: 15,height: 15,color: _seats2[93])
        ),
        Positioned(
            top: 476,
            left: 281,
            child:   Container(width: 15,height: 15,color: _seats2[94])
        ),
        Positioned(
            top: 496,
            left: 281,
            child:   Container(width: 15,height: 15,color: _seats2[95])
        ),
        Positioned(
            top: 516,
            left: 281,
            child:   Container(width: 15,height: 15,color: _seats2[96])
        ),
        Positioned(
            top: 536,
            left: 281,
            child:   Container(width: 15,height: 15,color: _seats2[97])
        ),
        Positioned(
            top: 416,
            left: 258,
            child:   Container(width: 15,height: 15,color: _seats2[98])
        ),
        Positioned(
            top: 436,
            left: 258,
            child:   Container(width: 15,height: 15,color: _seats2[99])
        ),
        Positioned(
            top: 456,
            left: 258,
            child:   Container(width: 15,height: 15,color: _seats2[100])
        ),
        Positioned(
            top: 476,
            left: 258,
            child:   Container(width: 15,height: 15,color: _seats2[101])
        ),
        Positioned(
            top: 496,
            left: 258,
            child:   Container(width: 15,height: 15,color: _seats2[102])
        ),
        Positioned(
            top: 516,
            left: 258,
            child:   Container(width: 15,height: 15,color: _seats2[103])
        ),
        Positioned(
            top: 536,
            left: 258,
            child:   Container(width: 15,height: 15,color: _seats2[104])
        ),
        Positioned(
            top: 416,
            left: 236,
            child:   Container(width: 15,height: 15,color: _seats2[105])
        ),
        Positioned(
            top: 436,
            left: 236,
            child:   Container(width: 15,height: 15,color: _seats2[106])
        ),
        Positioned(
            top: 456,
            left: 236,
            child:   Container(width: 15,height: 15,color: _seats2[107])
        ),
        Positioned(
            top: 476,
            left: 236,
            child:   Container(width: 15,height: 15,color: _seats2[108])
        ),
        Positioned(
            top: 496,
            left: 236,
            child:   Container(width: 15,height: 15,color: _seats2[109])
        ),
        Positioned(
            top: 516,
            left: 236,
            child:   Container(width: 15,height: 15,color: _seats2[110])
        ),
        Positioned(
            top: 536,
            left: 236,
            child:   Container(width: 15,height: 15,color: _seats2[111])
        ),
        Positioned(
            top: 416,
            left: 214,
            child:   Container(width: 15,height: 15,color: _seats2[112])
        ),
        Positioned(
            top: 436,
            left: 214,
            child:   Container(width: 15,height: 15,color: _seats2[113])
        ),
        Positioned(
            top: 456,
            left: 214,
            child:   Container(width: 15,height: 15,color: _seats2[114])
        ),
        Positioned(
            top: 476,
            left: 214,
            child:   Container(width: 15,height: 15,color: _seats2[115])
        ),
        Positioned(
            top: 496,
            left: 214,
            child:   Container(width: 15,height: 15,color: _seats2[116])
        ),
        Positioned(
            top: 516,
            left: 214,
            child:   Container(width: 15,height: 15,color: _seats2[117])
        ),
        Positioned(
            top: 536,
            left: 214,
            child:   Container(width: 15,height: 15,color: _seats2[118])
        ),
        Positioned(
            top: 416,
            left: 193,
            child:   Container(width: 15,height: 15,color: _seats2[119])
        ),
        Positioned(
            top: 436,
            left: 193,
            child:   Container(width: 15,height: 15,color: _seats2[120])
        ),
        Positioned(
            top: 456,
            left: 193,
            child:   Container(width: 15,height: 15,color: _seats2[121])
        ),
        Positioned(
            top: 476,
            left: 193,
            child:   Container(width: 15,height: 15,color: _seats2[122])
        ),
        Positioned(
            top: 496,
            left: 193,
            child:   Container(width: 15,height: 15,color: _seats2[123])
        ),
        Positioned(
            top: 516,
            left: 193,
            child:   Container(width: 15,height: 15,color: _seats2[124])
        ),
        Positioned(
            top: 536,
            left: 193,
            child:   Container(width: 15,height: 15,color: _seats2[125])
        ),
        Positioned(
            top: 416,
            left: 171,
            child:   Container(width: 15,height: 15,color: _seats2[126])
        ),
        Positioned(
            top: 436,
            left: 171,
            child:   Container(width: 15,height: 15,color: _seats2[127])
        ),
        Positioned(
            top: 456,
            left: 171,
            child:   Container(width: 15,height: 15,color: _seats2[128])
        ),
        Positioned(
            top: 476,
            left: 171,
            child:   Container(width: 15,height: 15,color: _seats2[129])
        ),
        Positioned(
            top: 496,
            left: 171,
            child:   Container(width: 15,height: 15,color: _seats2[130])
        ),
        Positioned(
            top: 516,
            left: 171,
            child:   Container(width: 15,height: 15,color: _seats2[131])
        ),
        Positioned(
            top: 536,
            left: 171,
            child:   Container(width: 15,height: 15,color: _seats2[132])
        ),
        Positioned(
            top: 416,
            left: 148,
            child:   Container(width: 15,height: 15,color: _seats2[133])
        ),
        Positioned(
            top: 436,
            left: 148,
            child:   Container(width: 15,height: 15,color: _seats2[134])
        ),
        Positioned(
            top: 456,
            left: 148,
            child:   Container(width: 15,height: 15,color: _seats2[135])
        ),
        Positioned(
            top: 476,
            left: 148,
            child:   Container(width: 15,height: 15,color: _seats2[136])
        ),
        Positioned(
            top: 496,
            left: 148,
            child:   Container(width: 15,height: 15,color: _seats2[137])
        ),
        Positioned(
            top: 516,
            left: 148,
            child:   Container(width: 15,height: 15,color: _seats2[138])
        ),
        Positioned(
            top: 536,
            left: 148,
            child:   Container(width: 15,height: 15,color: _seats2[139])
        ),
      ],
    )
    );
  }
}

class ScreenB extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
                body: Center(
                    child: Text(snapshot.error.toString(),
                        textDirection: TextDirection.ltr))),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          log("Firebase is connected yay!");
          return Screen2();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take A Seat',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage2(title: 'TAKE A SEAT'),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<MyHomePage2> {
  int _counter1 = 140;
  int _counter2 = 140;
  List<Color> _seats1 = List.filled(140, Colors.lightGreenAccent);
  List<Color> _seats2 = List.filled(140, Colors.lightGreenAccent);

  List<int> train1 = List.filled(140, 0);
  List<int> train2 = List.filled(140, 0);

  @override
  void initState() {
    super.initState();

    // defines a timer
    Timer _everySecond = Timer.periodic(Duration(seconds: 3), (Timer t) async {
      FirebaseDatabase database = FirebaseDatabase.instance;
      DatabaseReference ref = database.ref("train2");
      final event = await ref.once(DatabaseEventType.value);
      if (event.snapshot.exists) {
        //log(event.snapshot.value.toString());
        Map data = event.snapshot.value as Map;

        for (var i=0 ; i<140 ; i++){
          train1[i] = data['chair_$i'];
        }
      }

      DatabaseReference ref2 = database.ref("train3");
      final event2 = await ref2.once(DatabaseEventType.value);
      if (event2.snapshot.exists) {
        //log(event.snapshot.value.toString());
        Map data = event2.snapshot.value as Map;

        for (var i=0 ; i<140 ; i++){
          train2[i] = data['chair_$i'];
        }
      }

      setState(() {
        _counter1 = 140;
        _counter2 = 140;
        int i = 0;

        for (int seat in train1) {
          _counter1 -= seat;

          if (train1[i] == 0){
            _seats1[i] = Colors.lightGreenAccent;
          }
          else{
            _seats1[i] = Colors.redAccent;
          }

          i++;
        }

        i = 0;
        for (int seat in train2) {
          _counter2 -= seat;

          if (train2[i] == 0){
            _seats2[i] = Colors.lightGreenAccent;
          }
          else{
            _seats2[i] = Colors.redAccent;
          }

          i++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body:
        Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/screenB.jpg"), fit: BoxFit.cover)),
            ),
            Positioned(
              bottom: 10,
              right: 300,
              child: Text(_counter1.toString(), style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            Positioned(
                top: 332,
                right: 469,
                child:   Container(width: 13,height: 13,color: _seats1[0])
            ),
            Positioned(
                top: 349,
                right: 469,
                child:   Container(width: 13,height: 13,color: _seats1[1])
            ),
            Positioned(
                top: 366,
                right: 469,
                child:   Container(width: 13,height: 13,color: _seats1[2])
            ),
            Positioned(
                top: 383,
                right: 469,
                child:   Container(width: 13,height: 13,color: _seats1[3])
            ),
            Positioned(
                top: 400,
                right: 469,
                child:   Container(width: 13,height: 13,color: _seats1[4])
            ),
            Positioned(
                top: 417,
                right: 469,
                child:   Container(width: 13,height: 13,color: _seats1[5])
            ),
            Positioned(
                top: 434,
                right: 469,
                child:   Container(width: 13,height: 13,color: _seats1[6])
            ),
            Positioned(
                top: 332,
                right: 451,
                child:   Container(width: 13,height: 13,color: _seats1[7])
            ),
            Positioned(
                top: 349,
                right: 451,
                child:   Container(width: 13,height: 13,color: _seats1[8])
            ),
            Positioned(
                top: 366,
                right: 451,
                child:   Container(width: 13,height: 13,color: _seats1[9])
            ),
            Positioned(
                top: 383,
                right: 451,
                child:   Container(width: 13,height: 13,color: _seats1[10])
            ),
            Positioned(
                top: 400,
                right: 451,
                child:   Container(width: 13,height: 13,color: _seats1[11])
            ),
            Positioned(
                top: 417,
                right: 451,
                child:   Container(width: 13,height: 13,color: _seats1[12])
            ),
            Positioned(
                top: 434,
                right: 451,
                child:   Container(width: 13,height: 13,color: _seats1[13])
            ),
            Positioned(
                top: 332,
                right: 433,
                child:   Container(width: 13,height: 13,color: _seats1[14])
            ),
            Positioned(
                top: 349,
                right: 433,
                child:   Container(width: 13,height: 13,color: _seats1[15])
            ),
            Positioned(
                top: 366,
                right: 433,
                child:   Container(width: 13,height: 13,color: _seats1[16])
            ),
            Positioned(
                top: 383,
                right: 433,
                child:   Container(width: 13,height: 13,color: _seats1[17])
            ),
            Positioned(
                top: 400,
                right: 433,
                child:   Container(width: 13,height: 13,color: _seats1[18])
            ),
            Positioned(
                top: 417,
                right: 433,
                child:   Container(width: 13,height: 13,color: _seats1[19])
            ),
            Positioned(
                top: 434,
                right: 433,
                child:   Container(width: 13,height: 13,color: _seats1[20])
            ),
            Positioned(
                top: 332,
                right: 415,
                child:   Container(width: 13,height: 13,color: _seats1[21])
            ),
            Positioned(
                top: 349,
                right: 415,
                child:   Container(width: 13,height: 13,color: _seats1[22])
            ),
            Positioned(
                top: 366,
                right: 415,
                child:   Container(width: 13,height: 13,color: _seats1[23])
            ),
            Positioned(
                top: 383,
                right: 415,
                child:   Container(width: 13,height: 13,color: _seats1[24])
            ),
            Positioned(
                top: 400,
                right: 415,
                child:   Container(width: 13,height: 13,color: _seats1[25])
            ),
            Positioned(
                top: 417,
                right: 415,
                child:   Container(width: 13,height: 13,color: _seats1[26])
            ),
            Positioned(
                top: 434,
                right: 415,
                child:   Container(width: 13,height: 13,color: _seats1[27])
            ),
            Positioned(
                top: 332,
                right: 397,
                child:   Container(width: 13,height: 13,color: _seats1[28])
            ),
            Positioned(
                top: 349,
                right: 397,
                child:   Container(width: 13,height: 13,color: _seats1[29])
            ),
            Positioned(
                top: 366,
                right: 397,
                child:   Container(width: 13,height: 13,color: _seats1[30])
            ),
            Positioned(
                top: 383,
                right: 397,
                child:   Container(width: 13,height: 13,color: _seats1[31])
            ),
            Positioned(
                top: 400,
                right: 397,
                child:   Container(width: 13,height: 13,color: _seats1[32])
            ),
            Positioned(
                top: 417,
                right: 397,
                child:   Container(width: 13,height: 13,color: _seats1[33])
            ),
            Positioned(
                top: 434,
                right: 397,
                child:   Container(width: 13,height: 13,color: _seats1[34])
            ),
            Positioned(
                top: 332,
                right: 378,
                child:   Container(width: 13,height: 13,color: _seats1[35])
            ),
            Positioned(
                top: 349,
                right: 378,
                child:   Container(width: 13,height: 13,color: _seats1[36])
            ),
            Positioned(
                top: 366,
                right: 378,
                child:   Container(width: 13,height: 13,color: _seats1[37])
            ),
            Positioned(
                top: 383,
                right: 378,
                child:   Container(width: 13,height: 13,color: _seats1[38])
            ),
            Positioned(
                top: 400,
                right: 378,
                child:   Container(width: 13,height: 13,color: _seats1[39])
            ),
            Positioned(
                top: 417,
                right: 378,
                child:   Container(width: 13,height: 13,color: _seats1[40])
            ),
            Positioned(
                top: 434,
                right: 378,
                child:   Container(width: 13,height: 13,color: _seats1[41])
            ),
            Positioned(
                top: 332,
                right: 358,
                child:   Container(width: 13,height: 13,color: _seats1[42])
            ),
            Positioned(
                top: 349,
                right: 358,
                child:   Container(width: 13,height: 13,color: _seats1[43])
            ),
            Positioned(
                top: 366,
                right: 358,
                child:   Container(width: 13,height: 13,color: _seats1[44])
            ),
            Positioned(
                top: 383,
                right: 358,
                child:   Container(width: 13,height: 13,color: _seats1[45])
            ),
            Positioned(
                top: 400,
                right: 358,
                child:   Container(width: 13,height: 13,color: _seats1[46])
            ),
            Positioned(
                top: 417,
                right: 358,
                child:   Container(width: 13,height: 13,color: _seats1[47])
            ),
            Positioned(
                top: 434,
                right: 358,
                child:   Container(width: 13,height: 13,color: _seats1[48])
            ),
            Positioned(
                top: 332,
                right: 340,
                child:   Container(width: 13,height: 13,color: _seats1[49])
            ),
            Positioned(
                top: 349,
                right: 340,
                child:   Container(width: 13,height: 13,color: _seats1[50])
            ),
            Positioned(
                top: 366,
                right: 340,
                child:   Container(width: 13,height: 13,color: _seats1[51])
            ),
            Positioned(
                top: 383,
                right: 340,
                child:   Container(width: 13,height: 13,color: _seats1[52])
            ),
            Positioned(
                top: 400,
                right: 340,
                child:   Container(width: 13,height: 13,color: _seats1[53])
            ),
            Positioned(
                top: 417,
                right: 340,
                child:   Container(width: 13,height: 13,color: _seats1[54])
            ),
            Positioned(
                top: 434,
                right: 340,
                child:   Container(width: 13,height: 13,color: _seats1[55])
            ),
            Positioned(
                top: 332,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[56])
            ),
            Positioned(
                top: 349,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[57])
            ),
            Positioned(
                top: 366,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[58])
            ),
            Positioned(
                top: 383,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[59])
            ),
            Positioned(
                top: 400,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[60])
            ),
            Positioned(
                top: 417,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[61])
            ),
            Positioned(
                top: 434,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[62])
            ),
            Positioned(
                top: 332,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[63])
            ),
            Positioned(
                top: 349,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[64])
            ),
            Positioned(
                top: 366,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[65])
            ),
            Positioned(
                top: 383,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[66])
            ),
            Positioned(
                top: 400,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[67])
            ),
            Positioned(
                top: 417,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[68])
            ),
            Positioned(
                top: 434,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[69])
            ),
            Positioned(
                top: 332,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[56])
            ),
            Positioned(
                top: 349,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[57])
            ),
            Positioned(
                top: 366,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[58])
            ),
            Positioned(
                top: 383,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[59])
            ),
            Positioned(
                top: 400,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[60])
            ),
            Positioned(
                top: 417,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[61])
            ),
            Positioned(
                top: 434,
                right: 322,
                child:   Container(width: 13,height: 13,color: _seats1[62])
            ),
            Positioned(
                top: 332,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[63])
            ),
            Positioned(
                top: 349,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[64])
            ),
            Positioned(
                top: 366,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[65])
            ),
            Positioned(
                top: 383,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[66])
            ),
            Positioned(
                top: 400,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[67])
            ),
            Positioned(
                top: 417,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[68])
            ),
            Positioned(
                top: 434,
                right: 304,
                child:   Container(width: 13,height: 13,color: _seats1[69])
            ),
            Positioned(
                top: 332,
                right: 286,
                child:   Container(width: 13,height: 13,color: _seats1[70])
            ),
            Positioned(
                top: 349,
                right: 286,
                child:   Container(width: 13,height: 13,color: _seats1[71])
            ),
            Positioned(
                top: 366,
                right: 286,
                child:   Container(width: 13,height: 13,color: _seats1[72])
            ),
            Positioned(
                top: 383,
                right: 286,
                child:   Container(width: 13,height: 13,color: _seats1[73])
            ),
            Positioned(
                top: 400,
                right: 286,
                child:   Container(width: 13,height: 13,color: _seats1[74])
            ),
            Positioned(
                top: 417,
                right: 286,
                child:   Container(width: 13,height: 13,color: _seats1[75])
            ),
            Positioned(
                top: 434,
                right: 286,
                child:   Container(width: 13,height: 13,color: _seats1[76])
            ),
            Positioned(
                top: 332,
                right: 267,
                child:   Container(width: 13,height: 13,color: _seats1[77])
            ),
            Positioned(
                top: 349,
                right: 267,
                child:   Container(width: 13,height: 13,color: _seats1[78])
            ),
            Positioned(
                top: 366,
                right: 267,
                child:   Container(width: 13,height: 13,color: _seats1[79])
            ),
            Positioned(
                top: 383,
                right: 267,
                child:   Container(width: 13,height: 13,color: _seats1[80])
            ),
            Positioned(
                top: 400,
                right: 267,
                child:   Container(width: 13,height: 13,color: _seats1[81])
            ),
            Positioned(
                top: 417,
                right: 267,
                child:   Container(width: 13,height: 13,color: _seats1[82])
            ),
            Positioned(
                top: 434,
                right: 267,
                child:   Container(width: 13,height: 13,color: _seats1[83])
            ),
            Positioned(
                top: 332,
                right: 248,
                child:   Container(width: 13,height: 13,color: _seats1[84])
            ),
            Positioned(
                top: 349,
                right: 248,
                child:   Container(width: 13,height: 13,color: _seats1[85])
            ),
            Positioned(
                top: 366,
                right: 248,
                child:   Container(width: 13,height: 13,color: _seats1[86])
            ),
            Positioned(
                top: 383,
                right: 248,
                child:   Container(width: 13,height: 13,color: _seats1[87])
            ),
            Positioned(
                top: 400,
                right: 248,
                child:   Container(width: 13,height: 13,color: _seats1[88])
            ),
            Positioned(
                top: 417,
                right: 248,
                child:   Container(width: 13,height: 13,color: _seats1[89])
            ),
            Positioned(
                top: 434,
                right: 248,
                child:   Container(width: 13,height: 13,color: _seats1[90])
            ),
            Positioned(
                top: 332,
                right: 230,
                child:   Container(width: 13,height: 13,color: _seats1[91])
            ),
            Positioned(
                top: 349,
                right: 230,
                child:   Container(width: 13,height: 13,color: _seats1[92])
            ),
            Positioned(
                top: 366,
                right: 230,
                child:   Container(width: 13,height: 13,color: _seats1[93])
            ),
            Positioned(
                top: 383,
                right: 230,
                child:   Container(width: 13,height: 13,color: _seats1[94])
            ),
            Positioned(
                top: 400,
                right: 230,
                child:   Container(width: 13,height: 13,color: _seats1[95])
            ),
            Positioned(
                top: 417,
                right: 230,
                child:   Container(width: 13,height: 13,color: _seats1[96])
            ),
            Positioned(
                top: 434,
                right: 230,
                child:   Container(width: 13,height: 13,color: _seats1[97])
            ),
            Positioned(
                top: 332,
                right: 212,
                child:   Container(width: 13,height: 13,color: _seats1[98])
            ),
            Positioned(
                top: 349,
                right: 212,
                child:   Container(width: 13,height: 13,color: _seats1[99])
            ),
            Positioned(
                top: 366,
                right: 212,
                child:   Container(width: 13,height: 13,color: _seats1[100])
            ),
            Positioned(
                top: 383,
                right: 212,
                child:   Container(width: 13,height: 13,color: _seats1[101])
            ),
            Positioned(
                top: 400,
                right: 212,
                child:   Container(width: 13,height: 13,color: _seats1[102])
            ),
            Positioned(
                top: 417,
                right: 212,
                child:   Container(width: 13,height: 13,color: _seats1[103])
            ),
            Positioned(
                top: 434,
                right: 212,
                child:   Container(width: 13,height: 13,color: _seats1[104])
            ),
            Positioned(
                top: 332,
                right: 194,
                child:   Container(width: 13,height: 13,color: _seats1[105])
            ),
            Positioned(
                top: 349,
                right: 194,
                child:   Container(width: 13,height: 13,color: _seats1[106])
            ),
            Positioned(
                top: 366,
                right: 194,
                child:   Container(width: 13,height: 13,color: _seats1[107])
            ),
            Positioned(
                top: 383,
                right: 194,
                child:   Container(width: 13,height: 13,color: _seats1[108])
            ),
            Positioned(
                top: 400,
                right: 194,
                child:   Container(width: 13,height: 13,color: _seats1[109])
            ),
            Positioned(
                top: 417,
                right: 194,
                child:   Container(width: 13,height: 13,color: _seats1[110])
            ),
            Positioned(
                top: 434,
                right: 194,
                child:   Container(width: 13,height: 13,color: _seats1[111])
            ),
            Positioned(
                top: 332,
                right: 176,
                child:   Container(width: 13,height: 13,color: _seats1[112])
            ),
            Positioned(
                top: 349,
                right: 176,
                child:   Container(width: 13,height: 13,color: _seats1[113])
            ),
            Positioned(
                top: 366,
                right: 176,
                child:   Container(width: 13,height: 13,color: _seats1[114])
            ),
            Positioned(
                top: 383,
                right: 176,
                child:   Container(width: 13,height: 13,color: _seats1[115])
            ),
            Positioned(
                top: 400,
                right: 176,
                child:   Container(width: 13,height: 13,color: _seats1[116])
            ),
            Positioned(
                top: 417,
                right: 176,
                child:   Container(width: 13,height: 13,color: _seats1[117])
            ),
            Positioned(
                top: 434,
                right: 176,
                child:   Container(width: 13,height: 13,color: _seats1[118])
            ),
            Positioned(
                top: 332,
                right: 158,
                child:   Container(width: 13,height: 13,color: _seats1[119])
            ),
            Positioned(
                top: 349,
                right: 158,
                child:   Container(width: 13,height: 13,color: _seats1[120])
            ),
            Positioned(
                top: 366,
                right: 158,
                child:   Container(width: 13,height: 13,color: _seats1[121])
            ),
            Positioned(
                top: 383,
                right: 158,
                child:   Container(width: 13,height: 13,color: _seats1[122])
            ),
            Positioned(
                top: 400,
                right: 158,
                child:   Container(width: 13,height: 13,color: _seats1[123])
            ),
            Positioned(
                top: 417,
                right: 158,
                child:   Container(width: 13,height: 13,color: _seats1[124])
            ),
            Positioned(
                top: 434,
                right: 158,
                child:   Container(width: 13,height: 13,color: _seats1[125])
            ),
            Positioned(
                top: 332,
                right: 140,
                child:   Container(width: 13,height: 13,color: _seats1[126])
            ),
            Positioned(
                top: 349,
                right: 140,
                child:   Container(width: 13,height: 13,color: _seats1[127])
            ),
            Positioned(
                top: 366,
                right: 140,
                child:   Container(width: 13,height: 13,color: _seats1[128])
            ),
            Positioned(
                top: 383,
                right: 140,
                child:   Container(width: 13,height: 13,color: _seats1[129])
            ),
            Positioned(
                top: 400,
                right: 140,
                child:   Container(width: 13,height: 13,color: _seats1[130])
            ),
            Positioned(
                top: 417,
                right: 140,
                child:   Container(width: 13,height: 13,color: _seats1[131])
            ),
            Positioned(
                top: 434,
                right: 140,
                child:   Container(width: 13,height: 13,color: _seats1[132])
            ),
            Positioned(
                top: 332,
                right: 121,
                child:   Container(width: 13,height: 13,color: _seats1[133])
            ),
            Positioned(
                top: 349,
                right: 121,
                child:   Container(width: 13,height: 13,color: _seats1[134])
            ),
            Positioned(
                top: 366,
                right: 121,
                child:   Container(width: 13,height: 13,color: _seats1[135])
            ),
            Positioned(
                top: 383,
                right: 121,
                child:   Container(width: 13,height: 13,color: _seats1[136])
            ),
            Positioned(
                top: 400,
                right: 121,
                child:   Container(width: 13,height: 13,color: _seats1[137])
            ),
            Positioned(
                top: 417,
                right: 121,
                child:   Container(width: 13,height: 13,color: _seats1[138])
            ),
            Positioned(
                top: 434,
                right: 121,
                child:   Container(width: 13,height: 13,color: _seats1[139])
            ),


            Positioned(
              bottom: 10,
              left: 270,
              child: Text(_counter2.toString(), style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            Positioned(
                top: 333,
                left: 472,
                child:   Container(width: 13,height: 13,color: _seats2[0])
            ),
            Positioned(
                top: 350,
                left: 472,
                child:   Container(width: 13,height: 13,color: _seats2[1])
            ),
            Positioned(
                top: 367,
                left: 472,
                child:   Container(width: 13,height: 13,color: _seats2[2])
            ),
            Positioned(
                top: 383,
                left: 472,
                child:   Container(width: 13,height: 13,color: _seats2[3])
            ),
            Positioned(
                top: 400,
                left: 472,
                child:   Container(width: 13,height: 13,color: _seats2[4])
            ),
            Positioned(
                top: 417,
                left: 472,
                child:   Container(width: 13,height: 13,color: _seats2[5])
            ),
            Positioned(
                top: 434,
                left: 472,
                child:   Container(width: 13,height: 13,color: _seats2[6])
            ),
            Positioned(
                top: 333,
                left: 454,
                child:   Container(width: 13,height: 13,color: _seats2[7])
            ),
            Positioned(
                top: 350,
                left: 454,
                child:   Container(width: 13,height: 13,color: _seats2[8])
            ),
            Positioned(
                top: 367,
                left: 454,
                child:   Container(width: 13,height: 13,color: _seats2[9])
            ),
            Positioned(
                top: 383,
                left: 454,
                child:   Container(width: 13,height: 13,color: _seats2[10])
            ),
            Positioned(
                top: 400,
                left: 454,
                child:   Container(width: 13,height: 13,color: _seats2[11])
            ),
            Positioned(
                top: 417,
                left: 454,
                child:   Container(width: 13,height: 13,color: _seats2[12])
            ),
            Positioned(
                top: 434,
                left: 454,
                child:   Container(width: 13,height: 13,color: _seats2[13])
            ),
            Positioned(
                top: 333,
                left: 436,
                child:   Container(width: 13,height: 13,color: _seats2[14])
            ),
            Positioned(
                top: 350,
                left: 436,
                child:   Container(width: 13,height: 13,color: _seats2[15])
            ),
            Positioned(
                top: 367,
                left: 436,
                child:   Container(width: 13,height: 13,color: _seats2[16])
            ),
            Positioned(
                top: 383,
                left: 436,
                child:   Container(width: 13,height: 13,color: _seats2[17])
            ),
            Positioned(
                top: 400,
                left: 436,
                child:   Container(width: 13,height: 13,color: _seats2[18])
            ),
            Positioned(
                top: 417,
                left: 436,
                child:   Container(width: 13,height: 13,color: _seats2[19])
            ),
            Positioned(
                top: 434,
                left: 436,
                child:   Container(width: 13,height: 13,color: _seats2[20])
            ),
            Positioned(
                top: 333,
                left: 418,
                child:   Container(width: 13,height: 13,color: _seats2[21])
            ),
            Positioned(
                top: 350,
                left: 418,
                child:   Container(width: 13,height: 13,color: _seats2[22])
            ),
            Positioned(
                top: 367,
                left: 418,
                child:   Container(width: 13,height: 13,color: _seats2[23])
            ),
            Positioned(
                top: 383,
                left: 418,
                child:   Container(width: 13,height: 13,color: _seats2[24])
            ),
            Positioned(
                top: 400,
                left: 418,
                child:   Container(width: 13,height: 13,color: _seats2[25])
            ),
            Positioned(
                top: 417,
                left: 418,
                child:   Container(width: 13,height: 13,color: _seats2[26])
            ),
            Positioned(
                top: 434,
                left: 418,
                child:   Container(width: 13,height: 13,color: _seats2[27])
            ),
            Positioned(
                top: 333,
                left: 400,
                child:   Container(width: 13,height: 13,color: _seats2[28])
            ),
            Positioned(
                top: 350,
                left: 400,
                child:   Container(width: 13,height: 13,color: _seats2[29])
            ),
            Positioned(
                top: 367,
                left: 400,
                child:   Container(width: 13,height: 13,color: _seats2[30])
            ),
            Positioned(
                top: 383,
                left: 400,
                child:   Container(width: 13,height: 13,color: _seats2[31])
            ),
            Positioned(
                top: 400,
                left: 400,
                child:   Container(width: 13,height: 13,color: _seats2[32])
            ),
            Positioned(
                top: 417,
                left: 400,
                child:   Container(width: 13,height: 13,color: _seats2[33])
            ),
            Positioned(
                top: 434,
                left: 400,
                child:   Container(width: 13,height: 13,color: _seats2[34])
            ),
            Positioned(
                top: 333,
                left: 381,
                child:   Container(width: 13,height: 13,color: _seats2[35])
            ),
            Positioned(
                top: 350,
                left: 381,
                child:   Container(width: 13,height: 13,color: _seats2[36])
            ),
            Positioned(
                top: 367,
                left: 381,
                child:   Container(width: 13,height: 13,color: _seats2[37])
            ),
            Positioned(
                top: 383,
                left: 381,
                child:   Container(width: 13,height: 13,color: _seats2[38])
            ),
            Positioned(
                top: 400,
                left: 381,
                child:   Container(width: 13,height: 13,color: _seats2[39])
            ),
            Positioned(
                top: 417,
                left: 381,
                child:   Container(width: 13,height: 13,color: _seats2[40])
            ),
            Positioned(
                top: 434,
                left: 381,
                child:   Container(width: 13,height: 13,color: _seats2[41])
            ),
            Positioned(
                top: 333,
                left: 362,
                child:   Container(width: 13,height: 13,color: _seats2[42])
            ),
            Positioned(
                top: 350,
                left: 362,
                child:   Container(width: 13,height: 13,color: _seats2[43])
            ),
            Positioned(
                top: 367,
                left: 362,
                child:   Container(width: 13,height: 13,color: _seats2[44])
            ),
            Positioned(
                top: 383,
                left: 362,
                child:   Container(width: 13,height: 13,color: _seats2[45])
            ),
            Positioned(
                top: 400,
                left: 362,
                child:   Container(width: 13,height: 13,color: _seats2[46])
            ),
            Positioned(
                top: 417,
                left: 362,
                child:   Container(width: 13,height: 13,color: _seats2[47])
            ),
            Positioned(
                top: 434,
                left: 362,
                child:   Container(width: 13,height: 13,color: _seats2[48])
            ),
            Positioned(
                top: 333,
                left: 344,
                child:   Container(width: 13,height: 13,color: _seats2[49])
            ),
            Positioned(
                top: 350,
                left: 344,
                child:   Container(width: 13,height: 13,color: _seats2[50])
            ),
            Positioned(
                top: 367,
                left: 344,
                child:   Container(width: 13,height: 13,color: _seats2[51])
            ),
            Positioned(
                top: 383,
                left: 344,
                child:   Container(width: 13,height: 13,color: _seats2[52])
            ),
            Positioned(
                top: 400,
                left: 344,
                child:   Container(width: 13,height: 13,color: _seats2[53])
            ),
            Positioned(
                top: 417,
                left: 344,
                child:   Container(width: 13,height: 13,color: _seats2[54])
            ),
            Positioned(
                top: 434,
                left: 344,
                child:   Container(width: 13,height: 13,color: _seats2[55])
            ),
            Positioned(
                top: 333,
                left: 326,
                child:   Container(width: 13,height: 13,color: _seats2[56])
            ),
            Positioned(
                top: 350,
                left: 326,
                child:   Container(width: 13,height: 13,color: _seats2[57])
            ),
            Positioned(
                top: 367,
                left: 326,
                child:   Container(width: 13,height: 13,color: _seats2[58])
            ),
            Positioned(
                top: 383,
                left: 326,
                child:   Container(width: 13,height: 13,color: _seats2[59])
            ),
            Positioned(
                top: 400,
                left: 326,
                child:   Container(width: 13,height: 13,color: _seats2[60])
            ),
            Positioned(
                top: 417,
                left: 326,
                child:   Container(width: 13,height: 13,color: _seats2[61])
            ),
            Positioned(
                top: 434,
                left: 326,
                child:   Container(width: 13,height: 13,color: _seats2[62])
            ),
            Positioned(
                top: 333,
                left: 308,
                child:   Container(width: 13,height: 13,color: _seats2[63])
            ),
            Positioned(
                top: 350,
                left: 308,
                child:   Container(width: 13,height: 13,color: _seats2[64])
            ),
            Positioned(
                top: 367,
                left: 308,
                child:   Container(width: 13,height: 13,color: _seats2[65])
            ),
            Positioned(
                top: 383,
                left: 308,
                child:   Container(width: 13,height: 13,color: _seats2[66])
            ),
            Positioned(
                top: 400,
                left: 308,
                child:   Container(width: 13,height: 13,color: _seats2[67])
            ),
            Positioned(
                top: 417,
                left: 308,
                child:   Container(width: 13,height: 13,color: _seats2[68])
            ),
            Positioned(
                top: 434,
                left: 308,
                child:   Container(width: 13,height: 13,color: _seats2[69])
            ),
            Positioned(
                top: 333,
                left: 290,
                child:   Container(width: 13,height: 13,color: _seats2[70])
            ),
            Positioned(
                top: 350,
                left: 290,
                child:   Container(width: 13,height: 13,color: _seats2[71])
            ),
            Positioned(
                top: 367,
                left: 290,
                child:   Container(width: 13,height: 13,color: _seats2[72])
            ),
            Positioned(
                top: 383,
                left: 290,
                child:   Container(width: 13,height: 13,color: _seats2[73])
            ),
            Positioned(
                top: 400,
                left: 290,
                child:   Container(width: 13,height: 13,color: _seats2[74])
            ),
            Positioned(
                top: 417,
                left: 290,
                child:   Container(width: 13,height: 13,color: _seats2[75])
            ),
            Positioned(
                top: 434,
                left: 290,
                child:   Container(width: 13,height: 13,color: _seats2[76])
            ),
            Positioned(
                top: 333,
                left: 272,
                child:   Container(width: 13,height: 13,color: _seats2[77])
            ),
            Positioned(
                top: 350,
                left: 272,
                child:   Container(width: 13,height: 13,color: _seats2[78])
            ),
            Positioned(
                top: 367,
                left: 272,
                child:   Container(width: 13,height: 13,color: _seats2[79])
            ),
            Positioned(
                top: 383,
                left: 272,
                child:   Container(width: 13,height: 13,color: _seats2[80])
            ),
            Positioned(
                top: 400,
                left: 272,
                child:   Container(width: 13,height: 13,color: _seats2[81])
            ),
            Positioned(
                top: 417,
                left: 272,
                child:   Container(width: 13,height: 13,color: _seats2[82])
            ),
            Positioned(
                top: 434,
                left: 272,
                child:   Container(width: 13,height: 13,color: _seats2[83])
            ),
            Positioned(
                top: 333,
                left: 253,
                child:   Container(width: 13,height: 13,color: _seats2[84])
            ),
            Positioned(
                top: 350,
                left: 253,
                child:   Container(width: 13,height: 13,color: _seats2[85])
            ),
            Positioned(
                top: 367,
                left: 253,
                child:   Container(width: 13,height: 13,color: _seats2[86])
            ),
            Positioned(
                top: 383,
                left: 253,
                child:   Container(width: 13,height: 13,color: _seats2[87])
            ),
            Positioned(
                top: 400,
                left: 253,
                child:   Container(width: 13,height: 13,color: _seats2[88])
            ),
            Positioned(
                top: 417,
                left: 253,
                child:   Container(width: 13,height: 13,color: _seats2[89])
            ),
            Positioned(
                top: 434,
                left: 253,
                child:   Container(width: 13,height: 13,color: _seats2[90])
            ),
            Positioned(
                top: 333,
                left: 235,
                child:   Container(width: 13,height: 13,color: _seats2[91])
            ),
            Positioned(
                top: 350,
                left: 235,
                child:   Container(width: 13,height: 13,color: _seats2[92])
            ),
            Positioned(
                top: 367,
                left: 235,
                child:   Container(width: 13,height: 13,color: _seats2[93])
            ),
            Positioned(
                top: 383,
                left: 235,
                child:   Container(width: 13,height: 13,color: _seats2[94])
            ),
            Positioned(
                top: 400,
                left: 235,
                child:   Container(width: 13,height: 13,color: _seats2[95])
            ),
            Positioned(
                top: 417,
                left: 235,
                child:   Container(width: 13,height: 13,color: _seats2[96])
            ),
            Positioned(
                top: 434,
                left: 235,
                child:   Container(width: 13,height: 13,color: _seats2[97])
            ),
            Positioned(
                top: 333,
                left: 217,
                child:   Container(width: 13,height: 13,color: _seats2[98])
            ),
            Positioned(
                top: 350,
                left: 217,
                child:   Container(width: 13,height: 13,color: _seats2[99])
            ),
            Positioned(
                top: 367,
                left: 217,
                child:   Container(width: 13,height: 13,color: _seats2[100])
            ),
            Positioned(
                top: 383,
                left: 217,
                child:   Container(width: 13,height: 13,color: _seats2[101])
            ),
            Positioned(
                top: 400,
                left: 217,
                child:   Container(width: 13,height: 13,color: _seats2[102])
            ),
            Positioned(
                top: 417,
                left: 217,
                child:   Container(width: 13,height: 13,color: _seats2[103])
            ),
            Positioned(
                top: 434,
                left: 217,
                child:   Container(width: 13,height: 13,color: _seats2[104])
            ),
            Positioned(
                top: 333,
                left: 197,
                child:   Container(width: 13,height: 13,color: _seats2[105])
            ),
            Positioned(
                top: 350,
                left: 197,
                child:   Container(width: 13,height: 13,color: _seats2[106])
            ),
            Positioned(
                top: 367,
                left: 197,
                child:   Container(width: 13,height: 13,color: _seats2[107])
            ),
            Positioned(
                top: 383,
                left: 197,
                child:   Container(width: 13,height: 13,color: _seats2[108])
            ),
            Positioned(
                top: 400,
                left: 197,
                child:   Container(width: 13,height: 13,color: _seats2[109])
            ),
            Positioned(
                top: 417,
                left: 197,
                child:   Container(width: 13,height: 13,color: _seats2[110])
            ),
            Positioned(
                top: 434,
                left: 197,
                child:   Container(width: 13,height: 13,color: _seats2[111])
            ),
            Positioned(
                top: 333,
                left: 179,
                child:   Container(width: 13,height: 13,color: _seats2[112])
            ),
            Positioned(
                top: 350,
                left: 179,
                child:   Container(width: 13,height: 13,color: _seats2[113])
            ),
            Positioned(
                top: 367,
                left: 179,
                child:   Container(width: 13,height: 13,color: _seats2[114])
            ),
            Positioned(
                top: 383,
                left: 179,
                child:   Container(width: 13,height: 13,color: _seats2[115])
            ),
            Positioned(
                top: 400,
                left: 179,
                child:   Container(width: 13,height: 13,color: _seats2[116])
            ),
            Positioned(
                top: 417,
                left: 179,
                child:   Container(width: 13,height: 13,color: _seats2[117])
            ),
            Positioned(
                top: 434,
                left: 179,
                child:   Container(width: 13,height: 13,color: _seats2[118])
            ),
            Positioned(
                top: 333,
                left: 161,
                child:   Container(width: 13,height: 13,color: _seats2[119])
            ),
            Positioned(
                top: 350,
                left: 161,
                child:   Container(width: 13,height: 13,color: _seats2[120])
            ),
            Positioned(
                top: 367,
                left: 161,
                child:   Container(width: 13,height: 13,color: _seats2[121])
            ),
            Positioned(
                top: 383,
                left: 161,
                child:   Container(width: 13,height: 13,color: _seats2[122])
            ),
            Positioned(
                top: 400,
                left: 161,
                child:   Container(width: 13,height: 13,color: _seats2[123])
            ),
            Positioned(
                top: 417,
                left: 161,
                child:   Container(width: 13,height: 13,color: _seats2[124])
            ),
            Positioned(
                top: 434,
                left: 161,
                child:   Container(width: 13,height: 13,color: _seats2[125])
            ),
            Positioned(
                top: 333,
                left: 143,
                child:   Container(width: 13,height: 13,color: _seats2[126])
            ),
            Positioned(
                top: 350,
                left: 143,
                child:   Container(width: 13,height: 13,color: _seats2[127])
            ),
            Positioned(
                top: 367,
                left: 143,
                child:   Container(width: 13,height: 13,color: _seats2[128])
            ),
            Positioned(
                top: 383,
                left: 143,
                child:   Container(width: 13,height: 13,color: _seats2[129])
            ),
            Positioned(
                top: 400,
                left: 143,
                child:   Container(width: 13,height: 13,color: _seats2[130])
            ),
            Positioned(
                top: 417,
                left: 143,
                child:   Container(width: 13,height: 13,color: _seats2[131])
            ),
            Positioned(
                top: 434,
                left: 143,
                child:   Container(width: 13,height: 13,color: _seats2[132])
            ),
            Positioned(
                top: 333,
                left: 125,
                child:   Container(width: 13,height: 13,color: _seats2[133])
            ),
            Positioned(
                top: 350,
                left: 125,
                child:   Container(width: 13,height: 13,color: _seats2[134])
            ),
            Positioned(
                top: 367,
                left: 125,
                child:   Container(width: 13,height: 13,color: _seats2[135])
            ),
            Positioned(
                top: 383,
                left: 125,
                child:   Container(width: 13,height: 13,color: _seats2[136])
            ),
            Positioned(
                top: 400,
                left: 125,
                child:   Container(width: 13,height: 13,color: _seats2[137])
            ),
            Positioned(
                top: 417,
                left: 125,
                child:   Container(width: 13,height: 13,color: _seats2[138])
            ),
            Positioned(
                top: 434,
                left: 125,
                child:   Container(width: 13,height: 13,color: _seats2[139])
            ),
          ],
        )
    );
  }
}