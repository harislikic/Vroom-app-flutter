class MyReservation {
  final int id;
  final String reservationDate;
  final String status;
  final Automobile automobile;

  MyReservation({
    required this.id,
    required this.reservationDate,
    required this.status,
    required this.automobile,
  });

  factory MyReservation.fromJson(Map<String, dynamic> json) {
    return MyReservation(
      id: json['id'] ?? 0,
      reservationDate: json['reservationDate'] ?? '',
      status: json['status'] ?? 'Unknown',
      automobile: Automobile.fromJson(json['automobile'] ?? {}),
    );
  }
}

class Automobile {
  final int id;
  final String title;
  final int price;
  final String firstImage;
  final ReservationUser user;

  Automobile({
    required this.id,
    required this.title,
    required this.price,
    required this.firstImage,
    required this.user,
  });

  factory Automobile.fromJson(Map<String, dynamic> json) {
    return Automobile(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      price: json['price'] ?? 0,
      firstImage: json['firstImage'] ?? "",
      user: ReservationUser.fromJson(json['user'] ?? {}),
    );
  }
}

class ReservationUser {
  final int id;
  final String userName;
  final String profilePicture;

  ReservationUser({
    required this.id,
    required this.userName,
    required this.profilePicture,
  });

  factory ReservationUser.fromJson(Map<String, dynamic> json) {
    return ReservationUser(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? "Nepoznat korisnik",
      profilePicture: json['profilePicture'] ?? "",
    );
  }
}
