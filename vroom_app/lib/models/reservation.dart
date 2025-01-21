class Reservation {
  final int reservationId;
  final String reservationDate;
  final String status;
  final int? userId;
  final ReservationUser? user;
  final int? automobileAdId;
  final String? title; // Naziv oglasa
  final int? price; // Naziv oglasa
  final String? firstImage; // URL prve slike oglasa

  Reservation({
    required this.reservationId,
    required this.reservationDate,
    required this.status,
    this.userId,
    this.user,
    this.automobileAdId,
    this.title,
    this.price,
    this.firstImage,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationId: json['id'],
      reservationDate: json['reservationDate'] ?? '',
      status: json['status'] ?? '',
      userId: json['userId'],
      user:
          json['user'] != null ? ReservationUser.fromJson(json['user']) : null,
      automobileAdId: json['automobileAdId'],
      title: json['title'],
      price: json['price'],
      firstImage: json['firstImage'],
    );
  }
}

class ReservationUser {
  final int id;
  final String userName;
  final String? profilePicture;

  ReservationUser({
    required this.id,
    required this.userName,
    this.profilePicture,
  });

  factory ReservationUser.fromJson(Map<String, dynamic> json) {
    return ReservationUser(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }
}
