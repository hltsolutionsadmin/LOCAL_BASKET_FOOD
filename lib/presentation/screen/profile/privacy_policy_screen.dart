import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_basket/components/custom_topbar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      appBar: const CustomAppBar(title: 'Privacy Policy'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text(
            'Your privacy matters',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Last updated: August 20, 2026',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          _PolicySection(
            title: 'Information we collect',
            body:
                'We collect information you provide when creating an account, managing your profile, saving an address, contacting support, or placing an order. This may include your name, mobile number, email address, delivery address, and order details.',
          ),
          _PolicySection(
            title: 'Location information',
            body:
                'With your permission, we use your device location to show nearby restaurants, check service availability, and improve delivery accuracy. You can manage location permission from your device settings.',
          ),
          _PolicySection(
            title: 'Payments',
            body:
                'Payments are processed through our payment partners. Local Basket does not store your complete card or banking credentials. Payment providers may process information according to their own privacy policies.',
          ),
          _PolicySection(
            title: 'How we use information',
            body:
                'We use information to provide and improve food delivery, process orders and payments, show offers, provide customer support, send service notifications, prevent misuse, and comply with legal requirements.',
          ),
          _PolicySection(
            title: 'Notifications and device data',
            body:
                'If you allow notifications, we may use a device token to deliver order updates and important service messages. Technical information may be used to keep the app secure and reliable.',
          ),
          _PolicySection(
            title: 'Sharing information',
            body:
                'We share only the information needed to complete your order with restaurants, delivery partners, payment providers, technology providers, and authorities where legally required.',
          ),
          _PolicySection(
            title: 'Your choices',
            body:
                'You can update your profile and saved addresses in the app, control device permissions, and request account deletion through support. Some information may be retained where required for legal, security, or transaction records.',
          ),
          _PolicySection(
            title: 'Contact us',
            body:
                'For privacy questions or requests, contact HAVE LIFE TECH SOLUTIONS at havelifetech03@gmail.com.',
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String body;

  const _PolicySection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(
              fontSize: 13,
              height: 1.55,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
