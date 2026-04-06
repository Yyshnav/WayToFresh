import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../../../routes/app_routes.dart';

class VoiceSearchController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  RxBool isListening = false.obs;
  RxString speechText = "".obs;
  RxBool isInitialized = false.obs;
  RxString errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
            // If we have text and it stopped, navigate
            if (speechText.value.isNotEmpty) {
              _navigateToSearch();
            }
          }
        },
        onError: (errorNotification) {
          errorMessage.value = errorNotification.errorMsg;
          isListening.value = false;
        },
      );
      isInitialized.value = available;
      if (available) {
        startListening();
      }
    } catch (e) {
      errorMessage.value = "Speech recognition not available";
      isInitialized.value = false;
    }
  }

  Future<void> startListening() async {
    if (!isInitialized.value) {
      await _initSpeech();
      if (!isInitialized.value) return;
    }

    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
      if (!status.isGranted) return;
    }

    speechText.value = "";
    errorMessage.value = "";
    isListening.value = true;
    
    await _speech.listen(
      onResult: (result) {
        speechText.value = result.recognizedWords;
        if (result.finalResult) {
          isListening.value = false;
          _navigateToSearch();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
    );
  }

  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  void _navigateToSearch() {
    if (speechText.value.trim().isEmpty) return;
    
    String query = speechText.value;
    // Reset state before navigation
    speechText.value = "";
    
    // Close bottom sheet if open
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    
    // Navigate to Search Result
    Get.toNamed(AppRoutes.searchScreen, arguments: query);
  }
}
