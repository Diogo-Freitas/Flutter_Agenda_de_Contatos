import 'package:flutter/material.dart';
import '../controllers/contact_controller.dart';
import '../pages/contact_page.dart';
import '../models/contact.dart';
import 'dart:io';

class ContactCard extends StatelessWidget {
  ContactCard({super.key, required this.contact, required this.onUpdate});

  final Contact contact;
  final VoidCallback onUpdate;

  final ContactController _controller = ContactController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: contact.img != null
                      ? DecorationImage(
                          image: FileImage(File(contact.img!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: contact.img == null
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name ?? '',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contact.email ?? '',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      contact.phone ?? '',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context);
      },
    );
  }

  void _showCotactPage(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact)),
    ).then((_) {
      onUpdate();
    });
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Ligar",
                        style: TextStyle(color: Colors.redAccent, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showCotactPage(context);
                      },
                      child: const Text(
                        "Editar",
                        style: TextStyle(color: Colors.redAccent, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _controller.deleteContact(contact);
                        onUpdate();
                      },
                      child: const Text(
                        "Excluir",
                        style: TextStyle(color: Colors.redAccent, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}