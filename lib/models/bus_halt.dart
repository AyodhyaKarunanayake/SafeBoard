import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusHalt {
  final String id;
  final String name;
  final String landmark;
  final double latitude;
  final double longitude;

  const BusHalt({
    required this.id,
    required this.name,
    required this.landmark,
    required this.latitude,
    required this.longitude,
  });

  LatLng get location => LatLng(latitude, longitude);

  String get fullName => '$name — $landmark';
}

class Route87Data {
  static const List<BusHalt> colomboToJaffnaHalts = [
    BusHalt(
      id: 'H01',
      name: 'Colombo (Pettah Central)',
      landmark: 'Main Central Bus Stand',
      latitude: 6.9344,
      longitude: 79.8540,
    ),
    BusHalt(
      id: 'H02',
      name: 'Peliyagoda',
      landmark: 'Kandy Road Interchange',
      latitude: 6.9667,
      longitude: 79.8833,
    ),
    BusHalt(
      id: 'H03',
      name: 'Wattala',
      landmark: 'Negombo Road Town Halt',
      latitude: 6.9892,
      longitude: 79.8928,
    ),
    BusHalt(
      id: 'H04',
      name: 'Kandana',
      landmark: 'Railway & Town Halt',
      latitude: 7.0475,
      longitude: 79.8942,
    ),
    BusHalt(
      id: 'H05',
      name: 'Ja-Ela',
      landmark: 'Highway Interchange',
      latitude: 7.0744,
      longitude: 79.8919,
    ),
    BusHalt(
      id: 'H06',
      name: 'Seeduwa',
      landmark: 'FTZ Industrial Area',
      latitude: 7.1136,
      longitude: 79.8839,
    ),
    BusHalt(
      id: 'H07',
      name: 'Katunayake',
      landmark: 'BIA Airport Junction',
      latitude: 7.1706,
      longitude: 79.8842,
    ),
    BusHalt(
      id: 'H08',
      name: 'Negombo',
      landmark: 'Main Town Bus Stand',
      latitude: 7.2083,
      longitude: 79.8358,
    ),
    BusHalt(
      id: 'H09',
      name: 'Kochchikade',
      landmark: 'Northern Boundary',
      latitude: 7.2650,
      longitude: 79.8600,
    ),
    BusHalt(
      id: 'H10',
      name: 'Marawila',
      landmark: 'Coastal Highway Stop',
      latitude: 7.4167,
      longitude: 79.8167,
    ),
    BusHalt(
      id: 'H11',
      name: 'Chilaw',
      landmark: 'Main Bus Station',
      latitude: 7.5758,
      longitude: 79.7953,
    ),
    BusHalt(
      id: 'H12',
      name: 'Puttalam',
      landmark: 'A9 / A12 Junction',
      latitude: 8.0362,
      longitude: 79.8283,
    ),
    BusHalt(
      id: 'H13',
      name: 'Nochchiyagama',
      landmark: 'Wildlife Corridor Junction',
      latitude: 8.2611,
      longitude: 80.1772,
    ),
    BusHalt(
      id: 'H14',
      name: 'Anuradhapura',
      landmark: 'New Bus Station',
      latitude: 8.3114,
      longitude: 80.4037,
    ),
    BusHalt(
      id: 'H15',
      name: 'Medawachchiya',
      landmark: 'A9 North Railway Junction',
      latitude: 8.5381,
      longitude: 80.4906,
    ),
    BusHalt(
      id: 'H16',
      name: 'Vavuniya',
      landmark: 'Northern Gateway Terminal',
      latitude: 8.7514,
      longitude: 80.4971,
    ),
    BusHalt(
      id: 'H17',
      name: 'Omanthai',
      landmark: 'Security Checkpoint Halt',
      latitude: 8.8683,
      longitude: 80.4858,
    ),
    BusHalt(
      id: 'H18',
      name: 'Puliyankulam',
      landmark: 'A9 Highway Junction',
      latitude: 8.9744,
      longitude: 80.5056,
    ),
    BusHalt(
      id: 'H19',
      name: 'Mankulam',
      landmark: 'A9 Trunk Road Junction',
      latitude: 9.1294,
      longitude: 80.4439,
    ),
    BusHalt(
      id: 'H20',
      name: 'Kilinochchi',
      landmark: 'Central Town Terminal',
      latitude: 9.3803,
      longitude: 80.3997,
    ),
    BusHalt(
      id: 'H21',
      name: 'Elephant Pass',
      landmark: 'Lagoon Cause-way Halt',
      latitude: 9.5256,
      longitude: 80.4022,
    ),
    BusHalt(
      id: 'H22',
      name: 'Pallai (Palei)',
      landmark: 'Northern Rail & Bus Halt',
      latitude: 9.6019,
      longitude: 80.3475,
    ),
    BusHalt(
      id: 'H23',
      name: 'Kodikamam',
      landmark: 'Point Pedro Junction',
      latitude: 9.6786,
      longitude: 80.2078,
    ),
    BusHalt(
      id: 'H24',
      name: 'Chavakachcheri',
      landmark: 'Thenmarachchi Central',
      latitude: 9.6547,
      longitude: 80.1603,
    ),
    BusHalt(
      id: 'H25',
      name: 'Kaithadi',
      landmark: 'University / Bridge Halt',
      latitude: 9.6708,
      longitude: 80.0986,
    ),
    BusHalt(
      id: 'H26',
      name: 'Jaffna Central',
      landmark: 'Main City Bus Stand',
      latitude: 9.6615,
      longitude: 80.0255,
    ),
  ];

  static List<BusHalt> get jaffnaToColomboHalts =>
      colomboToJaffnaHalts.reversed.toList();
}
