class Project {
  final String title;
  final String description;
  final String longDescription;
  final List<String> technologies;
  final List<String> tags;
  final String? appStoreUrl;
  final String? playStoreUrl;
  final String? githubUrl;
  final String? websiteUrl;
  final String? imageUrl;
  final String achievement;
  final String category;

  const Project({
    required this.title,
    required this.description,
    required this.longDescription,
    required this.technologies,
    required this.tags,
    this.appStoreUrl,
    this.playStoreUrl,
    this.githubUrl,
    this.websiteUrl,
    this.imageUrl,
    required this.achievement,
    required this.category,
  });
}
