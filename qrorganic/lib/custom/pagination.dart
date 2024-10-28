// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';

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
                switch (title.toLowerCase()) {
                  case 'pack':
                    provider.setCurrentPage(title, page);
                    provider.fetchReadyToPackOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  case 'rack':
                    provider.setCurrentPage(title, page);
                    provider.fetchReadyToRackedOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  case 'pick':
                    provider.setCurrentPage(title, page);
                    provider.fetchReadyToPickOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  case 'manifest':
                    provider.setCurrentPage(title, page);
                    provider.fetchReadyToManiFestOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  case 'check':
                    provider.setCurrentPage(title, page);
                    provider.fetchReadyToCheckOrders(
                        page: provider.getCurrentPage(title));
                    break;
                  default:
                    throw Exception('Invalid page title: $title');
                }
              },
              nextIcon: const Icon(Icons.chevron_right_rounded,
                  color: Colors.blueAccent, size: 20),
              previousIcon: const Icon(Icons.chevron_left_rounded,
                  color: Colors.blueAccent, size: 20),
              activeTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
              activeBtnStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                shape: MaterialStateProperty.all(const CircleBorder(
                    side: BorderSide(color: Colors.blueAccent, width: 1))),
              ),
              inactiveBtnStyle: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(const CircleBorder(
                    side: BorderSide(color: Colors.blueAccent, width: 1))),
              ),
              inactiveTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
