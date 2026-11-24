import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/auth_service.dart';
import 'auth_status.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = NotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
);

final profileProvider =
    FutureProvider<Map<String, String>>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  final name = await storage.read(key: AuthNotifier.profileNameKey);
  final email = await storage.read(key: AuthNotifier.profileEmailKey);
  final institution =
      await storage.read(key: AuthNotifier.profileInstitutionKey);
  final program = await storage.read(key: AuthNotifier.profileProgramKey);

  return {
    'name': name ?? 'Aminata Ouédraogo',
    'email': email ?? 'aminata@campusflow.com',
    'institution': institution ?? 'Université Aube Nouvelle',
    'program': program ?? 'Master 1 MSI',
  };
});

class AuthNotifier extends Notifier<bool> {
  static const String tokenKey = 'auth_token';
  static const String profileNameKey = 'profile_name';
  static const String profileEmailKey = 'profile_email';
  static const String profileInstitutionKey = 'profile_institution';
  static const String profileProgramKey = 'profile_program';

  @override
  bool build() => false;

  Future<void> initialize() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: tokenKey);

    if (token == null || token.isEmpty) {
      state = false;
      authStatus.value = false;
      return;
    }

    final valid = await ref.read(authServiceProvider).validateToken(token);

    if (!valid) {
      await storage.delete(key: tokenKey);
    }

    state = valid;
    authStatus.value = valid;
  }

  Future<void> login(String email, String password) async {
    final token = await ref.read(authServiceProvider).login(email, password);

    await ref.read(secureStorageProvider).write(
      key: tokenKey,
      value: token,
    );

    state = true;
    authStatus.value = true;
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: tokenKey);
    await storage.delete(key: profileNameKey);
    await storage.delete(key: profileEmailKey);
    await storage.delete(key: profileInstitutionKey);
    await storage.delete(key: profileProgramKey);

    state = false;
    authStatus.value = false;
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String institution,
    required String program,
    required String password,
  }) async {
    final token = await ref.read(authServiceProvider).register(
          fullName: fullName,
          email: email,
          institution: institution,
          program: program,
          password: password,
        );

    final storage = ref.read(secureStorageProvider);
    await storage.write(key: tokenKey, value: token);
    await storage.write(key: profileNameKey, value: fullName);
    await storage.write(key: profileEmailKey, value: email);
    await storage.write(key: profileInstitutionKey, value: institution);
    await storage.write(key: profileProgramKey, value: program);

    state = true;
    authStatus.value = true;
  }

  void unauthorized() {
    state = false;
    authStatus.value = false;
  }
}
