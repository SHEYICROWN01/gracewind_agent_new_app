import 'package:gracewind_agent_new_app/app_export.dart';

class SecondActionButton extends StatelessWidget {
  const SecondActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.1), // Transparent black for the shadow
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3), // Changes the position of the shadow
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 25),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildExpanded('Savings', Icons.add_box,
              () => Navigator.pushNamed(context, RouteName.allMembers)),
          buildExpanded('Open Account', Icons.account_circle,
              () => Navigator.pushNamed(context, RouteName.customerRegistration)),
          buildExpanded(
              'Local Activities',
              Icons.local_activity_outlined,
              () =>
                  Navigator.pushNamed(context, RouteName.localActivities)),
        ],
      ),
    );
  }

  Expanded buildExpanded(
      String text, IconData iconData, void Function() onTap) {
    return Expanded(
      child: Column(
        children: [
          Material(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.hardEdge,
            color: ColorConstant.primaryColor.withOpacity(0.1),
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Icon(
                  iconData,
                  color: ColorConstant.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
