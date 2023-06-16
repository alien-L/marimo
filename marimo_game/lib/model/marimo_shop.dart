
class Shop {
  String? name;
  String? nameEn;
  String? nameJp;
  String? price;
  String? stateScore;
  String? expScore;
  String? enabled;
  String? bought;
  String? category;
  String? imageName;
  String? isCheckedMoving;
  String? positionX;
  String? positionY;
  String? size;

  Shop(
      {this.name,
      this.nameEn,
      this.nameJp,
      this.price,
      this.stateScore,
      this.expScore,
      this.enabled,
      this.bought,
      this.category,
      this.imageName,
      this.isCheckedMoving,
      this.positionX,
      this.positionY,
      this.size});

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        name: json['name'],
        nameEn: json['name_en'],
        nameJp: json['name_jp'],
        price: json['price'],
        stateScore: json['state_score'],
        expScore: json['exp_score'],
        enabled: json['enabled'],
        bought: json['bought'],
        category: json['category'],
        imageName: json['image_name'],
        isCheckedMoving: json['isCheckedMoving'],
        positionX: json['position_x'],
        positionY: json['position_y'],
        size: json['size'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['name_en'] = nameEn;
    data['name_jp'] = nameJp;
    data['price'] = price;
    data['state_score'] = stateScore;
    data['exp_score'] = expScore;
    data['enabled'] = enabled;
    data['bought'] = bought;
    data['category'] = category;
    data['image_name'] = imageName;
    data['isCheckedMoving'] = isCheckedMoving;
    data['position_x'] = positionX;
    data['position_y'] = positionY;
    data['size'] = size;
    return data;
  }
}
