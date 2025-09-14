class Experience {
  final String company;
  final String position;
  final String location;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final List<String> achievements;
  final List<String> technologies;
  final String description;

  const Experience({
    required this.company,
    required this.position,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.achievements,
    required this.technologies,
    required this.description,
  });
}
