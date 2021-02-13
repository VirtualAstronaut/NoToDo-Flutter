
import 'package:flutter_app/models/syncmodel.dart';
import 'package:flutter_app/savetojson.dart';
import 'package:flutter_riverpod/all.dart';

import 'models/ListHold.dart';
import 'models/NotesModel.dart';
import 'models/SliderUpdate.dart';
import 'models/datetimemodel.dart';

final listStateProvider = StateNotifierProvider((ref) => MyList());
final notesProvider = StateNotifierProvider((re) => NotesModel());
final syncProvider = StateNotifierProvider((ref) => SyncHandler(ref.read));
final sliderProvider = ChangeNotifierProvider((_) => SliderUpdate());
final saveToLocalJSON = Provider((_) => SaveToLocal());
final progressProvider = ChangeNotifierProvider((_) => ProgressProvider());
final dateTimeProvider = ChangeNotifierProvider((ref) => DateTimeNotifier());
