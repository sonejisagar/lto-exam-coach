import '../models/question_model.dart';

class LocalizedQuestionContent {
  final String question;
  final List<String> options;
  final String explanation;

  const LocalizedQuestionContent({
    required this.question,
    required this.options,
    required this.explanation,
  });
}

/// Curated, reviewed Filipino study translations for LTO Exam Coach reviewer.
/// English remains the canonical original question dataset.
/// Filipino is provided as an optional localized study reviewer version.
/// All translations strictly preserve 1-to-1 option ordering and correctAnswerIndex.
class QuestionsFilipinoData {
  static const Map<String, LocalizedQuestionContent> translations = {
    'tr_001': LocalizedQuestionContent(
      question: 'Sa ilalim ng batas trapiko ng Pilipinas (RA 4136), ano ang kahulugan ng kumikislap na pulang ilaw (flashing red light) sa panulukan?',
      options: [
        'Bumagal at magpatuloy nang may pag-iingat nang hindi humihinto',
        'Ganap na huminto, magbigay-daan sa tumatawid na trapiko at mga naglalakad, saka magpatuloy kung ligtas na',
        'Huminto at maghintay hanggang sa maging berdeng ilaw ito',
        'Bumilis upang makatawid agad sa panulukan bago dumating ang ibang sasakyan',
      ],
      explanation: 'Ang kumikislap na pulang ilaw ay gumagana katulad ng STOP sign. Dapat ganap na huminto ang tsuper bago ang stop line, magbigay-daan sa parating na trapiko at mga naglalakad, at magpatuloy lamang kapag ligtas.',
    ),
    'tr_002': LocalizedQuestionContent(
      question: 'Sa ilalim ng RA 10913 (Anti-Distracted Driving Act), alin sa mga sumusunod ang mahigpit na ipinagbabawal habang nagmamaneho o pansamantalang nakatigil sa pulang ilaw?',
      options: [
        'Paggamit ng hands-free dash-mounted phone para sa nabigasyon gamit ang voice prompts',
        'Paghawak at pagbabasa ng text message o pagtawag gamit ang hawak na cellphone',
        'Pakikinig sa audio ng gabay sa kalsada sa pamamagitan ng vehicular speakers',
        'Pag-aayos ng lakas ng built-in car radio gamit ang controls sa manibela',
      ],
      explanation: 'Ipinagbabawal ng RA 10913 ang paghawak at paggamit ng handheld electronic device habang nagmamaneho o pansamantalang nakatigil sa panulukan, red light, o trapiko.',
    ),
    'tr_003': LocalizedQuestionContent(
      question: 'Ano ang validity period ng isang Student Permit na inisyu ng Land Transportation Office (LTO)?',
      options: [
        '6 na buwan mula sa petsa ng pag-isyu',
        '1 taon mula sa petsa ng pag-isyu',
        '3 buwan mula sa petsa ng pag-isyu',
        '3 taon mula sa petsa ng pag-isyu',
      ],
      explanation: 'Ang LTO Student Permit ay may bisa sa loob ng 1 taon (12 buwan) mula sa petsa ng pag-isyu ayon sa mga alituntunin ng LTO.',
    ),
    'tr_004': LocalizedQuestionContent(
      question: 'Sa ilalim ng RA 4136, ano ang pinakamataas na pinapahintulutang takbo (maximum speed limit) para sa mga pampasaherong kotse at motorsiklo sa bukas na kalsada sa lalawigan na walang blind corners?',
      options: [
        '60 km/h',
        '80 km/h',
        '100 km/h',
        '50 km/h',
      ],
      explanation: 'Itinatakda ng Seksyon 35(b) ng RA 4136 ang maximum speed limit na 80 km/h sa mga bukas na kalsada sa probinsya na walang blind corner para sa mga pampasaherong sasakyan at motorsiklo.',
    ),
    'tr_005': LocalizedQuestionContent(
      question: 'Sa ilalim ng Republic Act No. 10930, ilang taon ang magiging bisa ng driver\'s license kapag nag-renew kung walang anumang tala ng paglabag sa batas trapiko ang tsuper?',
      options: [
        '3 taon',
        '5 taon',
        '10 taon',
        '15 taon',
      ],
      explanation: 'Pinahihintulutan ng RA 10930 ang pagpapalawig ng bisa ng lisensya hanggang 10 taon sa pag-renew para sa mga tsuper na walang anumang demerit points o paglabag.',
    ),
    'tr_006': LocalizedQuestionContent(
      question: 'Ano ang legal na obligasyon ng isang tsuper sa paglapit ng isang opisyal na emergency vehicle na gumagamit ng sirena o kumikislap na ilaw?',
      options: [
        'Bumilis upang manatili sa unahan ng emergency vehicle',
        'Agad na magbigay-daan, tumabi sa kanang gilid ng kalsada, at huminto hanggang sa makalampas ito',
        'Panatilihin ang kasalukuyang bilis at manatili sa sariling linya',
        'Buksan ang hazard lights at sumunod nang dikit sa likod ng emergency vehicle',
      ],
      explanation: 'Sa ilalim ng Seksyon 43 ng RA 4136, dapat agad na magbigay-daan ang tsuper sa emergency vehicle sa pamamagitan ng pagtabi sa kanan at paghinto.',
    ),
    'tr_010': LocalizedQuestionContent(
      question: 'Sa ilalim ng RA 10586 (Anti-Drunk and Drugged Driving Act), ano ang standardized field sobriety tests na dapat isagawa ng traffic enforcer kung pinaghihinalaang nakainom ang tsuper?',
      options: [
        'Eye Exam, Hearing Test, at Pulse Check',
        'Horizontal Gaze Nystagmus (HGN), Walk-and-Turn, at One-Leg Stand',
        'Coin Toss, Fingerprint Scan, at Reflex Tap',
        'Straight Line Run, Squat Jump, at Breath Hold',
      ],
      explanation: 'Itinatakda ng RA 10586 ang tatlong standardized field sobriety tests: ang Horizontal Gaze Nystagmus (HGN), Walk-and-Turn, at One-Leg Stand test.',
    ),
    'rs_001': LocalizedQuestionContent(
      question: 'Ano ang pangunahing dapat gawin kapag papalapit sa isang hugis oktagon na pulang senyas na may puting salitang \'STOP\'?',
      options: [
        'Bumagal at dahan-dahang tumuloy kung walang nakikitang sasakyan',
        'Ganap na huminto sa stop line, magbigay-daan sa lahat ng tumatawid na sasakyan at pedestrian, bago magpatuloy kung ligtas na',
        'Huminto lamang kung may nakatayong traffic enforcer',
        'Bumusina at bumilis sa pagtawid',
      ],
      explanation: 'Ang pulang STOP sign ay isang regulatory sign na nag-aatas ng ganap na paghinto bago ang stop line o pedestrian lane at pagbibigay-daan sa lahat bago magpatuloy.',
    ),
    'rs_002': LocalizedQuestionContent(
      question: 'Ano ang kahulugan ng baligtad na tatsulok (inverted triangle) na senyas na may pulang border at puting background?',
      options: [
        'Stop (Ganap na Huminto)',
        'Yield / Give Way (Magbigay ng Daan sa parating na trapiko)',
        'No Entry (Bawal Pumasok)',
        'Pedestrian Crossing (Tawiran ng Tao)',
      ],
      explanation: 'Ang baligtad na equilateral triangle ay ang internasyonal at LTO standard na hugis para sa "Yield" o "Give Way", na nag-aatas sa tsuper na magbigay-daan sa mga sasakyan sa pangunahing kalsada.',
    ),
    'rs_003': LocalizedQuestionContent(
      question: 'Ano ang ibig sabihin ng pabilog na regulatory sign na may pulang border, itim na kurbang palaso pakaliwa, at may pulang diagonal slash?',
      options: [
        'Matarik na kurba pakaliwa sa unahan',
        'Bawal Kumaliwa (No Left Turn)',
        'Pinapayagan ang U-turn',
        'Magtatapos ang kaliwang linya',
      ],
      explanation: 'Ang pulang bilog na may diagonal slash sa ibabaw ng palaso ay nagpapahiwatig ng pagbabawal — sa sitwasyong ito, Bawal Kumaliwa (No Left Turn).',
    ),
    'rm_001': LocalizedQuestionContent(
      question: 'Ano ang kahulugan ng isang putol-putol na puting linya (broken white line) sa kalsada?',
      options: [
        'Naghihiwalay sa trapikong magkasalubong; mahigpit na bawal mag-overtake',
        'Naghihiwalay sa mga linya ng trapiko sa iisang direksyon; pinapayagan ang pagpapalit ng linya at pag-overtake kung ligtas',
        'Nagpapahiwatig ng daanan para lamang sa mga naglalakad',
        'Nagmamarka sa panlabas na gilid ng shoulder ng kalsada',
      ],
      explanation: 'Ang putol-putol na puting linya ay naghihiwalay sa mga lane na patungo sa parehong direksyon at nagpapahintulot sa ligtas na paglipat ng linya at pag-overtake.',
    ),
    'rm_002': LocalizedQuestionContent(
      question: 'Ano ang panuntunan kapag may dobleng linyang dilaw (double solid yellow line) sa gitna ng two-way na kalsada?',
      options: [
        'Pinapayagan ang pag-overtake anumang oras kung walang kasalubong sa loob ng 50 metro',
        'Mahigpit na ipinagbabawal ang pag-overtake o pagtawid sa linya mula sa magkabilang direksyon',
        'Pinapayagan lamang ang pag-overtake para sa mga motorsiklo',
        'Pinapayagan ang pag-overtake sa oras lamang ng araw',
      ],
      explanation: 'Ang double solid yellow line ay nangangahulugang mahigpit na bawal mag-overtake o lumagpas sa linya ang mga sasakyan mula sa magkabilang direksyon.',
    ),
    'row_001': LocalizedQuestionContent(
      question: 'Sa ilalim ng Seksyon 42(a) ng RA 4136, kapag ang dalawang sasakyan ay sabay na dumating sa isang panulukan na walang senyas, sino ang may karapatan sa daan (Right of Way)?',
      options: [
        'Ang tsuper na nasa kaliwa ay dapat magbigay-daan sa tsuper na nasa kanan',
        'Ang tsuper na nasa kanan ay dapat magbigay-daan sa tsuper na nasa kaliwa',
        'Ang mas malaking sasakyan ang awtomatikong may karapatan sa daan',
        'Ang sasakyang mas mabilis ang takbo ang may karapatan sa daan',
      ],
      explanation: 'Ayon sa Seksyon 42(a) ng RA 4136, ang sasakyan na nasa kaliwa ay dapat magbigay-daan sa sasakyan na nasa kanyang kanang bahagi kung sabay silang dumating sa panulukan.',
    ),
    'ov_001': LocalizedQuestionContent(
      question: 'Ano ang pangkalahatang batas sa pag-overtake ng isa pang sasakyan na kapareho mo ng direksyon sa two-lane na kalsada?',
      options: [
        'Mag-overtake sa kanang bahagi lamang',
        'Lumusot sa kaliwang bahagi sa ligtas na agwat at huwag babalik sa kanan hanggang hindi ligtas na nakalayo',
        'Tuloy-tuloy na bumusina habang tumatabi sa sasakyan',
        'Mag-flash ng high beam at pilitin ang sasakyan na tumabi sa shoulder',
      ],
      explanation: 'Itinatakda ng Seksyon 39 ng RA 4136 na ang pag-overtake ay dapat gawin sa kaliwang bahagi nang may ligtas na agwat at bumalik lamang sa kanang lane kapag ligtas na nakalampas.',
    ),
    'pk_001': LocalizedQuestionContent(
      question: 'Sa ilalim ng Seksyon 46 ng RA 4136, ilang metro ang pinakamababang layo mula sa isang fire hydrant bago maaaring pumarada?',
      options: [
        '2 metro',
        '4 na metro',
        '6 na metro',
        '10 metro',
      ],
      explanation: 'Sa ilalim ng Seksyon 46(f) ng RA 4136, mahigpit na ipinagbabawal ang pagparada sa loob ng apat (4) na metro mula sa anumang fire hydrant upang magamit ito ng mga bumbero.',
    ),
    'dd_001': LocalizedQuestionContent(
      question: 'Ano ang tinatawag na "two-second rule" sa defensive driving?',
      options: [
        'Ang oras bago huminto sa red light',
        'Ang ligtas na agwat (following distance) sa likod ng sinusundang sasakyan sa normal na kondisyon ng panahon',
        'Ang oras na pinapayagan sa paggamit ng busina',
        'Ang tagal ng pag-signal bago lumiko',
      ],
      explanation: 'Ang two-second rule ay standard na gabay para sa ligtas na sumusunod na agwat sa pagitan ng iyong sasakyan at ng sasakyan sa iyong harapan.',
    ),
    'sf_001': LocalizedQuestionContent(
      question: 'Sa ilalim ng RA 10913 (Anti-Distracted Driving Act), saan maaaring legal na ipuwesto ang cellphone para sa nabigasyon?',
      options: [
        'Hawak sa kamay ng tsuper kapantay ng manibela',
        'Naka-mount sa dashboard sa loob ng safe zone nang hindi humaharang sa paningin ng tsuper',
        'Nakapatong sa kandungan (lap) ng tsuper',
        'Naka-kabit mismo sa gitna ng windshield sa tapat ng mata',
      ],
      explanation: 'Pinapayagan ng RA 10913 ang mga navigation device kung nakakabit ito sa itinalagang safe zone sa dashboard at hindi humaharang sa malinaw na paningin sa daan.',
    ),
    'sf_003': LocalizedQuestionContent(
      question: 'Sa ilalim ng Republic Act No. 8750 (Seat Belts Use Act of 1999), sinu-sino ang dapat magsuot ng seatbelt sa loob ng umaandar na sasakyan?',
      options: [
        'Tsuper lamang',
        'Tsuper at pasahero sa unahang upuan lamang',
        'Ang tsuper at lahat ng pasahero sa unahan at likurang upuan',
        'Mga pasahero lamang sa likod',
      ],
      explanation: 'Inoobliga ng RA 8750 ang tsuper at lahat ng pasahero sa unahan at likuran ng pribadong sasakyan na magsuot ng seatbelt habang umaandar ang makina.',
    ),
  };
}

/// Helper extension on QuestionModel providing seamless access to localized content.
/// If languageCode is 'fil' and a reviewed translation exists, returns the Filipino version.
/// Otherwise, gracefully falls back to canonical English content.
extension LocalizedQuestionModel on QuestionModel {
  String getLocalizedQuestion(String languageCode) {
    if (languageCode == 'fil') {
      final fil = QuestionsFilipinoData.translations[id];
      if (fil != null && fil.question.trim().isNotEmpty) {
        return fil.question;
      }
    }
    return question;
  }

  List<String> getLocalizedOptions(String languageCode) {
    if (languageCode == 'fil') {
      final fil = QuestionsFilipinoData.translations[id];
      if (fil != null && fil.options.length == 4) {
        return fil.options;
      }
    }
    return options;
  }

  String getLocalizedExplanation(String languageCode) {
    if (languageCode == 'fil') {
      final fil = QuestionsFilipinoData.translations[id];
      if (fil != null && fil.explanation.trim().isNotEmpty) {
        return fil.explanation;
      }
    }
    return explanation;
  }
}
