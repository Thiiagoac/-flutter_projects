import 'package:contact_schedule/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late ContactHelper helper = ContactHelper();


  @override
  void initState() {
    super.initState();

    // Contact c = Contact();
    // c.name = 'Thiago araujo';
    // c.email = 'teste@gmail.com';
    // c.phone = '1234';
    // c.img = 'test';
    //
    // helper.saveContact(c);
    helper.getAllContacts().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
