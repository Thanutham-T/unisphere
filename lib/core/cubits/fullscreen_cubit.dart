import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class FullscreenCubit extends Cubit<bool> {
  FullscreenCubit() : super(false);

  void enterFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    emit(true);
  }

  void exitFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    emit(false);
  }
}
