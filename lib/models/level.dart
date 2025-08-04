class Level {
  final String id;
  final String categoryId;
  final int levelNumber;
  final String word;
  final String clue;
  final int timeLimit;
  final List<String> distractors;
  final int maxLength;

  Level({
    required this.id,
    required this.categoryId,
    required this.levelNumber,
    required this.word,
    required this.clue,
    required this.timeLimit,
    required this.distractors,
    required this.maxLength,
  });

  factory Level.fromMap(Map<String, dynamic> map) {
    return Level(
      id: map['id'],
      categoryId: map['categoryId'],
      levelNumber: map['levelNumber'],
      word: map['word'],
      clue: map['clue'],
      timeLimit: map['timeLimit'],
      distractors: List<String>.from(map['distractors']),
      maxLength: map['maxLength'],
    );
  }
}

/// Global map to hold levels grouped by categoryId
Map<String, List<Level>> categoryLevels = {};

/// Call this once with your full list of levels after loading them
void groupLevelsByCategory(List<Level> allLevels) {
  categoryLevels.clear(); // Make sure it's fresh
  for (final level in allLevels) {
    categoryLevels.putIfAbsent(level.categoryId, () => []);
    categoryLevels[level.categoryId]!.add(level);
  }
}

/// Helper function to get a specific level
Level? getLevel(String categoryId, int levelNumber) {
  final levels = categoryLevels[categoryId];
  if (levels == null) {
    print('No levels found for category $categoryId');
    return null;
  }
  if (levels.length < levelNumber) {
    print('Category $categoryId has only ${levels.length} levels; requested level $levelNumber');
    return null;
  }
  return levels[levelNumber - 1];
}


final Map<String, List<String>> categoryWords = {
  "1": _medicineWords,
  "2": _musicWords,
  "3": _paintingWords,
  "4": _cookingWords,
  "5": _lawWords,
  "6": _engineeringWords,
  "7": _aviationWords,
  "8": _marineBiologyWords,
  "9": _astronomyWords,
  "10": _architectureWords,
  "11": _fashionWords,
  "12": _photographyWords,
  "13": _journalismWords,
  "14": _psychologyWords,
  "15": _agricultureWords,
  "16": _computerScienceWords,
  "17": _chemistryWords,
  "18": _physicsWords,
  "19": _mathematicsWords,
  "20": _dentistryWords,
  "21": _veterinaryWords,
  "22": _botanyWords,
  "23": _geologyWords,
  "24": _meteorologyWords,
  "25": _economicsWords,
  "26": _archaeologyWords,
  "27": _linguisticsWords,
  "28": _philosophyWords,
  "29": _theaterWords,
  "30": _sportsWords,
};

final Map<String, List<String>> categoryClues = {
  "1": _medicineClues,
  "2": _musicClues,
  "3": _paintingClues,
  "4": _cookingClues,
  "5": _lawClues,
  "6": _engineeringClues,
  "7": _aviationClues,
  "8": _marineBiologyClues,
  "9": _astronomyClues,
  "10": _architectureClues,
  "11": _fashionClues,
  "12": _photographyClues,
  "13": _journalismClues,
  "14": _psychologyClues,
  "15": _agricultureClues,
  "16": _computerScienceClues,
  "17": _chemistryClues,
  "18": _physicsClues,
  "19": _mathematicsClues,
  "20": _dentistryClues,
  "21": _veterinaryClues,
  "22": _botanyClues,
  "23": _geologyClues,
  "24": _meteorologyClues,
  "25": _economicsClues,
  "26": _archaeologyClues,
  "27": _linguisticsClues,
  "28": _philosophyClues,
  "29": _theaterClues,
  "30": _sportsClues,
};

final Map<String, List<String>> categoryDistractors = {
  "1": ['h', 'c', 'i', 'x', 'e', 'a', 'n', 't', 'm'],
  "2": ['r', 'd', 'o', 's', 'g', 'u', 'l', 't', 'n'],
  "3": ['m', 'e', 'w', 'l', 'a', 'c', 'o', 'p', 'g'],
  "4": ['a', 'c', 'f', 'l', 'i', 'o', 'r', 's', 't'],
  "5": ['h', 'e', 'v', 'l', 'a', 't', 'i', 'c', 'o'],
  "6": ['b', 'o', 'p', 'r', 'e', 'c', 't', 's', 'n'],
  "7": ['n', 'e', 'x', 't', 'a', 'i', 'r', 'o', 's'],
  "8": ['a', 'b', 'f', 'g', 'i', 'l', 'm', 'o', 't'],
  "9": ['k', 'e', 'd', 'g', 'l', 'o', 's', 't', 'u'],
  "10": ['n', 'e', 'x', 't', 'a', 'i', 'r', 'o', 's'],
  "11": ['f', 'a', 's', 'h', 'i', 'o', 'n', 't', 'r'],
  "12": ['p', 'h', 'o', 't', 'o', 'g', 'r', 'a', 'p'],
  "13": ['j', 'o', 'u', 'r', 'n', 'a', 'l', 'i', 's'],
  "14": ['p', 's', 'y', 'c', 'h', 'o', 'l', 'o', 'g'],
  "15": ['a', 'g', 'r', 'i', 'c', 'u', 'l', 't', 'e'],
  "16": ['c', 's', 'e', 'o', 'm', 'p', 'u', 't', 'r'],
  "17": ['c', 'h', 'e', 'm', 'i', 's', 't', 'r', 'y'],
  "18": ['p', 'h', 'y', 's', 'i', 'c', 's', 't', 'r'],
  "19": ['m', 'a', 't', 'h', 'e', 'm', 'a', 't', 's'],
  "20": ['d', 'e', 'n', 't', 'i', 's', 't', 'r', 'n'],
  "21": ['v', 'e', 't', 'e', 'r', 'i', 'n', 'a', 'l'],
  "22": ['b', 'o', 't', 'a', 'n', 'y', 'p', 'l', 's'],
  "23": ['g', 'e', 'o', 'l', 'o', 'g', 'y', 's', 't'],
  "24": ['m', 'e', 't', 'e', 'o', 'r', 'o', 'l', 'o'],
  "25": ['e', 'c', 'o', 'n', 'o', 'm', 'i', 'c', 's'],
  "26": ['a', 'r', 'c', 'h', 'a', 'e', 'o', 'l', 'g'],
  "27": ['l', 'i', 'n', 'g', 'u', 'i', 's', 't', 's'],
  "28": ['p', 'h', 'i', 'l', 'o', 's', 'o', 'p', 'h'],
  "29": ['t', 'h', 'e', 'a', 't', 'e', 'r', 's', 'z'],
  "30": ['s', 'p', 'o', 'r', 't', 's', 'g', 'a', 'm'],
};

List<Level> generateLevels(String categoryId) {
  final words = categoryWords[categoryId]!;
  final clues = categoryClues[categoryId]!;
  final distractors = categoryDistractors[categoryId]!;

  final count = words.length < clues.length ? words.length : clues.length;

  return List.generate(count, (i) {
    return Level(
      id: '$categoryId-${i + 1}',
      categoryId: categoryId,
      levelNumber: i + 1,
      word: words[i],
      clue: clues[i],
      timeLimit: 60,
      distractors: distractors,
      maxLength: words[i].length,
    );
  });
}

