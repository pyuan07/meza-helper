import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/tag_model.dart';
import '../../providers/tag_provider.dart';
import 'widgets/tag_details_modal.dart';

enum TagOwnershipFilter { all, owned, missing }

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
  TagOwnershipFilter _ownershipFilter = TagOwnershipFilter.all;

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
              // Filters Row
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      TagType.values.length + 3, // +3 for Owned, Missing, All
                  itemBuilder: (context, index) {
                    // 1. My Collection Filter
                    if (index == 0) {
                      final isSelected =
                          _ownershipFilter == TagOwnershipFilter.owned;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          showCheckmark: true,
                          checkmarkColor:
                              isSelected ? Colors.white : Colors.transparent,
                          selected: isSelected,
                          avatar: Icon(
                            Icons.check_circle_outline_rounded,
                            color: isSelected ? Colors.white : Colors.white70,
                            size: 18,
                          ),
                          label: const Text('My Collection'),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          backgroundColor: Colors.white.withOpacity(0.1),
                          selectedColor: const Color(0xFF4CAF50), // Green
                          onSelected: (val) {
                            setState(() => _ownershipFilter = val
                                ? TagOwnershipFilter.owned
                                : TagOwnershipFilter.all);
                          },
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.white10,
                            ),
                          ),
                        ),
                      );
                    }

                    // 2. Missing Filter
                    if (index == 1) {
                      final isSelected =
                          _ownershipFilter == TagOwnershipFilter.missing;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: FilterChip(
                          showCheckmark: true,
                          checkmarkColor:
                              isSelected ? Colors.white : Colors.transparent,
                          selected: isSelected,
                          avatar: Icon(
                            Icons.cancel_outlined,
                            color: isSelected ? Colors.white : Colors.white70,
                            size: 18,
                          ),
                          label: const Text('Missing'),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          backgroundColor: Colors.white.withOpacity(0.1),
                          selectedColor: const Color(0xFFE57373), // Red accent
                          onSelected: (val) {
                            setState(() => _ownershipFilter = val
                                ? TagOwnershipFilter.missing
                                : TagOwnershipFilter.all);
                          },
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.white10,
                            ),
                          ),
                        ),
                      );
                    }

                    // 3. All Types Filter
                    if (index == 2) {
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

                    // 4. Specific Type Filters
                    final type = TagType.values[index - 3];
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
            _TagGrid(
                version: 0,
                filterType: _selectedType,
                ownershipFilter: _ownershipFilter),
            _TagGrid(
                version: 4,
                filterType: _selectedType,
                ownershipFilter: _ownershipFilter),
            _TagGrid(
                version: 3,
                filterType: _selectedType,
                ownershipFilter: _ownershipFilter),
            _TagGrid(
                version: 2,
                filterType: _selectedType,
                ownershipFilter: _ownershipFilter),
            _TagGrid(
                version: 1,
                filterType: _selectedType,
                ownershipFilter: _ownershipFilter),
          ],
        ),
      ),
    );
  }
}

class _TagGrid extends ConsumerWidget {
  final int version;
  final TagType? filterType;
  final TagOwnershipFilter ownershipFilter;

  const _TagGrid({
    required this.version,
    this.filterType,
    required this.ownershipFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch derived provider for reactivity
    final allTags = ref.watch(tagsByVersionProvider(version));

    // Apply Local Filters
    var tags = allTags;
    if (filterType != null) {
      tags = tags.where((t) => t.type == filterType).toList();
    }
    if (ownershipFilter == TagOwnershipFilter.owned) {
      tags = tags.where((t) => t.isOwned).toList();
    } else if (ownershipFilter == TagOwnershipFilter.missing) {
      tags = tags.where((t) => !t.isOwned).toList();
    }

    if (tags.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ownershipFilter == TagOwnershipFilter.owned
                  ? Icons.check_circle_outline_rounded
                  : (ownershipFilter == TagOwnershipFilter.missing
                      ? Icons.cancel_outlined
                      : Icons.search_off_rounded),
              size: 64,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              ownershipFilter == TagOwnershipFilter.owned
                  ? 'No owned tags found'
                  : (ownershipFilter == TagOwnershipFilter.missing
                      ? 'No missing tags found! Great job!'
                      : 'No ${filterType?.displayName ?? ""} tags found'),
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
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.15,
            crossAxisSpacing: 8, // Increased spacing
            mainAxisSpacing: 8,
          ),
          itemCount: tags.length,
          itemBuilder: (context, index) {
            return _TagCard(tag: tags[index]);
          },
        );
      },
    );
  }
}

class _TagCard extends StatefulWidget {
  final TagModel tag;

  const _TagCard({required this.tag});

  @override
  State<_TagCard> createState() => _TagCardState();
}

class _TagCardState extends State<_TagCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Column(
          children: [
            // Tag Image
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => TagDetailsModal(tag: widget.tag),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: _isHovered
                                ? Colors.black.withOpacity(0.4)
                                : Colors.black.withOpacity(0.2),
                            blurRadius: _isHovered ? 12 : 4,
                            offset: _isHovered
                                ? const Offset(0, 6)
                                : const Offset(0, 2),
                          ),
                        ],
                      ),
                      foregroundDecoration: widget.tag.isOwned
                          ? null
                          : BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              backgroundBlendMode: BlendMode.darken,
                            ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.tag.imageUrl,
                          fit: BoxFit.contain,
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
                    ),
                    // Mechanic Badge
                    if (widget.tag.mechanic != Mechanic.none)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: widget.tag.mechanic.color,
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
                            widget.tag.mechanic.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Owned Badge
                    if (widget.tag.isOwned)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50), // Green
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 4)
                              ]),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            // ID
            Text(
              widget.tag.id,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: widget.tag.isOwned ? Colors.white : Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),
            // Pokemon Name
            Text(
              widget.tag.pokemonName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: widget.tag.isOwned ? Colors.white : Colors.white60,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
