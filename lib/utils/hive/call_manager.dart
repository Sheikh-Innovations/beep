import 'package:beep/utils/hive/call_log.dart';
import 'package:hive/hive.dart';

class CallLogsManager {
  static const String boxName = 'call_logs';

  // Add a call log
  static Future<void> addCallLog(CallLog callLog) async {
    final box = await Hive.openBox<CallLog>(boxName); // Open the box
    await box.add(callLog); // Add the call log
  }

  // Get all call logs

  static Future<List<CallLog>> getCallLogs() async {
    final box = await Hive.openBox<CallLog>(boxName);

    final callLogs = box.values.toList();

    // Sort by date (most recent first)
    callLogs
        .sort((a, b) => b.date.compareTo(a.date)); // Sorting DateTime directly

    return callLogs;
  }
}