final List<String> _medicineWords = [
  "anatomy", "antibody", "vaccine", "surgery", "therapy", "pharmacy", "pathogen",
  "cellular", "immunity", "biopsy", "epidemic", "pandemic", "antigen", "fracture",
  "insulin", "glucose", "globulin", "sedation", "injector", "clinic", "nursing",
  "xray", "scan", "stethoscope", "pulse", "oxygen", "bandage", "tumor", "scanner", "vital",
  "dosage", "symptom", "virus", "bacteria", "lipid", "enzyme", "hormone", "renal",
  "spine", "bone", "muscle", "tissue", "organ", "brain", "lung", "grafting",
  "monitor", "sutures", "painkiller", "fatigue"
];

final List<String> _medicineClues = [
  "Study of body structure",                          // anatomy
  "Protein produced to fight antigens",              // antibody
  "Stimulates immune response",                      // vaccine
  "Medical procedure involving incision",            // surgery
  "Treatment of disease",                            // therapy
  "Place to get medications",                        // pharmacy
  "Microorganism causing disease",                   // pathogen
  "Made of cells",                                   // cellular
  "Body's defense system",                           // immunity
  "Sample removal for examination",                  // biopsy
  "Outbreak in a community",                         // epidemic
  "Worldwide outbreak",                              // pandemic
  "Substance that triggers immune response",         // antigen
  "Broken bone",                                     // fracture
  "Hormone regulating sugar",                        // insulin
  "Simple sugar in blood",                           // glucose
  "Protein related to immunity",                     // globulin
  "Calming or sleep aid",                            // sedation
  "Device for injection",                            // injector
  "Outpatient medical facility",                     // clinic
  "Health care profession",                          // nursing
  "Medical image technique",                         // xray
  "Medical scan technique",                          // scan
  "Instrument to hear heartbeat",                    // stethoscope
  "Heart rate",                                      // pulse
  "Essential gas for breathing",                     // oxygen
  "Material for wrapping wounds",                    // bandage
  "Abnormal cell growth",                            // tumor
  "Device to create images",                         // scanner
  "Crucial for life",                                // vital
  "Amount of medicine given",                        // dosage
  "Indication of illness",                           // symptom
  "Tiny infectious agent",                           // virus
  "Single-celled organism",                          // bacteria
  "Fat in the body",                                 // lipid
  "Biological catalyst",                             // enzyme
  "Chemical messenger",                              // hormone
  "Relating to kidneys",                             // renal
  "Backbone structure",                              // spine
  "Skeletal component",                              // bone
  "Fibrous tissue",                                  // muscle
  "Group of similar cells",                          // tissue
  "Control center of body",                          // brain
  "Organ for breathing",                             // lung
  "Transplanting skin or tissue",                    // grafting
  "Device to check vital signs",                     // monitor
  "Stitches used after surgery",                     // sutures
  "Drug that relieves pain",                         // painkiller
  "Feeling tired"                                    // fatigue
];





final List<String> _musicWords = [
  "piano", "guitar", "violin", "drums", "flute", "trumpet", "cello", "harp",
  "clarinet", "bassoon", "choir", "tempo", "melody", "harmony", "rhythm", "note",
  "scale", "octave", "chord", "beat", "lyric", "opera", "concert", "orchestra",
  "solo", "duet", "band", "singer", "composer", "genre", "jazz", "blues", "rock",
  "pop", "classical", "folk", "rap", "metal", "acoustic", "amplifier", "tune",
  "refrain", "verse", "chorus", "bridge", "pitch", "tone", "marimba", "harmonic",
  "timbre", "session"
];

final List<String> _musicClues = [
  "A keyboard instrument", "A string instrument with six strings", "String instrument played with a bow",
  "Percussion instrument", "Woodwind instrument", "Brass instrument", "Large string instrument played sitting down",
  "Large harp string instrument", "Single-reed woodwind instrument", "Double reed instrument",
  "Group of singers", "Speed of the music", "Main tune", "Combination of notes", "Pattern of beats",
  "Musical symbol", "Series of notes", "Interval of eight notes", "Combination of notes played together",
  "Regular pulse", "Words of a song", "Dramatic musical form", "Public musical performance",
  "Large instrumental ensemble", "Performance by one musician", "Performance by two musicians",
  "Group of musicians", "Person who sings", "Person who writes music", "Category of music",
  "Jazz music style", "Blues music style", "Rock music genre", "Popular music",
  "Classical music", "Traditional music", "Rhythmic poetry", "Heavy metal music",
  "Non-electric music", "Device that increases sound", "Melodic sequence", "Repeated musical phrase",
  "Section of a song", "Main repeating section", "Linking section", "Highness or lowness of a sound",
  "Quality of a musical note", "Percussion instrument with wooden bars", "Related to harmony",
  "Tone color or quality", "Professional recording time"
];



final List<String> _paintingWords = [
  "canvas", "brush", "easel", "acrylic", "portrait", "landscape", "abstract",
  "sketch", "fresco", "mural", "charcoal", "gouache", "texture", "shade", "highlight",
  "composition", "perspective", "layer", "glaze", "tone", "medium", "stroke", "frame",
  "color", "hue", "saturation", "contrast", "vivid", "blend", "detail", "line", "form",
  "pattern", "brushwork", "impasto", "realism", "cubism", "gallery", "exhibit", "artist",
  "masterpiece", "signature", "study", "style", "palette", "design", "motif", "mosaic",
  "media"
];

final List<String> _paintingClues = [
  "Surface for painting", "Tool for applying paint", "Set of colors used by an artist",
  "Stand to hold canvas", "Fast-drying paint type", "Painting of a person", "Painting of natural scenery",
  "Non-representational art", "Preliminary drawing", "Wall painting technique",
  "Large wall painting", "Black drawing material", "Opaque watercolor paint", "Surface quality",
  "Dark area in painting", "Light area in painting", "Arrangement of elements", "Illusion of depth",
  "Thin paint layer", "Thin transparent paint", "Lightness or darkness", "Material used",
  "Brush movement", "Edge around a painting", "Visual sensation", "Color family", "Intensity of color",
  "Difference in colors", "Bright and strong", "Mix colors smoothly", "Small parts",
  "Mark made by a pen or brush", "Shape or structure", "Repeated design", "Style of brush strokes",
  "Thick paint texture", "Faithful depiction", "Geometric abstraction", "Place to show art",
  "Art display", "Person who paints", "Highly regarded artwork", "Artist's mark",
  "Preliminary work", "Distinct manner", "Set of colors", "Arrangement", "Decorative design",
  "Surface for art", "art made from small pieces" "Materials used",
];



final List<String> _cookingWords = [
  "recipe", "ingredient", "saute", "boil", "grill", "bake", "roast", "fry",
  "steam", "chop", "slice", "dice", "mix", "whisk", "knead", "marinate",
  "season", "broil", "simmer", "blend", "garnish", "sauce", "stock", "oven",
  "pan", "spice", "herb", "knife", "timer", "grater", "mixer", "stir",
  "funnel", "peel", "pour", "measure", "strain", "tongs", "lid", "baste",
  "caramel", "flavor", "ferment", "roasting", "toasting", "zest", "whip",
  "blender", "boiling"
];

