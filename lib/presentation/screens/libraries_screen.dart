import 'package:flutter/material.dart';

class LibrariesScreen extends StatelessWidget {
  const LibrariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ライブラリ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB7B2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFB7B2).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Color(0xFFFFB7B2)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'このアプリは以下のオープンソースライブラリを使用しています',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildLibraryCard(
              name: 'Flutter',
              description: 'Google\'s UI toolkit for building beautiful apps',
              license: 'BSD-3-Clause',
              url: 'https://flutter.dev',
            ),
            _buildLibraryCard(
              name: 'Riverpod',
              description: 'A reactive caching and data-binding framework',
              license: 'MIT',
              url: 'https://riverpod.dev',
            ),
            _buildLibraryCard(
              name: 'Freezed',
              description: 'Code generation for immutable classes',
              license: 'MIT',
              url: 'https://pub.dev/packages/freezed',
            ),
            _buildLibraryCard(
              name: 'Firebase',
              description: 'Google\'s mobile platform',
              license: 'Apache-2.0',
              url: 'https://firebase.google.com',
            ),
            _buildLibraryCard(
              name: 'Google Fonts',
              description:
                  'A Flutter package to use fonts from fonts.google.com',
              license: 'Apache-2.0',
              url: 'https://pub.dev/packages/google_fonts',
            ),
            _buildLibraryCard(
              name: 'Image Picker',
              description: 'A Flutter plugin for selecting images',
              license: 'Apache-2.0',
              url: 'https://pub.dev/packages/image_picker',
            ),
            _buildLibraryCard(
              name: 'Shared Preferences',
              description:
                  'Flutter plugin for reading and writing simple key-value pairs',
              license: 'BSD-3-Clause',
              url: 'https://pub.dev/packages/shared_preferences',
            ),
            _buildLibraryCard(
              name: 'URL Launcher',
              description: 'A Flutter plugin for launching URLs',
              license: 'BSD-3-Clause',
              url: 'https://pub.dev/packages/url_launcher',
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'その他多数のライブラリに感謝します',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryCard({
    required String name,
    required String description,
    required String license,
    required String url,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFB5EAD7).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  license,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D6A4F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
