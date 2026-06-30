import 'package:url_launcher/url_launcher.dart';
import '../data/repositories/sos_contact_repository.dart';

/// Resultado de un intento de envío, para poder armar un resumen
/// y mostrarle al usuario qué pasó con cada contacto.
class MessageSendResult {
  final SosContact contact;
  final bool success;
  final String channel; // 'whatsapp' | 'sms' | 'none'

  const MessageSendResult({
    required this.contact,
    required this.success,
    required this.channel,
  });
}

class MessagingService {
  /// Intenta abrir WhatsApp con el mensaje precargado para el contacto.
  /// Si WhatsApp no está instalado o falla, intenta SMS nativo.
  /// Devuelve por qué canal se logró enviar (o 'none' si ninguno).
  Future<MessageSendResult> sendSos({
    required SosContact contact,
    required String message,
  }) async {
    final phone = contact.cleanPhone;
    if (phone.isEmpty) {
      return MessageSendResult(contact: contact, success: false, channel: 'none');
    }

    // 1) Intentar WhatsApp
    final waUri = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );
    try {
      final waLaunched = await canLaunchUrl(waUri);
      if (waLaunched) {
        final ok = await launchUrl(waUri, mode: LaunchMode.externalApplication);
        if (ok) {
          return MessageSendResult(contact: contact, success: true, channel: 'whatsapp');
        }
      }
    } catch (_) {
      // sigue al fallback de SMS
    }

    // 2) Fallback a SMS nativo
    final smsUri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: {'body': message},
    );
    try {
      final smsLaunched = await canLaunchUrl(smsUri);
      if (smsLaunched) {
        final ok = await launchUrl(smsUri);
        if (ok) {
          return MessageSendResult(contact: contact, success: true, channel: 'sms');
        }
      }
    } catch (_) {}

    return MessageSendResult(contact: contact, success: false, channel: 'none');
  }

  /// Envía el mensaje SOS a una lista de contactos, uno por uno.
  /// IMPORTANTE: cada llamada a WhatsApp/SMS abre la app externa,
  /// así que el usuario va a ver una transición por cada contacto.
  /// Esto es una limitación de Android: no se puede enviar SMS/WhatsApp
  /// silenciosamente sin que el usuario confirme el envío (por seguridad
  /// del sistema operativo y de la propia app de WhatsApp).
  Future<List<MessageSendResult>> sendSosToAll({
    required List<SosContact> contacts,
    required String message,
  }) async {
    final results = <MessageSendResult>[];
    for (final c in contacts) {
      final r = await sendSos(contact: c, message: message);
      results.add(r);
      // pequeño delay para que no se pisen las transiciones de apps
      await Future.delayed(const Duration(milliseconds: 400));
    }
    return results;
  }

  /// Genera el texto del mensaje SOS con ubicación.
  String buildSosMessage({
    required String userName,
    required double latitude,
    required double longitude,
    required String address,
  }) {
    final mapsUrl = 'https://maps.google.com/?q=$latitude,$longitude';
    final name = userName.isNotEmpty ? userName : 'Un usuario de Guardian';
    return '🚨 ALERTA SOS — $name necesita ayuda\n'
        'Ubicación: ${address.isNotEmpty ? address : "$latitude, $longitude"}\n'
        'Ver en mapa: $mapsUrl\n'
        'Enviado desde la app Guardian.';
  }
}
