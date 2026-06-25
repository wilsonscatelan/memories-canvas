import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/memory.dart';
import '../utils/app_theme.dart';
import '../utils/storage_service.dart';

class DetailScreen extends StatelessWidget {
  final Memory memory;

  const DetailScreen({super.key, required this.memory});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remover memória?',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Essa ação é permanente. A foto e os dados serão deletados do dispositivo.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Remover',
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await StorageService().deleteImageFile(memory.imagePath);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR').format(memory.date);
    final formattedTime = DateFormat('HH:mm').format(memory.date);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline,
                      size: 20, color: AppTheme.error),
                ),
                tooltip: 'Remover memória',
                onPressed: () => _confirmDelete(context),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: _buildHeroImage(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Data e hora
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined,
                          size: 14, color: AppTheme.accent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '$formattedDate · $formattedTime',
                          style: const TextStyle(
                            color: AppTheme.accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Título
                  Text(
                    memory.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divisor
                  Container(
                    width: 40,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Descrição
                  Text(
                    memory.description,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    final file = File(memory.imagePath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return Container(
      color: AppTheme.surfaceVariant,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined,
            color: AppTheme.textSecondary, size: 48),
      ),
    );
  }
}
