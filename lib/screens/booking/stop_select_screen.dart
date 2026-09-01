import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/booking_provider.dart';
import '../../models/journey_instance.dart';
import '../../models/bus_halt.dart';
import '../../constants/colors.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class StopSelectScreen extends StatefulWidget {
  const StopSelectScreen({super.key});

  @override
  State<StopSelectScreen> createState() => _StopSelectScreenState();
}

class _StopSelectScreenState extends State<StopSelectScreen> with SingleTickerProviderStateMixin {
  BusHalt? _selectedBoardingHalt;
  BusHalt? _selectedAlightingHalt;
  DateTime _travelDate = DateTime.now();
  TimeOfDay _startingTime = const TimeOfDay(hour: 5, minute: 0);
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    final booking = Provider.of<BookingProvider>(context, listen: false);
    _travelDate = booking.selectedDate;
    _startingTime = booking.selectedTime;
    _initDefaultHalts(booking.direction);
  }

  void _initDefaultHalts(String direction) {
    final halts = direction == 'colombo_to_jaffna'
        ? Route87Data.colomboToJaffnaHalts
        : Route87Data.jaffnaToColomboHalts;

    _selectedBoardingHalt = halts.first;
    _selectedAlightingHalt = halts.last;
  }

  void _onDirectionChanged(String newDirection, BookingProvider bookingProvider) {
    bookingProvider.setDirection(newDirection);
    final halts = newDirection == 'colombo_to_jaffna'
        ? Route87Data.colomboToJaffnaHalts
        : Route87Data.jaffnaToColomboHalts;

    setState(() {
      _selectedBoardingHalt = halts.first;
      _selectedAlightingHalt = halts.last;
    });

    bookingProvider.setBoardingStop(_selectedBoardingHalt!.fullName);
    bookingProvider.setAlightingStop(_selectedAlightingHalt!.fullName);

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedBoardingHalt!.location, 8.5),
      );
    }
  }

  void _selectBoardingHalt(BusHalt halt, BookingProvider bookingProvider) {
    setState(() {
      _selectedBoardingHalt = halt;
    });
    bookingProvider.setBoardingStop(halt.fullName);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(halt.location, 11.5),
    );
  }

  void _selectAlightingHalt(BusHalt halt, BookingProvider bookingProvider) {
    setState(() {
      _selectedAlightingHalt = halt;
    });
    bookingProvider.setAlightingStop(halt.fullName);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(halt.location, 11.5),
    );
  }

  void _onHaltMarkerTapped(BusHalt halt, BookingProvider bookingProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_bus, color: AppColors.primaryNavy),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      halt.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                halt.landmark,
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _selectBoardingHalt(halt, bookingProvider);
                      },
                      icon: const Icon(Icons.trip_origin, size: 16),
                      label: const Text('Set as Boarding', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.generalAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _selectAlightingHalt(halt, bookingProvider);
                      },
                      icon: const Icon(Icons.place, size: 16),
                      label: const Text('Set as Alighting', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.priorityAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Set<Marker> _buildMapMarkers(List<BusHalt> halts, BookingProvider bookingProvider) {
    final Set<Marker> markers = {};

    for (var halt in halts) {
      final isBoarding = _selectedBoardingHalt?.id == halt.id;
      final isAlighting = _selectedAlightingHalt?.id == halt.id;

      double hue = BitmapDescriptor.hueAzure;
      if (isBoarding) hue = BitmapDescriptor.hueGreen;
      if (isAlighting) hue = BitmapDescriptor.hueRose;

      markers.add(
        Marker(
          markerId: MarkerId(halt.id),
          position: halt.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          infoWindow: InfoWindow(
            title: isBoarding
                ? '🟢 BOARDING: ${halt.name}'
                : (isAlighting ? '🔴 ALIGHTING: ${halt.name}' : halt.name),
            snippet: halt.landmark,
          ),
          onTap: () => _onHaltMarkerTapped(halt, bookingProvider),
        ),
      );
    }
    return markers;
  }

  Set<Polyline> _buildRoutePolyline(List<BusHalt> halts) {
    return {
      Polyline(
        polylineId: const PolylineId('route_87_line'),
        points: halts.map((h) => h.location).toList(),
        color: AppColors.primaryNavy,
        width: 4,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final isColomboToJaffna = bookingProvider.direction == 'colombo_to_jaffna';
    final halts = isColomboToJaffna
        ? Route87Data.colomboToJaffnaHalts
        : Route87Data.jaffnaToColomboHalts;

    final suggestedBus = bookingProvider.selectedBus;
    final upcomingBuses = bookingProvider.upcomingBuses;

    final isBothSelected = _selectedBoardingHalt != null &&
        _selectedAlightingHalt != null &&
        _selectedBoardingHalt!.id != _selectedAlightingHalt!.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Select Bus (Route 87)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Direction Toggle Selector (Colombo ➔ Jaffna vs Jaffna ➔ Colombo)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onDirectionChanged('colombo_to_jaffna', bookingProvider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isColomboToJaffna ? AppColors.primaryNavy : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Colombo ➔ Jaffna',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isColomboToJaffna ? Colors.white : AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _onDirectionChanged('jaffna_to_colombo', bookingProvider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !isColomboToJaffna ? AppColors.primaryNavy : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Jaffna ➔ Colombo',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: !isColomboToJaffna ? Colors.white : AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown & Map Selection Title
            const Text(
              'Select Boarding & Alighting Stops',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Select halts from the dropdowns below OR tap physical stop markers directly on the Google Map.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),

            // Interactive Google Map View Component
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryNavy.withValues(alpha: 0.3), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _selectedBoardingHalt?.location ?? halts.first.location,
                        zoom: 7.2,
                      ),
                      markers: _buildMapMarkers(halts, bookingProvider),
                      polylines: _buildRoutePolyline(halts),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: false,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.touch_app, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Tap map pin to select stop',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // SYNCHRONIZED DROPDOWN CONTROLS
            // Boarding Stop Dropdown
            const Row(
              children: [
                Icon(Icons.trip_origin, color: AppColors.generalAccent, size: 18),
                SizedBox(width: 6),
                Text(
                  'Boarding Stop (Dropdown)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.generalText),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.generalAccent, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<BusHalt>(
                  value: _selectedBoardingHalt,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.generalAccent),
                  items: halts.map((halt) {
                    return DropdownMenuItem<BusHalt>(
                      value: halt,
                      child: Text(
                        halt.fullName,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (newHalt) {
                    if (newHalt != null) {
                      _selectBoardingHalt(newHalt, bookingProvider);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Alighting Stop Dropdown
            const Row(
              children: [
                Icon(Icons.place, color: AppColors.priorityAccent, size: 18),
                SizedBox(width: 6),
                Text(
                  'Alighting Stop / Destination (Dropdown)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.priorityText),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.priorityAccent, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<BusHalt>(
                  value: _selectedAlightingHalt,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.priorityAccent),
                  items: halts.map((halt) {
                    return DropdownMenuItem<BusHalt>(
                      value: halt,
                      child: Text(
                        halt.fullName,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (newHalt) {
                    if (newHalt != null) {
                      _selectAlightingHalt(newHalt, bookingProvider);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Date & Time Picker Controls Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  // Date Picker
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _travelDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null) {
                          setState(() {
                            _travelDate = picked;
                          });
                          bookingProvider.setTravelDate(picked);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TRAVEL DATE',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: AppColors.generalAccent),
                              const SizedBox(width: 6),
                              Text(
                                '${_travelDate.day}/${_travelDate.month}/${_travelDate.year}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 30, width: 1, color: AppColors.borderLight),
                  const SizedBox(width: 12),

                  // Time Picker
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _startingTime,
                        );
                        if (picked != null) {
                          setState(() {
                            _startingTime = picked;
                          });
                          bookingProvider.setStartingTime(picked);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'STARTING TIME',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: AppColors.generalAccent),
                              const SizedBox(width: 6),
                              Text(
                                _startingTime.format(context),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Suggested Bus & Upcoming Departures Section
            const Text(
              'Suggested & Upcoming Buses',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 8),

            if (suggestedBus != null)
              Column(
                children: upcomingBuses.map((JourneyInstance bus) {
                  final isSelected = bookingProvider.selectedBus?.busId == bus.busId;
                  final String timeStr =
                      '${bus.departureDatetime.hour.toString().padLeft(2, '0')}:${bus.departureDatetime.minute.toString().padLeft(2, '0')} AM';
                  final int seatsAvail = (56 - bus.currentOccupancy).toInt();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.generalBg : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.generalAccent : AppColors.borderLight,
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Bus ${bus.busId}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(width: 8),
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.generalAccent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'BEST MATCH',
                                      style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Departs $timeStr from ${_selectedBoardingHalt?.name ?? 'Pettah'}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$seatsAvail Seats Free',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: seatsAvail > 10 ? Colors.green : AppColors.standingAccent,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ElevatedButton(
                              onPressed: () {
                                bookingProvider.setSelectedBus(bus);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected ? AppColors.generalAccent : AppColors.primaryNavy,
                                minimumSize: const Size(70, 32),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              child: Text(isSelected ? 'Selected' : 'Select'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 28),

            // Confirm Button
            ElevatedButton(
              onPressed: isBothSelected
                  ? () {
                      context.go('/requesting');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isBothSelected ? AppColors.primaryNavy : Colors.grey.shade400,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Proceed to Seat Allocation →'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}
