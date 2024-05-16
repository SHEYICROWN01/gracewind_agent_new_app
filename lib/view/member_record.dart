// ignore_for_file: file_names
import 'package:gracewind_agent_new_app/app_export.dart';

class MemberRecord extends StatefulWidget {
  const MemberRecord({Key? key}) : super(key: key);

  @override
  State<MemberRecord> createState() => _MemberRecordState();
}

class _MemberRecordState extends State<MemberRecord> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<InstantMemberRecordProvider>(context, listen: false)
          .getAllMemberRecord();
    });
  }
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Instant Member Record View",
          style: TextStyle(fontSize: 10),
        ),
        backgroundColor: ColorConstant.primaryColor,
      ),
      body: Consumer<InstantMemberRecordProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: ColorConstant.primaryColor,
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.search, size: 10),
                      title: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          value.filterMembers(query);
                        },
                        decoration: const InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(fontSize: 7),
                            border: InputBorder.none),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _searchController.clear();
                          value.filterMembers('');
                        },
                        icon: const Icon(Icons.cancel, size: 10),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: value.allDailySavings.length,
                    itemBuilder: (context, i) {
                      return Container(
                          padding: const EdgeInsets.all(3.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ConfirmInstantMemberRecord(
                                  memberId: value.allDailySavings[i].memberId,
                                ),
                              ));
                            },
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                title: Text(value.allDailySavings[i].fullname,
                                    style: const TextStyle(
                                        fontSize: 12.0,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.bold)),
                                trailing: Icon(
                                  Icons.play_arrow,
                                  color: ColorConstant.primaryColor,
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(value.allDailySavings[i].memberId,
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            letterSpacing: 2,
                                            color: ColorConstant.primaryColor)),
                                    Text(
                                        'Balance:  ${value.allDailySavings[i].totalSavings.toString()}',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.w900,
                                            color: value.allDailySavings[i]
                                                        .totalSavings <
                                                    0
                                                ? Colors.red
                                                : Colors.green)),
                                  ],
                                ),
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
