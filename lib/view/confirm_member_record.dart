import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:http/http.dart' as http;

class ConfirmInstantMemberRecord extends StatefulWidget {
  final String memberId;

  const ConfirmInstantMemberRecord({super.key, required this.memberId});

  @override
  _ConfirmInstantMemberRecordState createState() =>
      _ConfirmInstantMemberRecordState();
}

class _ConfirmInstantMemberRecordState
    extends State<ConfirmInstantMemberRecord> {
  @override
  void initState() {
    super.initState();
    getMethod1();
  }

  Future<List> getMethod1() async {
    var url = Uri.parse('${AppUrl.wallet}?memberid=${widget.memberId}');
    var response = await http.post(url, body: {"memberid": widget.memberId});
    var resBodyID = json.decode(response.body);
    return resBodyID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.memberId,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: ColorConstant.primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MemberRecord()),
                );
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: FutureBuilder<List>(
            future: getMethod1(),
            builder: (context, snapshot) {
              if (snapshot.hasError) debugPrint(snapshot.error.toString());
              return snapshot.hasData
                  ? ItemList(
                      list: snapshot.data!,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}

class ItemList extends StatelessWidget {
  final List list;
  const ItemList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // ignore: unnecessary_null_comparison
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.loading,
                    text: "Total Savings:  ${list[i]['Total']} ",
                  );
                },
                child: Card(
                  elevation: 20,
                  child: ListTile(
                    title: Text(list[i]['Member_Name']),
                    leading: const Icon(Icons.person_pin),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${list[i]['Amount']}",
                          style: const TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${list[i]['Date']}",
                          style: const TextStyle(
                              fontSize: 10.0, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
