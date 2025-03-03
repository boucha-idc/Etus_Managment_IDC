class BusLine {

  String code;
  String name;
  double price;
  bool status;
  int departCityId;
  int arrivalCityId;

  // Constructor
  BusLine({
    required this.code,
    required this.name,
    required this.price,
    required this.status,
    required this.departCityId,
    required this.arrivalCityId,
  });

  // Convert JSON to BusLine object
  factory BusLine.fromJson(Map<String, dynamic> json) {
    return BusLine(
      code: json['code'],
      name: json['name'],
      price: json['price'].toDouble(),
      status: json['status'] == 1, // Convert integer to boolean
      departCityId: json['depart_city_id'],
      arrivalCityId: json['arrival_city_id'],
    );
  }
}
