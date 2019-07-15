class Coupon {
  String description;
  String ownedBy;
   String usedBy;
   int points;
  bool isUsed;
  String id;

  Coupon({
    this.description,
    this.ownedBy,
     this.usedBy,
     this.points,
    this.isUsed,
    this.id,
  });

  Coupon.fromData(Map<String, dynamic> data)
        : description = data['description'],
          id = data['id'],
          ownedBy = data['ownedBy'],
           usedBy = data['usedBy'],
           points = data['points'],
          isUsed = data['isUsed'];

        
}