import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'data/tag_repository.dart';
import '../../models/tag_model.dart';
import 'widgets/tag_details_modal.dart';

class TagDexScreen extends ConsumerStatefulWidget {
  const TagDexScreen({super.key});

  @override
  ConsumerState<TagDexScreen> createState() => _TagDexScreenState();
}

class _TagDexScreenState extends ConsumerState<TagDexScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TagType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          'Tag Dex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Version Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'ALL'),
                    Tab(text: 'Ver 4'),
                    Tab(text: 'Ver 3'),
                    Tab(text: 'Ver 2'),
                    Tab(text: 'Ver 1'),
                  ],
                ),
              ),
              // Type Filter
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: TagType.values.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isSelected = _selectedType == null;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          showCheckmark: false,
                          selected: isSelected,
                          label: const Text('All Types'),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          backgroundColor: Colors.white.withOpacity(0.1),
                          selectedColor: const Color(0xFF6C63FF),
                          onSelected: (_) =>
                              setState(() => _selectedType = null),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color:
                                  isSelected ? Colors.white24 : Colors.white10,
                            ),
                          ),
                        ),
                      );
                    }
                    final type = TagType.values[index - 1];
                    final isSelected = _selectedType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        showCheckmark: false,
                        selected: isSelected,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              type.iconPath,
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                isSelected ? Colors.white : type.color,
                                BlendMode.srcIn,
                              ),
                              placeholderBuilder: (_) => Icon(
                                Icons.circle,
                                color: isSelected ? Colors.white : type.color,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(type.displayName),
                          ],
                        ),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: type.color.withOpacity(0.15),
                        selectedColor: type.color,
                        onSelected: (_) => setState(() {
                          _selectedType = isSelected ? null : type;
                        }),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected
                                ? Colors.white24
                                : type.color.withOpacity(0.3),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E), // Dark Blue
              Color(0xFF16213E), // Slightly lighter blue
              Color(0xFF0F3460), // Even lighter
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _TagGrid(version: 0, filterType: _selectedType),
            _TagGrid(version: 4, filterType: _selectedType),
            _TagGrid(version: 3, filterType: _selectedType),
            _TagGrid(version: 2, filterType: _selectedType),
            _TagGrid(version: 1, filterType: _selectedType),
          ],
        ),
      ),
    );
  }
}

class _TagGrid extends StatelessWidget {
  final int version;
  final TagType? filterType;

  const _TagGrid({required this.version, this.filterType});

  @override
  Widget build(BuildContext context) {
    List<TagModel> tags = version == 0
        ? TagRepository.getAllTags()
        : TagRepository.getTagsByVersion(version);

    if (filterType != null) {
      tags = tags.where((t) => t.type == filterType).toList();
    }

    if (tags.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              'No ${filterType?.displayName ?? ""} tags found',
              style: const TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use 5 columns for wider screens (tablet/desktop), 3 for mobile
        final int crossAxisCount = constraints.maxWidth > 600 ? 5 : 3;

        return GridView.builder(
          padding: const EdgeInsets.all(
              16), // Simplified padding as it's no longer floating
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.15,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: tags.length,
          itemBuilder: (context, index) {
            return _TagCard(tag: tags[index], index: index);
          },
        );
      },
    );
  }
}

class _TagCard extends StatelessWidget {
  final TagModel tag;
  final int index;

  const _TagCard({required this.tag, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tag Image
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => TagDetailsModal(tag: tag),
              );
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    tag.imageUrl,
                    fit: BoxFit.contain, // Maintain aspect ratio
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              size: 20, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                if (tag.mechanic != Mechanic.none)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: tag.mechanic.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        tag.mechanic.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        // ID
        Text(
          tag.id,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
        // Pokemon Name
        Text(
          tag.pokemonName,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500, // Slightly bolder but less than ID
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
