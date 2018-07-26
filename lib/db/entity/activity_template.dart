class ActivityTemplate {
  static const table = 'activityTemplate';
  static const idCol = 'activityId';

  static const imageCol = 'image';

  String activityId;

  String image;

  ActivityTemplate({this.activityId, this.image});

  Map<String, dynamic> toMap() {
    print("hello in this its comming database here");
    return {idCol: activityId, imageCol: image};
  }

  ActivityTemplate.fromMap(Map<String, dynamic> map)
      : this(
          activityId: map[idCol],
          image: map[imageCol],
        );

  @override
  int get hashCode => activityId.hashCode ^ image.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTemplate &&
          runtimeType == other.runtimeType &&
          activityId == other.activityId &&
          image == other.image;

  @override
  String toString() {
    print("hello in this its comming database11 here");
    return '{idCol: $activityId, imageCol: $image}';
  }
}
