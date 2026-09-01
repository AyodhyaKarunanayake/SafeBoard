import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/incident_report.dart';

class IncidentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitIncidentReport(IncidentReport report) async {
    try {
      await _firestore
          .collection('incident_reports')
          .doc(report.incidentId)
          .set(report.toMap());
    } catch (e) {
      // Graceful offline execution
    }
  }
}
