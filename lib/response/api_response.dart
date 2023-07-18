class ApiResponse {
  final List<dynamic> items;
  final int count;

  ApiResponse({required this.items, required this.count});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      items: json['items'],
      count: json['count'],
    );
  }
}