final List<String> _cookingClues = [
  "Instructions for making a dish", "Food components", "Cook quickly in a little fat",
  "Cook in boiling water", "Cook over direct heat", "Cook with dry heat in oven",
  "Cook evenly in oven", "Cook in hot oil", "Cook with steam", "Cut into small pieces",
  "Cut into thin pieces", "Cut into cubes", "Combine ingredients", "Beat rapidly",
  "Work dough by hand", "Soak in seasoning", "Add flavor", "Cook with high heat from above",
  "Cook gently below boiling", "Mix thoroughly", "Decorate food", "Thickened liquid accompaniment",
  "Flavored liquid for cooking", "Heat appliance", "Cooking vessel", "Plant seasonings",
  "Plant flavorings", "Cutting tool", "Device to track time", "Tool to shred food",
  "Electric mixing tool", "Move food gently", "Tool to direct liquids", "Remove skin or peel",
  "Pour liquid", "Determine quantity", "Remove solids from liquid", "Gripping tool",
  "Cover for pot", "Moisten food during cooking", "Sugar cooked until brown",
  "Taste or aroma", "Process of aging food", "Cooking by dry heat", "Browning food by heat",
  "Outer peel of citrus", "Beat cream or eggs", "Electric mixer", "Boiling water"
];



final List<String> _lawWords = [
  "contract", "tort", "defense", "appeal", "verdict", "statute",
  "affidavit", "subpoena", "testify", "evidence", "witness",
  "hearing", "trial", "injunct", "settle", "clause",
  "damages", "liability", "negligent", "breach", "indict",
  "acquit", "sentence", "parole", "probate", "felony",
  "convict", "attorney", "counsel", "judge", "jury",
  "bailiff", "notary", "lawyer", "lawful", "legal",
  "warrant", "charge", "court", "decree", "claim",
  "plea", "fine","litigate", "defraud", "plaintiff", "testator", "litigant", "judgment"
];

final List<String> _lawClues = [
  "Legal agreement", "Civil wrong", "Legal defense", "Request court",
  "Jury decision", "Law passed", "Written oath", "Court order",
  "Speak under oath", "Proof in court", "Person testifying",
  "Court session", "Formal trial", "Court order stop", "Dispute end",
  "Part of legal doc", "Money owed", "Legal duty", "Care failure",
  "Contract fail", "Formal charge", "Not guilty", "Court punishment",
  "Release from jail", "Legal process", "Serious crime",
  "Found guilty", "Legal expert", "Legal advice", "Judge",
  "Group deciding", "Court officer", "Legal witness",
  "Legal worker", "Allowed by law", "Legal", "Legal order",
  "Legal claim", "Admission", "Monetary penalty",
  "Engage in lawsuit", "Cheat or deceive", "Person suing", "Will maker", "Party in case", "Court decision"
];


final List<String> _engineeringWords = [
  "circuit", "voltage", "resistor", "capacitor", "inductor", "diode",
  "transistor", "sensor", "actuator", "algorithm", "robotics", "prototype",
  "blueprint", "beam", "stress", "strain", "load", "torque",
  "welding", "hydraulic", "pneumatic", "gear", "shaft", "bearing",
  "bridge", "engine", "valve", "pump", "motor", "cable", "solder",
  "screw", "bolt", "nut", "lever", "pulley", "cam", "crank", "joint",
  "cogwheel", "kinematics", "dynamics", "fluid", "circuitry",
  // new words
  "gasket", "wiring", "engineer", "servo", "clutch", "axle", "gearbox"
];

final List<String> _engineeringClues = [
  "Electrical path", "Electric potential", "Limits current", "Stores charge",
  "Stores magnetism", "Allows current one way", "Amplifies current",
  "Detects change", "Causes motion", "Step procedure", "Robot design",
  "Early model", "Detailed plan", "Support beam", "Force on area",
  "Material stretch", "Load carried", "Rotational force",
  "Metal joining", "Liquid power", "Air power", "Rotating wheel",
  "Rotating shaft", "Reduces friction", "Structure support",
  "Machine engine", "Controls flow", "Moves fluid", "Rotating machine",
  "Electric wire", "Joins parts", "Threaded fastener",
  "Threaded fastener", "Threaded fastener", "Rigid bar", "Wheel & rope",
  "Rotating piece", "Rotating arm", "Connection point", "Toothed wheel",
  "Study of motion", "Study of forces", "Substance flow", "Electric system",
  // new clues
  "Seal between parts", "Electrical cables", "Technical professional",
  "Automated controller", "Device to connect/disconnect", "Rotating shaft", "Gear housing"
];


final List<String> _aviationWords = [
  "aircraft", "cockpit", "altitude", "runway", "hangar", "turbine",
  "propeller", "glider", "autopilot", "radar", "flight", "takeoff",
  "landing", "fuselage", "navigation", "airspace", "aviator", "blackbox",
  "flaps", "spoilers", "landinggear", "tailwind", "headwind", "airspeed",
  "altimeter", "compass", "controltower", "pilot", "copilot", "engine",
  "fuel", "airport", "passenger", "crew", "seating", "emergency",
  "parachute", "voicebox", "pressure", "rudder", "yaw", "pitch", "roll",
  "vector", "approach", "departure", "terminal", "airline", "flightpath",
  "clearance", "jetway", "taxiway"
];

final List<String> _aviationClues = [
  "Flying machine", "Pilot's area", "Height above sea", "Plane strip",
  "Plane storage", "Engine type", "Rotating blade", "Non-motor plane",
  "Auto flight", "Detection system", "Air journey", "Flight start",
  "Touchdown", "Plane body", "Finding direction", "Controlled sky",
  "Plane pilot", "Flight recorder", "Moveable wings", "Air brakes",
  "Plane wheels", "Wind aiding", "Wind opposing", "Plane speed",
  "Altitude meter", "Direction tool", "Airport control", "Plane driver",
  "Second pilot", "Power unit", "Fuel source", "Airport place",
  "Air traveler", "Flight staff", "Seats", "Urgent situation",
  "Safety chute", "Cockpit sound", "Cabin pressure", "Steering fin",
  "Side to side", "Up and down", "Rotate", "Flight line", "Landing path",
  "Flight leave", "Airport building", "Flight company", "Flight route",
  "Permission to fly", "Connector to plane", "Path for planes on ground"
];


final List<String> _marineBiologyWords = [
  "plankton", "coral", "algae", "kelp", "reef", "mollusk", "crab", "echinoderm",
  "jellyfish", "seahorse", "dolphin", "whale", "shark", "octopus", "squid",
  "barnacle", "lobster", "clam", "oyster", "starfish", "urchin", "anemone",
  "tide", "current", "salinity", "estuary", "marine", "brackish", "phytoplankton",
  "zooplankton", "habitat", "biodiversity", "ecosystem", "photosynthesis",
  "predator", "prey", "adaptation", "migration", "fins", "gills", "shell",
  "spine", "tentacle", "camouflage", "symbiosis", "filter", "bioluminescence",
  "dives", "aquatic", "krill"
];

final List<String> _marineBiologyClues = [
  "Microscopic organisms", "Animals that build reefs", "Plant-like water life",
  "Large seaweed", "Rocky ridge", "Soft-bodied", "Crab-like", "Spiny skin",
  "Jelly sea creature", "Small fish", "Smart mammal", "Large mammal",
  "Cartilage fish", "Eight-armed mollusk", "Fast mollusk",
  "Small crustacean", "Large crustacean", "Soft bodied shellfish",
  "Hard shellfish", "Five-armed sea creature", "Spiny sea creature",
  "Sea animal", "Sea level rise", "Water movement", "Salt content",
  "Where fresh meets salt", "Sea-related", "Mix of fresh and salt",
  "Plant plankton", "Animal plankton", "Living place", "Variety of life",
  "Community of life", "Light to energy", "Animal hunter", "Animal hunted",
  "Change to survive", "Season move", "Swimming limbs", "Breathing organs",
  "Hard outer layer", "Support structure", "Flexible arm", "Blending in",
  "Close relationship", "Strains water", "Glowing light", "Underwater dive",
  "Water-related", "Small shrimp-like animal"
];


