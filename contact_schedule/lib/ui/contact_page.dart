import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _userEdited = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  late Contact _editedContact;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      _nameController.text =
      _editedContact.name != null ? _editedContact.name! : '';
      _emailController.text =
      _editedContact.email != null ? _editedContact.email! : '';
      _phoneController.text =
      _editedContact.phone != null ? _editedContact.phone! : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // The result argument contains the pop result that is defined in `_PageTwo`.
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo Contato"),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null &&
                _editedContact.name!.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  ImagePicker.platform
                      .getImageFromSource(source: ImageSource.camera)
                      .then((file) {
                    if (file == null) return;
                    setState(() {
                      _editedContact.img = file!.path;
                    });
                  });
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img!))
                        as ImageProvider
                            : const AssetImage('images/person.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Nome'),
                controller: _nameController,
                focusNode: _nameFocus,
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    if (_userEdited) {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Descartar alterações?'),
            content: const Text(
              'Se você sair as alterações serão perdidas.',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme
                      .of(context)
                      .textTheme
                      .labelLarge,
                ),
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme
                      .of(context)
                      .textTheme
                      .labelLarge,
                ),
                child: const Text('Sair'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
    } else {
      return Future.value(true);
    }
  }
}
