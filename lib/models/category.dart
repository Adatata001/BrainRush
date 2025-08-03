import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final int totalLevels;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.totalLevels,
    required this.description,
  });
}

final List<Category> categories = [
  Category(
    id: "1",
    name: "Medicine",
    icon: Icons.medical_services,
    totalLevels: 50,
    description: "Medical terms and conditions",
  ),
  Category(
    id: "2",
    name: "Music",
    icon: Icons.music_note,
    totalLevels: 50,
    description: "Musical terms and instruments",
  ),
  Category(
    id: "3",
    name: "Painting",
    icon: Icons.brush,
    totalLevels: 50,
    description: "Art terms and techniques",
  ),
  Category(
    id: "4",
    name: "Cooking",
    icon: Icons.restaurant,
    totalLevels: 50,
    description: "Culinary terms and techniques",
  ),
  Category(
    id: "5",
    name: "Law",
    icon: Icons.balance,
    totalLevels: 50,
    description: "Legal terms and concepts",
  ),
  Category(
    id: "6",
    name: "Engineering",
    icon: Icons.engineering,
    totalLevels: 50,
    description: "Engineering terms and tools",
  ),
  Category(
    id: "7",
    name: "Aviation",
    icon: Icons.flight,
    totalLevels: 50,
    description: "Aviation terms and concepts",
  ),
  Category(
    id: "8",
    name: "Marine Biology",
    icon: Icons.waves,
    totalLevels: 50,
    description: "Marine life and oceanography",
  ),
  Category(
    id: "9",
    name: "Astronomy",
    icon: Icons.nightlight_round,
    totalLevels: 50,
    description: "Space and celestial objects",
  ),
  Category(
    id: "10",
    name: "Architecture",
    icon: Icons.account_balance,
    totalLevels: 50,
    description: "Architectural terms and styles",
  ),
  Category(
    id: "11",
    name: "Fashion",
    icon: Icons.checkroom,
    totalLevels: 50,
    description: "Fashion terms and designers",
  ),
  Category(
    id: "12",
    name: "Photography",
    icon: Icons.camera_alt,
    totalLevels: 50,
    description: "Photography terms and techniques",
  ),
  Category(
    id: "13",
    name: "Journalism",
    icon: Icons.article,
    totalLevels: 50,
    description: "Journalism terms and concepts",
  ),
  Category(
    id: "14",
    name: "Psychology",
    icon: Icons.psychology,
    totalLevels: 50,
    description: "Psychological terms and theories",
  ),
  Category(
    id: "15",
    name: "Agriculture",
    icon: Icons.agriculture,
    totalLevels: 50,
    description: "Farming terms and techniques",
  ),
  Category(
    id: "16",
    name: "Computer Science",
    icon: Icons.computer,
    totalLevels: 50,
    description: "Programming and computing terms",
  ),
  Category(
    id: "17",
    name: "Chemistry",
    icon: Icons.science,
    totalLevels: 50,
    description: "Chemical elements and processes",
  ),
  Category(
    id: "18",
    name: "Physics",
    icon: Icons.waves,
    totalLevels: 50,
    description: "Physical laws and concepts",
  ),
  Category(
    id: "19",
    name: "Mathematics",
    icon: Icons.calculate,
    totalLevels: 50,
    description: "Mathematical terms and concepts",
  ),
  Category(
    id: "20",
    name: "Dentistry",
    icon: Icons.medical_services,
    totalLevels: 50,
    description: "Dental terms and procedures",
  ),
  Category(
    id: "21",
    name: "Veterinary",
    icon: Icons.pets,
    totalLevels: 50,
    description: "Animal health terms",
  ),
  Category(
    id: "22",
    name: "Botany",
    icon: Icons.eco,
    totalLevels: 50,
    description: "Plant science terms",
  ),
  Category(
    id: "23",
    name: "Geology",
    icon: Icons.terrain,
    totalLevels: 50,
    description: "Earth science terms",
  ),
  Category(
    id: "24",
    name: "Meteorology",
    icon: Icons.cloud,
    totalLevels: 50,
    description: "Weather science terms",
  ),
  Category(
    id: "25",
    name: "Economics",
    icon: Icons.trending_up,
    totalLevels: 50,
    description: "Economic terms and theories",
  ),
  Category(
    id: "26",
    name: "Archaeology",
    icon: Icons.account_balance,
    totalLevels: 50,
    description: "Ancient artifacts and terms",
  ),
  Category(
    id: "27",
    name: "Linguistics",
    icon: Icons.record_voice_over,
    totalLevels: 50,
    description: "Language science terms",
  ),
  Category(
    id: "28",
    name: "Philosophy",
    icon: Icons.question_answer,
    totalLevels: 50,
    description: "Philosophical terms and theories",
  ),
  Category(
    id: "29",
    name: "Theater",
    icon: Icons.theater_comedy,
    totalLevels: 50,
    description: "Drama and stage terms",
  ),
  Category(
    id: "30",
    name: "Sports",
    icon: Icons.sports_soccer,
    totalLevels: 50,
    description: "Sports terms and equipment",
  ),
];