final List<String> _astronomyWords = [
  "planet", "star", "galaxy", "comet", "asteroid", "meteor", "orbit",
  "telescope", "satellite", "nebula", "blackhole", "supernova", "eclipse",
  "gravity", "cosmos", "lightyear", "quasar", "solar", "lunar", "equinox",
  "solstice", "asterism", "planetarium", "astronaut", "spaceship", "rocket",
  "payload", "mission", "radiation", "vacuum", "universe", "exoplanet",
  "binary", "axis", "celestial", "zenith", "horizon", "ecliptic", "aphelion",
  "perihelion", "redshift", "blueshift", "cosmology", "interstellar",
  "darkmatter", "eventhorizon",
  // new words
  "zodiac", "cosmic", "nebular", "meteor"
];

final List<String> _astronomyClues = [
  "Orbits a star", "Massive glowing gas ball", "Group of stars",
  "Icy tail object", "Rock orbiting sun", "Space rock",
  "Path in space", "Object for viewing stars", "Man-made in space",
  "Cloud of gas/dust", "Region of strong gravity", "Exploding star",
  "Sun or moon blocked", "Force pulling objects", "Universe",
  "Distance light travels", "Bright distant object", "Relates to sun",
  "Relates to moon", "Day of equal day/night", "Sun's highest/lowest point",
  "Group of stars", "Place for star shows", "Space traveler",
  "Space vehicle", "Vehicle with engines", "Cargo carried", "Space journey",
  "Energy emitted", "Empty space", "All matter", "Planet outside solar system",
  "Two stars orbiting", "Imaginary line", "Sky-related", "Point overhead",
  "Where earth meets sky", "Sun's path", "Farthest sun point",
  "Closest sun point", "Light shift red", "Light shift blue",
  "Study of universe", "Between stars", "Invisible universe mass", "Black hole edge",
  // new clues
  "Star sign band", "Relating to universe", "Relating to nebula", "Space rock burning"
];


final List<String> _architectureWords = [
  "arch", "column", "beam", "foundation", "facade", "vault", "dome",
  "pediment", "buttress", "cornice", "plinth", "balcony", "pillar",
  "truss", "gable", "lintel", "keystone", "masonry", "parapet",
  "cladding", "cantilever", "eave", "pilaster", "quoin", "soffit",
  "spire", "staircase", "terrace", "transom", "vaulting", "cupola",
  "portico", "niche", "alcove", "balustrade", "casing", "clerestory",
  "finial", "frieze", "gablet", "groin", "hip", "impost", "joist",
  "lattice", "molding", "mullion", "oculus", "parterre",
  // new words
  "fascia", "archway", "decking"
];

final List<String> _architectureClues = [
  "Curved support", "Vertical support", "Horizontal support",
  "Building base", "Front exterior", "Arched ceiling", "Rounded roof",
  "Triangular upper part", "Wall support", "Decorative edge",
  "Base platform", "Outside platform", "Vertical support", "Roof framework",
  "Triangular roof end", "Beam over opening", "Central wedge stone",
  "Stonework", "Low protective wall", "Wall covering",
  "Projecting beam", "Roof edge", "Flat column", "Corner block",
  "Underside of eave", "Pointed structure", "Steps", "Flat open area",
  "Window section", "Arched ceiling", "Small dome", "Covered porch",
  "Recessed wall area", "Small recess", "Railings", "Decorative trim",
  "Upper wall windows", "Ornamental top", "Decorative band",
  "Small gable", "Intersecting vault", "Roof with 3 slopes",
  "Support block", "Floor joist", "Crisscross framework",
  "Decorative molding", "Window divider", "Round window", "Garden area",
  // new clues
  "Decorative band", "Arched passage", "Outdoor wooden floor"
];


final List<String> _fashionWords = [
  "tunic", "placket", "sequin", "jumpsuit", "blazer", "corset", "pumps",
  "legging", "kimono", "culotte", "shawl", "halter", "bodice", "sweater",
  "jersey", "parka", "chinos", "cardigan", "tanktop", "anorak", "sarong",
  "muffler", "tassels", "gloves", "jacket", "suspend", "buttons", "scarf",
  "necktie", "beanie", "overalls", "earring", "bracelet", "skirt", "blouse",
  "mittens", "brogues", "loafers", "oxfords", "sneaker", "flannel", "fedora",
  "tuxedo", "slipper", "kilt", "hoodie", "crochet", "zippers", "beret"
];

final List<String> _fashionClues = [
  "Loose-fitting top", "Garment opening strip", "Shiny decoration",
  "One-piece outfit", "Casual jacket", "Fitted bodice", "Heeled shoe",
  "Tight pants", "Japanese robe", "Split skirt", "Shoulder wrap",
  "Backless top", "Upper part of dress", "Warm knitwear", "Stretchy shirt",
  "Hooded coat", "Casual trousers", "Open sweater", "Sleeveless shirt",
  "Pullover coat", "Wrap skirt", "Neck warmer", "Hanging ornament",
  "Hand covers", "Upper garment", "Hold up pants", "Closures on clothes",
  "Neck wrap", "Formal neckwear", "Warm cap", "Full-body garment",
  "Ear jewelry", "Wrist accessory", "Lower wear", "Dress shirt",
  "Finger warmers", "Wingtip shoes", "Slip-on shoes", "Formal shoes",
  "Sport shoe", "Soft fabric shirt", "Brimmed hat", "Formal suit",
  "Comfy shoe", "Scottish skirt", "Sweatshirt", "Knitted fabric",
  "Fasteners on clothes", "Flat round cap"
];

final List<String> _photographyWords = [
  "viewing", "panels", "pixels", "focus", "flash", "manual", "sensor",
  "mirror", "shutter", "apertur", "expose", "framing", "filter", "viewer",
  "zooming", "tripods", "bulb", "film", "bokeh", "prints", "images",
  "layers", "editor", "camera", "framer", "toning", "format", "canvas",
  "border", "shapes", "rotate", "shades", "retake", "motion", "record",
  "export", "resize", "editing", "capture", "lighting", "shallow",
  "contrast", "balance", "highres", "preview", "picture", "digital",
  "tripod", "develop"
];

final List<String> _photographyClues = [
  "Looking at photos", "Display sections", "Image elements",
  "Adjust clarity", "Light burst", "User-operated mode", "Image detector",
  "Reflective part", "Opens/closes lens", "Lens hole",
  "Control light time", "Photo composition", "Color adjuster",
  "Eye viewer", "Close image", "Stand support", "Long exposure setting",
  "Old photo medium", "Blurry background", "Printed pictures",
  "Captured visuals", "Image layers", "Photo adjuster", "Takes photo",
  "Outlines image", "Image coloring", "File structure", "Drawing space",
  "Frame line", "Basic outlines", "Turn image", "Light range",
  "Redo photo", "Motion blur", "Save video", "Send photo",
  "Image size", "Change image", "Grab moment", "Light source setup",
  "Shallow focus", "Light/dark level", "Color tuning",
  "High resolution", "Image preview", "Still image", "Electronic image",
  "Camera stand", "Process film"
];

final List<String> _journalismWords = [
  "bulletin", "pressman", "briefing", "newsdesk", "dispatch", "release",
  "notebook", "photog", "scoop", "lead", "editor", "reporter", "caption",
  "column", "review", "opinion", "feature", "sources", "newsroom",
  "dateline", "article", "sidebar", "magazine", "gazette", "journal",
  "retract", "publish", "headline", "teasers", "updates", "credits",
  "rewrite", "presskit", "coverage", "layout", "weekly", "bylines",
  "report", "viewer", "clerk", "stringer", "digests", "slander",
  "freedom", "printing", "media", "column", "paper", "truth"
];

