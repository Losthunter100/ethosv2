import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ethosv2/feature/contact/repository/contacts_repositry.dart';

final contactsControllerProvider = FutureProvider(
      (ref) {
    final contactsRepository = ref.watch(contactsRepositoryProvider);
    return contactsRepository.getAllContacts();
  },
);
