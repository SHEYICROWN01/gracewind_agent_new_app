import 'dart:io';
import 'package:gracewind_agent_new_app/app_export.dart';
import 'package:http/http.dart' as http;

class Register extends StatelessWidget {
  const Register({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return const Content();
          },
        );
      },
      child: Text('Create a new account',
          style: TextStyle(color: ColorConstant.primaryColor)),
    );
  }
}

class Content extends StatefulWidget {
  const Content({
    super.key,
  });

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String name = "";
  String phone = "";
  String address = "";
  String username = "";
  String password = "";
  String registrationCode = "";
  bool hidePassword = true;
  String? _mySelection;
  File? _profileImage;
  bool isLoading = false;

  List? data = [];
  Future<String> getSWData() async {
    var res = await http.get(Uri.parse(AppUrl.branch));
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });
    return "Success";
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  String? _validateImage(File? image) {
    if (image == null) {
      return 'Select a profile picture';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      padding: const EdgeInsets.all(30),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text("Create a new account")
                    ],
                  ),
                  //clone button
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _profileImage != null
                          ? Image.file(_profileImage!).image
                          : null,
                    ),
                    Positioned(
                      top: 55,
                      right: -4,
                      child: Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  suffixIcon: Icon(Icons.mail_outlined),
                ),
                validator: (val) {
                  const pattern =
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$";
                  final regex = RegExp(pattern);
                  if (!regex.hasMatch(val!)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'FullName',
                  hintText: 'Enter your FullName',
                  suffixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) {
                  if (val!.length < 2) {
                    return "Enter your FullName";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter your phone',
                  suffixIcon: Icon(Icons.phone),
                ),
                validator: (val) {
                  if (val!.length < 11) {
                    return "Enter a valid Phone";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    phone = val;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter your address',
                  suffixIcon: Icon(Icons.home_work),
                ),
                validator: (val) {
                  if (val!.length < 2) {
                    return "Enter your address";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    address = val;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  suffixIcon: Icon(Icons.account_circle),
                ),
                validator: (val) {
                  if (val!.length < 2) {
                    return "Enter your username";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    username = val;
                  });
                },
              ),
              TextFormField(
                obscureText: hidePassword,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    child: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                      // color: ColorConstant.deepOrange800,
                    ),
                  ),
                ),
                validator: (val) {
                  if (val!.length < 6) {
                    return "Password can be less than 6";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 15.0, letterSpacing: 1),
                  ),
                  DropdownButton(
                    items: data?.map((item) {
                      return DropdownMenuItem(
                        value: item['branch'].toString(),
                        child: Text(
                            data!.isEmpty ? 'Please wait....' : item['branch'],
                            style: const TextStyle(
                                letterSpacing: 1, fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal.toString();
                      });
                    },
                    value: _mySelection,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                indent: 100,
                endIndent: 100,
                thickness: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Registration Code',
                  hintText: 'Enter your registration code',
                  suffixIcon: Icon(Icons.lock_person_sharp),
                ),
                validator: (val) {
                  if (val != "Godsmercyventure") {
                    return "Provide a valid Registration Code";
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    registrationCode = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              isLoading == true
                  ? FilledButton(
                      onPressed: () {},
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )),
                      ),
                    )
                  : FilledButton(
                      onPressed: () => register(),
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(child: Text('Register')),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    String? imageValidation = _validateImage(_profileImage);

    if (formKey.currentState!.validate() && imageValidation == null) {
      setState(() {
        isLoading = true;
      });

      try {
        final url = Uri.parse(AppUrl.staffRegistration);
        var request = http.MultipartRequest('POST', url);
        request.fields['fullname'] = name;
        request.fields['email'] = email;
        request.fields['phone'] = phone;
        request.fields['address'] = address;
        request.fields['branch'] = _mySelection.toString();
        request.fields['username'] = username;
        request.fields['password'] = password;

        var pic =
            await http.MultipartFile.fromPath("image", _profileImage!.path);
        request.files.add(pic);

        var response = await request.send();
        var bodyResponse = await response.stream.bytesToString();

        const successMessage = "Member's Information Created Successfully!";
        const failureMessage = "Registration Failed: ";

        if (bodyResponse == successMessage) {
          setState(() {
            isLoading = false; // Set to false on success
          });
          Utils.toastMessage("Registration Successful!");
          Navigator.pop(context);
        } else {
          // Handle failure
          setState(() {
            isLoading = false;
          });

          Utils.toastMessage("$failureMessage$bodyResponse");
        }
      } on SocketException {
        setState(() {
          isLoading = false;
        });
        Utils.toastMessage('No connectivity');
      }
    } else {
      // Show error message for image validation
      Utils.snackBar(imageValidation!, context);
    }
  }
}
