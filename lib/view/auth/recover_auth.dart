import 'package:gracewind_agent_new_app/app_export.dart';


class Recover extends StatelessWidget {
  const Recover({
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
      child:  Text('Register', style: TextStyle(color: ColorConstant.primaryColor)),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recover password",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text("Enter your email to recover your password")
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              suffixIcon: Icon(Icons.mail_outlined),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {},
            child: const SizedBox(
              width: double.infinity,
              child: Center(child: Text('Recover')),
            ),
          ),
        ],
      ),
    );
  }
}
