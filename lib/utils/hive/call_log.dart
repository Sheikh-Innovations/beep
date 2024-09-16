import 'package:hive/hive.dart';

part 'call_log.g.dart'; // Generated adapter file

@HiveType(typeId: 1) // Assign a unique typeId for this class
class CallLog {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final bool isVideoCall;

  @HiveField(4)
  final String roomId;

  CallLog({
    required this.name,
    required this.imageUrl,
    required this.date,
    required this.isVideoCall,
    required this.roomId

  });
}
