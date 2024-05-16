import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';

import 'package:http/http.dart' as http;

class ConfirmUpdateProfile extends StatefulWidget {
  final List list;
  final int index;
  const ConfirmUpdateProfile({
    Key? key,
    required this.list,
    required this.index,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmUpdateProfileState createState() => _ConfirmUpdateProfileState();
}

class _ConfirmUpdateProfileState extends State<ConfirmUpdateProfile> {
  List? data = [];
  File? _image;
  final picker = ImagePicker();

  Future choiceImage(ImageSource source) async {
    try {
      var pickedImage = await picker.pickImage(source: source);
      if (pickedImage == null) return;
      setState(() {
        final imageTemporary = File(pickedImage.path);
        _image = imageTemporary;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  bool _loading = false;
  bool _loadingPicture = false;
  bool isLoading = false;

  TextEditingController? customerId;
  TextEditingController? fullname;
  TextEditingController? lastname;
  TextEditingController? rate;
  TextEditingController? phone;
  TextEditingController? marital;
  TextEditingController? occupation;
  TextEditingController? address;

  @override
  void initState() {
    customerId =
        TextEditingController(text: widget.list[widget.index].memberId);
    fullname = TextEditingController(text: widget.list[widget.index].fullname);
    lastname = TextEditingController(text: widget.list[widget.index].lastname);
    rate = TextEditingController(text: widget.list[widget.index].rate);
    phone = TextEditingController(text: widget.list[widget.index].phone);
    marital = TextEditingController(text: widget.list[widget.index].marital);
    occupation =
        TextEditingController(text: widget.list[widget.index].occupation);
    address = TextEditingController(text: widget.list[widget.index].address);

    super.initState();
  }

  @override
  void dispose() {
    customerId?.dispose();
    fullname?.dispose();
    lastname?.dispose();
    rate?.dispose();
    phone?.dispose();
    marital?.dispose();
    occupation?.dispose();
    address?.dispose();
    super.dispose();
  }

  Future updateMember() async {
    try {
      setState(() {
        _loading = true;
      });

      final url = Uri.parse(AppUrl.updateMember);
      var request = http.MultipartRequest('POST', url);
      request.fields['member_id'] = customerId!.text;
      request.fields['member_name'] = fullname!.text;
      request.fields['lastname'] = lastname!.text;
      request.fields['rate'] = rate!.text;
      request.fields['phone'] = phone!.text;
      request.fields['marital'] = marital!.text;
      request.fields['occupation'] = occupation!.text;
      request.fields['address'] = address!.text;
      // var pic = await http.MultipartFile.fromPath("image", _image!.path);
      // request.files.add(pic);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.statusCode.toString());
        debugPrint(respStr);
        Utils.toastMessage('Record Updated');

        setState(() {
          _loading = false;
        });
      } else if (response.statusCode != 200) {
        Utils.snackBar('Unable to update record', context);
        setState(() {
          _loading = false;
        });
      }
      setState(() {
        _loading = false;
      });
    } on SocketException {
      Fluttertoast.showToast(
          msg: "No connectivity",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.SNACKBAR);
    }
  }

  Future updateMemberProfilePicture() async {
    try {
      setState(() {
        _loadingPicture = true;
      });

      final url = Uri.parse(AppUrl.updateMemberPicture);
      var request = http.MultipartRequest('POST', url);
      request.fields['member_id'] = customerId!.text;
      var pic = await http.MultipartFile.fromPath("image", _image!.path);
      request.files.add(pic);
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Utils.toastMessage('Profile Picture Updated');
        setState(() {
          _loadingPicture = false;
        });
      } else if (response.statusCode != 200) {
        // ignore: use_build_context_synchronously
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Oops...",
          text: "Sorry, Something went wrong",
        );
        setState(() {
          _loadingPicture = false;
        });
      }
      setState(() {
        _loadingPicture = false;
      });
    } on SocketException {
      Fluttertoast.showToast(
          msg: "No connectivity",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          gravity: ToastGravity.SNACKBAR);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Customer Details")),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('Update Member Profile Picture',
                    style: TextStyle(
                        fontSize: 10.0,
                        letterSpacing: 2,
                        color: ColorConstant.primaryColor)),
              ),
              const SizedBox(height: 10),
              Align(alignment: Alignment.center, child: buildPaddingImage()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Builder(builder: (context) {
                  return FloatingActionButton(
                    backgroundColor: ColorConstant.primaryColor,
                    onPressed: () {
                      showBottomSheet(
                          backgroundColor: ColorConstant.primaryColor,
                          context: context,
                          builder: (context) => SafeArea(
                                child: Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.photo_camera,
                                          color: Colors.white),
                                      title: const Text(
                                        'Camera',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () async {
                                        choiceImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_library,
                                          color: Colors.white),
                                      title: const Text(
                                        'Gallery',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () async {
                                        choiceImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.close,
                                          color: Colors.white),
                                      title: const Text(
                                        'Close',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () async {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ));
                    },
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  if (_image!.path.length < 2) {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      title: "Oops...",
                      text: "No Image Selected",
                    );
                  } else {
                    updateMemberProfilePicture();
                  }
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorConstant.primaryColor,
                  ),
                  child: Center(
                    child: _loadingPicture
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Update Member Profile Picture",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Divider(
                  height: 10, thickness: 5, color: ColorConstant.primaryColor),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Text('Update Member Details',
                    style: TextStyle(
                        fontSize: 10.0,
                        letterSpacing: 2,
                        color: ColorConstant.primaryColor)),
              ),
              const SizedBox(height: 15),
              InputSavingsTextFields(
                  editable: false,
                  myController: customerId!,
                  labelText: 'Member ID',
                  hintText: 'Member ID'),
              InputSavingsTextFields(
                  editable: true,
                  myController: fullname!,
                  hintText: 'First Name',
                  labelText: 'First Name'),
              InputSavingsTextFields(
                  editable: true,
                  myController: lastname!,
                  hintText: 'Last Name',
                  labelText: 'Last Name'),
              InputSavingsTextFields(
                  editable: true,
                  myController: rate!,
                  hintText: 'Rate',
                  labelText: 'Rate'),
              InputSavingsTextFields(
                  editable: true,
                  myController: marital!,
                  hintText: 'Marital Status',
                  labelText: 'Marital Status'),
              InputSavingsTextFields(
                  editable: true,
                  myController: phone!,
                  hintText: 'Phone Number',
                  labelText: 'Phone Number'),
              InputSavingsTextFields(
                  editable: true,
                  myController: occupation!,
                  hintText: 'Occupation',
                  labelText: 'Occupation'),
              InputSavingsTextFields(
                  editable: true,
                  myController: address!,
                  hintText: 'Address',
                  labelText: 'Address'),
              GestureDetector(
                onTap: () async {
                  updateMember();
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorConstant.primaryColor,
                  ),
                  child: Center(
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Update Member Details",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          )),
    );
  }

  Padding buildPaddingImage() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 0.0, right: 30.0, left: 30.0),
      child: _image == null
          ? Stack(
              children: [
                CircleAvatar(
                  maxRadius: 100,
                  minRadius: 100,
                  backgroundColor: ColorConstant.primaryColor,
                  child: CircleAvatar(
                    minRadius: 90,
                    maxRadius: 90,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      maxRadius: 80,
                      minRadius: 80,
                      // radius: 80,
                      child: CircleAvatar(
                          // maxRadius: 60,
                          // minRadius: 60,
                          radius: 80,
                          backgroundImage: NetworkImage(
                              '${AppUrl.domainName}${widget.list[widget.index].picture}')),
                    ),
                  ),
                )
              ],
            )
          : Stack(
              children: [
                CircleAvatar(
                  maxRadius: 100,
                  minRadius: 100,
                  // radius: 70 + 6,
                  backgroundColor: ColorConstant.primaryColor,
                  child: CircleAvatar(
                    minRadius: 90,
                    maxRadius: 90,
                    //radius: 70 + 2,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      maxRadius: 80,
                      minRadius: 80,
                      // radius: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80.0),
                        child: Image.file(_image!,
                            fit: BoxFit.cover, width: 150.0, height: 150.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
