import 'package:flutter/material.dart';
import 'package:piano/piano.dart';
import 'layout_tester.dart';

/// A separate app to specifically test different piano layouts
class LayoutTestApp extends StatelessWidget {
  const LayoutTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piano Layout Tests',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LayoutTestHome(),
    );
  }
}

class LayoutTestHome extends StatefulWidget {
  const LayoutTestHome({Key? key}) : super(key: key);

  @override
  State<LayoutTestHome> createState() => _LayoutTestHomeState();
}

class _LayoutTestHomeState extends State<LayoutTestHome> {
  int _selectedIndex = 0;
  
  final List<Widget> _testPages = [
    PianoLayoutTester(
      title: 'Basic Layout Test',
      keyWidths: const [30, 40, 50, 60, 70],
      clefs: const [Clef.Treble, Clef.Bass],
      highlightedNotes: [
        NotePosition(note: Note.C, octave: 4),
        NotePosition(note: Note.E, octave: 4),
        NotePosition(note: Note.G, octave: 4),
      ],
    ),
    
    PianoLayoutTester(
      title: 'Custom Colors Test',
      keyWidths: [45, 55, 65],
      clefs: [Clef.Treble, Clef.Bass],
      naturalColor: Colors.amber[50],
      accidentalColor: Colors.brown[900],
      highlightColor: Colors.orange,
      highlightedNotes: [
        NotePosition(note: Note.D, octave: 4),
        NotePosition(note: Note.F, octave: 4),
        NotePosition(note: Note.A, octave: 4),
      ],
    ),
    
    const LayoutTesterInTabletMode(),
    
    const LayoutTesterInPhoneMode(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _testPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.straighten),
            label: 'Basic',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: 'Colors',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.tablet),
            label: 'Tablet',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            label: 'Phone',
          ),
        ],
      ),
    );
  }
}

/// Special layout tester that simulates tablet dimensions
class LayoutTesterInTabletMode extends StatelessWidget {
  const LayoutTesterInTabletMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Simulate a tablet landscape view in a container
        return Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            width: constraints.maxWidth * 0.95,
            height: constraints.maxHeight * 0.8,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[300],
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tablet Mode (1024 x 768)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Landscape'),
                    ],
                  ),
                ),
                Expanded(
                  child: PianoLayoutTester(
                    title: 'Tablet Layout',
                    keyWidths: const [40, 50, 60],
                    clefs: const [Clef.Treble, Clef.Bass],
                    naturalColor: Colors.grey[50],
                    accidentalColor: Colors.blueGrey[900],
                    highlightColor: Colors.lightBlue[300],
                    highlightedNotes: [
                      NotePosition(note: Note.E, octave: 3),
                      NotePosition(note: Note.G, octave: 3),
                      NotePosition(note: Note.B, octave: 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Special layout tester that simulates phone dimensions
class LayoutTesterInPhoneMode extends StatelessWidget {
  const LayoutTesterInPhoneMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Simulate a phone portrait view in a container
        return Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            width: constraints.maxWidth * 0.6,
            height: constraints.maxHeight * 0.8,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[300],
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phone Mode (390 x 844)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Portrait'),
                    ],
                  ),
                ),
                Expanded(
                  child: PianoLayoutTester(
                    title: 'Phone Layout',
                    keyWidths: const [25, 30, 35],
                    clefs: const [Clef.Treble, Clef.Bass],
                    naturalColor: Colors.white,
                    accidentalColor: Colors.black,
                    highlightColor: Colors.green[300],
                    highlightedNotes: [
                      NotePosition(note: Note.F, octave: 4),
                      NotePosition(note: Note.A, octave: 4),
                      NotePosition(note: Note.C, octave: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