final List<String> _journalismClues = [
  "Short news update", "Printing press operator", "Concise news delivery",
  "Central editing station", "Sent news report", "Official info issued",
  "Reporter’s jotter", "News photographer", "Exclusive story",
  "Intro to news piece", "Story reviser", "News gatherer",
  "Text under photo", "Recurring piece", "Critique article",
  "Personal view", "In-depth story", "Information givers",
  "Workplace of journalists", "Story origin", "Written piece",
  "Extra story", "Glossy publication", "Official journal",
  "Public record", "Print content", "Story title",
  "Preview texts", "Fresh news", "Story acknowledgements",
  "News revision", "Reporter kit", "Media attention", "Page structure",
  "Regular news", "Author credits", "Give account", "Photo viewer",
  "Filing staff", "News helper", "News summaries", "False statement",
  "Right to publish", "Print process", "News source", "Opinion piece",
  "Paper sheet", "Factful info"
];


final List<String> _psychologyWords = [
  "therapy", "empathy", "habits", "anxiety", "feeling", "motive", "dreams",
  "coping", "stress", "shyness", "phobia", "trauma", "values", "parent",
  "socials", "temper", "beliefs", "impulse", "mental", "crisis", "grieve",
  "psyche", "disrupt", "remorse", "guilt", "person", "esteem", "addicts",
  "adjusts", "memory", "denial", "craves", "brains", "wishes", "sexual",
  "border", "silent", "crisis", "talker", "outcry", "family", "values",
  "socials", "trauma", "intake", "repress", "mindset", "delays"
];

final List<String> _psychologyClues = [
  "Healing process", "Feeling others' pain", "Routine acts",
  "Worry disorder", "Internal state", "What drives acts",
  "Sleep stories", "Dealing tactic", "Mental strain",
  "Introverted trait", "Extreme fear", "Past wound",
  "Moral stance", "Caregiver", "Relating to peers",
  "Mood balance", "Held truths", "Sudden urge",
  "Mind health", "Life turning point", "Deep sorrow",
  "Mind state", "Break in state", "Deep regret",
  "Inner shame", "Self image", "Need for fix",
  "Life tuning", "Recalled info", "Truth refusal",
  "Strong want", "Thinking part", "Inner hopes",
  "Urge desire", "Limit line", "Quiet type",
  "Crisis time", "Talkative one", "Public shout",
  "Kin group", "Belief rules", "Peer bonds",
  "Emotional harm", "Food taken", "Push down",
  "Way of view", "Delay act"
];

final List<String> _agricultureWords = [
  "harvest", "ploughs", "seeders", "tractor", "farmer", "irrigate",
  "livests", "weeder", "mulcher", "sprayer", "hoeing", "gardens",
  "grafts", "pesticid", "barn", "fodder", "milker", "herder", "raking",
  "farrow", "sickle", "reaper", "seeder", "fields", "tiller",
  "planter", "pasture", "ridges", "manure", "hoe", "fork",
  "cattle", "poultry", "grains", "pruner", "nursery", "herbs",
  "weevil", "shovel", "spades", "rakers", "garden", "crops",
  "mower", "digger", "loader", "cutter", "binder", "bailer"
];

final List<String> _agricultureClues = [
  "Crop picking", "Soil turning tool", "Planting gear",
  "Farm vehicle", "Farm worker", "Watering plants",
  "Farm beasts", "Grass cutter", "Soil cover tool",
  "Crop duster", "Ground work", "Plant plots",
  "Plant merge", "Bug killer", "Storage hut",
  "Animal feed", "Milk taker", "Cattle guide",
  "Gather tool", "Pig birth", "Grain blade",
  "Crop cutter", "Seed dropper", "Farm land",
  "Soil tool", "Plant setter", "Grazing land",
  "Soil mounds", "Soil boost", "Dig tool",
  "Soil lift tool", "Farm cows", "Farm birds",
  "Seed foods", "Cutting tool", "Plant place",
  "Small meds", "Crop bug", "Dig tool",
  "Dig tool", "Farm sweeper", "Green space",
  "Food plants", "Grass tool", "Earth mover",
  "Lift tool", "Chop tool", "Bind tool",
  "Hay packer"
];

final List<String> _computerScienceWords = [
  "backend", "cookies", "network", "gateway", "compile", "pixels",
  "syntax", "boolean", "storage", "firewall", "router", "binary",
  "cache", "output", "input", "coding", "script", "markup",
  "client", "server", "folder", "cursor", "prompt", "domain",
  "cookie", "upload", "buffer", "socket", "thread", "widget",
  "mobile", "browser", "tablet", "driver", "cloud", "layout",
  "github", "plugin", "launch", "search", "format", "window",
  "button", "screen", "cursor", "editor", "update", "filter"
];

final List<String> _computerScienceClues = [
  "Behind systems", "Web tracker", "Data links",
  "Entry bridge", "Make program", "Tiny squares",
  "Code rules", "True/false type", "Data saving",
  "Net block", "Net splitter", "Number code",
  "Fast store", "Data result", "Enter data",
  "Code writing", "Run file", "Tag type",
  "User side", "Host side", "File space",
  "Text arrow", "User line", "Web name",
  "Tiny file", "Send file", "Hold data",
  "Port link", "Code stream", "UI part",
  "Small phone", "Web viewer", "Touch screen",
  "Run tool", "Web save", "Design view",
  "Code site", "Extra tool", "Start app",
  "Find info", "Text style", "App box",
  "Click item", "View zone", "Type arrow",
  "Code pad", "Fix file", "Sort info"
];


final List<String> _chemistryWords = [
  "atom", "molecule", "element", "compound", "ion", "acid", "base", "pH",
  "reaction", "catalyst", "enzyme", "oxidize", "reduce", "periodic", "valence",
  "bond", "electron", "proton", "neutron", "isotope", "solvent", "solute",
  "solution", "mixture", "precipitate", "equilibrium", "energy", "molarity", "density",
  "viscosity", "boiling", "melting", "fusion", "sublime", "condense", "evaporate",
  "distill", "polymer", "organic", "inorganic", "alkane", "alkene", "alkyne",
  "aromatic", "acidic", "basic", "neutral", "oxidizer", "reducer"
];

final List<String> _chemistryClues = [
  "Smallest unit of matter", "Two or more atoms bonded", "Pure substance", "Two or more elements bonded",
  "Charged atom", "Substance with H+ ions", "Substance with OH- ions", "Measure of acidity",
  "Chemical change", "Speeds up reaction", "Biological catalyst", "Loss of electrons",
  "Gain of electrons", "Table of elements", "Outer shell electrons",
  "Connection between atoms", "Negatively charged particle", "Positively charged particle",
  "Neutral particle", "Atoms with different neutrons", "Liquid dissolving agent", "Dissolved substance",
  "Homogeneous mixture", "Combination of substances", "Solid formed in solution", "Balance in reaction",
  "Capacity to do work", "Concentration of solute", "Mass per volume", "Thickness of liquid",
  "Temperature boiling point", "Temperature melting point", "Process of melting",
  "Solid to gas", "Gas to liquid", "Liquid to gas", "Separating mixtures by boiling",
  "Large molecule", "Carbon-based compound", "Not carbon-based",
  "Single bonds", "Double bonds", "Triple bonds", "Ring structure", "pH below 7",
  "pH above 7", "pH of 7", "Electron acceptor", "Electron donor"
];

