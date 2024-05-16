import 'package:flutter/material.dart';
import 'package:gracewind_agent_new_app/controller/getWithdrawalProvider.dart';
import 'package:gracewind_agent_new_app/view/confirmGetWithdrawalList.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GetWithdrawalList extends StatefulWidget {
  const GetWithdrawalList({Key? key}) : super(key: key);

  @override
  State<GetWithdrawalList> createState() => _GetWithdrawalListState();
}

class _GetWithdrawalListState extends State<GetWithdrawalList> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GetWithdrawalProvider>(context, listen: false).getDailySavings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Get Withdrawal List'),
        //backgroundColor: ColorConstant.deepOrange800,
        centerTitle: true,
      ),
      body: Consumer<GetWithdrawalProvider>(
        builder: (context, dailyProvider, child) {
          if (dailyProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color:const Color(0xFF24487C),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.search, size: 10),
                      title: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          dailyProvider.filterMembers(query);
                        },
                        decoration: const InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(fontSize: 7),
                            border: InputBorder.none),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _searchController.clear();
                          dailyProvider.filterMembers('');
                        },
                        icon: const Icon(Icons.cancel, size: 10),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dailyProvider.allDailySavings.length,
                    itemBuilder: (context, i) {
                      final dailySavings = dailyProvider.allDailySavings[i];
                      return Container(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(
                                    context,MaterialPageRoute(
                                    builder:(context)=>ConfirmGetWithdrawalList(
                                      index: i,
                                      list: dailyProvider.allDailySavings,


                                    )
                                )
                                );
                              },
                              title: Text(dailySavings.name,
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dailySavings.memberId,
                                      style: const TextStyle(
                                          fontSize: 10.0,
                                          letterSpacing: 2,
                                          color: Color(0xFF24487C))),
                                  Text(
                                    'Amount: ${NumberFormat.currency(symbol: 'NGN').format(double.parse(dailySavings.amount))}',
                                    style: const TextStyle(
                                        fontSize: 10.0,
                                        letterSpacing: 2,
                                        color: Color(0xFF24487C)
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}