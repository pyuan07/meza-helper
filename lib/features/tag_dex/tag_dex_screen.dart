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

  final Set<TagType> _selectedTypes = {};
  TagOwnershipFilter _ownershipFilter = TagOwnershipFilter.all;
  bool _isFilterExpanded = false;

  Widget _buildTypeIcon(TagType type, {bool isSelected = false}) {
    return SvgPicture.asset(
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
    );
  }

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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
            // Filters Section (Moved from AppBar, Accordion Style)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                // Much darker background when expanded for readability
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
                                if (_ownershipFilter != TagOwnershipFilter.all)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _buildGlassFilterCapsule(
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
                                ..._selectedTypes.map(
                                  (type) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _buildGlassFilterCapsule(
                                      isSelected: true,
                                      label: type.displayName,
                                      iconWidget: _buildTypeIcon(type,
                                          isSelected: true),
                                      color: type.color,
                                      onTap: () => setState(
                                          () => _selectedTypes.remove(type)),
                                    ),
                                  ),
                                ),
                                if (_ownershipFilter ==
                                        TagOwnershipFilter.all &&
                                    _selectedTypes.isEmpty &&
                                    !_isFilterExpanded)
                                  Text(
                                    'Showing All Tags',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Toggle Button
                        GestureDetector(
                          onTap: () => setState(
                              () => _isFilterExpanded = !_isFilterExpanded),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.1)),
                            ),
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
                          const SizedBox(height: 8),
                          // Ownership Section
                          const Text(
                            'OWNERSHIP',
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildGlassFilterCapsule(
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
                              _buildGlassFilterCapsule(
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
                          const SizedBox(height: 16),
                          // Types Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'POKEMON TYPES',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0),
                              ),
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
                              return _buildGlassFilterCapsule(
                                isSelected: isSelected,
                                label: type.displayName,
                                iconWidget: _buildTypeIcon(type,
                                    isSelected: isSelected),
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
                children: [
                  _TagGrid(
                      version: 0,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter),
                  _TagGrid(
                      version: 4,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter),
                  _TagGrid(
                      version: 3,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter),
                  _TagGrid(
                      version: 2,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter),
                  _TagGrid(
                      version: 1,
                      filterTypes: _selectedTypes,
                      ownershipFilter: _ownershipFilter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassFilterCapsule({
    required bool isSelected,
    required String label,
    IconData? icon,
    Widget? iconWidget,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withOpacity(0.8)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : Colors.white.withOpacity(0.1),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                  const SizedBox(width: 6),
                ] else if (iconWidget != null) ...[
                  iconWidget,
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TagGrid extends ConsumerWidget {
  final int version;
  final Set<TagType> filterTypes;
  final TagOwnershipFilter ownershipFilter;

  const _TagGrid({
    required this.version,
    required this.filterTypes,
    required this.ownershipFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch derived provider for reactivity
    final allTags = ref.watch(tagsByVersionProvider(version));

    // Apply Local Filters
    var tags = allTags;
    if (filterTypes.isNotEmpty) {
      tags = tags.where((t) => filterTypes.contains(t.type)).toList();
    }
    if (ownershipFilter == TagOwnershipFilter.owned) {
      tags = tags.where((t) => t.isOwned).toList();
    } else if (ownershipFilter == TagOwnershipFilter.missing) {
      tags = tags.where((t) => !t.isOwned).toList();
    }

    if (tags.isEmpty) {
      // Helper text for empty state
      String emptyText = 'No tags found';
      if (ownershipFilter == TagOwnershipFilter.owned) {
        emptyText = 'No owned tags found';
      } else if (ownershipFilter == TagOwnershipFilter.missing) {
        emptyText = 'No missing tags found! Great job!';
      } else if (filterTypes.isNotEmpty) {
        // Show up to 2 types in the message, or "X Selected Types"
        final typeNames =
            filterTypes.take(2).map((t) => t.displayName).join(", ");
        final suffix = filterTypes.length > 2 ? "..." : "";
        emptyText = 'No $typeNames$suffix tags found';
      }

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
              emptyText,
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

    _offset =
        Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Stagger based on index
    // Cap delay to prevent long waits on large lists
    final delay = (widget.index * 50).clamp(0, 1000);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
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
