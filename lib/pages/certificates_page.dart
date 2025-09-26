import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/wipe_provider.dart';

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WipeProvider>();
    final certs = provider.certificates;
    final last = certs.isNotEmpty ? certs.last : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_outlined),
              const SizedBox(width: 8),
              Text('Certificates', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              if (last != null)
                FilledButton.icon(
                  onPressed: () => provider.downloadCertificate(last),
                  icon: const Icon(Icons.download),
                  label: const Text('Download Certificate'),
                )
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: SelectableText(
                  last != null ? last.toJson(pretty: true) : '{\n  "message": "Run a simulated wipe to generate a certificate."\n}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
