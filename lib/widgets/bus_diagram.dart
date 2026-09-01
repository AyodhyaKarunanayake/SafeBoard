import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BusDiagram extends StatelessWidget {
  final String allocatedSeat; // e.g. "3A"

  const BusDiagram({
    super.key,
    required this.allocatedSeat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Realistic Front Header: Driver Cabin (Right) & Front Entry Door (Left)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryNavy.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Front Entry Door (Left Side)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.sensor_door_outlined, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'FRONT DOOR (ENTRY)',
                        style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Driver Cabin (Right Side)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.airline_seat_recline_extra, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'DRIVER CABIN',
                        style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 10 Rows Grid (2 Left, 3 Right = 50 Seats)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              int rowNum = index + 1;
              bool isPriority = rowNum <= 3;
              bool isDualPurpose = rowNum >= 8;

              Color zoneBg = isPriority
                  ? AppColors.priorityBg
                  : (isDualPurpose ? AppColors.standingBg : AppColors.generalBg);
              Color zoneAccent = isPriority
                  ? AppColors.priorityAccent
                  : (isDualPurpose ? AppColors.standingAccent : AppColors.generalAccent);
              Color zoneText = isPriority
                  ? AppColors.priorityText
                  : (isDualPurpose ? AppColors.standingText : AppColors.generalText);

              return Column(
                children: [
                  // Insert Realistic Rear Exit Door between Row 7 and Row 8
                  if (rowNum == 8)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.door_back_door_outlined, size: 14, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'REAR DOOR (EXIT & STANDING ACCESS)',
                            style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        // Row indicator / Zone label
                        SizedBox(
                          width: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Row $rowNum',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: zoneText,
                                ),
                              ),
                              if (rowNum == 1)
                                const Text(
                                  'PRIORITY',
                                  style: TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.priorityAccent,
                                  ),
                                ),
                              if (rowNum == 4)
                                const Text(
                                  'GENERAL',
                                  style: TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.generalAccent,
                                  ),
                                ),
                              if (rowNum == 8)
                                const Text(
                                  'DUAL+STAND',
                                  style: TextStyle(
                                    fontSize: 6.5,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.standingAccent,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Left 2 seats: e.g. 1A, 1B
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(child: _buildSeatCell('${rowNum}A', isPriority, zoneBg, zoneAccent)),
                              const SizedBox(width: 3),
                              Expanded(child: _buildSeatCell('${rowNum}B', isPriority, zoneBg, zoneAccent)),
                            ],
                          ),
                        ),

                        // Central Aisle Gap (Dual-Purpose standing allowance with fever-distance indicator)
                        Container(
                          width: 22,
                          alignment: Alignment.center,
                          child: Text(
                            isDualPurpose ? '🚶' : '|',
                            style: TextStyle(
                              color: isDualPurpose ? AppColors.standingAccent : AppColors.textMuted.withValues(alpha: 0.3),
                              fontSize: isDualPurpose ? 9 : 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Right 3 seats: e.g. 1C, 1D, 1E
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(child: _buildSeatCell('${rowNum}C', isPriority, zoneBg, zoneAccent)),
                              const SizedBox(width: 3),
                              Expanded(child: _buildSeatCell('${rowNum}D', isPriority, zoneBg, zoneAccent)),
                              const SizedBox(width: 3),
                              Expanded(child: _buildSeatCell('${rowNum}E', isPriority, zoneBg, zoneAccent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 6),

          // Row 11: Final Back Row with Exactly 6 Continuous Seats (11A, 11B, 11C, 11D, 11E, 11F)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                const SizedBox(
                  width: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Row 11',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.standingText,
                        ),
                      ),
                      Text(
                        '6-SEAT BENCH',
                        style: TextStyle(
                          fontSize: 6,
                          fontWeight: FontWeight.w900,
                          color: AppColors.standingAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.standingBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.standingAccent.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildSeatCell('11A', false, AppColors.standingBg, AppColors.standingAccent)),
                        const SizedBox(width: 2),
                        Expanded(child: _buildSeatCell('11B', false, AppColors.standingBg, AppColors.standingAccent)),
                        const SizedBox(width: 2),
                        Expanded(child: _buildSeatCell('11C', false, AppColors.standingBg, AppColors.standingAccent)),
                        const SizedBox(width: 2),
                        Expanded(child: _buildSeatCell('11D', false, AppColors.standingBg, AppColors.standingAccent)),
                        const SizedBox(width: 2),
                        Expanded(child: _buildSeatCell('11E', false, AppColors.standingBg, AppColors.standingAccent)),
                        const SizedBox(width: 2),
                        Expanded(child: _buildSeatCell('11F', false, AppColors.standingBg, AppColors.standingAccent)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Dual-Purpose Rear Section & Standing Passenger Spacing Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.standingBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.standingAccent,
                width: 1.5,
              ),
            ),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_seat, size: 14, color: AppColors.standingText),
                    SizedBox(width: 4),
                    Icon(Icons.directions_walk, size: 14, color: AppColors.standingText),
                    SizedBox(width: 6),
                    Text(
                      '56 SEATS + DUAL-PURPOSE REAR STANDING (ROWS 8-11)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.standingText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Rows 1-10 (50 seats) + Row 11 (6 bench seats) = 56 total seats. Standing passengers occupy rear aisle (Max 18 standing with fever-distance buffer).',
                  style: TextStyle(fontSize: 9.5, color: AppColors.standingText),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Rear Door Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.door_back_door_outlined, size: 14, color: AppColors.primaryNavy),
                SizedBox(width: 6),
                Text(
                  'Rear Door (Exit)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatCell(String seatNo, bool isPriority, Color bg, Color accent) {
    final bool isAllocated = seatNo.toUpperCase() == allocatedSeat.toUpperCase();

    if (isAllocated) {
      return Transform.scale(
        scale: 1.08,
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.5),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 12, color: Colors.white),
              Text(
                seatNo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      alignment: Alignment.center,
      child: Text(
        seatNo,
        style: TextStyle(
          color: isPriority ? AppColors.priorityText : AppColors.generalText,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
