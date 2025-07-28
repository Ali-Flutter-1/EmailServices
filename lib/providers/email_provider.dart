import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/mail_api.dart';
import '../model/email.dart';


final emailProvider = StateNotifierProvider<EmailNotifier, AsyncValue<List<Email>>>(
      (ref) => EmailNotifier(),
);

class EmailNotifier extends StateNotifier<AsyncValue<List<Email>>> {
  EmailNotifier() : super(const AsyncValue.loading()) {
    _init(); // fetch emails on load
  }

  String? _email;
  String? _password;
  String? _token;

  String? get email => _email;

  Future<void> _init() async {
    try {
      // Step 1: Create temp account
      final account = await MailApi.createTempAccount();
      _email = account['email'];
      _password = account['password'];

      // Step 2: Login and get token
      _token = await MailApi.getAuthToken(_email!, _password!);

      // Step 3: Load inbox
      await loadInbox();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadInbox() async {
    if (_token == null) return;

    try {
      state = const AsyncValue.loading();
      final rawEmails = await MailApi.getInbox(_token!);
      final emails = rawEmails.map((e) => Email.fromJson(e)).toList();
      state = AsyncValue.data(emails);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshEmail() async {
    await _init(); // reset everything
  }
}
