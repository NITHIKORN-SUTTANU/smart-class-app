class CheckInRecord {
  final int? id;
  final String studentId;
  final String checkInTime;
  final double gpsLat;
  final double gpsLng;
  final String qrCodeData;
  final String previousTopic;
  final String expectedTopic;
  final int moodBefore;

  CheckInRecord({
    this.id,
    required this.studentId,
    required this.checkInTime,
    required this.gpsLat,
    required this.gpsLng,
    required this.qrCodeData,
    required this.previousTopic,
    required this.expectedTopic,
    required this.moodBefore,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentId': studentId,
        'checkInTime': checkInTime,
        'gpsLat': gpsLat,
        'gpsLng': gpsLng,
        'qrCodeData': qrCodeData,
        'previousTopic': previousTopic,
        'expectedTopic': expectedTopic,
        'moodBefore': moodBefore,
      };

  factory CheckInRecord.fromMap(Map<String, dynamic> map) => CheckInRecord(
        id: map['id'],
        studentId: map['studentId'],
        checkInTime: map['checkInTime'],
        gpsLat: map['gpsLat'],
        gpsLng: map['gpsLng'],
        qrCodeData: map['qrCodeData'],
        previousTopic: map['previousTopic'],
        expectedTopic: map['expectedTopic'],
        moodBefore: map['moodBefore'],
      );
}

class CheckOutRecord {
  final int? id;
  final String studentId;
  final String checkOutTime;
  final double gpsLat;
  final double gpsLng;
  final String qrCodeData;
  final String whatLearned;
  final String feedback;

  CheckOutRecord({
    this.id,
    required this.studentId,
    required this.checkOutTime,
    required this.gpsLat,
    required this.gpsLng,
    required this.qrCodeData,
    required this.whatLearned,
    required this.feedback,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentId': studentId,
        'checkOutTime': checkOutTime,
        'gpsLat': gpsLat,
        'gpsLng': gpsLng,
        'qrCodeData': qrCodeData,
        'whatLearned': whatLearned,
        'feedback': feedback,
      };

  factory CheckOutRecord.fromMap(Map<String, dynamic> map) => CheckOutRecord(
        id: map['id'],
        studentId: map['studentId'],
        checkOutTime: map['checkOutTime'],
        gpsLat: map['gpsLat'],
        gpsLng: map['gpsLng'],
        qrCodeData: map['qrCodeData'],
        whatLearned: map['whatLearned'],
        feedback: map['feedback'],
      );
}
