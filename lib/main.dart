import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: CounterDown(),
    );
  }
}

class CounterDown extends StatefulWidget {
  const CounterDown({super.key});

  @override
  State<CounterDown> createState() => _CounterDownState();
}

class _CounterDownState extends State<CounterDown> {
  Duration duration = Duration(minutes: 25);
  bool isStartPressed = false;
  String str = "Stop Timer";
  Timer? timerHndler;
  count() {
    timerHndler = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        int newDuration = duration.inSeconds - 1;
        duration = Duration(seconds: newDuration);
        if (duration.inSeconds == 0) {
          timer.cancel(); //or timerHndler!.cancel();
          duration = Duration(minutes: 25);
          isStartPressed = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 33, 40, 34),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 120,
                        progressColor: Color.fromARGB(255, 255, 85, 113),
                        backgroundColor: Colors.white,
                        lineWidth: 8.0,
                        percent: duration.inMinutes / 25,
                        animation: true,
                        animateFromLastPercent: true,
                        animationDuration: 1000, // in ms
                        center: Text(
                            "${duration.inMinutes.toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 80,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              isStartPressed
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //check if the timer is runing
                            if (timerHndler!.isActive) {
                              setState(() {
                                // stop timer
                                timerHndler!.cancel();
                              });
                            } else {
                              // run timer
                              count();
                            }
                          },
                          child: Text(
                              timerHndler!.isActive ? "Stop Timer" : "Resume",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.pinkAccent[100]),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            timerHndler!.cancel();
                            setState(() {
                              duration = Duration(minutes: 25);
                              isStartPressed = false;
                            });
                          },
                          child: Text("Cancel",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Colors.pinkAccent[100]),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        count();
                        setState(() {
                          isStartPressed = true;
                        });
                      },
                      child: Text("Start Timer",
                          style: TextStyle(color: Colors.white, fontSize: 25)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      ),
                    ),
            ],
          ),
        ));
  }
}
