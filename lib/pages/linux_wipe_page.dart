import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/wipe_provider.dart';

class LinuxWipePage extends StatefulWidget {
  const LinuxWipePage({super.key});

  @override
  State<LinuxWipePage> createState() => _LinuxWipePageState();
}

class _LinuxWipePageState extends State<LinuxWipePage> {
  DiskInfo? _selectedDisk;
  WipeMethod _method = WipeMethod.deleteAllFiles;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WipeProvider>().loadAvailableDisks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WipeProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_method == WipeMethod.purgeAllFiles) ...[
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
                    child: Text('⚠ This will irreversibly erase all data. Use with caution.',
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
                child: DropdownButtonFormField<DiskInfo>(
                  value: _selectedDisk,
                  items: provider.availableDisks.map((disk) => DropdownMenuItem(
                    value: disk,
                    child: Text('${disk.name} (${disk.type.name.toUpperCase()}, ${disk.sizeGB}GB)'),
                  )).toList(),
                  onChanged: provider.isWiping ? null : (v) => setState(() => _selectedDisk = v),
                  decoration: const InputDecoration(
                    labelText: 'Select Disk',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.storage),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<WipeMethod>(
                  value: _method,
                  items: const [
                    DropdownMenuItem(value: WipeMethod.deleteAllFiles, child: Text('Delete all Files')),
                    DropdownMenuItem(value: WipeMethod.purgeAllFiles, child: Text('Purge all Files')),
                  ],
                  onChanged: provider.isWiping ? null : (v) => setState(() => _method = v ?? _method),
                  decoration: const InputDecoration(
                    labelText: 'Wipe Method',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: (provider.isWiping || _selectedDisk == null) ? null : () => 
                  context.read<WipeProvider>().simulateLinuxWipe(_selectedDisk!, _method),
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
