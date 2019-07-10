class Coupon {
  String description;
  String ownedBy;
  String usedBy;
  String points;
  bool isUsed;

  Coupon({
    this.description,
    this.ownedBy,
    this.usedBy,
    this.points,
    this.isUsed,
  });

  Coupon.fromData(Map<String, dynamic> data)
        : description = data['description'],
          ownedBy = data['ownedBy'],
          usedBy = data['usedBy'],
          points = data['points'],
          isUsed = data['isUsed'];

        
}