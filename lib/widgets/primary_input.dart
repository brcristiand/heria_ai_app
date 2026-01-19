import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class PrimaryInput extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final TextInputType keyboardType;
  final bool obscureText;

  const PrimaryInput({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  State<PrimaryInput> createState() => _PrimaryInputState();
}

class _PrimaryInputState extends State<PrimaryInput> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late TextEditingController _internalController;
  TextEditingController? _fallbackController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    if (widget.controller == null) {
      _fallbackController = TextEditingController();
    }
    _internalController = widget.controller ?? _fallbackController!;
  }

  @override
  void dispose() {
    _fallbackController?.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) => setState(() => _isListening = false),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _internalController.text = val.recognizedWords;
              // Trigger onChanged if speech recognition provides a result
              if (widget.onChanged != null) {
                widget.onChanged!(val.recognizedWords);
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _internalController,
      onChanged: widget.onChanged,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500, // typo-h6
        color: const Color(0xFFEDEDED),
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500, // typo-h6
          color: const Color(0xFFE4E4E4),
        ),
        filled: true,
        fillColor: const Color(0xFF9FA4A7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : Colors.white70,
            ),
            onPressed: _listen,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
