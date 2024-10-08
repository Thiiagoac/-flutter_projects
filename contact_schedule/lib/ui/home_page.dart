import 'package:contact_schedule/helpers/contact_helper.dart';
import 'package:contact_schedule/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher_string.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                    const PopupMenuItem<OrderOptions>(
                      child: Text('Ordenar de A-Z'),
                      value: OrderOptions.orderaz,
                    ),
                    const PopupMenuItem<OrderOptions>(
                      child: Text('Ordenar de Z-A'),
                      value: OrderOptions.orderza,
                    ),
                  ],
              onSelected: _orderList),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // _showContactPage(contact: contacts[index]);
        _showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _buildContactImage(contacts[index].img),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactImage(String? imgPath) {
    if (imgPath != null && File(imgPath).existsSync()) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: FileImage(File(imgPath)),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('images/person.png'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              showDragHandle: true,
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          launchUrlString('tel:${contacts[index].phone}');
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Ligar',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                        child: const Text(
                          'Editar',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          helper.deleteContact(contacts[index].id!);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          'Remover',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
        });
        break;
      default:
        break;
    }
    setState(() {

    });
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          contact: contact,
        ),
      ),
    );

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}
