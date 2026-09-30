import '../models/road_sign_model.dart';

class RoadSignsData {
  static const String categoryRegulatory = 'Regulatory';
  static const String categoryWarning = 'Warning';
  static const String categoryInformative = 'Informative';
  static const String categoryGuide = 'Guide';
  static const String categoryRoadWork = 'Road Work';

  static const List<String> allCategories = [
    categoryRegulatory,
    categoryWarning,
    categoryInformative,
    categoryGuide,
    categoryRoadWork,
  ];

  static const List<RoadSignModel> allSigns = [
    // ==========================================
    // 1. REGULATORY SIGNS (15)
    // DPWH Highway Safety Design Standards (Part 2) / RA 4136
    // ==========================================
    RoadSignModel(
      id: 'reg_01',
      name: 'Stop Sign',
      category: categoryRegulatory,
      meaning: 'Driver must bring vehicle to a complete stop before the stop line and proceed only when safe.',
      description: 'Red octagonal sign with white capital letters STOP and a white border.',
      usage: 'Installed at intersections without traffic signals, before entering a major highway, or at railway crossings.',
      signType: 'stop',
      sourceReference: 'DPWH Road Signs Manual (R1-1); RA 4136 Sec. 42',
    ),
    RoadSignModel(
      id: 'reg_02',
      name: 'Give Way / Yield',
      category: categoryRegulatory,
      meaning: 'Driver must yield the right of way to vehicles approaching or crossing the intersection.',
      description: 'Inverted equilateral triangle with a broad red border and a white interior.',
      usage: 'Placed at junction entrances where stopping is not mandatory if the roadway is clear.',
      signType: 'yield',
      sourceReference: 'DPWH Road Signs Manual (R1-2); RA 4136 Sec. 42',
    ),
    RoadSignModel(
      id: 'reg_03',
      name: 'No Entry',
      category: categoryRegulatory,
      meaning: 'No vehicular traffic is permitted to enter the street or roadway beyond this point.',
      description: 'Circular sign with a solid red background and a horizontal white bar across the center.',
      usage: 'Posted at the exits of one-way streets, closed access ramps, and prohibited zones.',
      signType: 'no_entry',
      sourceReference: 'DPWH Road Signs Manual (R2-1); RA 4136',
    ),
    RoadSignModel(
      id: 'reg_04',
      name: 'No U-Turn',
      category: categoryRegulatory,
      meaning: 'Vehicles are strictly prohibited from making a 180-degree turn to reverse direction.',
      description: 'Circular white sign with a red border, black U-turn arrow, and a diagonal red slash.',
      usage: 'Installed on divided highways, busy intersections, and median openings where U-turns pose safety hazards.',
      signType: 'no_u_turn',
      sourceReference: 'DPWH Road Signs Manual (R2-4); RA 4136',
    ),
    RoadSignModel(
      id: 'reg_05',
      name: 'No Left Turn',
      category: categoryRegulatory,
      meaning: 'Drivers may not turn left at the upcoming intersection or roadway opening.',
      description: 'Circular white sign with a red border, black left-curving arrow, and a diagonal red slash.',
      usage: 'Used where left turns would cross heavy opposing traffic or enter one-way passages.',
      signType: 'no_left_turn',
      sourceReference: 'DPWH Road Signs Manual (R2-2); RA 4136',
    ),
    RoadSignModel(
      id: 'reg_06',
      name: 'No Right Turn',
      category: categoryRegulatory,
      meaning: 'Drivers may not turn right at the intersection or point of placement.',
      description: 'Circular white sign with a red border, black right-curving arrow, and a diagonal red slash.',
      usage: 'Placed where right-turning movements are prohibited due to one-way traffic or pedestrian safety.',
      signType: 'no_right_turn',
      sourceReference: 'DPWH Road Signs Manual (R2-3); RA 4136',
    ),
    RoadSignModel(
      id: 'reg_07',
      name: 'Speed Limit 60 km/h',
      category: categoryRegulatory,
      meaning: 'Maximum permitted legal speed limit is 60 kilometers per hour under normal conditions.',
      description: 'Circular white sign with a red outer ring and the black number 60 centered.',
      usage: 'Posted on secondary highways, arterial boulevards, and designated non-expressway thoroughfares.',
      signType: 'speed_limit_60',
      sourceReference: 'DPWH Road Signs Manual (R4-1); RA 4136 Sec. 35',
    ),
    RoadSignModel(
      id: 'reg_08',
      name: 'Speed Limit 80 km/h',
      category: categoryRegulatory,
      meaning: 'Maximum permitted legal speed limit is 80 kilometers per hour.',
      description: 'Circular white sign with a red outer ring and the black number 80 centered.',
      usage: 'Standard maximum speed limit on open provincial highways and certain expressway truck lanes.',
      signType: 'speed_limit_80',
      sourceReference: 'DPWH Road Signs Manual (R4-1); RA 4136 Sec. 35',
    ),
    RoadSignModel(
      id: 'reg_09',
      name: 'No Overtaking',
      category: categoryRegulatory,
      meaning: 'Drivers must not pass or overtake another moving vehicle in this zone.',
      description: 'Circular white sign with a red border showing two cars side-by-side (one red, one black).',
      usage: 'Installed before blind curves, bridges, narrow sections, and hazardous crests.',
      signType: 'no_overtaking',
      sourceReference: 'DPWH Road Signs Manual (R2-5); RA 4136 Sec. 41',
    ),
    RoadSignModel(
      id: 'reg_10',
      name: 'Keep Right',
      category: categoryRegulatory,
      meaning: 'Vehicles must pass or stay to the right side of an island, obstruction, or divider.',
      description: 'Circular blue sign with a bold white arrow pointing downward to the right.',
      usage: 'Placed on traffic islands, median noses, and road channelization obstacles.',
      signType: 'keep_right',
      sourceReference: 'DPWH Road Signs Manual (R3-1R)',
    ),
    RoadSignModel(
      id: 'reg_11',
      name: 'Keep Left',
      category: categoryRegulatory,
      meaning: 'Vehicles must pass or stay to the left side of a divider, barrier, or obstruction.',
      description: 'Circular blue sign with a bold white arrow pointing downward to the left.',
      usage: 'Used at channelized islands or road work barriers directing traffic toward the left lane.',
      signType: 'keep_left',
      sourceReference: 'DPWH Road Signs Manual (R3-1L)',
    ),
    RoadSignModel(
      id: 'reg_12',
      name: 'No Parking',
      category: categoryRegulatory,
      meaning: 'Vehicles are not permitted to park in this area during regulated periods.',
      description: 'Circular white sign with a red ring, black letter P, and a diagonal red slash.',
      usage: 'Posted along congested urban roadways, emergency lanes, and designated tow-away zones.',
      signType: 'no_parking',
      sourceReference: 'DPWH Road Signs Manual (R5-1); RA 4136 Sec. 46',
    ),
    RoadSignModel(
      id: 'reg_13',
      name: 'No Stopping / No Waiting',
      category: categoryRegulatory,
      meaning: 'Drivers may not stop or wait even momentarily, except to avoid a conflict or comply with traffic direction.',
      description: 'Circular blue or white sign with a red outer ring and a bold red X across.',
      usage: 'Installed on primary urban arteries, yellow box approaches, and bridge decks.',
      signType: 'no_stopping',
      sourceReference: 'DPWH Road Signs Manual (R5-2)',
    ),
    RoadSignModel(
      id: 'reg_14',
      name: 'No Horn / Silence Zone',
      category: categoryRegulatory,
      meaning: 'Sounding of vehicle horn is prohibited except in emergency situations to avoid imminent collision.',
      description: 'Circular white sign with a red border, black vehicle horn silhouette, and a diagonal red slash.',
      usage: 'Posted near hospitals, medical clinics, schools, and courthouses.',
      signType: 'no_horn',
      sourceReference: 'DPWH Road Signs Manual (R2-11)',
    ),
    RoadSignModel(
      id: 'reg_15',
      name: 'Pedestrians Prohibited',
      category: categoryRegulatory,
      meaning: 'Pedestrians are strictly forbidden from walking on, across, or along this roadway.',
      description: 'Circular white sign with a red border, black silhouette of a walking person, and a diagonal red slash.',
      usage: 'Installed on expressways, flyovers, vehicular tunnels, and high-speed bypasses.',
      signType: 'no_pedestrians',
      sourceReference: 'DPWH Road Signs Manual (R2-12)',
    ),

    // ==========================================
    // 2. WARNING SIGNS (15)
    // DPWH Highway Safety Design Standards (Part 2)
    // ==========================================
    RoadSignModel(
      id: 'warn_01',
      name: 'Sharp Turn Left',
      category: categoryWarning,
      meaning: 'Warns of a sharp curve or 90-degree bend to the left; reduce speed before entering.',
      description: 'Yellow diamond or red-bordered triangle with a black arrow curving sharply left.',
      usage: 'Placed before sharp road bends where safe travel speed is significantly lower than roadway limit.',
      signType: 'sharp_turn_left',
      sourceReference: 'DPWH Road Signs Manual (W1-1L)',
    ),
    RoadSignModel(
      id: 'warn_02',
      name: 'Sharp Turn Right',
      category: categoryWarning,
      meaning: 'Warns of a sharp curve or bend to the right; driver should slow down and maintain lane discipline.',
      description: 'Yellow diamond or red-bordered triangle with a black arrow curving sharply right.',
      usage: 'Placed before right-hand curves requiring speed reduction to maintain stability.',
      signType: 'sharp_turn_right',
      sourceReference: 'DPWH Road Signs Manual (W1-1R)',
    ),
    RoadSignModel(
      id: 'warn_03',
      name: 'Winding Road Ahead',
      category: categoryWarning,
      meaning: 'Warns of a series of closely spaced curves ahead, beginning with the indicated direction.',
      description: 'Yellow diamond with a black serpentine/curved arrow symbol.',
      usage: 'Posted on mountainous or hilly terrain before winding passes.',
      signType: 'winding_road',
      sourceReference: 'DPWH Road Signs Manual (W1-3)',
    ),
    RoadSignModel(
      id: 'warn_04',
      name: 'Crossroad / Intersection Ahead',
      category: categoryWarning,
      meaning: 'Warns that an intersecting public road crosses the highway ahead; prepare for crossing traffic.',
      description: 'Yellow diamond with a bold black plus (+) symbol.',
      usage: 'Installed in advance of rural or unsignalized four-leg intersections.',
      signType: 'crossroad_ahead',
      sourceReference: 'DPWH Road Signs Manual (W1-4)',
    ),
    RoadSignModel(
      id: 'warn_05',
      name: 'T-Junction Ahead',
      category: categoryWarning,
      meaning: 'Warns that the road terminates at an upcoming T-intersection; prepare to turn left or right.',
      description: 'Yellow diamond with a bold black T symbol.',
      usage: 'Posted on side roads ending at perpendicular arterial roads.',
      signType: 't_junction_ahead',
      sourceReference: 'DPWH Road Signs Manual (W1-5)',
    ),
    RoadSignModel(
      id: 'warn_06',
      name: 'Narrow Road Ahead',
      category: categoryWarning,
      meaning: 'Warns that the width of the carriageway is reduced ahead; check oncoming traffic.',
      description: 'Yellow diamond showing roadway lines that taper inward from both sides.',
      usage: 'Installed prior to one-lane bridges, construction transitions, or pavement width reductions.',
      signType: 'narrow_road_ahead',
      sourceReference: 'DPWH Road Signs Manual (W2-1)',
    ),
    RoadSignModel(
      id: 'warn_07',
      name: 'Slippery When Wet',
      category: categoryWarning,
      meaning: 'Road surface may be particularly slick or slippery when wet or raining; reduce speed.',
      description: 'Yellow diamond featuring a car with serpentine skid marks trailing beneath its wheels.',
      usage: 'Posted near polished asphalt sections, steel deck bridges, or areas prone to water ponding.',
      signType: 'slippery_road',
      sourceReference: 'DPWH Road Signs Manual (W2-4)',
    ),
    RoadSignModel(
      id: 'warn_08',
      name: 'Steep Descent Ahead',
      category: categoryWarning,
      meaning: 'Warns of a steep downgrade; shift to a lower gear to assist braking and prevent brake fade.',
      description: 'Yellow diamond showing a vehicle on a downward-inclined ramp or percentage incline.',
      usage: 'Placed at the crest of steep mountain passes or long continuous downgrades.',
      signType: 'steep_descent',
      sourceReference: 'DPWH Road Signs Manual (W2-5)',
    ),
    RoadSignModel(
      id: 'warn_09',
      name: 'Falling Rocks / Landslide Area',
      category: categoryWarning,
      meaning: 'Warns of the hazard of rockfalls, debris, or landslides on the roadway ahead.',
      description: 'Yellow diamond depicting rocks tumbling down a steep cliff face.',
      usage: 'Installed on mountain cuts, hillside highways, and canyon roads during rainy seasons.',
      signType: 'falling_rocks',
      sourceReference: 'DPWH Road Signs Manual (W2-7)',
    ),
    RoadSignModel(
      id: 'warn_10',
      name: 'Traffic Signals Ahead',
      category: categoryWarning,
      meaning: 'Warns of an upcoming signalized intersection; be prepared to slow down or stop on amber/red.',
      description: 'Yellow diamond containing a vertical traffic light symbol with red, yellow, and green lights.',
      usage: 'Posted where traffic signals may not be immediately visible due to grade or curvature.',
      signType: 'traffic_signals_ahead',
      sourceReference: 'DPWH Road Signs Manual (W3-1)',
    ),
    RoadSignModel(
      id: 'warn_11',
      name: 'Roundabout Ahead',
      category: categoryWarning,
      meaning: 'Warns of a circular intersection (rotunda) ahead; yield to circulating vehicles.',
      description: 'Yellow diamond with three black arrows forming a continuous counter-clockwise circle.',
      usage: 'Posted on approaches to traffic circles and rotunda junctions.',
      signType: 'roundabout_ahead',
      sourceReference: 'DPWH Road Signs Manual (W3-3)',
    ),
    RoadSignModel(
      id: 'warn_12',
      name: 'Pedestrian Crossing Ahead',
      category: categoryWarning,
      meaning: 'Warns that a marked pedestrian crosswalk is located ahead; watch for crossing pedestrians.',
      description: 'Yellow diamond showing a silhouette of a person walking across zebra pavement lines.',
      usage: 'Placed in advance of mid-block pedestrian crosswalks on urban and suburban streets.',
      signType: 'pedestrian_crossing_ahead',
      sourceReference: 'DPWH Road Signs Manual (W4-1)',
    ),
    RoadSignModel(
      id: 'warn_13',
      name: 'School Zone / Children Crossing',
      category: categoryWarning,
      meaning: 'Warns of a school vicinity or playground nearby; slow down and expect sudden child movements.',
      description: 'Yellow diamond depicting two school children silhouettes walking with school bags.',
      usage: 'Installed on roadways adjacent to elementary, high schools, and daycares.',
      signType: 'school_zone',
      sourceReference: 'DPWH Road Signs Manual (W4-2)',
    ),
    RoadSignModel(
      id: 'warn_14',
      name: 'Railroad Crossing Ahead',
      category: categoryWarning,
      meaning: 'Warns that an un-gated or gated railway line crosses the highway ahead; look and listen for trains.',
      description: 'Yellow circular or diamond sign showing a black railroad crossbuck or steam locomotive silhouette.',
      usage: 'Posted in advance of PNR and industrial railway grade crossings.',
      signType: 'railroad_crossing',
      sourceReference: 'DPWH Road Signs Manual (W5-1)',
    ),
    RoadSignModel(
      id: 'warn_15',
      name: 'Two-Way Traffic Ahead',
      category: categoryWarning,
      meaning: 'Warns that a divided highway or one-way street transitions into an undivided two-way road ahead.',
      description: 'Yellow diamond with two vertical parallel arrows pointing in opposite directions.',
      usage: 'Placed where a divided highway terminates or dual carriageway merges.',
      signType: 'two_way_traffic',
      sourceReference: 'DPWH Road Signs Manual (W6-1)',
    ),

    // ==========================================
    // 3. INFORMATIVE & GUIDE SIGNS (10)
    // DPWH Highway Safety Design Standards (Part 2)
    // ==========================================
    RoadSignModel(
      id: 'info_01',
      name: 'Hospital',
      category: categoryInformative,
      meaning: 'Indicates the location or entrance of a hospital or emergency medical treatment facility.',
      description: 'Blue rectangular or square sign with a bold white letter H.',
      usage: 'Posted in advance of hospital emergency entrances and healthcare facilities.',
      signType: 'hospital',
      sourceReference: 'DPWH Road Signs Manual (I1-1)',
    ),
    RoadSignModel(
      id: 'info_02',
      name: 'First Aid Station',
      category: categoryInformative,
      meaning: 'Indicates the presence of a medical first aid post or emergency response station.',
      description: 'Blue or green rectangular sign displaying a bold white cross.',
      usage: 'Found along major highways, tollway service areas, and rest stops.',
      signType: 'first_aid',
      sourceReference: 'DPWH Road Signs Manual (I1-2)',
    ),
    RoadSignModel(
      id: 'info_03',
      name: 'Parking Area',
      category: categoryInformative,
      meaning: 'Designates an authorized public parking zone or facility where parking is allowed.',
      description: 'Blue square sign with a bold white letter P.',
      usage: 'Posted at entrances to off-street parking facilities or designated on-street parking bays.',
      signType: 'parking_area',
      sourceReference: 'DPWH Road Signs Manual (I2-1)',
    ),
    RoadSignModel(
      id: 'info_04',
      name: 'One Way Street (Right)',
      category: categoryGuide,
      meaning: 'Indicates that vehicular traffic may only proceed in the direction indicated by the arrow (Right).',
      description: 'Black or blue rectangular sign with a bold white horizontal arrow pointing right.',
      usage: 'Installed at cross-street corners where traffic is strictly one-directional.',
      signType: 'one_way_right',
      sourceReference: 'DPWH Road Signs Manual (I3-1)',
    ),
    RoadSignModel(
      id: 'info_05',
      name: 'One Way Street (Straight)',
      category: categoryGuide,
      meaning: 'Indicates that traffic on this roadway flows strictly straight ahead in one direction.',
      description: 'Blue rectangular sign with a bold white vertical arrow pointing upward.',
      usage: 'Posted along one-way urban corridors confirming direction of travel.',
      signType: 'one_way_straight',
      sourceReference: 'DPWH Road Signs Manual (I3-2)',
    ),
    RoadSignModel(
      id: 'info_06',
      name: 'Bus / PUV Stop',
      category: categoryInformative,
      meaning: 'Designates an authorized passenger loading and unloading zone for buses and public utility vehicles.',
      description: 'Blue rectangular sign featuring a white bus silhouette.',
      usage: 'Placed at designated public transit stops along primary transport routes.',
      signType: 'bus_stop',
      sourceReference: 'DPWH Road Signs Manual (I4-1)',
    ),
    RoadSignModel(
      id: 'info_07',
      name: 'Disabled Persons Access',
      category: categoryInformative,
      meaning: 'Designates parking spaces, ramps, or facilities specifically reserved for persons with disabilities.',
      description: 'Blue square sign with the international white wheelchair access symbol.',
      usage: 'Installed at reserved accessible parking spaces and facility entrances (BP 344).',
      signType: 'disabled_access',
      sourceReference: 'DPWH Road Signs Manual (I6-1); Batas Pambansa Blg. 344',
    ),
    RoadSignModel(
      id: 'info_08',
      name: 'Gas / Fuel Station',
      category: categoryInformative,
      meaning: 'Informs motorists that an automotive fuel and service station is located nearby.',
      description: 'Blue rectangular sign featuring a white fuel pump dispenser icon.',
      usage: 'Posted along expressways, inter-provincial highways, and highway service plazas.',
      signType: 'fuel_station',
      sourceReference: 'DPWH Road Signs Manual (I5-1)',
    ),
    RoadSignModel(
      id: 'info_09',
      name: 'Expressway Exit Guide',
      category: categoryGuide,
      meaning: 'Guides motorists toward an upcoming expressway off-ramp or destination interchange.',
      description: 'Green rectangular sign with white text, exit number, and an upward-angled directional arrow.',
      usage: 'Mounted on expressway gantries and roadside advance posts (e.g., NLEX, SLEX, SCTEX, TPLEX).',
      signType: 'expressway_exit',
      sourceReference: 'DPWH Road Signs Manual (G1-1); TRB Guidelines',
    ),
    RoadSignModel(
      id: 'info_10',
      name: 'Pedestrian Overpass',
      category: categoryInformative,
      meaning: 'Indicates the presence of a footbridge or elevated pedestrian overpass crossing the highway.',
      description: 'Blue square or rectangular sign showing a person climbing pedestrian footbridge stairs.',
      usage: 'Posted on wide multi-lane highways where at-grade crossing is restricted.',
      signType: 'pedestrian_overpass',
      sourceReference: 'DPWH Road Signs Manual (G2-1)',
    ),

    // ==========================================
    // 4. ROAD WORK & TEMPORARY SIGNS (5)
    // DPWH Highway Safety Design Standards (Part 2)
    // ==========================================
    RoadSignModel(
      id: 'work_01',
      name: 'Road Work Ahead',
      category: categoryRoadWork,
      meaning: 'Warns of road construction, resurfacing, or maintenance operations on the roadway ahead.',
      description: 'Orange diamond sign featuring a black silhouette of a person working with a shovel.',
      usage: 'Placed in advance of roadway work zones to alert drivers to slow down.',
      signType: 'road_work_ahead',
      sourceReference: 'DPWH Road Signs Manual (T1-1)',
    ),
    RoadSignModel(
      id: 'work_02',
      name: 'Men at Work / Road Workers Ahead',
      category: categoryRoadWork,
      meaning: 'Warns that road construction crew and personnel are working actively near or on the travel lane.',
      description: 'Orange diamond or rectangular sign showing road workers silhouette with protective gear.',
      usage: 'Installed immediately approaching active highway work crews.',
      signType: 'men_at_work',
      sourceReference: 'DPWH Road Signs Manual (T1-2)',
    ),
    RoadSignModel(
      id: 'work_03',
      name: 'Detour Ahead',
      category: categoryRoadWork,
      meaning: 'Traffic must divert from the regular route onto a designated bypass or detour route.',
      description: 'Orange rectangular sign featuring a bold black arrow and the word DETOUR.',
      usage: 'Posted where a road closure necessitates diverting traffic onto alternative streets.',
      signType: 'detour_ahead',
      sourceReference: 'DPWH Road Signs Manual (T2-1)',
    ),
    RoadSignModel(
      id: 'work_04',
      name: 'Road Closed',
      category: categoryRoadWork,
      meaning: 'Roadway is completely shut down to traffic due to construction, hazard, or special event.',
      description: 'White or orange rectangular barrier sign bearing the bold words ROAD CLOSED.',
      usage: 'Mounted on temporary physical barricades across all closed traffic lanes.',
      signType: 'road_closed',
      sourceReference: 'DPWH Road Signs Manual (T3-1)',
    ),
    RoadSignModel(
      id: 'work_05',
      name: 'Flagman Ahead',
      category: categoryRoadWork,
      meaning: 'Warns that a designated traffic flagman is controlling vehicular flow ahead; obey signals.',
      description: 'Orange diamond sign featuring a silhouette of a person holding a horizontal warning flag.',
      usage: 'Placed prior to alternating single-lane operations in construction areas.',
      signType: 'flagman_ahead',
      sourceReference: 'DPWH Road Signs Manual (T4-1)',
    ),
  ];

  static List<RoadSignModel> getSignsByCategory(String category) {
    if (category == 'All') return allSigns;
    return allSigns.where((s) => s.category == category).toList();
  }

  static RoadSignModel? getSignById(String id) {
    try {
      return allSigns.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<RoadSignModel> searchSigns(String query, {String? category}) {
    final cleanQuery = query.trim().toLowerCase();
    return allSigns.where((sign) {
      final matchesCategory = category == null ||
          category == 'All' ||
          sign.category == category;
      if (!matchesCategory) return false;

      if (cleanQuery.isEmpty) return true;

      final nameMatch = sign.name.toLowerCase().contains(cleanQuery);
      final meaningMatch = sign.meaning.toLowerCase().contains(cleanQuery);
      final categoryMatch = sign.category.toLowerCase().contains(cleanQuery);

      return nameMatch || meaningMatch || categoryMatch;
    }).toList();
  }
}
