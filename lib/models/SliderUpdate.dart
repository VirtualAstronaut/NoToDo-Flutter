import 'package:flutter/foundation.dart';

class SliderUpdate with ChangeNotifier {
  double _sliderValue = 1.0;

  double get sliderValue => _sliderValue;

  updateValue(double value){
    _sliderValue = value;
    notifyListeners();
  }
  resetSlider(){
    _sliderValue = 1.0;
  }
  updateWithoutNotify( double value){
    _sliderValue = value;
  }
}