import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';

import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  bool isLoading = false;
  List<UpdateModel> _list = [];
  final List<UpdateModel> _search = [];
  var loading = false;
  TextEditingController controller = TextEditingController();

  Future<void> fetchData() async {
    try {
      setState(() {
        loading = true;
      });
      _list.clear();
      var url = Uri.parse(AppUrl.getMemberForUpdate);
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _list = data
            .map<UpdateModel>((json) => UpdateModel.fromJson(json))
            .toList();
      }

      setState(() {
        loading = false;
      });
    } on SocketException {
      Fluttertoast.showToast(
        msg: "No connectivity",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        gravity: ToastGravity.SNACKBAR,
      );
    }
  }

  void onSearch(String text) {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _search.addAll(_list.where((f) =>
        f.fullname.toLowerCase().contains(text.toLowerCase()) ||
        f.memberId.toString().contains(text)));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const Text(
        "Update Profile",
        style: TextStyle(fontSize: 10),
      ),
      backgroundColor: ColorConstant.primaryColor,
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: ColorConstant.primaryColor,
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.search),
          title: TextField(
            controller: controller,
            onChanged: onSearch,
            decoration: const InputDecoration(
              hintText: "Search",
              border: InputBorder.none,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              controller.clear();
              onSearch('');
            },
            icon: const Icon(Icons.cancel),
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    return loading
        ? const Center(
            child: LinearProgressIndicator(
              backgroundColor: Colors.red,
            ),
          )
        : Expanded(
            child: _search.isNotEmpty || controller.text.isNotEmpty
                ? buildRefreshIndicator(_search)
                : buildRefreshIndicator(_list),
          );
  }

  Widget buildRefreshIndicator(List<UpdateModel> itemList) {
    return RefreshIndicator(
      child: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ConfirmUpdateProfile(
                    list: itemList,
                    index: i,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5,
              child: ListTile(
                trailing: Icon(
                  Icons.play_arrow,
                  color: ColorConstant.primaryColor,
                ),
                title: Text(
                  '${itemList[i].fullname} ${itemList[i].lastname}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: CircleAvatar(
                  radius: 30.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image.network(
                      '${AppUrl.domainName}${itemList[i].picture}',
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                subtitle: Text(
                  itemList[i].memberId,
                  style: const TextStyle(
                    fontSize: 10.0,
                    letterSpacing: 2,
                    color: Color(0xFF24487C),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            fetchData();
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: <Widget>[
          buildSearchBar(),
          buildListView(),
        ],
      ),
    );
  }
}
