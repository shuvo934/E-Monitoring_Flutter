class PostResponse {
  final String stringOut;

  PostResponse({required this.stringOut});

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(stringOut: json['string_out']);
  }
}
