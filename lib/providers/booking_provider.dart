import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../models/journey_instance.dart';
import '../models/seat_allocation.dart';
import '../models/passenger.dart';
import '../services/allocation_service.dart';

class BookingProvider with ChangeNotifier {
  final AllocationService _allocationService = AllocationService();

  RouteModel? _selectedRoute;
  String? _boardingStop;
  String? _alightingStop;
  String _direction = 'colombo_to_jaffna'; // 'colombo_to_jaffna' or 'jaffna_to_colombo'
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 5, minute: 0);
  bool _isAllocating = false;
  SeatAllocation? _lastAllocation;
  
  JourneyInstance? _selectedBus;
  List<JourneyInstance> _upcomingBuses = [];
  final Set<String> _excludedSeats = {};
  String _paymentMethod = 'advance_card';
  String _paymentStatus = 'paid';
  String? _notificationMessage;

  RouteModel? get selectedRoute => _selectedRoute;
  String? get boardingStop => _boardingStop;
  String? get alightingStop => _alightingStop;
  String get direction => _direction;
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isAllocating => _isAllocating;
  SeatAllocation? get lastAllocation => _lastAllocation;
  JourneyInstance? get selectedBus => _selectedBus;
  List<JourneyInstance> get upcomingBuses => _upcomingBuses;
  String get paymentMethod => _paymentMethod;
  String get paymentStatus => _paymentStatus;
  String? get notificationMessage => _notificationMessage;

  // Complete 26 Geographical Halts on Route 87 (Colombo - Jaffna via A9) with Key Landmark / Type
  static final List<String> _route87StopsColomboToJaffna = [
    'Colombo (Pettah Central) — Main Central Bus Stand',
    'Peliyagoda — Kandy Road Interchange',
    'Wattala — Negombo Road Town Halt',
    'Kandana — Railway & Town Halt',
    'Ja-Ela — Highway Interchange',
    'Seeduwa — FTZ Industrial Area',
    'Katunayake — BIA Airport Junction',
    'Negombo — Main Town Bus Stand',
    'Kochchikade — Northern Boundary',
    'Marawila — Coastal Highway Stop',
    'Chilaw — Main Bus Station',
    'Puttalam — A9 / A12 Junction',
    'Nochchiyagama — Wildlife Corridor Junction',
    'Anuradhapura — New Bus Station',
    'Medawachchiya — A9 North Railway Junction',
    'Vavuniya — Northern Gateway Terminal',
    'Omanthai — Security Checkpoint Halt',
    'Puliyankulam — A9 Highway Junction',
    'Mankulam — A9 Trunk Road Junction',
    'Kilinochchi — Central Town Terminal',
    'Elephant Pass — Lagoon Cause-way Halt',
    'Pallai (Palei) — Northern Rail & Bus Halt',
    'Kodikamam — Point Pedro Junction',
    'Chavakachcheri — Thenmarachchi Central',
    'Kaithadi — University / Bridge Halt',
    'Jaffna Central — Main City Bus Stand',
  ];

  static List<String> get _route87StopsJaffnaToColombo =>
      _route87StopsColomboToJaffna.reversed.toList();

  // Mock list of Ceylon Bus Departures with time schedules
  final List<JourneyInstance> _availableJourneys = [
    JourneyInstance(
      journeyId: 'JRN_87_001',
      busId: 'BUS_NB_8701',
      routeId: 'R_87',
      conductorId: 'COND_882',
      departureDatetime: DateTime.now().add(const Duration(hours: 1, minutes: 15)),
      arrivalDatetime: DateTime.now().add(const Duration(hours: 8, minutes: 30)),
      currentOccupancy: 28,
      standingCount: 4,
      currentStop: 'Colombo (Pettah Central)',
      crowdingLevel: 'moderate',
      status: 'scheduled',
      priorityOccupied: 4,
      generalOccupied: 20,
    ),
    JourneyInstance(
      journeyId: 'JRN_87_002',
      busId: 'BUS_NB_8702',
      routeId: 'R_87',
      conductorId: 'COND_419',
      departureDatetime: DateTime.now().add(const Duration(hours: 3, minutes: 30)),
      arrivalDatetime: DateTime.now().add(const Duration(hours: 10, minutes: 45)),
      currentOccupancy: 18,
      standingCount: 0,
      currentStop: 'Colombo (Pettah Central)',
      crowdingLevel: 'low',
      status: 'scheduled',
      priorityOccupied: 2,
      generalOccupied: 16,
    ),
    JourneyInstance(
      journeyId: 'JRN_87_003',
      busId: 'BUS_NB_8703',
      routeId: 'R_87',
      conductorId: 'COND_730',
      departureDatetime: DateTime.now().add(const Duration(hours: 6, minutes: 0)),
      arrivalDatetime: DateTime.now().add(const Duration(hours: 13, minutes: 15)),
      currentOccupancy: 36,
      standingCount: 8,
      currentStop: 'Puttalam',
      crowdingLevel: 'high',
      status: 'scheduled',
      priorityOccupied: 6,
      generalOccupied: 22,
    ),
    JourneyInstance(
      journeyId: 'JRN_87_004',
      busId: 'BUS_NB_8704',
      routeId: 'R_87',
      conductorId: 'COND_512',
      departureDatetime: DateTime.now().add(const Duration(hours: 9, minutes: 30)),
      arrivalDatetime: DateTime.now().add(const Duration(hours: 16, minutes: 45)),
      currentOccupancy: 20,
      standingCount: 1,
      currentStop: 'Colombo (Pettah Central)',
      crowdingLevel: 'low',
      status: 'scheduled',
      priorityOccupied: 3,
      generalOccupied: 17,
    ),
  ];

  // Primary Route 87 Model
  final List<RouteModel> sampleRoutes = [
    RouteModel(
      routeId: 'R_87',
      routeName: 'Route 87',
      startPoint: 'Colombo (Pettah Central)',
      endPoint: 'Jaffna Central',
      totalStops: 26,
      distanceKm: 396.0,
      routeType: 'Interprovincial Express AC',
      status: 'active',
      stops: _route87StopsColomboToJaffna,
    ),
    RouteModel(
      routeId: 'R_138',
      routeName: 'Route 138',
      startPoint: 'Pettah Main Station',
      endPoint: 'Homagama / NSBM Campus',
      totalStops: 10,
      distanceKm: 28.5,
      routeType: 'High Capacity AC',
      status: 'active',
      stops: [
        'Pettah Main Station',
        'Colombo Fort',
        'Town Hall',
        'Borella',
        'Nugegoda',
        'Maharagama',
        'Kottawa',
        'Makumbura MMC',
        'NSBM Green University Campus',
        'Homagama Bus Stand',
      ],
    ),
  ];

  BookingProvider() {
    _selectedRoute = sampleRoutes.first;
    _boardingStop = _route87StopsColomboToJaffna.first;
    _alightingStop = _route87StopsColomboToJaffna.last;
    _updateBusMatches();
  }

  void setDirection(String dir) {
    _direction = dir;
    final stopsList = dir == 'colombo_to_jaffna'
        ? _route87StopsColomboToJaffna
        : _route87StopsJaffnaToColombo;

    _selectedRoute = RouteModel(
      routeId: 'R_87',
      routeName: 'Route 87',
      startPoint: stopsList.first,
      endPoint: stopsList.last,
      totalStops: stopsList.length,
      distanceKm: 396.0,
      routeType: 'Interprovincial Express AC',
      status: 'active',
      stops: stopsList,
    );
    _boardingStop = stopsList.first;
    _alightingStop = stopsList.last;
    _updateBusMatches();
    notifyListeners();
  }

  void selectRoute(RouteModel route) {
    _selectedRoute = route;
    _boardingStop = route.stops.isNotEmpty ? route.stops.first : null;
    _alightingStop = route.stops.length > 1 ? route.stops.last : null;
    _updateBusMatches();
    notifyListeners();
  }

  void setTravelDate(DateTime date) {
    _selectedDate = date;
    _updateBusMatches();
    notifyListeners();
  }

  void setStartingTime(TimeOfDay time) {
    _selectedTime = time;
    _updateBusMatches();
    notifyListeners();
  }

  void setBoardingStop(String stop) {
    _boardingStop = stop;
    _updateBusMatches();
    notifyListeners();
  }

  void setAlightingStop(String stop) {
    _alightingStop = stop;
    notifyListeners();
  }

  void setSelectedBus(JourneyInstance bus) {
    _selectedBus = bus;
    notifyListeners();
  }

  void setPaymentOptions({required String method, required String status}) {
    _paymentMethod = method;
    _paymentStatus = status;
    notifyListeners();
  }

  Future<void> completePayment() async {
    _paymentStatus = 'paid_online';
    _notificationMessage =
        'Payment of LKR 1,250 Successful! Your booking for Seat ${_lastAllocation?.seatNumber ?? '3A'} on Bus ${_selectedBus?.busId ?? 'NB-8701'} is confirmed. SMS & In-app ticket generated.';
    notifyListeners();
  }

  JourneyInstance? _bestFitBus;
  List<JourneyInstance> _otherBuses = [];

  JourneyInstance? get bestFitBus => _bestFitBus;
  List<JourneyInstance> get otherBuses => _otherBuses;

  void _updateBusMatches() {
    final routeId = _selectedRoute?.routeId ?? 'R_87';

    // Build a reference DateTime from selected date + selected time
    final refDt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Keep only buses on this route whose departure is at-or-after the chosen time
    final eligible = _availableJourneys
        .where((j) =>
            j.routeId == routeId &&
            !j.departureDatetime.isBefore(refDt))
        .toList()
      ..sort((a, b) => a.departureDatetime.compareTo(b.departureDatetime));

    if (eligible.isNotEmpty) {
      _bestFitBus = eligible.first; // closest departure ≥ requested time
      _selectedBus = _bestFitBus;
      _otherBuses = eligible.skip(1).toList();
      _upcomingBuses = eligible;
    } else {
      // Fallback: show all route buses sorted soonest-first
      final fallback = _availableJourneys
          .where((j) => j.routeId == routeId)
          .toList()
        ..sort((a, b) => a.departureDatetime.compareTo(b.departureDatetime));
      _bestFitBus = fallback.isNotEmpty ? fallback.first : null;
      _selectedBus = _bestFitBus;
      _otherBuses = fallback.skip(1).toList();
      _upcomingBuses = fallback;
    }
  }

  Future<SeatAllocation> requestAllocation(Passenger passenger) async {
    _isAllocating = true;
    notifyListeners();

    final route = _selectedRoute ?? sampleRoutes.first;
    final bStop = _boardingStop ?? route.stops.first;
    final aStop = _alightingStop ?? route.stops.last;
    final bus = _selectedBus ?? _availableJourneys.first;

    try {
      final allocation = await _allocationService.allocateSeat(
        passenger: passenger,
        journeyId: bus.journeyId,
        routeId: route.routeId,
        busId: bus.busId,
        boardingStop: bStop,
        alightingStop: aStop,
      );
      _excludedSeats.add(allocation.seatNumber);
      _lastAllocation = allocation;
      return allocation;
    } finally {
      _isAllocating = false;
      notifyListeners();
    }
  }

  Future<SeatAllocation> reallocateSeat(Passenger passenger) async {
    _isAllocating = true;
    notifyListeners();

    final route = _selectedRoute ?? sampleRoutes.first;
    final bStop = _boardingStop ?? route.stops.first;
    final aStop = _alightingStop ?? route.stops.last;
    final bus = _selectedBus ?? _availableJourneys.first;

    try {
      // Allocate seat excluding seats in _excludedSeats
      final allocation = await _allocationService.allocateSeat(
        passenger: passenger,
        journeyId: bus.journeyId,
        routeId: route.routeId,
        busId: bus.busId,
        boardingStop: bStop,
        alightingStop: aStop,
      );

      // If allocated seat was already offered, pick next available seat safely
      String newSeatNo = allocation.seatNumber;
      if (_excludedSeats.contains(newSeatNo)) {
        final altSeats = ['2A', '2B', '3B', '4A', '4B', '5A', '5B'];
        for (var alt in altSeats) {
          if (!_excludedSeats.contains(alt)) {
            newSeatNo = alt;
            break;
          }
        }
      }

      _excludedSeats.add(newSeatNo);

      final reallocated = SeatAllocation(
        allocationId: 'alloc_${DateTime.now().millisecondsSinceEpoch}',
        bookingId: allocation.bookingId,
        seatId: newSeatNo,
        seatNumber: newSeatNo,
        busId: bus.busId,
        journeyId: bus.journeyId,
        allocationDatetime: DateTime.now(),
        boardingStop: bStop,
        alightingStop: aStop,
        allocationType: 'reallocated',
        riskScore: allocation.riskScore,
        status: 'confirmed',
        qrCode: 'SB-${bus.journeyId}-$newSeatNo-PASS_${passenger.passengerId}',
      );

      _lastAllocation = reallocated;
      return reallocated;
    } finally {
      _isAllocating = false;
      notifyListeners();
    }
  }
}
