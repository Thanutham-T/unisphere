import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

/// Speech handler for managing voice recognition
class _SpeechHandler {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  
  bool get isEnabled => _speechEnabled && !kIsWeb;
  bool get isListening => _isListening;
  
  Future<void> initialize() async {
    if (kIsWeb) return;
    try {
      _speechEnabled = await _speechToText.initialize();
    } catch (e) {
      _speechEnabled = false;
    }
  }
  
  Future<void> startListening(Function(String) onResult, VoidCallback onStateChanged) async {
    if (!isEnabled || _isListening) return;
    
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) return;
      
      _isListening = true;
      onStateChanged();
      
      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'th_TH',
      );
    } catch (e) {
      _isListening = false;
      onStateChanged();
    }
  }
  
  Future<void> stopListening(VoidCallback onStateChanged) async {
    if (!_isListening) return;
    try {
      await _speechToText.stop();
    } catch (e) {}
    _isListening = false;
    onStateChanged();
  }
  
  void dispose() {
    _speechToText.cancel();
  }
}

class MapSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onProfileTap;

  const MapSearchBar({
    super.key,
    required this.onSearchChanged,
    this.onProfileTap,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final _SpeechHandler _speechHandler = _SpeechHandler();

  @override
  void initState() {
    super.initState();
    _speechHandler.initialize();
  }

  void _handleMicTap() async {
    if (kIsWeb) {
      _showWebNotSupportedMessage();
      return;
    }
    
    if (_speechHandler.isListening) {
      await _speechHandler.stopListening(() => setState(() {}));
    } else {
      await _speechHandler.startListening(
        (text) {
          _searchController.text = text;
          widget.onSearchChanged(text);
        },
        () => setState(() {}),
      );
    }
  }

  void _showWebNotSupportedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('การค้นหาด้วยเสียงใช้งานได้เฉพาะในมือถือเท่านั้น'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _speechHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: colorScheme.onSurface.withOpacity(0.6)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'ค้นหาในแผนที่',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        setState(() {});
                        widget.onSearchChanged(value);
                      },
                    ),
                  ),
                  // Clear button (show only when there's text)
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {});
                        widget.onSearchChanged('');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.clear,
                          color: colorScheme.onSurface.withOpacity(0.6),
                          size: 20,
                        ),
                      ),
                    ),
                  // Microphone button
                  GestureDetector(
                    onTap: _handleMicTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _speechHandler.isListening
                            ? colorScheme.error.withOpacity(0.2)
                            : _speechHandler.isEnabled
                                ? colorScheme.primary.withOpacity(0.1)
                                : colorScheme.onSurface.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        kIsWeb
                            ? Icons.mic_off
                            : _speechHandler.isListening
                                ? Icons.mic
                                : Icons.mic_none,
                        color: kIsWeb
                            ? colorScheme.onSurface.withOpacity(0.5)
                            : _speechHandler.isListening
                                ? colorScheme.error
                                : _speechHandler.isEnabled
                                    ? colorScheme.primary
                                    : colorScheme.onSurface.withOpacity(0.5),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Profile Icon
          GestureDetector(
            onTap: widget.onProfileTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: colorScheme.onPrimary, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
