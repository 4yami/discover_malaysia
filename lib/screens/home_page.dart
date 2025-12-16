import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/destination_repository.dart';
import 'site_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _destinationRepo = DestinationRepository();
  final _searchController = TextEditingController();
  
  DestinationCategory? _selectedCategory;
  String _searchQuery = '';

  List<Destination> get _filteredDestinations {
    var destinations = _destinationRepo.getAllDestinations();
    
    // Filter by category
    if (_selectedCategory != null) {
      destinations = destinations
          .where((d) => d.category == _selectedCategory)
          .toList();
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      destinations = _destinationRepo.search(_searchQuery);
      if (_selectedCategory != null) {
        destinations = destinations
            .where((d) => d.category == _selectedCategory)
            .toList();
      }
    }
    
    return destinations;
  }

  List<Destination> get _featuredDestinations => 
      _destinationRepo.getFeatured(limit: 1);

  List<Destination> get _nearbyDestinations =>
      _destinationRepo.getNearby(limit: 5);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.map, size: 32),
        ),
        title: const Text('Discover Malaysia'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, size: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search Malaysia Wonders',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Category chips
              _buildCategoryChips(),
              const SizedBox(height: 16),
              
              // Show filtered results if searching or category selected
              if (_searchQuery.isNotEmpty || _selectedCategory != null) ...[
                Text(
                  _selectedCategory != null 
                      ? _getCategoryTitle(_selectedCategory!)
                      : 'Search Results',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildDestinationList(_filteredDestinations),
              ] else ...[
                // Default view: Featured + Nearby
                const Text(
                  'Featured for you',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (_featuredDestinations.isNotEmpty)
                  _buildFeaturedCard(_featuredDestinations.first),
                const SizedBox(height: 24),
                const Text(
                  'Nearby Cultural Sites',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildNearbySites(_nearbyDestinations),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip(null, 'All', Icons.apps),
          const SizedBox(width: 8),
          _buildCategoryChip(DestinationCategory.sites, 'Sites', Icons.location_city),
          const SizedBox(width: 8),
          _buildCategoryChip(DestinationCategory.events, 'Events', Icons.event),
          const SizedBox(width: 8),
          _buildCategoryChip(DestinationCategory.packages, 'Packages', Icons.card_giftcard),
          const SizedBox(width: 8),
          _buildCategoryChip(DestinationCategory.food, 'Food', Icons.restaurant),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(DestinationCategory? category, String label, IconData icon) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: Colors.blue,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
    );
  }

  String _getCategoryTitle(DestinationCategory category) {
    switch (category) {
      case DestinationCategory.sites:
        return 'Cultural Sites';
      case DestinationCategory.events:
        return 'Events';
      case DestinationCategory.packages:
        return 'Packages';
      case DestinationCategory.food:
        return 'Food & Dining';
    }
  }

  Widget _buildDestinationList(List<Destination> destinations) {
    if (destinations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No destinations found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: destinations.map((d) => _buildSiteCard(d)).toList(),
    );
  }

  Widget _buildFeaturedCard(Destination destination) {
    return GestureDetector(
      onTap: () => _navigateToDetails(destination),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    destination.images.isNotEmpty 
                        ? destination.images.first 
                        : 'assets/images/placeholder.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
                color: Colors.grey[300],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              destination.shortDescription,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          destination.displayPrice,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            destination.displayDistance,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            destination.rating.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbySites(List<Destination> destinations) {
    return Column(
      children: destinations.map((d) => _buildSiteCard(d)).toList(),
    );
  }

  Widget _buildSiteCard(Destination destination) {
    return GestureDetector(
      onTap: () => _navigateToDetails(destination),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        destination.images.isNotEmpty 
                            ? destination.images.first 
                            : 'assets/images/placeholder.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey[300],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destination.shortDescription,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              destination.displayDistance,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  destination.displayPrice,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(
                    destination.rating.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(Destination destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SiteDetailsPage(destination: destination),
      ),
    );
  }
}
