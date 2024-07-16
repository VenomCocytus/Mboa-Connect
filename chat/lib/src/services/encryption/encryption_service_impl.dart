import 'package:chat/src/services/encryption/encryption_service_contract.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionService implements IEncryption {

  final Encrypter _encrypter;
  final _iv = IV.fromLength(16);

  EncryptionService(this._encrypter);

  @override
  String decrypt(String? encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText!);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  @override
  String encrypt(String? textToEncrypt) {
    return _encrypter.encrypt(textToEncrypt!, iv: _iv).base64;
  }
  
}