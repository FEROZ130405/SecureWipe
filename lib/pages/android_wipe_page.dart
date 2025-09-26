import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/wipe_provider.dart';

class AndroidWipePage extends StatefulWidget {
  const AndroidWipePage({super.key});

  @override
  State<AndroidWipePage> createState() => _AndroidWipePageState();
}

class _AndroidWipePageState extends State<AndroidWipePage> {
  AndroidWipeMethod _method = AndroidWipeMethod.factoryReset;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WipeProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_method == AndroidWipeMethod.encryptAndReset) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Theme.of(context).colorScheme.onErrorContainer),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('⚠ This will irreversibly encrypt and erase all data. Use with caution.',
                        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<AndroidWipeMethod>(
                  value: _method,
                  items: const [
                    DropdownMenuItem(value: AndroidWipeMethod.factoryReset, child: Text('Factory Reset')),
                    DropdownMenuItem(value: AndroidWipeMethod.encryptAndReset, child: Text('Encrypt and Reset')),
                  ],
                  onChanged: provider.isWiping ? null : (v) => setState(() => _method = v ?? _method),
                  decoration: const InputDecoration(
                    labelText: 'Wipe Method',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.smartphone),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: provider.isWiping ? null : () => 
                  context.read<WipeProvider>().simulateAndroidWipe(_method),
                icon: provider.isWiping
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.play_arrow),
                label: const Text('Start Wipe'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Text(
                  provider.logOutput.isEmpty ? 'Logs will appear here...' : provider.logOutput,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
