class ParamParser {
  /// Smartly extracts an integer ID from dynamic route arguments (int, String, Map, or Model instance).
  static int? extractId(dynamic args, [String key = 'id']) {
    if (args == null) return null;
    if (args is int) return args;
    if (args is String) return int.tryParse(args);
    if (args is Map) {
      final val = args[key] ?? args['id'] ?? args['course_id'] ?? args['quiz_id'] ?? args['teacher_id'];
      if (val is int) return val;
      if (val != null) return int.tryParse(val.toString());
    }
    try {
      final dynamic id = (args as dynamic).id;
      if (id is int) return id;
      if (id != null) return int.tryParse(id.toString());
    } catch (_) {}
    return null;
  }
}
