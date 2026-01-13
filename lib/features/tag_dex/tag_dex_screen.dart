import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/tag_model.dart';
import '../../providers/tag_provider.dart';
import 'widgets/tag_details_modal.dart';
import '../../shared/widgets/glass_capsule.dart';
import '../../shared/widgets/type_icon.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/glass_container.dart';

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

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  final Set<TagType> _selectedTypes = {};
  final Set<Mechanic> _selectedMechanics = {};
  MoveCategory? _selectedMoveCategory;

  TagOwnershipFilter _ownershipFilter = TagOwnershipFilter.all;
  bool _isFilterExpanded = false;

  void _resetFilters() {
    setState(() {
      _selectedTypes.clear();
      _selectedMechanics.clear();
      _selectedMoveCategory = null;
      _ownershipFilter = TagOwnershipFilter.all;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          false, // Changed to false to avoid body overlapping
      resizeToAvoidBottomInset: false, // Prevent keyboard from resizing body
      appBar: AppBar(
        title: const Text(
          'Tag Dex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors
            .transparent, // We will use a container in flexibleSpace for gradient
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.9), // Darker for better contrast
                const Color(0xFF1A1A2E),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110), // Adjusted height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: GlassContainer(
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: const Color(0xFF6C63FF),
                      decoration: InputDecoration(
                        hintText: 'Search Pokémon...',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.4)),
                        prefixIcon: Icon(Icons.search,
                            color: Colors.white.withOpacity(0.4)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: Colors.white70),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ),
              ),
              // Version Tabs
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
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
                  unselectedLabelColor: Colors.white54,
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
        child: Column(
          children: [
            // Filters Section (Accordion Style)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: _isFilterExpanded
                    ? const Color(0xFF0F172A).withOpacity(0.95)
                    : Colors.transparent,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
                boxShadow: _isFilterExpanded
                    ? [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10)
                      ]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle / Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        // Active Filters Summary (Collapsed State)
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (_isFilterExpanded)
                                  const Text(
                                    'Advanced Filters',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold),
                                  )
                                else ...[
                                  // Ownership
                                  if (_ownershipFilter !=
                                      TagOwnershipFilter.all)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: GlassCapsule(
                                        isSelected: true,
                                        label: _ownershipFilter ==
                                                TagOwnershipFilter.owned
                                            ? 'Collection'
                                            : 'Missing',
                                        icon: _ownershipFilter ==
                                                TagOwnershipFilter.owned
                                            ? Icons.check_circle_outline_rounded
                                            : Icons.cancel_outlined,
                                        color: _ownershipFilter ==
                                                TagOwnershipFilter.owned
                                            ? const Color(0xFF4CAF50)
                                            : const Color(0xFFE57373),
                                        onTap: () => setState(() =>
                                            _ownershipFilter =
                                                TagOwnershipFilter.all),
                                      ),
                                    ),
                                  // Mechanics
                                  ..._selectedMechanics.map((m) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: GlassCapsule(
                                            isSelected: true,
                                            label: m.displayName,
                                            icon: Icons.bolt,
                                            color: m.color,
                                            onTap: () => setState(() =>
                                                _selectedMechanics.remove(m))),
                                      )),
                                  // Types
                                  ..._selectedTypes.map(
                                    (type) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: GlassCapsule(
                                        isSelected: true,
                                        label: type.displayName,
                                        iconWidget: TypeIcon(
                                            type: type, isSelected: true),
                                        color: type.color,
                                        onTap: () => setState(
                                            () => _selectedTypes.remove(type)),
                                      ),
                                    ),
                                  ),
                                  // Move Category
                                  if (_selectedMoveCategory != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: GlassCapsule(
                                        isSelected: true,
                                        label:
                                            _selectedMoveCategory!.displayName,
                                        icon: _selectedMoveCategory ==
                                                MoveCategory.physical
                                            ? Icons.fitness_center
                                            : Icons.auto_awesome,
                                        color: _selectedMoveCategory!.color,
                                        onTap: () => setState(
                                            () => _selectedMoveCategory = null),
                                      ),
                                    ),
                                ],
                                if (!_isFilterExpanded &&
                                    _ownershipFilter ==
                                        TagOwnershipFilter.all &&
                                    _selectedTypes.isEmpty &&
                                    _selectedMechanics.isEmpty &&
                                    _selectedMoveCategory == null)
                                  Text(
                                    'Filter Tags...',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Reset Button (if filters active)
                        if (_ownershipFilter != TagOwnershipFilter.all ||
                            _selectedTypes.isNotEmpty ||
                            _selectedMechanics.isNotEmpty ||
                            _selectedMoveCategory != null)
                          IconButton(
                              onPressed: _resetFilters,
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white54, size: 20)),
                        // Toggle Button
                        GestureDetector(
                          onTap: () => setState(
                              () => _isFilterExpanded = !_isFilterExpanded),
                          child: GlassContainer(
                            borderRadius: BorderRadius.circular(20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  _isFilterExpanded ? 'CLOSE' : 'FILTER',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  _isFilterExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.filter_list_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expanded Grid
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: Container(
                      height: _isFilterExpanded ? null : 0,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: Colors.white10),

                          // SECTION: OWNERSHIP
                          const SizedBox(height: 8),
                          _buildFilterSectionTitle('OWNERSHIP'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              GlassCapsule(
                                isSelected: _ownershipFilter ==
                                    TagOwnershipFilter.owned,
                                label: 'My Collection',
                                icon: Icons.check_circle_outline_rounded,
                                color: const Color(0xFF4CAF50),
                                onTap: () => setState(() => _ownershipFilter =
                                    _ownershipFilter == TagOwnershipFilter.owned
                                        ? TagOwnershipFilter.all
                                        : TagOwnershipFilter.owned),
                              ),
                              GlassCapsule(
                                isSelected: _ownershipFilter ==
                                    TagOwnershipFilter.missing,
                                label: 'Missing',
                                icon: Icons.cancel_outlined,
                                color: const Color(0xFFE57373),
                                onTap: () => setState(() => _ownershipFilter =
                                    _ownershipFilter ==
                                            TagOwnershipFilter.missing
                                        ? TagOwnershipFilter.all
                                        : TagOwnershipFilter.missing),
                              ),
                            ],
                          ),

                          // SECTION: MECHANICS
                          const SizedBox(height: 16),
                          _buildFilterSectionTitle('MECHANICS'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: Mechanic.values
                                .where((m) => m != Mechanic.none)
                                .map((m) {
                              final isSelected = _selectedMechanics.contains(m);
                              return GlassCapsule(
                                isSelected: isSelected,
                                label: m.displayName,
                                icon: Icons
                                    .bolt, // Use a generic bolt or specific icons if available
                                color: m.color,
                                onTap: () => setState(() {
                                  if (isSelected) {
                                    _selectedMechanics.remove(m);
                                  } else {
                                    _selectedMechanics.add(m);
                                  }
                                }),
                              );
                            }).toList(),
                          ),

                          // SECTION: MOVE CATEGORY
                          const SizedBox(height: 16),
                          _buildFilterSectionTitle('MOVE CATEGORY'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: MoveCategory.values.map((c) {
                              final isSelected = _selectedMoveCategory == c;
                              return GlassCapsule(
                                isSelected: isSelected,
                                label: c.displayName,
                                icon: c == MoveCategory.physical
                                    ? Icons.fitness_center
                                    : Icons.auto_awesome,
                                color: c.color,
                                onTap: () => setState(() {
                                  if (isSelected) {
                                    _selectedMoveCategory = null;
                                  } else {
                                    _selectedMoveCategory = c;
                                  }
                                }),
                              );
                            }).toList(),
                          ),

                          // SECTION: TYPES
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildFilterSectionTitle('POKEMON TYPES'),
                              if (_selectedTypes.isNotEmpty)
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedTypes.clear()),
                                  child: const Text(
                                    'Reset Types',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 10),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: TagType.values.map((type) {
                              final isSelected = _selectedTypes.contains(type);
                              return GlassCapsule(
                                isSelected: isSelected,
                                label: type.displayName,
                                iconWidget: TypeIcon(
                                    type: type, isSelected: isSelected),
                                color: type.color,
                                onTap: () => setState(() {
                                  if (isSelected) {
                                    _selectedTypes.remove(type);
                                  } else {
                                    _selectedTypes.add(type);
                                  }
                                }),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tag Grid (Expanded to fill remaining space)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable swipe to avoid conflict with horizontal scrolling
                children: [
                  _TagGrid(
                      version: 0,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter,
                      searchQuery: _searchController.text,
                      filterMechanics: _selectedMechanics,
                      filterMoveCategory: _selectedMoveCategory),
                  _TagGrid(
                      version: 4,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter,
                      searchQuery: _searchController.text,
                      filterMechanics: _selectedMechanics,
                      filterMoveCategory: _selectedMoveCategory),
                  _TagGrid(
                      version: 3,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter,
                      searchQuery: _searchController.text,
                      filterMechanics: _selectedMechanics,
                      filterMoveCategory: _selectedMoveCategory),
                  _TagGrid(
                      version: 2,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter,
                      searchQuery: _searchController.text,
                      filterMechanics: _selectedMechanics,
                      filterMoveCategory: _selectedMoveCategory),
                  _TagGrid(
                      version: 1,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter,
                      searchQuery: _searchController.text,
                      filterMechanics: _selectedMechanics,
                      filterMoveCategory: _selectedMoveCategory),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.white54,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0),
    );
  }
}

class _TagGrid extends ConsumerWidget {
  final int version;
  final Set<TagType> filterTypes;
  final TagOwnershipFilter ownershipFilter;
  final String searchQuery;
  final Set<Mechanic> filterMechanics;
  final MoveCategory? filterMoveCategory;

  const _TagGrid({
    required this.version,
    required this.filterTypes,
    required this.ownershipFilter,
    required this.searchQuery,
    required this.filterMechanics,
    required this.filterMoveCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch derived provider for reactivity
    final allTags = ref.watch(tagsByVersionProvider(version));

    // Apply Local Filters
    var tags = allTags;

    // Search Filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      tags = tags
          .where((t) =>
              t.pokemonName.toLowerCase().contains(query) ||
              t.id.toLowerCase().contains(query))
          .toList();
    }

    // Type Filter
    if (filterTypes.isNotEmpty) {
      tags = tags.where((t) => filterTypes.contains(t.type)).toList();
    }

    // Mechanic Filter
    if (filterMechanics.isNotEmpty) {
      tags = tags.where((t) => filterMechanics.contains(t.mechanic)).toList();
    }

    // Move Category Filter
    if (filterMoveCategory != null) {
      tags = tags.where((t) => t.moveCategory == filterMoveCategory).toList();
    }

    // Ownership Filter
    if (ownershipFilter == TagOwnershipFilter.owned) {
      tags = tags.where((t) => t.isOwned).toList();
    } else if (ownershipFilter == TagOwnershipFilter.missing) {
      tags = tags.where((t) => !t.isOwned).toList();
    }

    if (tags.isEmpty) {
      // Helper text for empty state
      String emptyText = 'No tags found';
      IconData icon = Icons.search_off_rounded;
      if (ownershipFilter == TagOwnershipFilter.owned) {
        emptyText = 'No owned tags found';
        icon = Icons.check_circle_outline_rounded;
      } else if (ownershipFilter == TagOwnershipFilter.missing) {
        emptyText = 'No missing tags found! Great job!';
        icon = Icons.cancel_outlined;
      } else if (filterTypes.isNotEmpty) {
        // Show up to 2 types in the message, or "X Selected Types"
        final typeNames =
            filterTypes.take(2).map((t) => t.displayName).join(", ");
        final suffix = filterTypes.length > 2 ? "..." : "";
        emptyText = 'No $typeNames$suffix tags found';
      }

      return EmptyStateView(
        icon: icon,
        title: emptyText,
        iconColor: Colors.white24,
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
            return _StaggeredSlideFade(
              index: index,
              child: _TagCard(tag: tags[index]),
            );
          },
        );
      },
    );
  }
}

