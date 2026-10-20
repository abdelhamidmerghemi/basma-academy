class StudentProfileModel {
  final int id;
  final int academicYearId;
  final int streamId;
  final String? schoolName;
  final int? wilayaCode;
  final String? avatarPath;

  StudentProfileModel({
    required this.id,
    required this.academicYearId,
    required this.streamId,
    this.schoolName,
    this.wilayaCode,
    this.avatarPath,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      id: json['id'] ?? 0,
      academicYearId: json['academic_year_id'] ?? 0,
      streamId: json['stream_id'] ?? 0,
      schoolName: json['school_name'],
      wilayaCode: json['wilaya_code'] is int ? json['wilaya_code'] : int.tryParse(json['wilaya_code']?.toString() ?? ''),
      avatarPath: json['avatar_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'academic_year_id': academicYearId,
      'stream_id': streamId,
      'school_name': schoolName,
      'wilaya_code': wilayaCode,
      'avatar_path': avatarPath,
    };
  }
}

class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? googleId;
  final String academicStream;
  final String language;
  final String role;
  final String? avatarUrl;
  final StudentProfileModel? studentProfile;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.googleId,
    required this.academicStream,
    required this.language,
    required this.role,
    this.avatarUrl,
    this.studentProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final studentProfileJson = json['student_profile'] as Map<String, dynamic>?;
    final studentProfile = studentProfileJson != null ? StudentProfileModel.fromJson(studentProfileJson) : null;

    final academicStream = (studentProfileJson?['stream']?['code'] as String?)
        ?? (json['academic_stream'] as String?)
        ?? 'BAC_Sciences';

    final roles = json['roles'] as List<dynamic>?;
    final role = (roles?.isNotEmpty == true
            ? roles!.first['name'] as String?
            : null)
        ?? (json['role'] as String?)
        ?? 'student';

    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      googleId: json['google_id'],
      academicStream: academicStream,
      language: json['language'] ?? 'ar',
      role: role,
      avatarUrl: (json['avatar_url'] as String?)
          ?? (studentProfileJson?['avatar_path'] as String?),
      studentProfile: studentProfile,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'google_id': googleId,
      'academic_stream': academicStream,
      'language': language,
      'role': role,
      'avatar_url': avatarUrl,
      'student_profile': studentProfile?.toJson(),
    };
  }
}
