import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/road_signs_data.dart';
import '../../models/road_sign_model.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/road_sign_painters.dart';
import 'road_sign_detail_screen.dart';
import 'sign_learning_screen.dart';

class RoadSignsScreen extends StatefulWidget {
  const RoadSignsScreen({super.key});

  @override
  State<RoadSignsScreen> createState() => _RoadSignsScreenState();
}

class _RoadSignsScreenState extends State<RoadSignsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';
  late Set<String> _favoriteSignIds;

  @override
  void initState() {
    super.initState();
    final storage = context.read<StorageService>();
    _favoriteSignIds = storage.getFavoriteSignIds();
  }

  void _onSearchChanged(String val) {
    setState(() {
      _searchQuery = val;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  Future<void> _toggleFavorite(String signId) async {
    final storage = context.read<StorageService>();
    await storage.toggleFavoriteSign(signId);
    setState(() {
      _favoriteSignIds = storage.getFavoriteSignIds();
    });
  }

  List<RoadSignModel> _getFilteredSigns() {
    List<RoadSignModel> list;
    if (_selectedCategory == 'Favorites') {
      list = RoadSignsData.allSigns
          .where((s) => _favoriteSignIds.contains(s.id))
          .toList();
    } else {
      list = RoadSignsData.getSignsByCategory(_selectedCategory);
    }

    if (_searchQuery.trim().isEmpty) {
      return list;
    }

    final q = _searchQuery.trim().toLowerCase();
    return list.where((sign) {
      final nameMatch = sign.name.toLowerCase().contains(q);
      final meaningMatch = sign.meaning.toLowerCase().contains(q);
      final categoryMatch = sign.category.toLowerCase().contains(q);
      return nameMatch || meaningMatch || categoryMatch;
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Regulatory':
        return AppColors.error;
      case 'Warning':
        return Colors.amber.shade900;
      case 'Informative':
        return Colors.blue.shade700;
      case 'Guide':
        return Colors.green.shade700;
      case 'Road Work':
        return Colors.deepOrange;
      default:
        return AppColors.primary;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filteredSigns = _getFilteredSigns();

    // Dynamically retrieve all categories actually present in dataset
    final availableCategories = [
      'All',
      ...RoadSignsData.allCategories,
      'Favorites',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Road Signs'),
        actions: [
          IconButton(
            tooltip: 'Practice Signs',
            icon: const Icon(Icons.school_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SignLearningScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Filter Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            color: colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search TextField
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search signs by name, meaning, or category...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 22),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: _clearSearch,
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Category Filter Chips List
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: availableCategories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = availableCategories[index];
                      final isSelected = _selectedCategory == cat;
                      final count = cat == 'All'
                          ? RoadSignsData.allSigns.length
                          : (cat == 'Favorites'
                              ? _favoriteSignIds.length
                              : RoadSignsData.getSignsByCategory(cat).length);

                      return FilterChip(
                        selected: isSelected,
                        label: Text('$cat ($count)'),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Practice Signs CTA Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignLearningScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school_rounded, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Learn Road Signs Mode',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            'Interactive 10-sign recognition quiz',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Main Sign Grid / Empty State
          Expanded(
            child: filteredSigns.isEmpty
                ? _buildEmptyState(context)
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: filteredSigns.length,
                    itemBuilder: (context, index) {
                      final sign = filteredSigns[index];
                      final isFav = _favoriteSignIds.contains(sign.id);
                      final catCol = _getCategoryColor(sign.category);

                      return CustomCard(
                        padding: const EdgeInsets.all(10),
                        onTap: () async {
                          final storage = context.read<StorageService>();
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoadSignDetailScreen(sign: sign),
                            ),
                          );
                          // Refresh favorites state when returning
                          if (mounted) {
                            setState(() {
                              _favoriteSignIds = storage.getFavoriteSignIds();
                            });
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Category Badge & Favorite Star
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: catCol.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    sign.category,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: catCol,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _toggleFavorite(sign.id),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                                      size: 20,
                                      color: isFav ? Colors.amber : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Vector Sign Art
                            Expanded(
                              child: Center(
                                child: RoadSignWidget(
                                  signType: sign.signType,
                                  size: 72,
                                  semanticLabel: sign.semanticLabel,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Sign Name
                            Text(
                              sign.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),

                            // Meaning snippet
                            Text(
                              sign.meaning,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Passive Banner Ad
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No signs found',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No signs matched "$_searchQuery"'
                  : 'No signs in this category',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (_searchQuery.isNotEmpty || _selectedCategory != 'All')
              OutlinedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _selectedCategory = 'All';
                  });
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Clear Search & Filters'),
              ),
          ],
        ),
      ),
    );
  }
}
