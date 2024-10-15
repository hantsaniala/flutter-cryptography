import 'package:basic_utils/basic_utils.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_rsa/fast_rsa.dart' as frsa;

class MainController extends GetxController {
  var isLoading = false.obs;
  var privateKeyPEM = """-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA5HLKtQqwfHz+yp1BB8ISWvH2L2bm4yscxgqLp9visRE/GDbB
lgzOaeoii6g7AXA85cKFPuCe93hitJmiv0maExrRbk+udSCaH6tAKW5WYhS66HqK
HOYA+wAvicrecKHVM4+pgSFr9+N3Ze74z5CMaL1Er6HkWKVEfL1ro3YCpfvfgNS9
7pTAvUGC5OOJeQ3CEsbLsehC274t7SHpK/CdObSsi7NHGZCW9P5a9m3ApbHj9W2E
3Xj4ve7fVxA1bHjajbnAc8be3ntQz6MG0LrviLilVlz+rjeJun0Rhph/JP+q6jgo
MFX9OmvBnvgJlfry1MS5Pb8TV/NLH+GAZeur8wIDAQABAoIBAC56xI9tK1dIvzZO
JGsFq2JhlGs0joltvh71ClEOxeKs1Z+BlIWI+X5HKtwrUEYMpfdBSobugKltDvgb
wicVPInijPXatG4UQgdrelRzpJO0EAs401zp1w06jnGEmxljc9NXyW8Cc8sttp9A
rdLdYBP3XkA1uhXnGjYe/AV3/zXx1Ju+RCKnJb46yS406N3LfPR+OcP3Nn4+CBuF
a8oXohsSY0HWbovfZG3svhU71Rx7oSWKSBtDXV6/Lb9tIpTqtuInQeKZX0ZVSe8F
/xG/rldmi5An/H/7nugCrSIBX7B9UrbJc4c3MNfuvL1q0sGrUIMHw7U0nltILxQf
Cp0Y8qECgYEA/BQZ2AEIrmdsb1p5bN5MbEflQuwkOlOfXt8OEodWozRWMyTMKuzF
OQipN0fls43k4cS1eMmMGn4S9sHrGlz+1nWWESjy4qp9dZ3ObAQPFMDPNQVIvzQH
a6XNvpm/Nwg+CR39s5TaNOVTsYvniI9HngrdpwamJtx/JmJrJAfO/esCgYEA6ACV
k9qD9kc7HIG8HAPYDWmYkqzxGpba6g6zbyGPVimvJGw1Kn3amumVdL2VyoEwd3lX
NskFUMntj+jpoH4nRZ+HQA5J3qRpDvzXrLx9xnKTBklBKT7SfGTAvBWeJ42qap4b
7EgH24xbXJlQAtczYqTOBXyhSKO5D6dXvlGGoBkCgYEAjwjM3U9A4M1Yrxq0Wb0N
ukdVZJLfv6ThgpCoyIS4+WRiISUZIKY3BrTOZ8rJIQg7vovCuSYL9KBjHFdOkyf/
his0msoUf99jzxBbJ9lpwUniiWBVNgFM0J1FUIinApAPu1akNXkaE/eodM9A8rDy
X1AlE3hnYReuolYoG0q+/j8CgYEAmznw2nlE+93S7hLbkn776pVxcQnnU5wFor7t
TXjN15+SQLNpqyGDx0xsJCzI8TIZBIcaVFyRguloWnZDApAFpK7FJpWo1R957346
q6d+G+4C8xzGTVtsJ7Cdx/pK1DoUALwDAMd9AmdZpY4qm4vzJJgSBFfL7bcllhSo
P316rtkCgYEA4gCL9fsXejZBA7B2d+VApJRmB9Qmb+8HlRYr4aNLd+T+pcGpvqBI
n2MdtyeMMMb/6pe+QV4vPS8c6JFNzSwvY0/k4OTFQchU5zNM1CAi1ABQyX3z4dBo
DIKA/xG7BfA9Gw9hhCBRcatn/+xEJR/8gOYFEo0M4Da+ZgWqUZepaxw=
-----END RSA PRIVATE KEY-----
      """;
  var publicKeyPEM = """-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5HLKtQqwfHz+yp1BB8IS
WvH2L2bm4yscxgqLp9visRE/GDbBlgzOaeoii6g7AXA85cKFPuCe93hitJmiv0ma
ExrRbk+udSCaH6tAKW5WYhS66HqKHOYA+wAvicrecKHVM4+pgSFr9+N3Ze74z5CM
aL1Er6HkWKVEfL1ro3YCpfvfgNS97pTAvUGC5OOJeQ3CEsbLsehC274t7SHpK/Cd
ObSsi7NHGZCW9P5a9m3ApbHj9W2E3Xj4ve7fVxA1bHjajbnAc8be3ntQz6MG0Lrv
iLilVlz+rjeJun0Rhph/JP+q6jgoMFX9OmvBnvgJlfry1MS5Pb8TV/NLH+GAZeur
8wIDAQAB
-----END PUBLIC KEY-----
      """;
  var randomKey = "sm8hND5JulfizWGKgxnlhu9mby3BBteOWcWarCb0IME=";
  var encryptedPassphrase =
      "YVJ/1OU++stfEtS611wbqbAu+Fz0SdYGdHqQm+3n9X/lH6yAoMaf5jgPcwZSx3V8B2ltZgufDUYc1WFSj8Sn9zYGMZjBsL1XmKlVZmPZdsP/OXdqW3Xnu+QIolpU0CklB6LcNTkQOe1xnjvVeWFo1OpDV8coyqPCvLL42ReKEMHk5BKkdJ3r/HqxnRq8wDKJMMsDcPlNy/lk1Kr6dBSmYykNRsP71AyPMSXPp/ShTpNeSYXyCvKSfSxRgauIEMclDhr1dp62J2qGPs0C8tXOIlogTwGtbrKyEyWBsPUd0aO6WNRvH6hHN6zcYfec/sBARYjZNcEkkb3LTALex7+utQ==";
  var encryptedPrivateKeyPEM =
      "gAAAAABm4DWOinzbnG9mh9S2-OgcOlSY6F3raORfi-TJk8zXHpbs9c3p-N5uBsYGTyNyoWfQqgVmFXlmB1eI6WAe9eRoSx1eRiwTkwjx29AAq6jMbNoSGCbOr0qv5qK2rgyTlpx4eCXixFvtudGRXCitC1Ih0KL2OoDFaS5l74O24Ppdusp7ODFWD4kw3g4XITwEkKRe9q5fYFDiqgdCQvTfBysl2GX9NDgt6Z7FopmuvBz5c7HzMnRh0ZT-RwLlEje4otFYhDhUQJMmiX2HzoOY4j0s0w7R94xSd1QtBpGvL9awHYrc6SFBbdpF28RANtR11QkrWtDJy8X__ZJggOULTuDt6_zdAhjHKVfbwH0zEyhynhZSLfR1cQxN-IU3DRsgz_qzLiWDkYyJok2qdBGG3fpqpCudq0v1q_I5Qp1CGqIn_UMUY0i1wWuzo0wxjUeXVogVjZlHBm1wBOuXT4a_hu4NzY_i5yi4waOjpay9jGEz1tqUaRUp_vm0fCSj7eGlv09ziVVDeQwr44xgGp8bYXrg4qFqc8l4lEwSJMoJmW-0tfeKj1HGLcIdXjxoeqOREU0kNxcCzAxzosXhLG4sdLW9_wUnOXNidpILblBTNiu4pL7KKLdne-4tbO5prdic8-Bs6tZuzsN6rVjstnJQZgLqzWrR1lgAiwg8Q9Hc_k7KqDre5G27dUH2_0qvEzeKTqt3WP8sOs5EboWKPGyAIRnkx3HXmFkpt5ZXX2_wRmQkKk4Zs8xJWHGorrAOwqAVyHMGfL4RLv7LXfzXlwypSLX9M1yiv0gXulX5iTK3z3F_xUMCsLG0SnDLoj7JP8V4DXWaJtMuzBKvAFn88c7U44rl_d6gFPEuUZaflyrAVmL53BhpkSuRTWavFdWWlJbSWSHYG27RSmQH_RBcwmN5ytsAR40CiLuukjkm5FeQyRbAVmJ_r8eNZCGbJM5QgHc7paD_fOmsBHOQTxQDHv9kaN48Ac07t69geJzZMAr8hr_zxQz7CEAjljh7yoqH-X3q7pbKQaaoF5K3fYUw8BF99fiXw8W2I7arhoLaGleqWqSGtxs0ghrF_IRR6vHTs6_WZV3H45_rhA9CrFy5AbC4-jryEU58T_E1ylpXgeCVDcsibOk5uoxmPdOetRaQZvrCGI1cvRZ8ny6APoKyGDeDtPjeeMzyomvgGQ2zBERlPeFtBQWUymBUjHfy1Nza2AJ5EWrU-GMpKveaSwB49o3m6fRjGBFppPzmLXU2yTfyUR08uzgnTlEFqvbY5PaZYlXChUyF1rao9Qudkyq6EbI6Y5hQqANuLqD6_YugeGSjj9dZPMvyqBytBfMWeJxsIKJf1FB-LyYsbixxkLbd8d0QhY6bKHPQaTr_khL8wMz6ydCYBQoK6JKqk8GE3yK_PndzNAX6Mr3KMFCfB85-Axb5e9Rmj4d_LwX0-0yckMuNUeMU4OyZHXSSZ0Kzz1V7ISHBprQH_KI2Y-nqGhqq8zlZ2JYt7YITNdVsMxAApy5gAF3fc9AWw_wg7x8T5bAoRhTDQAKNnAj7xILulALZoo_KoFW7vROz--4faPKaouMwbDouceU61RbKqCdOco7QaW10MXDZI-VM1WB5LaubLvBBbtBTYFQIsMk54I6UEhIFt9LsnYBAaFV-GrW4tAYSOPd87hpzcnGP3WJCtYP83Lh_djdVMdm4NrErGxVjC7syNbh2O1IoRMPljsXb3-hBvsGschgoP9rQ2WZ-3Ut3H9aQE7CzuLmaeCgoHqOHiNpLLNPZqBJeijtl2nnlOOCqWq39SsZBOxa-_I9y1Qdsohy8iudHKEMVu8Ga_AE78D3VrG8gi_t_ZIEhlBC9ggAVrstpq5bPMT6Th5rCRmY0q2WT1sQXPpbmKzpod03FSQ-i9v7PYqYkh82MtWMo0nRXYxBPQLmyQuvYKFCPDGjeNYpCmgpCYRr7vkNiIJ4mR0jN7ZL0_VT5v_ngjwA2HWwYnt1GsMi7_8B8Aifns5pVbOoT-NkK4xUBQeDd9loiszEOv77snEdD53tI8J-0GTfkTMRlpylwU4TnjvhLorTC9OjRTfRlF7uw8KoTPr647yrxcfgRKQD6UAulEQbTDyeAPVVr5BKdjcNVq0vlnuZbtqKil7qhGv0BLdaE1DbopduwA4ZbXdodapSRJe9B1giNiU-Bu_E4t9cY1czHysKVC0j3y35uK1G_rDecFUoRWyOoYfh4Jvtv9jQNMqqpUncsfZszMHp6ik0l_s0_6KPMr0xTpbZhJvcgWSRRZUiWWISb0AgTDcp1bkG8iMDvSV6cmDpUPCbxjbK9";

