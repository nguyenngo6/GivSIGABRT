class Coupon {
  String code;
  String description;
  String ownedBy;
  String usedBy;
  bool isPending;
  int points;
  bool isUsed;
  String id;
  String imageUrl;

  Coupon({
    this.code,
    this.description,
    this.ownedBy,
    this.usedBy,
    this.isPending,
    this.points,
    this.isUsed,
    this.id,
    this.imageUrl,

  });

  Coupon.fromData(Map<String, dynamic> data)
        : description = data['description'],
          id = data['id'],
          ownedBy = data['ownedBy'],
          usedBy = data['usedBy'],
          points = data['points'],
          isUsed = data['isUsed'],
          isPending = data['isPending'],
          imageUrl = data['imageUrl'],
          code = data['code'];



        
}