import 'package:gracewind_agent_new_app/app_export.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final username = Provider.of<AuthViewModel>(context, listen: false);
      Provider.of<NotificationProvider>(context, listen: false)
          .getNotification(username.userid.toString());
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Withdrawal Notification'),
        backgroundColor: ColorConstant.primaryColor,
      ),
      body: Consumer<NotificationProvider>(
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
                    itemCount: value.allNotification.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding:
                                    getPadding(left: 10, top: 19, right: 10),
                                child: Text(
                                    value.allNotification[i].date.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle
                                        .txtSourceSansProSemiBold14Black90099)),
                          ),
                          Container(
                              margin: getMargin(top: 9),
                              decoration: AppDecoration.fillGray30075,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        margin: getMargin(
                                            left: 15, top: 11, bottom: 12),
                                        decoration: AppDecoration
                                            .fillDeeporange800
                                            .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder20),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: getPadding(all: 3),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              getHorizontalSize(
                                                                  18.23)),
                                                      child: CommonImageView(
                                                          imagePath:
                                                              ImageConstant
                                                                  .imgEllipse2,
                                                          height:
                                                              getSize(36.00),
                                                          width: getSize(36.00),
                                                          fit: BoxFit.cover)))
                                            ])),
                                    Padding(
                                        padding: getPadding(
                                            left: 6, top: 18, bottom: 13),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width:
                                                      getHorizontalSize(296.00),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                            padding: getPadding(
                                                                top: 1),
                                                            child: Text(
                                                                value
                                                                    .allNotification[
                                                                        i]
                                                                    .fullname,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: AppStyle
                                                                    .txtSourceSansProSemiBold14)),
                                                        Text(
                                                            value
                                                                .allNotification[
                                                                    i]
                                                                .status,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtSourceSansProSemiBold14GreenA700)
                                                      ])),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                      width: getHorizontalSize(
                                                          287.00),
                                                      margin: getMargin(
                                                          top: 7, right: 9),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    getPadding(
                                                                        top: 1),
                                                                child: Text(
                                                                    value
                                                                        .allNotification[
                                                                            i]
                                                                        .memberId,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtSourceSansProSemiBold12Bluegray800)),
                                                            Padding(
                                                                padding:
                                                                    getPadding(
                                                                        bottom:
                                                                            1),
                                                                child: Text(
                                                                    "Amount: ${value.allNotification[i].amount}",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtSourceSansProRegular12))
                                                          ])))
                                            ]))
                                  ])),
                        ],
                      );
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
