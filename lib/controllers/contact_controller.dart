import 'package:flutter/material.dart';
import '../helpers/contact_helper.dart';
import '../models/contact.dart';

class ContactController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final ContactHelper _helper = ContactHelper();

  void populateFields(Contact? contact) {
    nameController.text = contact?.name ?? '';
    emailController.text = contact?.email ?? '';
    phoneController.text = contact?.phone ?? '';
  }

  Future<void> saveOrUpdateContact(Contact contact) async {
    if (contact.id == null) {
      await _helper.saveContact(contact);
    } else {
      await _helper.updateContact(contact);
    }
  }

  Future<void> deleteContact(Contact contact) async {
    _helper.deleteContact(contact.id!);
  }

  void updateContactField(Contact contact, String field, String value) {
    switch (field) {
      case 'name':
        contact.name = value;
        break;
      case 'email':
        contact.email = value;
        break;
      case 'phone':
        contact.phone = value;
        break;
    }
  }
}
