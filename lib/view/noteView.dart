import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:http/http.dart' as http;

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  TextEditingController commentController = TextEditingController();
  bool isLoading = false;
  _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        shape: const StadiumBorder(),
        content: Text(msg),
      ),
    );
  }

  Future uploadComment() async {
    final agentId = Provider.of<AuthViewModel>(context, listen: false);
    try {
      setState(() {
        isLoading = true;
      });

      final url = Uri.parse(AppUrl.individualComment);
      var request = http.MultipartRequest('POST', url);
      request.fields['agentId'] = agentId.userid.toString();
      request.fields['agentName'] = agentId.username.toString();
      request.fields['note'] = commentController.text;
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          isLoading = false;
          commentController.clear();
        });

        _showSnackBar('Successful ', ColorConstant.primaryColor);
        getMethod();
      } else {
        isLoading = false;
        _showSnackBar('Sorry, Something went wrong ', Colors.red);
      }
    } on SocketException {
      setState(() {
        isLoading = false;
      });

      _showSnackBar('No connectivity ', Colors.red);
    }
  }

  getMethod() async {
    final agentId = Provider.of<AuthViewModel>(context, listen: false);
    var url =
        Uri.parse('${AppUrl.getIndividualComment}?agentId=${agentId.userid}');

    var response = await http.post(url, body: {
      "agentId": '${agentId.userid}',
    });
    var resBodyID = json.decode(response.body);
    return resBodyID;
  }

  @override
  void initState() {
    super.initState();
    getMethod();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: ColorConstant.primaryColor,
      ),
      body: Column(
        children: [
          const Divider(),
          const SizedBox(
            height: 5,
          ),
          Expanded(child: buildComment()),
          const Divider(),
          ListTile(
            leading: IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Colors.red),
              onPressed: () {
                commentController.clear();
              },
            ),
            title: TextFormField(
              maxLines: 2,
              controller: commentController,
              decoration: const InputDecoration(labelText: 'Write a Note...'),
            ),
            trailing: isLoading
                ? CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    color: ColorConstant.primaryColor)
                : OutlinedButton(
                    onPressed: () {
                      if (commentController.text.isEmpty) {
                        _showSnackBar("Note box can't be empty", Colors.red);
                      } else {
                        uploadComment();
                      }
                    },
                    child: const Text('Post', style: TextStyle(fontSize: 12)),
                  ),
          )
        ],
      ),
    );
  }

  buildComment() {
    return FutureBuilder(
      future: getMethod(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List? snap = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error Fetching Data"),
          );
        }

        return ListView.builder(
            itemCount: snap!.length,
            itemBuilder: (context, index) {
              return Center(
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      "${snap[index]['Note']}",
                      style: const TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Date: ${snap[index]['Date']}",
                        style: const TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.w300)),
                    leading: const Icon(Icons.person),
                  ),
                ),
              );
            });
      },
    );
  }
}