final List<String> _physicsWords = [
  "force", "mirror", "conduction", "momentum", "refraction",
  "lightning", "sound", "crest", "velocity", "friction",
  "joule", "mass", "diffraction", "inertia", "gravity",
  "field", "gravity", "gravity", "speedlaw", "ray",
  "falltime", "constant", "weightless", "calorie", "sunlight",
  "voltage", "newton", "energy", "recoil", "atom",
  "waveform", "ray", "lever", "soundwave", "radio",
  "drag", "heatflow", "nofrictn", "timing", "particle",
  "potential", "direction", "chargeend", "heatmove", "rotation",
  "pointmass", "freezing", "mixing", "work", "beam"
];

final List<String> _physicsClues = [
  "Push pull", "Stops light", "Heat move", "Mass times", "Light mix",
  "Sky flash", "Sound out", "Wave crest", "Quick move", "Stops flow",
  "Base unit", "Matter amt", "Light bend", "No motion", "Attracts",
  "Field line", "Mass pull", "Earth pull", "Speed law", "Ray travel",
  "Fall time", "Same speed", "No weight", "Heat unit", "Sun power",
  "Volt push", "Force law", "Energy law", "Push back", "Atom unit",
  "Wave form", "Light ray", "Equal arm", "Sound wave", "Radio wave",
  "Slow drag", "Heat flow", "No frictn", "Time rule", "Fast part",
  "Up energy", "Down field", "Charge end", "Heat move", "Angle roll",
  "Point mass", "Ice temp", "Sound mix", "Mass work", "Wave beam"
];

final List<String> _mathematicsWords = [
  "arithmetic", "integer", "bargraph", "formula", "statistics",
  "median", "logic", "vertex", "anglesum", "parallelogram",
  "fraction", "histogram", "division", "digit", "addition",
  "identity", "maximum", "estimation", "line", "sum",
  "polygon", "isosceles", "perimeter", "total", "area",
  "set", "step", "highest", "lowest", "row",
  "axis", "endpoint", "line", "main", "root",
  "solve", "side", "change", "list", "factor",
  "two", "base", "sequence", "collinear", "zero",
  "process", "plus", "sum", "series", "variable"
];

final List<String> _mathematicsClues = [
  "Count art", "Whole num", "Graph bar", "Math rule", "Data part",
  "Half way", "Logic tool", "Top angle", "Side sum", "Long shape",
  "Tiny part", "Show data", "Long divs", "Num part", "Add back",
  "True form", "Big value", "Guess fit", "Fact line", "Add group",
  "Cut shape", "Same side", "Num side", "Whole all", "Math area",
  "Set pair", "Step jump", "High num", "Low num", "Place row",
  "Axis spin", "Graph end", "Line math", "Main math", "Root two",
  "Solve it", "Side math", "Change it", "List math", "Fact math",
  "Two line", "Ten part", "Step math", "Same line", "Zero line",
  "Math step", "Plus math", "Sum parts", "Three dot", "Change y"
];

final List<String> _dentistryWords = [
  "dentist", "cusp", "gingiva", "enamel", "cleaning",
  "gumcare", "cavity", "probe", "dentures", "bite",
  "xray", "anesthetic", "caries", "pulpitis", "rinse",
  "filling", "extraction", "sensation", "curette", "impression",
  "radiograph", "inflammation", "massage", "sensitivity", "heat",
  "mask", "orthodontist", "sealant", "pulling", "mouthguard",
  "testing", "wire", "chipped", "neuralgia", "numbness",
  "clinic", "gingivectomy", "swelling", "case", "ache",
  "softdiet", "stopper", "prosthesis", "hygiene", "healing",
  "brush", "bitewing", "treatment", "whitening", "restoration"
];

final List<String> _dentistryClues = [
  "Tooth doc", "Tooth tip", "Gum ache", "Tooth bone", "Tooth clean",
  "Gum care", "Tooth hole", "Tooth pick", "False set", "Bite mark",
  "Xray doc", "Numb drug", "Tooth rot", "Root pain", "Tooth wash",
  "Tooth aid", "Tooth fix", "Pull tool", "Tooth feel", "Tooth pic",
  "Tooth mold", "Mouth xray", "Gum swell", "Tooth rub", "Tooth heat",
  "Tooth mask", "Tooth doc", "Tooth fill", "Tooth pull", "Mouth tube",
  "Tooth test", "Fix wire", "Tooth chip", "Nerve pain", "Tooth numb",
  "Xray room", "Gum peel", "Jaw swell", "Tooth case", "Tooth pain",
  "Soft food", "Tooth stop", "Fake jaw", "Gum clean", "Bone heal",
  "Tooth brush", "Tooth bite", "Tooth cure", "White wash", "Smile fix"
];

final List<String> _veterinaryWords = [
  "animalcare", "vet", "vaccinate", "cat", "dog",
  "technician", "equine", "checkup", "bovine", "medications",
  "dermatology", "radiology", "barking", "dental", "paws",
  "bite", "parasite", "tail", "healing", "prescriptions",
  "aquatic", "breeds", "nutrition", "bitewound", "injury",
  "calming", "teeth", "cleaning", "examination", "treatment",
  "testing", "rash", "mites", "fur", "limping",
  "warming", "trimming", "ears", "filing", "stool",
  "injury", "eyes", "tooth", "milk", "cage",
  "illness", "health", "care", "sickness", "grooming"
];

final List<String> _veterinaryClues = [
  "Pet care", "Animal doc", "Dog shot", "Cat doc", "Vet tech",
  "Horse doc", "Check pup", "Farm vet", "Cow doc", "Pet meds",
  "Skin itch", "Pet xray", "Bark test", "Pet teeth", "Paw care",
  "Cat bite", "Flea bite", "Tail wag", "Pet heal", "Dog meds",
  "Fish vet", "Dog breed", "Food safe", "Bite mark", "Injure dog",
  "Bark calm", "Dog tooth", "Pet clean", "Check cow", "Fix tail",
  "Nose test", "Vet bag", "Bird doc", "Dog rash", "Ear mite",
  "Fur shed", "Dog limp", "Warm pad", "Nail trim", "Dog ear",
  "Pet file", "Stool lab", "Injure paw", "Check eyes", "Tooth fur",
  "Milk test", "Cage vet", "Pet hurt", "Sick dog", "Fix fur"
];

final List<String> _botanyWords = [
  "stomata", "xylem", "phloem", "sepal", "petal", "ovary", "pollen", "carpel",
  "leaf", "root", "stem", "flower", "fruit", "bud", "spore",
  "bark", "fungus", "moss", "fern", "lichen", "cutting", "tuber",
  "rhizome", "stigma", "style", "anther", "seed", "cone", "blade",
  "midrib", "petiole", "woody", "annual", "bud", "sap", "tree",
  "grass", "shrub", "rootlet", "clover", "ivy", "reed", "stemlet",
  "bulb", "leaflet", "vine", "flora", "fruitlet", "shoot", "leafy"
];