  @override
  void onInit() async {
    debugPrint("Init app");
    generateKeyPair();
    var decryptedPass = decryptPassphrase(encryptedPassphrase);
    if (decryptedPass != randomKey) {
      print("err: failed to decrypt Passphrase");
      print("randomKey: $randomKey");
      print("decryptedPass: $decryptedPass");
    }

    var decryptedPK = decryptPrivateKey(encryptedPrivateKeyPEM, decryptedPass);
    print(decryptedPK);

    var privateKey = RSAKeyParser().parse(privateKeyPEM) as RSAPrivateKey;
    decryptFile("/path/to/encrypted/file.encrypted", privateKey);

    super.onInit();
  }

  /// Decrypts a passphrase using the private RSA key.
  ///
  /// The passphrase is expected to be encrypted with the corresponding public key.
  /// The decrypted passphrase is returned as a string.
  String decryptPassphrase(String encryptedPass) {
    var encrypted = Encrypted.fromBase64(encryptedPass);
    var privateKey = RSAKeyParser().parse(privateKeyPEM) as RSAPrivateKey;

    var engine = encrypt.RSA(
        privateKey: privateKey,
        digest: RSADigest.SHA256,
        encoding: RSAEncoding.PKCS1);
    var decryptedData = engine.decrypt(encrypted);

    return String.fromCharCodes(decryptedData);
  }

