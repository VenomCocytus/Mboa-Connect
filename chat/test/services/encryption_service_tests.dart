import 'package:chat/src/services/encryption/encryption_service_contract.dart';
import 'package:chat/src/services/encryption/encryption_service_impl.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late IEncryption encryptionService;

  setUp(() {
    final encrypter = Encrypter(AES(Key.fromLength(32)));
    encryptionService = EncryptionService(encrypter);
  });

  test('Encryption of a plain text', () {
    const textToEncrypt = 'this is a message';
    final base64 = RegExp(r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$');
    final encryptedText = encryptionService.encrypt(textToEncrypt);
    
    expect(base64.hasMatch(encryptedText), true);
  });

  test('Decrypting the encrypted text', () {
    const text = 'this is a message';
    final encrypted = encryptionService.encrypt(text);
    final decrypted = encryptionService.decrypt(encrypted);

    expect(decrypted, text);
  });
}