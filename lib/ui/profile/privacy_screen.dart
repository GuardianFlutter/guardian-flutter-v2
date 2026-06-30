import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacidad y seguridad'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _InfoCard(
            icon: Icons.location_on_outlined,
            title: 'Ubicación',
            body: 'Tu ubicación se usa para mostrar incidentes cercanos en el '
                'mapa y para adjuntarla automáticamente cuando creás un reporte '
                'o activás una alerta SOS. Solo se comparte con tus contactos '
                'SOS al activar una alerta, nunca de forma pública.',
          ),
          _InfoCard(
            icon: Icons.people_outline,
            title: 'Contactos SOS',
            body: 'Los contactos que agregués se guardan de forma privada '
                'asociados a tu cuenta. Solo se usan para enviarles tu '
                'ubicación por WhatsApp o SMS cuando activás el botón SOS. '
                'Guardian no accede a tu lista de contactos del teléfono.',
          ),
          _InfoCard(
            icon: Icons.description_outlined,
            title: 'Reportes',
            body: 'Los reportes que publicás son visibles para otros usuarios '
                'de la app con tu nombre de perfil. No se comparte tu email '
                'ni tu teléfono en los reportes públicos.',
          ),
          _InfoCard(
            icon: Icons.storage_outlined,
            title: 'Almacenamiento de datos',
            body: 'Los datos de tu cuenta, reportes y contactos SOS se '
                'almacenan en Firebase (Google Cloud). Las fotos de los '
                'reportes se almacenan en un servicio externo (Cloudinary).',
          ),
          _InfoCard(
            icon: Icons.delete_outline,
            title: 'Eliminar tu cuenta',
            body: 'Para solicitar la eliminación de tu cuenta y tus datos, '
                'contactá a la cátedra o al administrador del proyecto.',
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _InfoCard({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(color: AppColors.textPrimary,
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(body,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }
}
