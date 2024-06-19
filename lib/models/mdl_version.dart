import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 5)
class Version {
  @HiveField(0)
  String? hash;
  @HiveField(1)
  String? epoch;

  Version({
    required this.hash,
    required this.epoch,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      hash: json['hash'],
      epoch: json['epoch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'epoch': epoch,
    };
  }
}
