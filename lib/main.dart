import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final images = <String>[
  'https://images.pexels.com/photos/2754200/pexels-photo-2754200.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2674052/pexels-photo-2674052.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3375116/pexels-photo-3375116.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3181458/pexels-photo-3181458.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/325185/pexels-photo-325185.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
];
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Note {
  late String id;
  late String title;
  late bool completed;

  Note(this.id, this.title, this.completed);
}

class Qoute {
  late String id;
  late String qoute;
  late String url;
  late String author;

  Qoute(
    this.id,
    this.qoute,
    this.url,
    this.author,
  );
}

class _MyHomePageState extends State<MyHomePage> {
  late Note _note;
  late List<Note> _allNotes;
  late List<Note> _completedNotes;
  late List<Note> _uncompletedNotes;
  late String _randomImage;
  late Qoute _randomQoute;
  final String _name = 'Sam';
  late String _message;
  late String _title;
  final _titleController = TextEditingController();
  bool _showCompleted = false;
  bool _showAll = false;
  late String _timeString;

  @override
  void initState() {
    final random = Random();
    // image
    _randomImage = images[random.nextInt(images.length)];
    // qoutes
    final qoutes = [
      Qoute(
        '1',
        '“Be yourself; everyone else is already taken.”',
        'https://www.goodreads.com/quotes/tag/inspirational',
        'Oscar Wilde',
      ),
      Qoute(
        '2',
        '“Be the change that you wish to see in the world.”',
        'https://www.goodreads.com/quotes/tag/inspirational',
        'Mahatma Gandhi',
      ),
      Qoute(
        '1',
        '“We accept the love we think we deserve.”',
        'https://www.goodreads.com/quotes/tag/inspirational',
        'Stephen Chbosky',
      ),
    ];
    _randomQoute = qoutes[random.nextInt(qoutes.length)];
    // getNotes
    _allNotes = <Note>[
      Note('1', 'Create momentum clone | Flutter', false),
    ];

    _uncompletedNotes = _allNotes.where((el) => !el.completed).toList();
    _completedNotes = _allNotes.where((el) => el.completed).toList();
    // getMessage
    _message = getGreetingMessage();
    // getTime
    _timeString = formatedDateTime(DateTime.now());
    Timer.periodic(const Duration(minutes: 1), (timer) => _getTime());
    super.initState();
  }

  void _onTab(Note note) {
    var _cloneNotes = _allNotes;
    note.completed = !note.completed;
    final index = _cloneNotes.indexWhere((el) => el.id == note.id);
    _cloneNotes[index] = note;
    setState(() {
      _allNotes = _cloneNotes;
      _completedNotes = _allNotes.where((el) => el.completed).toList();
      _uncompletedNotes = _allNotes.where((el) => !el.completed).toList();
    });
  }

  void _onAddNote(String val) {
    final id = DateTime.now().microsecondsSinceEpoch;
    if (val.isNotEmpty) {
      _note = Note('$id', val, false);
      var _cloneNotes = _allNotes;
      _cloneNotes = [_note, ..._cloneNotes];

      setState(() {
        _showAll = false;
        _showCompleted = false;
        _allNotes = _cloneNotes;
        _completedNotes = _allNotes.where((el) => el.completed).toList();
        _uncompletedNotes = _allNotes.where((el) => !el.completed).toList();
      });
      _titleController.clear();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(_randomImage),
            fit: BoxFit.cover,
            opacity: 0.75,
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 200.0),
              Text(
                _timeString,
                style: TextStyle(
                  fontSize: isWideScreen() ? 160.0 : 100.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_message, $_name',
                style: TextStyle(
                  fontSize: isWideScreen() ? 30.0 : 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isWideScreen() ? 200 : 50.0),
              Text(
                'What\'s in your mind today?',
                style: TextStyle(
                  fontSize: isWideScreen() ? 40.0 : 20.0,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen() ? width * 0.2 : 10.0,
                ),
                margin:
                    EdgeInsets.symmetric(vertical: isWideScreen() ? 20.0 : 0),
                child: TextFormField(
                  key: const Key('note title'),
                  controller: _titleController,
                  onFieldSubmitted: _onAddNote,
                  autocorrect: true,
                  autofocus: true,
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  showCursor: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isWideScreen() ? 30.0 : 20.0,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen() ? width * 0.2 : 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'Show All',
                        style: TextStyle(
                          fontSize: isWideScreen() ? 24.0 : 18.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _showAll = !_showAll;
                        });
                      },
                    ),
                    TextButton(
                      child: Text(
                        _showCompleted ? 'UnCompleted' : 'Completed',
                        style: TextStyle(
                          fontSize: isWideScreen() ? 24.0 : 18.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _showCompleted = !_showCompleted;
                          _showAll = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  semanticChildCount: _getSemanticChildCount(),
                  children: [
                    if (_showCompleted)
                      for (var n in _completedNotes) _buildNoteTile(n, _onTab)
                    else if (_showAll)
                      for (var n in _allNotes) _buildNoteTile(n, _onTab)
                    else
                      for (var n in _uncompletedNotes) _buildNoteTile(n, _onTab)
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Container(
                  child: Text(
                    "${_randomQoute.qoute} - ${_randomQoute.author}",
                    style: TextStyle(
                        fontSize: isWideScreen() ? 30.0 : 18.0,
                        color: Colors.white),
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: isWideScreen() ? 50.0 : 30.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteTile(Note n, Function(Note) onTab) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: isWideScreen() ? width * 0.2 : 10.0),
      child: ListTile(
        onTap: () => onTab(n),
        title: Text(
          n.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isWideScreen() ? 24.0 : 18.0,
            fontWeight: FontWeight.normal,
            decoration:
                n.completed ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        leading: Icon(
          n.completed ? Icons.circle : Icons.circle_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formatTime = formatedDateTime(now);
    setState(() {
      _timeString = formatTime;
    });
  }

  int _getSemanticChildCount() {
    if (_showAll) {
      return _allNotes.length;
    } else if (_showCompleted) {
      return _completedNotes.length;
    } else {
      return _uncompletedNotes.length;
    }
  }
}

String getGreetingMessage() {
  final now = DateTime.now();
  if (now.hour >= 0 && now.hour < 12) {
    return 'Good morning';
  } else if (now.hour >= 12 && now.hour < 17) {
    return 'Good afternoon';
  }
  return 'Good evening';
}

String formatedDateTime(DateTime now) {
  return DateFormat('hh:mm').format(now);
}

bool isWideScreen() {
  return kIsWeb || Platform.isMacOS || Platform.isWindows;
}
