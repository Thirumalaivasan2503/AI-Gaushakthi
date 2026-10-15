import 'package:equatable/equatable.dart';

/// Educational Article / FAQ / Government Scheme Model
class KnowledgeArticleModel extends Equatable {
  final String id;
  final String title;
  final String category; // Seasonal Advice, Ethno-Medicine, Govt Schemes, FAQ
  final String readTime;
  final String summary;
  final String fullContent;
  final String author;
  final bool isBookmarked;

  const KnowledgeArticleModel({
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.summary,
    required this.fullContent,
    required this.author,
    this.isBookmarked = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'read_time': readTime,
        'summary': summary,
        'full_content': fullContent,
        'author': author,
        'is_bookmarked': isBookmarked,
      };

  factory KnowledgeArticleModel.fromJson(Map<String, dynamic> json) => KnowledgeArticleModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        category: json['category'] ?? 'General',
        readTime: json['read_time'] ?? '5 min',
        summary: json['summary'] ?? '',
        fullContent: json['full_content'] ?? '',
        author: json['author'] ?? 'AgriTech Advisory Board',
        isBookmarked: json['is_bookmarked'] ?? false,
      );

  KnowledgeArticleModel copyWith({bool? isBookmarked}) {
    return KnowledgeArticleModel(
      id: id,
      title: title,
      category: category,
      readTime: readTime,
      summary: summary,
      fullContent: fullContent,
      author: author,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        readTime,
        summary,
        fullContent,
        author,
        isBookmarked,
      ];
}
