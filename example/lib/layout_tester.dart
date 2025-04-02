import 'package:flutter/material.dart';
import 'package:piano/piano.dart';

/// A utility class for testing different piano layouts
class PianoLayoutTester extends StatefulWidget {
  final String title;
  
  /// Optional parameters to customize the test
  final List<double> keyWidths;
  final List<Clef> clefs;
  final List<NotePosition> highlightedNotes;
  final Color? naturalColor;
  final Color? accidentalColor;
  final Color? highlightColor;

  const PianoLayoutTester({
    Key? key,
    required this.title,
    this.keyWidths = const [30, 40, 50, 60],
    this.clefs = const [Clef.Treble],
    this.highlightedNotes = const [],
    this.naturalColor,
    this.accidentalColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  State<PianoLayoutTester> createState() => _PianoLayoutTesterState();
}

class _PianoLayoutTesterState extends State<PianoLayoutTester> {
  late double _selectedKeyWidth;
  late Clef _selectedClef;
  bool _showMeasurements = false;

  @override
  void initState() {
    super.initState();
    _selectedKeyWidth = widget.keyWidths.first;
    _selectedClef = widget.clefs.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Controls
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Key Width:'),
                const SizedBox(width: 10),
                DropdownButton<double>(
                  value: _selectedKeyWidth,
                  items: widget.keyWidths
                      .map((width) => DropdownMenuItem<double>(
                            value: width,
                            child: Text('$width'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedKeyWidth = value!;
                    });
                  },
                ),
                const SizedBox(width: 20),
                const Text('Clef:'),
                const SizedBox(width: 10),
                DropdownButton<Clef>(
                  value: _selectedClef,
                  items: widget.clefs
                      .map((clef) => DropdownMenuItem<Clef>(
                            value: clef,
                            child: Text(clef.toString().split('.').last),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClef = value!;
                    });
                  },
                ),
                const SizedBox(width: 20),
                Switch(
                  value: _showMeasurements,
                  onChanged: (value) {
                    setState(() {
                      _showMeasurements = value;
                    });
                  },
                ),
                const Text('Show Measurements'),
              ],
            ),
          ),
          
          // Piano layout with optional measurements
          Expanded(
            child: _showMeasurements
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate piano dimensions
                      final noteRange = NoteRange.forClefs([_selectedClef]);
                      final numberOfNaturalKeys = noteRange.naturalPositions.length;
                      final pianoWidth = numberOfNaturalKeys * _selectedKeyWidth;
                      
                      return Column(
                        children: [
                          Container(
                            color: Colors.grey.withOpacity(0.2),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Container Width: ${constraints.maxWidth.toStringAsFixed(1)} px'),
                                Text('Piano Width: ${pianoWidth.toStringAsFixed(1)} px'),
                                Text('Number of Natural Keys: $numberOfNaturalKeys'),
                                Text('Fits Container: ${pianoWidth <= constraints.maxWidth ? 'Yes' : 'No'}'),
                                Text('Aspect Ratio: ${(pianoWidth / constraints.maxHeight).toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: _buildPiano(),
                          ),
                        ],
                      );
                    },
                  )
                : _buildPiano(),
          ),
        ],
      ),
    );
  }

  Widget _buildPiano() {
    return InteractivePiano(
      highlightedNotes: widget.highlightedNotes,
      naturalColor: widget.naturalColor ?? Colors.white,
      accidentalColor: widget.accidentalColor ?? Colors.black,
      highlightColor: widget.highlightColor ?? Colors.red,
      keyWidth: _selectedKeyWidth,
      noteRange: NoteRange.forClefs([_selectedClef]),
      onNotePositionTapped: (position) {
        print('Note tapped: $position');
      },
    );
  }
}