  /// Decrypts a private key with a given passphrase.
  ///
  /// The encrypted key must be a base64 encoded string.
  /// The passphrase must be a base64 encoded string.
  ///
  /// Returns the decrypted private key as a String.
  String decryptPrivateKey(String encryptedPrivateKey, passphrase) {
    var encrypted = Encrypted.fromBase64(encryptedPrivateKey);
    var key = encrypt.Key.fromBase64(passphrase);
    var engine = Fernet(key);
    var decryptedData = engine.decrypt(encrypted);
    return String.fromCharCodes(decryptedData);
  }

  /// Decrypts a file using the private RSA key.
  ///
  /// The encrypted file should be named [encryptedFilePath].
  ///
  /// The decrypted file is saved to [encryptedFilePath].decrypted.
  void decryptFile(String encryptedFilePath, RSAPrivateKey privateKey) async {
    var file = File(encryptedFilePath);
    var encryptedData = await file.readAsBytes();

    var engine = encrypt.RSA(
        privateKey: privateKey,
        digest: RSADigest.SHA256,
        encoding: RSAEncoding.PKCS1);

    var encrypter = encrypt.Encrypter(engine);

    final decryptedBytes =
        encrypter.decryptBytes(encrypt.Encrypted(encryptedData));

    var decryptedFilePath = encryptedFilePath.endsWith(".encrypted")
        ? encryptedFilePath.substring(0, encryptedFilePath.length - 10)
        : "$encryptedFilePath.decrypted";
    var decryptedFile = File(decryptedFilePath);
    await decryptedFile.writeAsBytes(decryptedBytes);
    print("Decrypted file saved to $decryptedFilePath");
  }

  void generateKeyPair() async {
    frsa.KeyPair keyPair1 = await frsa.RSA.generate(2048);
    print("privateKey: ${keyPair1.privateKey}");
    print("publicKey: ${keyPair1.publicKey}");
  }
}
