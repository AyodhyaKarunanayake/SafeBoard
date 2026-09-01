import 'package:flutter/material.dart';
import '../models/journey_instance.dart';
import '../models/seat_allocation.dart';
import '../models/incident_report.dart';
import '../services/incident_service.dart';

class JourneyProvider with ChangeNotifier {
  final IncidentService _incidentService = IncidentService();

  SeatAllocation? _currentAllocation;
  JourneyInstance? _activeJourney;

  // Real-time simulated / Firestore state
  int _currentOccupancy = 27; // Total occupied out of 42
  int _standingCount = 4; // Standing out of 18
  final int _priorityOccupied = 3;
  final int _generalOccupied = 20;
  final String _currentStop = 'Anuradhapura';
  String _crowdingLevel = 'moderate';
  bool _isJourneyActive = false; // Fresh start by default
  bool _isTrippingMode = false; // Activates when conductor scans QR code
  bool _isApproachingAlighting = false;
  bool _isJourneyCompleted = false;
  String? _conductorAlert;

  SeatAllocation? get currentAllocation => _currentAllocation;
  JourneyInstance? get activeJourney => _activeJourney;
  int get currentOccupancy => _currentOccupancy;
  int get standingCount => _standingCount;
  int get priorityOccupied => _priorityOccupied;
  int get generalOccupied => _generalOccupied;
  String get currentStop => _currentStop;
  String get crowdingLevel => _crowdingLevel;
  bool get isJourneyActive => _isJourneyActive;
  bool get isTrippingMode => _isTrippingMode;
  bool get isApproachingAlighting => _isApproachingAlighting;
  bool get isJourneyCompleted => _isJourneyCompleted;
  String? get conductorAlert => _conductorAlert;

  JourneyProvider() {
    _activeJourney = JourneyInstance(
      journeyId: 'JRN_87_001',
      busId: 'BUS_NB_8701',
      routeId: 'R_87',
      conductorId: 'COND_882',
      departureDatetime: DateTime.now().add(const Duration(hours: 1, minutes: 15)),
      arrivalDatetime: DateTime.now().add(const Duration(hours: 7, minutes: 30)),
      currentOccupancy: _currentOccupancy,
      standingCount: _standingCount,
      currentStop: _currentStop,
      crowdingLevel: _crowdingLevel,
      status: 'scheduled',
      priorityOccupied: _priorityOccupied,
      generalOccupied: _generalOccupied,
    );
  }

  void setCurrentAllocation(SeatAllocation allocation) {
    _currentAllocation = allocation;
    _isJourneyActive = true;
    notifyListeners();
  }

  void activateTrippingMode() {
    _isTrippingMode = true;
    _isJourneyActive = true;
    _isApproachingAlighting = true; // Simulating approaching destination alert
    notifyListeners();
  }

  void updateOccupancy(int newOccupancy, int newStanding) {
    _currentOccupancy = newOccupancy;
    _standingCount = newStanding;
    if (_currentOccupancy > 35) {
      _crowdingLevel = 'high';
    } else if (_currentOccupancy > 40) {
      _crowdingLevel = 'critical';
    } else {
      _crowdingLevel = 'moderate';
    }
    notifyListeners();
  }

  Future<void> submitIncident(IncidentReport report) async {
    _conductorAlert =
        'EMERGENCY ALERT: Passenger at Seat ${report.seatLocation} reported ${report.incidentType}. Conductor notified via FCM.';
    await _incidentService.submitIncidentReport(report);
    notifyListeners();
  }

  void completeJourney() {
    _isTrippingMode = false;
    _isJourneyActive = false;
    _isJourneyCompleted = true;
    notifyListeners();
  }

  void endJourney() {
    _isTrippingMode = false;
    _isJourneyActive = false;
    _isJourneyCompleted = false;
    notifyListeners();
  }
}
