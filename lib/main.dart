import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/api_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoApp(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

// ignore: must_be_immutable
class DemoApp extends StatefulWidget {
  Info? info;

  DemoApp({Key? key}) : super(key: key);

  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  final CountDownController _controller = CountDownController();
  final int _duration = 5;
  bool _isPause = false;

  TextEditingController idController = TextEditingController();
  TextEditingController namController = TextEditingController();
  TextEditingController tarController = TextEditingController();
  ApiService apiService = ApiService();
  SharedPreferences? sharedPreferences;

  bool editable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: [
            Column(
              children: [
                SizedBox(height: 30.0),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    hintText: "Id",
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: namController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    hintText: "Materia",
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: tarController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    hintText: "Tarea",
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  width: 200.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      Info data = await apiService
                          .getInfoId(int.parse(idController.text));
                      getData(data, idController, namController, tarController);
                    },
                    child: Text('Obtener tarea'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  width: 200.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      Info info = Info(
                        api: 0,
                        name: namController.text.toString(),
                        tarea: tarController.text.toString(),
                      );
                      await apiService.postInfo(info);
                    },
                    child: Text('Agregar tarea'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  width: 200.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (editable) {
                        Info info = Info(
                          api: int.parse(idController.text),
                          name: namController.text,
                          tarea: tarController.text,
                        );
                        apiService.putInfo(
                            int.parse(idController.text.toString()), info);
                        Navigator.pop(context);
                      }
                      setState(() {
                        editable = !editable;
                      });
                    },
                    child: const Text('Editar'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  width: 200.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      Info info = Info(
                        api: 0,
                        name: namController.text.toString(),
                        tarea: tarController.text.toString(),
                      );

                      await apiService
                          .deleteInfo(int.parse(idController.text.toString()));
                    },
                    child: Text('eliminar tarea'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ),
                Center(
                  child: CircularCountDownTimer(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    duration: _duration,
                    fillColor: Colors.redAccent,
                    controller: _controller,
                    backgroundColor: Colors.white54,
                    strokeWidth: 10.0,
                    strokeCap: StrokeCap.round,
                    autoStart: true,
                    isTimerTextShown: true,
                    isReverse: true,
                    onComplete: () {
                      FlutterRingtonePlayer.play(
                        android: AndroidSounds.notification,
                        ios: IosSounds.glass,
                        looping: false, // Android only - API >= 28 /
                        volume: 0.1, // Android only - API >= 28/
                        asAlarm: false, // Android only - all APIs/
                      );
                      Alert(
                              context: context,
                              title: 'Done',
                              style: AlertStyle(
                                isCloseButton: true,
                                isButtonVisible: false,
                                titleStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.0,
                                ),
                              ),
                              type: AlertType.success)
                          .show();
                    },
                    textStyle: TextStyle(fontSize: 50.0, color: Colors.black),
                    ringColor: Colors.red,
                  ),
                ),

                FloatingActionButton.extended(
                    onPressed: () => _controller.restart(duration: _duration),
                    label: Text('restart work timer'),
                    icon: Icon(Icons.restart_alt)),
                SizedBox(height: 10),

                FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      if (_isPause) {
                        _isPause = false;
                        _controller.resume();
                      } else {
                        _isPause = true;
                        _controller.pause();
                      }
                    });
                  },
                  icon: Icon(
                    _isPause ? Icons.play_arrow : Icons.pause,
                  ),
                  label: Text(
                    _isPause ? 'Resume' : 'Pause',
                  ),
                ),
                SizedBox(height: 10),

                FloatingActionButton.extended(
                    onPressed: () => _controller.restart(duration: 300),
                    label: Text('rest'),
                    icon: Icon(Icons.restaurant)),
                SizedBox(height: 10),

//solo lo uso para guiarme en el espacio
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondRoute()));
                },
                child: const Text("Información")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const CalRoute(tittle: 'Calendario de tareas')));
                },
                child: const Text("Calendario")),
          ],
        ),
      ),
    );
  }

  getData(
    Info data,
    TextEditingController id,
    TextEditingController nam,
    TextEditingController tar,
  ) {
    id.text = data.api.toString();
    nam.text = data.name.toString();
    tar.text = data.tarea.toString();
  }

  // ignore: non_constant_identifier_names
  static ApiService() {}
}

// ignore: must_be_immutable
class SecondRoute extends StatelessWidget {
  SecondRoute({Key? key}) : super(key: key);

  TextEditingController idController = TextEditingController();
  TextEditingController namController = TextEditingController();
  TextEditingController tarController = TextEditingController();
  ApiService apiService = ApiService();
  SharedPreferences? sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información mostrada'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  hintText: "ID",
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: namController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  hintText: "Nombre",
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: tarController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  hintText: "Tarea",
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: () async {
                    List<Info> data = await apiService.getInfo();
                    getData(data, idController, namController, tarController);
                  },
                  child: const Text('Mostrar Info'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: const Text("Volver")),
            ],
          ),
        ],
      ),
    );
  }

  getData(
    List<Info> data,
    TextEditingController id,
    TextEditingController nam,
    TextEditingController tar,
  ) {
    id.text = data.first.api.toString();
    nam.text = data.first.name.toString();
    tar.text = data.first.tarea.toString();
  }

  // ignore: non_constant_identifier_names
  static ApiService() {}
}

class CalRoute extends StatelessWidget {
  const CalRoute({Key? key, required this.tittle}) : super(key: key);

  final String tittle;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      firstDayOfWeek: 6,
      initialDisplayDate: DateTime(2021, 03, 01, 08, 30),
      initialSelectedDate: DateTime(2021, 03, 01, 08, 30),
      dataSource: MeetingDataSource(getAppointments()),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Board Meeting',
      color: Colors.blue,
      recurrenceRule: 'FREQ=DAILY;COUNT=10',
      isAllDay: false));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
