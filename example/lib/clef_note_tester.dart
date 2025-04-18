import 'package:flutter/material.dart';
import 'package:piano/piano.dart';

/// A screen to test different note appearances on clefs
class ClefNoteTesterScreen extends StatefulWidget {
  const ClefNoteTesterScreen({Key? key}) : super(key: key);

  @override
  State<ClefNoteTesterScreen> createState() => _ClefNoteTesterScreenState();
}

class _ClefNoteTesterScreenState extends State<ClefNoteTesterScreen> {
  Clef _selectedClef = Clef.Treble;
  Note _selectedNote = Note.C;
  int _selectedOctave = 4;
  Accidental _selectedAccidental = Accidental.None;
  Color _noteColor = Colors.black;
  Color _clefColor = Colors.black;

  // Returns available accidentals for the currently selected note
  Set<Accidental> get _availableAccidentals {
    final Set<Accidental> result = {Accidental.None};
    result.addAll(_selectedNote.accidentals);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clef Note Tester'),
      ),
      body: Column(
        children: [
          // Clef and Note Display Area
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth * 0.9,
                        height: constraints.maxHeight * 0.9,
                        child: ClefImage(
                          clef: _selectedClef,
                          noteRange: NoteRange.forClefs([_selectedClef]),
                          noteImages: [
                            NoteImage(
                              notePosition: NotePosition(
                                note: _selectedNote,
                                octave: _selectedOctave,
                                accidental: _selectedAccidental,
                              ),
                            ),
                          ],
                          clefColor: _clefColor,
                          noteColor: _noteColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          
          // Controls Area
          Container(
            height: MediaQuery.of(context).size.height * 0.4, // Fixed height instead of Expanded
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Important to prevent unbounded height error
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Clef Selector
                    Row(
                      children: [
                        const Text('Clef:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SegmentedButton<Clef>(
                            selected: {_selectedClef},
                            onSelectionChanged: (Set<Clef> selection) {
                              setState(() {
                                _selectedClef = selection.first;
                                // Adjust octave based on clef to ensure note is visible
                                if (_selectedClef == Clef.Bass && _selectedOctave > 4) {
                                  _selectedOctave = 3;
                                } else if (_selectedClef == Clef.Treble && _selectedOctave < 3) {
                                  _selectedOctave = 4;
                                }
                              });
                            },
                            segments: const [
                              ButtonSegment<Clef>(
                                value: Clef.Treble,
                                label: Text('Treble'),
                              ),
                              ButtonSegment<Clef>(
                                value: Clef.Bass,
                                label: Text('Bass'),
                              ),
                              ButtonSegment<Clef>(
                                value: Clef.Alto, 
                                label: Text('Alto'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Note Selector
                    Row(
                      children: [
                        const Text('Note:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButton<Note>(
                            value: _selectedNote,
                            isExpanded: true,
                            onChanged: (Note? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedNote = newValue;
                                  // Reset accidental when note changes
                                  _selectedAccidental = Accidental.None;
                                });
                              }
                            },
                            items: Note.values
                                .map((note) => DropdownMenuItem<Note>(
                                      value: note,
                                      child: Text(note.toString().split('.').last),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Accidental Selector
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Accidental:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            // Show note-specific accidental information
                            Text(
                              _selectedNote.accidentals.isEmpty
                                ? '(${_selectedNote.toString().split('.').last} has no accidentals)'
                                : '(Available: ${_getAccidentalDescription()})',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<Accidental>(
                          segments: [
                            ButtonSegment<Accidental>(
                              value: Accidental.None,
                              label: const Text('♮'),
                            ),
                            ButtonSegment<Accidental>(
                              value: Accidental.Sharp,
                              label: const Text('♯'),
                              enabled: _availableAccidentals.contains(Accidental.Sharp),
                            ),
                            ButtonSegment<Accidental>(
                              value: Accidental.Flat,
                              label: const Text('♭'),
                              enabled: _availableAccidentals.contains(Accidental.Flat),
                            ),
                          ],
                          selected: {_selectedAccidental},
                          onSelectionChanged: (Set<Accidental> newSelection) {
                            // Only change if this is a valid accidental for this note
                            if (_availableAccidentals.contains(newSelection.first)) {
                              setState(() {
                                _selectedAccidental = newSelection.first;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Octave Selector
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Octave:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: _selectedOctave > 2
                                  ? () {
                                      setState(() {
                                        _selectedOctave--;
                                      });
                                    }
                                  : null,
                            ),
                            Expanded(
                              child: Slider(
                                value: _selectedOctave.toDouble(),
                                min: 2,
                                max: 6,
                                divisions: 4,
                                label: _selectedOctave.toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    _selectedOctave = value.round();
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: _selectedOctave < 6
                                  ? () {
                                      setState(() {
                                        _selectedOctave++;
                                      });
                                    }
                                  : null,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _selectedOctave.toString(),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Color Controls
                    const Text('Colors:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Clef Color
                        Column(
                          children: [
                            const Text('Clef'),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                _showColorPicker(context, true);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _clefColor,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Note Color
                        Column(
                          children: [
                            const Text('Note'),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                _showColorPicker(context, false);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _noteColor,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Current Note Information
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.grey[200],
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Current Note: ${_selectedNote.toString().split('.').last}${_selectedAccidental.symbol}${_selectedOctave}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Clef: ${_selectedClef.toString().split('.').last}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Position: ${_getNotePositionDescription()}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getNotePositionDescription() {
    NotePosition position = NotePosition(
      note: _selectedNote,
      octave: _selectedOctave,
      accidental: _selectedAccidental,
    );
    
    // This is a simplified description - in a real app you might want to
    // calculate the actual position relative to the staff lines
    switch (_selectedClef) {
      case Clef.Treble:
        if (position.octave < 4) {
          return "Below staff";
        } else if (position.octave > 5) {
          return "Above staff";
        } else {
          return "On staff";
        }
      case Clef.Bass:
        if (position.octave < 2) {
          return "Below staff";
        } else if (position.octave > 3) {
          return "Above staff";
        } else {
          return "On staff";
        }
      case Clef.Alto:
        if (position.octave < 3) {
          return "Below staff";
        } else if (position.octave > 4) {
          return "Above staff";
        } else {
          return "On staff";
        }
    }
  }
  
  String _getAccidentalDescription() {
    final accidentals = _selectedNote.accidentals;
    final symbols = accidentals.map((a) => a.symbol).join(', ');
    return symbols;
  }
  
  void _showColorPicker(BuildContext context, bool isClefColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isClefColor ? 'Select Clef Color' : 'Select Note Color'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildColorOption(Colors.black, 'Black', isClefColor),
                _buildColorOption(Colors.blue, 'Blue', isClefColor),
                _buildColorOption(Colors.red, 'Red', isClefColor),
                _buildColorOption(Colors.green, 'Green', isClefColor),
                _buildColorOption(Colors.purple, 'Purple', isClefColor),
                _buildColorOption(Colors.orange, 'Orange', isClefColor),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildColorOption(Color color, String label, bool isClefColor) {
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        color: color,
      ),
      title: Text(label),
      onTap: () {
        setState(() {
          if (isClefColor) {
            _clefColor = color;
          } else {
            _noteColor = color;
          }
        });
        Navigator.of(context).pop();
      },
    );
  }
}
