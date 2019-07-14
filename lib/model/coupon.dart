class Coupon  {
  String description;
  bool isUsed;
  String ownedBy;
  String id;

  Coupon({
    this.description,
    this.isUsed,
    this.ownedBy,
    this.id,
  });

  Coupon.fromData(Map<String, dynamic> data)
      : description = data['description'],
        isUsed = data['isUsed'],
        ownedBy = data['ownedBy'],
        id = data['id'];
}