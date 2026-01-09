import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/tags_tower_data.dart';
import 'data/tag_repository.dart';
import '../../models/tag_model.dart';
import 'widgets/tag_details_modal.dart';

class TagsTowerScreen extends StatefulWidget {
  const TagsTowerScreen({super.key});

  @override
  State<TagsTowerScreen> createState() => _TagsTowerScreenState();
}

class _TagsTowerScreenState extends State<TagsTowerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 4 Versions: 4, 3, 2, 1
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Tags Tower',
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
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                Tab(text: 'Ver 4'),
                Tab(text: 'Ver 3'),
                Tab(text: 'Ver 2'),
                Tab(text: 'Ver 1'),
              ],
            ),
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
            _VersionView(version: 4),
            _VersionView(version: 3),
            _VersionView(version: 2),
            _VersionView(version: 1),
          ],
        ),
      ),
    );
  }
}

class _VersionView extends StatelessWidget {
  final int version;

  const _VersionView({required this.version});

  @override
  Widget build(BuildContext context) {
    final towers = TagsTowerData.towers[version] ?? [];

    if (towers.isEmpty) {
      return Center(
        child: Text(
          'No data for Version $version',
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Mezastar 星座 第$version彈',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.blueAccent.withOpacity(0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(towers.length, (index) {
                      return _TowerColumn(
                        towerNumber: index + 1,
                        pokemons: towers[index],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TowerColumn extends StatelessWidget {
  final int towerNumber;
  final List<String> pokemons;

  const _TowerColumn({
    required this.towerNumber,
    required this.pokemons,
  });

  @override
  Widget build(BuildContext context) {
    // Convert IDs to TagModels
    final tagModels =
        pokemons.map((id) => TagRepository.getTagById(id)).toList();

    return Container(
      width: 170, // Increased width
      margin:
          const EdgeInsets.only(right: 12, bottom: 16), // Reduced right margin
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20), // Slightly reduced radius
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tower Header
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 8), // Reduced vertical padding
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28, // Slightly smaller header circle
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CA1AF), Color(0xFF2C3E50)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$towerNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.all(4.0), // Reduced header-to-content padding
            child: Column(
              children: tagModels.map((tag) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 4.0), // Minimal bottom padding between cards
                  child: _PokemonCard(tag: tag),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  final TagModel tag;

  const _PokemonCard({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 2), // Very tight padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tag.type.color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Pokemon Image
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => TagDetailsModal(tag: tag),
              );
            },
            child: Container(
              padding: EdgeInsets.zero, // No padding for image container
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                tag.imageUrl,
                width: 140, // Maximized Image Size
                height: 140,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.catching_pokemon,
                    color: Colors.white70,
                    size: 60,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 2), // Minimal spacing text-image
          Text(
            tag.pokemonName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12, // Compact text
              fontWeight: FontWeight.w600,
              height: 1.0, // Tighter line height
            ),
            maxLines: 1, // Force single line if possible or allow 2 very tight
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
