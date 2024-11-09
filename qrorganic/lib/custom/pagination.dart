// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/colors.dart';

class PaginationWidget extends StatelessWidget {
  final String title; // Page title ("pack", "pick", etc.)

  PaginationWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ReadyToPackProvider>(context);

    return Consumer<ReadyToPackProvider>(
      builder: (context, provider, child) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pagination(
              numOfPages: provider.getTotalPages(title),
              selectedPage: provider.getCurrentPage(title),
              pagesVisible: 5,
              spacing: 10,
              onPageChanged: (page) {
                provider.setCurrentPage(title, page);
                switch (title) {
                  case 'pick':
                    provider.fetchReadyToPickOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  case 'pack':
                    provider.fetchReadyToPackOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  case 'check':
                    provider.fetchReadyToCheckOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  case 'rack':
                    provider.fetchReadyToRackedOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  case 'manifest':
                    provider.fetchReadyToManiFestOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  default:
                    throw Exception('Invalid page title: $title');
                }
              },
              nextIcon: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.primaryBlue, size: 20),
              previousIcon: const Icon(Icons.chevron_left_rounded,
                  color: AppColors.primaryBlue, size: 20),
              activeTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
              activeBtnStyle: ButtonStyle(
                  // backgroundColor: WidgetStateProperty.all(AppColors.primaryBlue),
                  // shape: WidgetStateProperty.all(const CircleBorder(
                  //     side: BorderSide(color: AppColors.primaryBlue, width: 1))),
                  ),
              inactiveBtnStyle: ButtonStyle(
                  // elevation: WidgetStateProperty.all(0),
                  // backgroundColor: WidgetStateProperty.all(Colors.white),
                  // shape: WidgetStateProperty.all(const CircleBorder(
                  //     side: BorderSide(color: AppColors.primaryBlue, width: 1))),
                  ),
              inactiveTextStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
