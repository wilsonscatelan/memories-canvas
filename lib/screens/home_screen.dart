import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../utils/app_theme.dart';
import '../utils/storage_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/memory_card.dart';
import 'add_memory_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  List<Memory> _memories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    final loaded = await _storage.loadMemories();
    // Ordena da mais recente para a mais antiga
    loaded.sort((a, b) => b.date.compareTo(a.date));
    if (mounted) {
      setState(() {
        _memories = loaded;
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToAdd() async {
    final newMemory = await Navigator.push<Memory>(
      context,
      MaterialPageRoute(builder: (_) => const AddMemoryScreen()),
    );

    if (newMemory != null) {
      setState(() {
        _memories.insert(0, newMemory);
      });
      await _storage.saveMemories(_memories);
    }
  }

  Future<void> _navigateToDetail(Memory memory) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(memory: memory)),
    );

    if (deleted == true) {
      setState(() {
        _memories.removeWhere((m) => m.id == memory.id);
      });
      await _storage.saveMemories(_memories);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Memória removida.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.accent),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 110,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MemoriesCanvas',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          '${_memories.length} ${_memories.length == 1 ? 'memória' : 'memórias'}',
                          style: const TextStyle(
                            color: AppTheme.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_memories.isEmpty)
                  const SliverFillRemaining(child: EmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final memory = _memories[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MemoryCard(
                              memory: memory,
                              onTap: () => _navigateToDetail(memory),
                            ),
                          );
                        },
                        childCount: _memories.length,
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        tooltip: 'Nova memória',
        child: const Icon(Icons.add),
      ),
    );
  }
}
