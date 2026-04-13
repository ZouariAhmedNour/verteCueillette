class ReservationLineModel {
  final int idProduit;
  final String nomProduit;
  final int quantite;
  final double prixUnitaire;
  final double sousTotal;

  ReservationLineModel({
    required this.idProduit,
    required this.nomProduit,
    required this.quantite,
    required this.prixUnitaire,
    required this.sousTotal,
  });

  factory ReservationLineModel.fromJson(Map<String, dynamic> json) {
    return ReservationLineModel(
      idProduit: json['idProduit'] ?? 0,
      nomProduit: json['nomProduit'] ?? '',
      quantite: json['quantite'] ?? 0,
      prixUnitaire: (json['prixUnitaire'] ?? 0).toDouble(),
      sousTotal: (json['sousTotal'] ?? 0).toDouble(),
    );
  }
}

class ReservationModel {
  final int idReservation;
  final int idUser;
  final String qrCode;
  final String dateReservation;
  final String heureReservation;
  final double totalCommande;
  final String statut;
  final List<ReservationLineModel> lignes;

  ReservationModel({
    required this.idReservation,
    required this.idUser,
    required this.qrCode,
    required this.dateReservation,
    required this.heureReservation,
    required this.totalCommande,
    required this.statut,
    required this.lignes,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    final lignesJson = (json['lignes'] as List?) ?? [];

    return ReservationModel(
      idReservation: json['idReservation'] ?? 0,
      idUser: json['idUser'] ?? 0,
      qrCode: json['qrCode'] ?? '',
      dateReservation: json['dateReservation']?.toString() ?? '',
      heureReservation: json['heureReservation']?.toString() ?? '',
      totalCommande: (json['totalCommande'] ?? 0).toDouble(),
      statut: json['statut'] ?? '',
      lignes: lignesJson
          .map((e) => ReservationLineModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}