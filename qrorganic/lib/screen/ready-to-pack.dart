import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/show-order-item-details.dart';
class ReadyToPackPage extends StatefulWidget {
  const ReadyToPackPage({super.key});

  @override
  State<ReadyToPackPage> createState() => _ReadyToPackPageState();
}

class _ReadyToPackPageState extends State<ReadyToPackPage> {
    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() async {
    print("featching vvvvvv dtaftaftaftaftfvafayftaft");
    var readyToPackProvider = Provider.of<ReadyToPackProvider>(context, listen: false);
   print( await readyToPackProvider.fetchReadyToPackOrders());
    print("featching dtaftaftaftaftfvafayftaft ${Provider.of<ReadyToPackProvider>(context, listen: false).orders.isNotEmpty} ");
    setState(() {
      List<bool>.filled(readyToPackProvider.orders.length, false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ready to Pack'),
        backgroundColor: const Color.fromRGBO(255, 193, 7, 1),
      ),
      body: Consumer<ReadyToPackProvider>(
        builder:(context,provider,child)=>provider.orders.isNotEmpty?Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: const Color.fromRGBO(255, 193, 7, 1),
              child: Row(
                children: [
                  Checkbox(value: true, onChanged: (val) {}),
                  const Text("Select All Orders"),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:provider.orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(value:provider.checkBox[index], onChanged: (val) {
                                  provider.updateCheckBoxStatus(index);
                                }),
                                 Expanded(
                                  child: Text(
                                    "Order ID: ${provider.orders[index].orderId} ",
                                    style:const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: List.generate(provider.orders[index].items!.length, (i) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTprI6-IHZrDj6tSyBRlbmUnRb6CuDfZYIQVoPNpHEBtjg1atSd-B_LlhBdT7fJpWqFQWM&usqp=CAU",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                               Text(
                                                provider.orders[index].items![i].product.displayName,
                                                style:const TextStyle(fontSize: 16),
                                              ),
                                              const SizedBox(height: 4),
                                               Text(
                                                "SKU: ${provider.orders[index].items![i].product.sku}",
                                                style:const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                               Text(
                                                "Quantity: ${provider.orders[index].items![i].quantity}",
                                                style:const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap:(){
                                      List<String>title=[];
                                      List<int>quantity=[];
                                      for(int val=0;val<provider.orders[index].items!.length;val++){
                                        title.add(provider.orders[index].items![val].product.sku);
                                         quantity.add((provider.orders[index].items![val].quantity).toInt());
                                      }
                                      Navigator.push(context,MaterialPageRoute(builder:(context)=>ShowDetailsOfOrderItem(numberOfItme:quantity, title:title,oredrId:provider.orders[index].orderId,)));
                                    },
                                  ),
                                );
                              }),
                            ),
                            Divider(thickness: 1),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ):const Text("Wait"),
      ),
    );
  }
}