final List<String> _botanyClues = [
  "Tiny openings on leaves", "Water transport tissue", "Food transport tissue", "Protective flower leaf",
  "Colorful flower part", "Part containing seeds", "Male pollen grains", "Female reproductive part",
  "Plant leaf", "Anchors plant", "Supports plant", "Reproductive structure", "Mature ovary", "New growth",
  "Reproductive cell in fungi", "Protective outer layer", "Fungi-like organism", "Non-vascular plant",
  "Vascular plant", "Plant propagation method", "Underground storage stem", "Horizontal underground stem",
  "Pollen-receptive part", "Part of style", "Part of stamen producing pollen", "Plant seed",
  "Reproductive structure of conifers", "Leaf part", "Central leaf vein", "Leaf stalk",
  "Woody plant", "Lives one year", "New growth tip", "Plant sap", "Large plant", "Small plant",
  "Small woody plant", "Tiny root", "Common lawn plant", "Climbing plant", "Water plant", "Small stem",
  "Bulbous plant part", "Small leaf", "Climbing plant", "Plants of a region", "Small fruit",
  "New plant growth", "Leafy plant part"
];


final List<String> _geologyWords = [
  "igneous", "magma", "lava", "fossil", "mineral", "rock", "crust",
  "mantle", "core", "fault", "plate", "rift", "fold", "glacier",
  "moraine", "geyser", "hotspot", "basalt", "granite", "quartz",
  "gneiss", "schist", "strata", "seismic", "sandstone", "calcite",
  "limestone", "pumice", "obsidian", "karst", "bedrock", "alluvial",
  "cairn", "cache", "chisel", "clan", "dam", "dome", "druid",
  "forge", "glyph", "vault", "wall", "yurt", "tool", "dig", "coal",
  "ore", "peat", "clay"
];

final List<String> _geologyClues = [
  "Formed from cooled magma", "Molten rock beneath surface", "Molten rock on surface",
  "Preserved remains", "Natural solid substance", "Solid mineral material", "Earth's outer layer",
  "Layer beneath crust", "Earth's center", "Crack in earth", "Large pieces of earth's surface",
  "Crack in crust", "Bend in rock layers", "Large ice mass", "Glacial debris",
  "Hot spring", "Volcanic hot spot", "Volcanic rock", "Coarse-grained rock", "Common mineral",
  "Foliated metamorphic rock", "Medium-grade metamorphic rock", "Layers of rock", "Related to earthquakes",
  "Sand-based rock", "Mineral form of calcium carbonate", "Calcium carbonate rock", "Light volcanic rock",
  "Volcanic glass", "Karst landscape", "Solid rock beneath soil", "Relating to river deposits",
  "Stone pile", "Hidden storage", "Tool for carving", "Family group", "Barrier across water",
  "Rounded roof", "Celtic priest", "Metalworking", "Symbol", "Arched ceiling", "Structure barrier",
  "Portable tent", "Implement", "To dig", "Fossil fuel", "Rock with metal", "Partly decayed plant",
  "Fine-grained soil"
];


final List<String> _meteorologyWords = [
  "humidity", "barometer", "wind", "cyclone", "front", "dewpoint", "isobar",
  "jetstream", "stratus", "cumulus", "cirrus", "hail", "sleet", "frost",
  "fog", "ozone", "gust", "storm", "tropic", "polar", "vortex", "cloud",
  "rain", "snow", "dew", "freeze", "windy", "stormy", "sunny", "humid",
  "dry", "calm", "cold", "hot", "rainy", "cloudy", "clear", "breeze",
  "frosty", "blustery", "chilly", "drizzle", "squall", "gale", "sun", "air",
  "mist", "ice", "arctic", "moist"
];

final List<String> _meteorologyClues = [
  "Moisture in air", "Pressure measuring tool", "Air movement", "Rotating wind storm",
  "Boundary between air masses", "Air's saturation point", "Equal pressure line",
  "Fast upper air current", "Flat low cloud", "Fluffy white cloud", "Thin high cloud",
  "Frozen rain", "Rain and snow mix", "Ice on surfaces", "Low visibility",
  "Protective gas layer", "Sudden wind burst", "Weather event", "Warm region",
  "Cold region", "Rotating air mass", "Water vapor group", "Liquid from clouds",
  "Frozen water drop", "Morning moisture", "Below 0°C", "With strong wind",
  "With lightning", "Bright and warm", "High moisture", "No moisture",
  "Still air", "Very low temp", "High temp", "Rain present", "Sky with clouds",
  "No clouds", "Gentle wind", "Cold and icy", "Windy and noisy", "Cool and fresh",
  "Light steady rain", "Short sharp wind", "Strong wind", "Sky orb",
  "Gas we breathe", "Thin fog", "Frozen water", "Wet and sticky air"
];

final List<String> _economicsWords = [
  "markets", "capital", "finance", "inflation", "demand", "supply", "product",
  "revenue", "costs", "profits", "budget", "monopoly", "tariffs", "utility",
  "export", "import", "savings", "currency", "equity", "debtors", "assets",
  "liability", "dividend", "interest", "stocks", "bonds", "taxation", "deficit",
  "surplus", "exchange", "welfare", "growths", "capital", "market", "prices",
  "labour", "output", "creditor", "funding", "capital", "loans", "profits",
  "income", "supply", "demand", "stocks", "trading", "wealth", "budget", "taxes"
];

final List<String> _economicsClues = [
  "Places to buy and sell", "Wealth or resources", "Money management", "General price rise",
  "Consumer desire", "Amount available", "Goods produced", "Income from sales",
  "Expenses", "Earnings after costs", "Financial plan", "Single seller control",
  "Taxes on imports", "Satisfaction gained", "Goods sent out", "Goods brought in",
  "Money saved", "Money system", "Ownership value", "Those who owe money",
  "Owned property", "Debt owed", "Profit shares", "Cost for borrowing", "Shares of company",
  "Debt certificates", "Government charges", "Spending more than income",
  "Spending less than income", "Trading goods", "Social aid", "Increase in size",
  "Wealth or assets", "Place to trade", "Cost of items", "Workers",
  "Production amount", "Person owed money", "Money supply", "Providing money",
  "Wealth or resources", "Borrowed money", "Profit made", "Money earned", "Goods available",
  "Desire for goods", "Shares of stock", "Buying and selling", "Material wealth",
  "Financial plan", "Government charges"
];

final List<String> _archaeologyWords = [
  "artifact", "excavate", "fossilize", "hieroglyph", "monument", "paleolith",
  "stratify", "toolkits", "carbonate", "ancients", "ceramics", "reliefs",
  "scaffold", "taphonomy", "tribalism", "unearthed", "valleybed", "warefare",
  "chronicle", "diggings", "epigraphy", "findings", "flintlock", "geology",
  "historian", "inscribe", "jewellery", "kilnsite", "lithics", "manuscript",
  "neolithic", "obsidian", "pictogram", "prehistor", "quarrying", "remains",
  "sarcophg", "sediment", "stratum", "temple", "toolmark", "uncover", "vaulted",
  "wattle", "xerophyte", "yielding", "ziggurat", "cuneiform", "digsite", "cairn"
];

final List<String> _archaeologyClues = [
  "Man-made object", "To dig carefully", "Become fossilized", "Ancient writing",
  "Historic building", "Old stone age era", "Layering of soil", "Set of tools",
  "Calcium compound", "Very old times", "Pottery", "Stone carvings",
  "Support structure", "Study of decay", "Group loyalty", "Found in ground",
  "Low land between hills", "War activity", "Historical record", "Excavations",
  "Study of inscriptions", "Discovered items", "Old firearm", "Study of earth",
  "Student of history", "Write on surface", "Ornaments", "Ancient kiln site",
  "Stone tools", "Handwritten document", "New stone age", "Volcanic glass",
  "Picture writing", "Before recorded history", "Mining stone", "Leftover parts",
  "Stone coffin", "Deposited material", "Soil layer", "Religious building",
  "Marks made by tools", "Reveal hidden", "Arched structure", "Fence of sticks",
  "Drought resistant plant", "Producing results", "Ancient Mesopotamian tower",
  "Wedge-shaped writing", "Digging location", "Stone pile"
];

