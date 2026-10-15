import 'package:equatable/equatable.dart';

enum DocumentCategory {
  vetReport('Veterinary Report'),
  medicalCertificate('Medical Certificate'),
  vaccinationCertificate('Vaccination Certificate'),
  animalPhoto('Animal Image / Photo'),
  invoiceReceipt('Purchase Invoice / Receipt');

  final String label;
  const DocumentCategory(this.label);
}

enum DocumentFormat { pdf, jpeg, png }

enum UploadStatus { pending, uploading, completed, error }

/// Document Metadata Model
class DocumentUploadModel extends Equatable {
  final String id;
  final String title;
  final DocumentCategory category;
  final String filePath;
  final String fileName;
  final double fileSizeBytes;
  final DocumentFormat format;
  final UploadStatus status;
  final double progressPercentage;
  final String uploadTimestamp;

  const DocumentUploadModel({
    required this.id,
    required this.title,
    required this.category,
    required this.filePath,
    required this.fileName,
    required this.fileSizeBytes,
    required this.format,
    this.status = UploadStatus.completed,
    this.progressPercentage = 100.0,
    required this.uploadTimestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category.name,
        'file_path': filePath,
        'file_name': fileName,
        'file_size_bytes': fileSizeBytes,
        'format': format.name,
        'status': status.name,
        'progress_percentage': progressPercentage,
        'upload_timestamp': uploadTimestamp,
      };

  factory DocumentUploadModel.fromJson(Map<String, dynamic> json) => DocumentUploadModel(
        id: json['id'] ?? '',
        title: json['title'] ?? 'Vaccination Cert',
        category: DocumentCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => DocumentCategory.vaccinationCertificate,
        ),
        filePath: json['file_path'] ?? '',
        fileName: json['file_name'] ?? 'cert_2024.pdf',
        fileSizeBytes: (json['file_size_bytes'] as num?)?.toDouble() ?? 1024000.0,
        format: DocumentFormat.values.firstWhere(
          (f) => f.name == json['format'],
          orElse: () => DocumentFormat.pdf,
        ),
        status: UploadStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => UploadStatus.completed,
        ),
        progressPercentage: (json['progress_percentage'] as num?)?.toDouble() ?? 100.0,
        uploadTimestamp: json['upload_timestamp'] ?? '2024-02-01 10:30 AM',
      );

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        filePath,
        fileName,
        fileSizeBytes,
        format,
        status,
        progressPercentage,
        uploadTimestamp,
      ];
}
