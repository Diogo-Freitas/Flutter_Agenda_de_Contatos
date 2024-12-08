import 'package:flutter/material.dart';
import '../helpers/contact_helper.dart';
import '../widgets/contact_card.dart';
import '../models/contact.dart';
import 'contact_page.dart';

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();

    _getContacts();
  }

  void _getContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAZ:
        contacts.sort((a, b) {
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        contacts.sort((a, b) {
          return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
        });
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<OrderOptions>(
            onSelected: _orderList,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderAZ,
                child: Text('Ordenar de A-Z'),
              ),
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderZA,
                child: Text('Ordenar de Z-A'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactPage()),
          ).then((_) {
            _getContacts();
          });
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ContactCard(contact: contacts[index], onUpdate: _getContacts);
        },
      ),
    );
  }
}