final List<String> _linguisticsWords = [
  "phonemes", "syntaxes", "morpheme", "semantics", "dialects", "grammar", "lexicon",
  "pragmatic", "phonology", "morphology", "discourse", "syntax", "linguist",
  "phonetic", "intonate", "stressful", "articulate", "bilingual", "codecopy",
  "inflection", "loanword", "neologsm", "paradigm", "prosody", "registers",
  "socioling", "transcript", "utterance", "vocabulary", "wordform", "accented",
  "cognates", "dialectal", "ellipsis", "ellipsis", "ellipsis", "glossary",
  "intonated", "lexeme", "metonymy", "nominals", "orthography", "parsing",
  "phonemic", "polysemy", "predicate", "sememe", "syntaxic", "tense", "verbals",
  "vowels", "syntaxed"
];

final List<String> _linguisticsClues = [
  "Distinct speech sounds", "Sentence structure", "Smallest meaning unit", "Meaning of words",
  "Regional language forms", "Rules of language", "Vocabulary list", "Contextual use",
  "Study of sounds", "Word formation", "Connected speech", "Arrangement of words",
  "Language expert", "Sound system", "Pitch patterns", "Emphasis in speech",
  "Clear speaking", "Speaks two languages", "Switching languages", "Change in form",
  "Borrowed word", "New word", "Model or pattern", "Speech rhythm", "Language style",
  "Language in society", "Written record", "Spoken phrase", "Word list", "Form of a word",
  "With emphasis", "Related words", "Related to dialect", "Omission of words", "Omission of words",
  "Word list", "Pitch changes", "Basic word form", "Meaning substitution", "Nouns",
  "Spelling system", "Analyzing sentences", "Sound units", "Multiple meanings",
  "Verb part", "Basic meaning", "Syntax related", "Time form", "Verb forms",
  "Speech sounds", "Sentence structure"
];

final List<String> _philosophyWords = [
  "epistemic", "aesthetic", "dialectic", "ontology", "metaphys", "ethics", "logic",
  "cognition", "rational", "virtues", "axioms", "paradox", "nihilism", "phenomen",
  "idealism", "existens", "dialect", "teleolog", "material", "skeptic", "utilita",
  "heuristic", "monism", "pluralism", "empirics", "categoric", "deductiv", "inductiv",
  "pragmatic", "realism", "solipsism", "stoicism", "utilitar", "fatalism", "hedonism",
  "dialect", "ontology", "epistemi", "ethics", "virtue", "logic", "reason",
  "truths", "beliefs", "morals", "values", "wisdom", "justice", "freedom", "mind",
  "reasoning", "conscious"
];

final List<String> _philosophyClues = [
  "Theory of knowledge", "Study of beauty", "Dialogue method", "Study of being",
  "Beyond physical", "Moral principles", "Principles of reasoning", "Mental processes",
  "Based on reason", "Good character traits", "Basic truths", "Contradictory truth",
  "Belief in nothing", "Experience of phenomena", "Idealistic belief", "State of being",
  "Formal discussion", "Purpose or design", "Physical matter", "Doubtful attitude",
  "Greatest good", "Problem-solving method", "Oneness", "Many forms", "Based on experience",
  "Absolute rules", "Reasoning from general to specific", "Reasoning from specific to general",
  "Practical approach", "Belief in reality", "Self is all", "Endurance philosophy",
  "Greatest pleasure", "Formal discussion", "Study of being", "Theory of knowledge",
  "Moral principles", "Good qualities", "Principles of logic", "Use of reason",
  "True statements", "Beliefs held", "Principles of right and wrong", "Standards held",
  "Deep understanding", "Fairness", "Freedom to act", "Thinking faculty",
  "Logical thinking", "Awareness"
];

final List<String> _theaterWords = [
  "backdrop", "costumes", "dialogue", "ensemble", "footlights", "monologue", "orchestra",
  "proscen", "stagecraft", "scripted", "tragedy", "comedy", "director", "playbill",
  "actress", "audience", "boxoffice", "charcter", "chorus", "curtain", "ensemble",
  "improv", "lighting", "makeup", "matinee", "melodram", "props", "producer",
  "rehears", "scenery", "script", "soliloqu", "spotlight", "staging", "stage",
  "theatre", "thespian", "troupe", "upstage", "vaudevil", "wings", "act", "auditor",
  "ballet", "captain", "casting", "director", "ensemble", "entrance"
];

final List<String> _theaterClues = [
  "Background scene", "Clothes worn", "Spoken lines", "Group acting", "Stage lights",
  "Solo speech", "Musical section", "Stage area", "Stage technical art", "Written play",
  "Sad play", "Funny play", "Show leader", "Show program", "Female actor",
  "Spectators", "Ticket sales", "Character role", "Group singing", "Stage curtain",
  "Group acting", "Unscripted acting", "Stage lights", "Face painting", "Afternoon show",
  "Dramatic play", "Stage items", "Show organizer", "Practice sessions", "Stage decorations",
  "Play text", "Solo speech", "Focused light", "Stage arranging", "Performance area",
  "Performance place", "Actor", "Acting group", "Behind stage", "Variety show", "Side areas",
  "Performance", "Hearing room", "Dance form", "Group leader", "Choosing actors", "Show leader",
  "Group acting", "Entry"
];

final List<String> _sportsWords = [
  "athletic", "baseball", "batting", "ballgame", "coaches", "cyclists", "defense",
  "fencing", "football", "goalpost", "gymnasts", "hurdles", "javelins", "kayaking",
  "lacrosse", "marathon", "offense", "outfield", "pitchers", "racquet", "referee",
  "sailors", "scoring", "skating", "soccer", "swimming", "tennis", "umpires",
  "volleys", "wrestler", "yachting", "boxing", "curling", "diving", "equestri",
  "fishing", "golfing", "handball", "hockey", "judo", "kayak", "karate", "motors",
  "rowing", "rugby", "skiing", "snowboard", "surfing", "taekwond", "triathlon"
];

final List<String> _sportsClues = [
  "Physical fitness", "Bat and ball game", "Hitting in baseball", "Competitive game",
  "Team leaders", "Bike racers", "Prevent scoring", "Sword fighting", "Team sport",
  "Goal structure", "Gymnastic athletes", "Race obstacles", "Throwing spear", "Water sport",
  "Stick game", "Long-distance race", "Attacking team", "Fielding position", "Baseball thrower",
  "Racket sports", "Game official", "Boat crew", "Earning points", "Ice skating sport",
  "Soccer game", "Water sport", "Racket game", "Game referees", "Volley hits",
  "Combat sport athlete", "Sailing sport", "Fighting sport", "Ice sport", "Underwater sport",
  "Horse riding", "Angling sport", "Golf game", "Handball sport", "Ice hockey",
  "Martial art", "Small boat", "Martial art", "Motor sport", "Boat racing",
  "Contact sport", "Snow sport", "Board sport", "Water sport", "Martial art",
  "Multi-sport event"
];

final List<Level> allLevels = List.generate(30, (index) {
  final categoryId = (index + 1).toString();
  return generateLevels(categoryId);
}).expand((levels) => levels).toList();

void initializeLevels() {
  groupLevelsByCategory(allLevels);
}