class _StaggeredSlideFade extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredSlideFade({required this.index, required this.child});

  @override
  State<_StaggeredSlideFade> createState() => _StaggeredSlideFadeState();
}

class _StaggeredSlideFadeState extends State<_StaggeredSlideFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Staggered start
    final delay = Duration(milliseconds: (widget.index * 50).clamp(0, 1000));
    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}

class _TagCard extends ConsumerWidget {
  final TagModel tag;

  const _TagCard({required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => TagDetailsModal(tag: tag),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: tag.type.color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Gradient Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tag.type.color.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Pokemon Image
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: 'tag_image_${tag.id}',
                  child: Image.asset(
                    tag.imageUrl,
                    fit: BoxFit.contain,
                    color: tag.isOwned ? null : Colors.black.withOpacity(0.3),
                    colorBlendMode: tag.isOwned ? null : BlendMode.darken,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.white30),
                  ),
                ),
              ),
            ),
            // ID Badge
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Owned Indicator
            if (tag.isOwned)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50), // Green for owned
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
            // Version Badge
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Ver ${tag.version}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            // Type Icon & Mechanic Badge (Bottom Left)
            Positioned(
              bottom: 4,
              left: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TypeIcon(
                    type: tag.type,
                    size: 14,
                  ),
                  if (tag.mechanic != Mechanic.none) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: tag.mechanic.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: tag.mechanic.color.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      child: Text(
                        tag.mechanic.displayName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
