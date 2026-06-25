import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/memory.dart';

class StorageService {
  static const _memoriesFileName = 'memories.json';
  static const _imagesDirName = 'memories_images';

  // Retorna o diretório de documentos do app
  Future<Directory> get _appDir async {
    return getApplicationDocumentsDirectory();
  }

  // Arquivo JSON onde as memórias são persistidas
  Future<File> get _memoriesFile async {
    final dir = await _appDir;
    return File('${dir.path}/$_memoriesFileName');
  }

  // Diretório exclusivo para imagens das memórias
  Future<Directory> get _imagesDir async {
    final dir = await _appDir;
    final imagesDir = Directory('${dir.path}/$_imagesDirName');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir;
  }

  /// Lê e retorna todas as memórias salvas no arquivo JSON.
  Future<List<Memory>> loadMemories() async {
    try {
      final file = await _memoriesFile;
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList
          .map((e) => Memory.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Arquivo corrompido ou inválido — começa do zero
      return [];
    }
  }

  /// Salva a lista completa de memórias no arquivo JSON.
  Future<void> saveMemories(List<Memory> memories) async {
    final file = await _memoriesFile;
    final jsonList = memories.map((m) => m.toMap()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  /// Copia a imagem temporária (do image_picker) para o diretório permanente
  /// do app e retorna o novo caminho definitivo.
  Future<String> copyImageToAppDir(String sourcePath) async {
    final imagesDir = await _imagesDir;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final destination = '${imagesDir.path}/$fileName';
    await File(sourcePath).copy(destination);
    return destination;
  }

  /// Remove fisicamente o arquivo de imagem do diretório do app.
  Future<void> deleteImageFile(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Ignora erros de exclusão silenciosamente
    }
  }
}
