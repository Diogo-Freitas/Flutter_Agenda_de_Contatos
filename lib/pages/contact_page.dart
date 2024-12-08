import '../controllers/contact_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import 'dart:io';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, this.contact});

  final Contact? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final ContactController _controller = ContactController();
  final _nameFocus = FocusNode();

  Contact? _editedContact;
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      _controller.populateFields(_editedContact);
    }
  }

  Future<void> _saveContact() async {
    if (_editedContact?.name != null && _editedContact!.name!.isNotEmpty) {
      await _controller.saveOrUpdateContact(_editedContact!);
      Navigator.pop(context, _editedContact);
    } else {
      FocusScope.of(context).requestFocus(_nameFocus);
    }
  }

  void _updateContactField(String field, String value) {
    setState(() {
      _userEdited = true;
      _controller.updateContactField(_editedContact!, field, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            _editedContact?.name ?? 'Novo Contato',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveContact,
          backgroundColor: Colors.red,
          child: const Icon(Icons.save, color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: _updateContactImagem,
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: _editedContact?.img != null
                        ? DecorationImage(
                            image: FileImage(File(_editedContact!.img!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _editedContact?.img == null
                      ? const Icon(Icons.person, size: 140, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                focusNode: _nameFocus,
                controller: _controller.nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                onChanged: (value) => _updateContactField('name', value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller.emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _updateContactField('email', value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller.phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => _updateContactField('phone', value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateContactImagem() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _userEdited = true;
        _editedContact?.img = pickedFile.path;
      });
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Descartar Alterações?"),
            content: const Text('Se sair as alterações serão perdidas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      Navigator.of(context).pop();
      return Future.value(false);
    }
  }
}