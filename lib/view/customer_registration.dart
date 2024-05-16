import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gracewind_agent_new_app/app_export.dart';

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({
    super.key,
  });

  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  late DateTime selectedDate;
  String email = "";
  String firstname = "";
  String lastname = "";
  String phone = "";
  String address = "";
  String rate = "";
  String occupation = "";
  String representative = "";
  String? _mySelection;
  File? _profileImage;
  bool isLoading = false;

  String dropdownValue = 'Gender';
  String dropMaritalStatus = 'Marital Status';
  String dropAgeRange = 'Age Range';
  String dropIdType = 'ID Type';
  String locationName = 'Location';
  String? dataIdType;
  String? dataGender;
  String? ageRange;
  String? maritalStatus;

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
      return 'Please pick an image';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getSWData();
    // Initialize selectedDate with the current date
    selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    occupationController.dispose();
    rateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getAgentDetails = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 50,
        padding: const EdgeInsets.all(20),
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
                      icon: Icon(
                        Icons.close,
                        color: ColorConstant.primaryColor,
                      ),
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
                  controller: firstnameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter your First Name',
                    suffixIcon: Icon(
                      Icons.person_outline,
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  validator: (val) {
                    if (val!.length < 2) {
                      return "Enter your First Name";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      firstname = val;
                    });
                  },
                ),
                TextFormField(
                  controller: lastnameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter your Last Name',
                    suffixIcon: Icon(
                      Icons.person_outline,
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  validator: (val) {
                    if (val!.length < 2) {
                      return "Enter your Last Name";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      lastname = val;
                    });
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter your phone',
                    suffixIcon: Icon(
                      Icons.phone,
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  validator: (val) {
                    if (val!.length < 11 || val.length > 11) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildPaddingGender(),
                    buildPaddingMaritalStatus(),
                    Row(
                      children: [
                        const Text('DOB'),
                        IconButton(
                          icon: Icon(Icons.date_range,
                              color: ColorConstant.primaryColor),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                                ageRange =
                                    '${selectedDate.day.toString()}-${selectedDate.month.toString()}';
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (firstname.isEmpty && lastname.isEmpty) {
                          GeneralVariable.newEmail = "";
                        } else {
                          GeneralVariable.newEmail =
                              '$firstname$lastname@gmail.com'
                                  .replaceAll(' ', '')
                                  .toLowerCase();
                          setState(() {
                            GeneralVariable.myEmail1 = GeneralVariable.newEmail;
                            emailController = TextEditingController(
                                text: GeneralVariable.myEmail1);
                          });
                        }
                      },
                      icon: Icon(
                        Icons.add_box,
                        color: ColorConstant.primaryColor,
                      ),
                    ),
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
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Address',
                    suffixIcon: Icon(
                      Icons.home_work,
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  validator: (val) {
                    if (val!.length < 2) {
                      return "Required Customer's Address";
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
                  controller: occupationController,
                  decoration: InputDecoration(
                    labelText: 'Occupation',
                    hintText: 'Occupation',
                    suffixIcon: Icon(
                      Icons.person_outline,
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  validator: (val) {
                    if (val!.length < 2) {
                      return "Required Customer's Occupation";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      occupation = val;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Location',
                      style: TextStyle(fontSize: 12.0, letterSpacing: 1),
                    ),
                    DropdownButton(
                      items: data?.map((item) {
                        return DropdownMenuItem(
                          value: item['branch'].toString(),
                          child: Text(
                              data!.isEmpty
                                  ? 'Please wait....'
                                  : item['branch'],
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
                TextFormField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Rate',
                    hintText: "Enter savings Rate",
                    suffixIcon: Icon(
                      Icons.currency_exchange,
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  validator: (val) {
                    if (int.parse(val!) < 1) {
                      return "Rate can't be 0";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      rate = val;
                    });
                  },
                ),
                const SizedBox(height: 20),
                isLoading == true
                    ? const CircularProgressIndicator(
                        strokeWidth: 2,
                      )
                    : FilledButton(
                        onPressed: () => _registerCustomer(
                            getAgentDetails.username.toString()),
                        child: const SizedBox(
                          width: double.infinity,
                          child: Center(child: Text('Register')),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildPaddingGender() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 15,
        elevation: 16,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12.0,
        ),
        underline: Container(
          height: 2,
          color: Colors.black12,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            dataGender = dropdownValue;
          });
        },
        items: <String>[
          'Gender',
          'Male',
          'Female',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Padding buildPaddingMaritalStatus() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
      child: DropdownButton<String>(
        value: dropMaritalStatus,
        icon: const Icon(Icons.arrow_downward),
        iconSize: 15,
        elevation: 16,
        style: const TextStyle(color: Colors.black, fontSize: 12.0),
        underline: Container(
          height: 2,
          color: Colors.black12,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropMaritalStatus = newValue!;
            maritalStatus = dropMaritalStatus;
          });
        },
        items: <String>[
          'Marital Status',
          'Single',
          'Married',
          'Divorce',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _registerCustomer(String getRepresentative) async {
    String? imageValidation = _validateImage(_profileImage);
    if (ageRange == null) {
      Utils.snackBar('DOB is Required', context);
    } else if (dropdownValue == 'Gender') {
      Utils.snackBar('Gender is Required', context);
    } else if (dropMaritalStatus == 'Marital Status') {
      Utils.snackBar('Martial Status is Required', context);
    } else if (formKey.currentState!.validate() && imageValidation == null) {
      setState(() {
        isLoading = true;
      });
      try {
        final url = Uri.parse(AppUrl.customerRegistration);
        var request = http.MultipartRequest('POST', url);
        request.fields['firstname'] = firstname;
        request.fields['lastname'] = lastname;
        request.fields['dob'] = ageRange!;
        request.fields['gender'] = dataGender!;
        request.fields['maritalStatus'] = maritalStatus!;
        request.fields['rate'] = rate;
        request.fields['occupation'] = occupation;
        request.fields['phoneNumber'] = phone;
        request.fields['email'] = emailController.text;
        request.fields['address'] = address;
        request.fields['branch'] = _mySelection.toString();
        request.fields['representative'] = getRepresentative;
        request.fields['userLat'] = '7.145244';
        request.fields['userLong'] = '3.327695';

        var pic =
            await http.MultipartFile.fromPath("image", _profileImage!.path);
        request.files.add(pic);
        var response = await request.send();
        var bodyResponse = await response.stream.bytesToString();

        if (bodyResponse !=
            "Unable to Insert Member Records.....Please try again later") {
          setState(() {
            isLoading = false;
          });
          CoolAlert.show(
            barrierDismissible: false,
            context: context,
            type: CoolAlertType.success,
            title: "Successful",
            text: "$bodyResponse",
          );
          firstnameController.clear();
          lastnameController.clear();
          phoneController.clear();
          emailController.clear();
          addressController.clear();
          occupationController.clear();
          rateController.clear();
        } else if (bodyResponse ==
            "Unable to Insert Member Records.....Please try again later") {
          setState(() {
            isLoading = false;
          });
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Oops...",
            text:
                "Account Number Already Exist.\n Use a different account number",
          );
        }
      } on SocketException {
        setState(() {
          isLoading = false;
        });
        Utils.snackBar('No Internet Connectivity', context);
      }
    }
  }
}
