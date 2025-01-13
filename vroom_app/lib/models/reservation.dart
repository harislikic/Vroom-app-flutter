class Reservation {
  final String reservationDate;
  final String status;
  final int? userId; // Može biti null u slučaju da nije vraćen userId
  final ReservationUser? user; // Takođe može biti null

  Reservation({
    required this.reservationDate,
    required this.status,
    this.userId,
    this.user,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationDate: json['reservationDate'] ?? '',
      status: json['status'] ?? '',
      userId: json['userId'], 
      user: json['user'] != null
          ? ReservationUser.fromJson(json['user'])
          : null, 
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
