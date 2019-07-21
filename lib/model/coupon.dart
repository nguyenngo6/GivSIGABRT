class Coupon {
  String code;
  String description;
  String ownedBy;
  String usedBy;
  bool isPending;
  int points;
  bool isUsed;
  String id;

  Coupon({
    this.code,
    this.description,
    this.ownedBy,
    this.usedBy,
    this.isPending,
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
          isUsed = data['isUsed'],
          isPending = data['isPending'],
          code = data['code'];


        
}