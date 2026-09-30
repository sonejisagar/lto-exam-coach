// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/routes/app_routes.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/custom_card.dart';

class VehicleSelectionScreen extends StatefulWidget {
  final bool isModal;

  const VehicleSelectionScreen({
    super.key,
    this.isModal = false,
  });

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  String _selectedType = 'both';

  @override
  void initState() {
    super.initState();
    final current = context.read<SettingsProvider>().vehicleType;
    _selectedType = current;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Category'),
        automaticallyImplyLeading: widget.isModal,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What are you preparing for?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your target license type to personalize your practice questions and study material.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Option 1: Car
              _buildVehicleOptionCard(
                context,
                type: 'car',
                title: 'Car (Non-Professional)',
                subtitle: 'Four-wheel light passenger vehicles & SUVs',
                icon: Icons.directions_car_rounded,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),

              // Option 2: Motorcycle
              _buildVehicleOptionCard(
                context,
                type: 'motorcycle',
                title: 'Motorcycle',
                subtitle: 'Two-wheel motorcycles, scooters & tricycles',
                icon: Icons.two_wheeler_rounded,
                color: Colors.teal,
              ),
              const SizedBox(height: 12),

              // Option 3: Both
              _buildVehicleOptionCard(
                context,
                type: 'both',
                title: 'Both Car & Motorcycle',
                subtitle: 'Comprehensive review covering all vehicle categories',
                icon: Icons.directions_transit_filled_rounded,
                color: Colors.indigo,
              ),

              const Spacer(),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final settings = context.read<SettingsProvider>();
                    await settings.setVehicleType(_selectedType);
                    await settings.completeOnboarding();

                    if (!mounted) return;
                    if (widget.isModal) {
                      navigator.pop();
                    } else {
                      navigator.pushNamedAndRemoveUntil(
                        AppRoutes.main,
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Save & Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleOptionCard(
    BuildContext context, {
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedType == type;

    return CustomCard(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      backgroundColor: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerLow,
      borderSide: isSelected
          ? BorderSide(color: colorScheme.primary, width: 2)
          : null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary
                  : color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: isSelected ? colorScheme.onPrimary : color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimaryContainer.withValues(alpha: 0.85)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Radio<String>(
            value: type,
            groupValue: _selectedType,
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedType = val);
              }
            },
          ),
        ],
      ),
    );
  }
}
