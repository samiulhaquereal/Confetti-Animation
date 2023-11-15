import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool button = true;
  var isPlaying = false;
  late ConfettiController confettiController;


  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  startConfettinAnimation(){
    if(confettiController.state ==ConfettiControllerState.playing){
      isPlaying = false;
      confettiController.stop();
    }else{
      isPlaying = true;
      confettiController.play();
    }
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            body: Center(
              child: ElevatedButton(
                child: button ? Text('Play') : Text('Stop'),
                onPressed: (){
                  setState(() {
                    button = button==false ? true : false;
                    startConfettinAnimation();
                  });
                },
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
            shouldLoop: true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
            createParticlePath: drawStar, // define a custom shape/path.
            //blastDirection: 0, // right
            //blastDirection: pi, // left
            //blastDirection: pi/2, // down
            //blastDirection: -pi / 2, // up
            //emissionFrequency: 0.8, // default 0.2
            //numberOfParticles: 20, // default 10
            //gravity: 0.8, // default 0.1
          ),
        ]
      ),

    );
  }
}
