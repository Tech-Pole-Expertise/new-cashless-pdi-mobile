import 'package:pv_deme/api/models/retrait_history_model.dart';

class MerchantStatModel {
  final String firstname;
  final String lastname;
  final String phone;
  final int withdrawalCount;
  final int supplyCount;
  List<RetraitHistoryModel> lastThreeWithdraw;
  MerchantStatModel({
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.withdrawalCount,
    required this.supplyCount,
    required this.lastThreeWithdraw,
  });

  factory MerchantStatModel.fromJson(Map<String, dynamic> json) {
   final List<dynamic> data = json['three_last_withdrawals'] ?? [];
    return MerchantStatModel(
      firstname: json['first_name'],
      lastname: json['last_name'],
      phone: json['phone'],
      withdrawalCount: json['withdrawal_count'],
      supplyCount: json['supply_count'],
      lastThreeWithdraw:
          data
              .map(
                (e) => RetraitHistoryModel.fromJson(
                  e,
                ),
              )
              .toList(),
    );
  }
}
