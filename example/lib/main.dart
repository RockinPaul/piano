import 'package:flutter/material.dart';
import 'package:piano/piano.dart';
import 'layout_test_app.dart';
import 'clef_note_tester.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piano Layout Examples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LayoutExamplesScreen(),
    );
  }
}

class LayoutExamplesScreen extends StatefulWidget {
  const LayoutExamplesScreen({Key? key}) : super(key: key);

  @override
  State<LayoutExamplesScreen> createState() => _LayoutExamplesScreenState();
}

class _LayoutExamplesScreenState extends State<LayoutExamplesScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _examples = [
    const PortraitLayoutExample(),
    const LandscapeLayoutExample(),
    const ResponsiveLayoutExample(),
    const CustomStylesExample(),
    const LayoutTestApp(),
    const ClefNoteTesterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piano Layout Examples'),
      ),
      body: _examples[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.stay_current_portrait),
            label: 'Portrait',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.stay_current_landscape),
            label: 'Landscape',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'Responsive',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.format_paint),
            label: 'Styles',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.science),
            label: 'Layout Tests',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Note Test',
          ),
        ],
      ),
    );
  }
}

class PortraitLayoutExample extends StatelessWidget {
  const PortraitLayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Clef with Notes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: ClefImage(
              clef: Clef.Treble,
              noteRange: NoteRange.forClefs([Clef.Treble]),
              noteImages: [
                NoteImage(
                  notePosition: NotePosition(note: Note.C, octave: 4),
                ),
                NoteImage(
                  notePosition: NotePosition(note: Note.E, octave: 4),
                ),
                NoteImage(
                  notePosition: NotePosition(note: Note.G, octave: 4),
                ),
              ],
              clefColor: Colors.black,
              noteColor: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Interactive Piano (Portrait)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InteractivePiano(
                highlightedNotes: [
                  NotePosition(note: Note.C, octave: 4),
                  NotePosition(note: Note.E, octave: 4),
                  NotePosition(note: Note.G, octave: 4),
                ],
                naturalColor: Colors.white,
                accidentalColor: Colors.black,
                keyWidth: 60,
                noteRange: NoteRange.forClefs([Clef.Treble]),
                onNotePositionTapped: (position) {
                  print('Note tapped: $position');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LandscapeLayoutExample extends StatelessWidget {
  const LandscapeLayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Clef Display',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: ClefImage(
                    clef: Clef.Bass,
                    noteRange: NoteRange.forClefs([Clef.Bass]),
                    noteImages: [
                      NoteImage(
                        notePosition: NotePosition(note: Note.F, octave: 2),
                      ),
                      NoteImage(
                        notePosition: NotePosition(note: Note.A, octave: 2),
                      ),
                      NoteImage(
                        notePosition: NotePosition(note: Note.C, octave: 3),
                      ),
                    ],
                    clefColor: Colors.black,
                    noteColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Interactive Piano (Landscape)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: InteractivePiano(
                    highlightedNotes: [
                      NotePosition(note: Note.F, octave: 2),
                      NotePosition(note: Note.A, octave: 2),
                      NotePosition(note: Note.C, octave: 3),
                    ],
                    naturalColor: Colors.white,
                    accidentalColor: Colors.black,
                    keyWidth: 40,
                    noteRange: NoteRange.forClefs([Clef.Bass]),
                    onNotePositionTapped: (position) {
                      print('Note tapped: $position');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveLayoutExample extends StatelessWidget {
  const ResponsiveLayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the orientation
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;
    
    // Adjust key width based on screen width
    final keyWidth = size.width / 14;
    
    if (orientation == Orientation.portrait) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Responsive Layout (Portrait)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ClefImage(
                clef: Clef.Treble,
                noteRange: NoteRange.forClefs([Clef.Treble]),
                noteImages: [
                  NoteImage(
                    notePosition: NotePosition(note: Note.D, octave: 4),
                  ),
                  NoteImage(
                    notePosition: NotePosition(note: Note.F, octave: 4),
                  ),
                  NoteImage(
                    notePosition: NotePosition(note: Note.A, octave: 4),
                  ),
                ],
                clefColor: Colors.black,
                noteColor: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: InteractivePiano(
                highlightedNotes: [
                  NotePosition(note: Note.D, octave: 4),
                  NotePosition(note: Note.F, octave: 4),
                  NotePosition(note: Note.A, octave: 4),
                ],
                naturalColor: Colors.white,
                accidentalColor: Colors.black,
                keyWidth: keyWidth,
                noteRange: NoteRange.forClefs([Clef.Treble]),
                onNotePositionTapped: (position) {
                  print('Note tapped: $position');
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Responsive Layout (Landscape)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: ClefImage(
                      clef: Clef.Treble,
                      noteRange: NoteRange.forClefs([Clef.Treble]),
                      noteImages: [
                        NoteImage(
                          notePosition: NotePosition(note: Note.D, octave: 4),
                        ),
                        NoteImage(
                          notePosition: NotePosition(note: Note.F, octave: 4),
                        ),
                        NoteImage(
                          notePosition: NotePosition(note: Note.A, octave: 4),
                        ),
                      ],
                      clefColor: Colors.black,
                      noteColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: InteractivePiano(
                highlightedNotes: [
                  NotePosition(note: Note.D, octave: 4),
                  NotePosition(note: Note.F, octave: 4),
                  NotePosition(note: Note.A, octave: 4),
                ],
                naturalColor: Colors.white,
                accidentalColor: Colors.black,
                keyWidth: keyWidth,
                noteRange: NoteRange.forClefs([Clef.Treble]),
                onNotePositionTapped: (position) {
                  print('Note tapped: $position');
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}

class CustomStylesExample extends StatelessWidget {
  const CustomStylesExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Custom Piano Styles',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: ClefImage(
              clef: Clef.Treble,
              noteRange: NoteRange.forClefs([Clef.Treble]),
              noteImages: [
                NoteImage(
                  notePosition: NotePosition(note: Note.C, octave: 4),
                ),
                NoteImage(
                  notePosition: NotePosition(note: Note.E, octave: 4),
                ),
                NoteImage(
                  notePosition: NotePosition(note: Note.G, octave: 4),
                ),
              ],
              clefColor: Colors.black,
              noteColor: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InteractivePiano(
                highlightedNotes: [
                  NotePosition(note: Note.C, octave: 4),
                  NotePosition(note: Note.E, octave: 4),
                  NotePosition(note: Note.G, octave: 4),
                ],
                naturalColor: Colors.lightBlue[100]!,
                accidentalColor: Colors.indigo[900]!,
                highlightColor: Colors.amber,
                keyWidth: 50,
                noteRange: NoteRange.forClefs([Clef.Treble]),
                onNotePositionTapped: (position) {
                  print('Note tapped: $position');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
