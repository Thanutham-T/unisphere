import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../logging/app_logger.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';

  bool get isAvailable => _speechEnabled;
  bool get isListening => _isListening;
  String get lastWords => _lastWords;

  /// Initialize speech recognition
  Future<bool> initialize() async {
    try {
      // Check if running on web
      if (kIsWeb) {
        AppLogger.debug('Speech recognition not supported on web');
        return false;
      }

      // Request microphone permission
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          AppLogger.debug('Microphone permission denied');
          return false;
        }
      }

      // Initialize speech to text
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          AppLogger.debug('Speech status: $status');
          _isListening = status == 'listening';
        },
        onError: (error) {
          AppLogger.debug('Speech error: $error');
          _isListening = false;
        },
      );

      AppLogger.debug('Speech recognition initialized: $_speechEnabled');
      return _speechEnabled;
    } catch (e) {
      AppLogger.debug('Speech initialization error: $e');
      return false;
    }
  }

  /// Start listening for speech
  Future<void> startListening({
    required Function(String) onResult,
    String? localeId,
  }) async {
    if (!_speechEnabled) {
      AppLogger.debug('Speech recognition not enabled');
      return;
    }

    if (_isListening) {
      AppLogger.debug('Already listening');
      return;
    }

    try {
      await _speechToText.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          AppLogger.debug('Speech result: $_lastWords');
          onResult(_lastWords);
          
          // Auto stop listening when final result is received
          if (result.finalResult) {
            stopListening();
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: localeId ?? 'th_TH', // Default to Thai
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );
      
      _isListening = true;
      AppLogger.debug('Started listening');
    } catch (e) {
      AppLogger.debug('Error starting speech recognition: $e');
      _isListening = false;
    }
  }

  /// Stop listening for speech
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    try {
      await _speechToText.stop();
      _isListening = false;
      AppLogger.debug('Stopped listening');
    } catch (e) {
      AppLogger.debug('Error stopping speech recognition: $e');
    }
  }

  /// Cancel current speech recognition
  Future<void> cancel() async {
    if (!_isListening) return;
    
    try {
      await _speechToText.cancel();
      _isListening = false;
      AppLogger.debug('Speech recognition cancelled');
    } catch (e) {
      AppLogger.debug('Error cancelling speech recognition: $e');
    }
  }

  /// Get available locales
  Future<List<LocaleName>> getLocales() async {
    if (!_speechEnabled) return [];
    
    try {
      return await _speechToText.locales();
    } catch (e) {
      AppLogger.debug('Error getting locales: $e');
      return [];
    }
  }

  /// Check if a specific locale is available
  Future<bool> hasLocale(String localeId) async {
    final locales = await getLocales();
    return locales.any((locale) => locale.localeId == localeId);
  }
}