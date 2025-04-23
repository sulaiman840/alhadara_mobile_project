import 'package:flutter/material.dart';

import '../../core/network/statusrequest.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget child;

  const HandlingDataView({super.key, required this.statusRequest, required this.child});

  @override
  Widget build(BuildContext context) {
    switch (statusRequest) {
      case StatusRequest.loading:
        return const Center(child: CircularProgressIndicator());
      case StatusRequest.offlinefailure:
        return Center(child: Text('Please connect to the internet and retry.'));
      case StatusRequest.serverfailure:
        return Center(child: Text('Server error, please try again later.'));
      case StatusRequest.failure:
        return Center(child: Text('No data available.'));
      case StatusRequest.success:
      case StatusRequest.none:
      default:
        return child;
    }
  }
}