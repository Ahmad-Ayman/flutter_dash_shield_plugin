import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:flutter/services.dart';

import '../../core/exceptions/configuration_exception.dart';
import '../../core/handlers/exception_handler.dart';

/// A service for managing SSL certificate pinning in the Dash Shield plugin.
///
/// The [SSLSecurityService] attaches SSL certificates to supported HTTP clients
/// for secure communication, ensuring only trusted certificates are accepted.
///
/// Example usage:
/// ```dart
/// await SSLSecurityService.attachSSLCertificate(
///   ['assets/certificates/my_cert.pem'],
///   dioClient,
/// );
/// ```
class SSLSecurityService {
  /// Attaches SSL certificates to the specified HTTP [client] to enforce SSL pinning.
  ///
  /// - [certificateAssetPaths] contains paths to certificate assets that will
  ///   be loaded and attached to the [client].
  /// - Currently supports only the Dio client. If an unsupported client type is
  ///   passed, a [ConfigurationException] is thrown.
  ///
  /// Throws a [ConfigurationException] if the client type is unsupported.
  static Future<dynamic> attachSSLCertificate(
      List<String> certificateAssetPaths, dynamic client) async {
    try {
      // Initialize security context with no trusted roots
      SecurityContext securityContext =
          SecurityContext(withTrustedRoots: false);

      // Load each certificate and add it to the security context
      for (var cert in certificateAssetPaths) {
        final ByteData data = await rootBundle.load(cert);
        securityContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
      }

      // Attach SSL pinning to the Dio client
      if (client is Dio) {
        _handleSSLPinningWithDio(client, securityContext);
      } else {
        throw ConfigurationException(
            'Unsupported client type. Only Dio and http.Client are supported for now.');
      }
    } catch (e, stackTrace) {
      ExceptionHandler.handleError(e, stackTrace);
    }
  }

  /// Configures SSL pinning for a Dio [client] using the specified [secContext].
  ///
  /// This method sets up an [HttpClient] with a custom security context for SSL
  /// certificate verification and attaches it to the Dio client.
  static void _handleSSLPinningWithDio(Dio client, SecurityContext secContext) {
    // Add HTTP formatter for logging requests and responses
    client.interceptors.add(HttpFormatter());

    // Create a customized HttpClient with the provided security context
    HttpClient httpClient = HttpClient(context: secContext);

    // Reject all certificates not in the trusted list
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return false;
    };

    // Set Dio's HTTP client adapter to use the customized HttpClient
    (client.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
        () => httpClient;
  }
}
