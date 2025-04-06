import 'package:flutter/material.dart';
import 'package:sae_mobile/models/cuisine.dart';
import 'package:sae_mobile/models/resto.dart';
import 'package:sae_mobile/services/cuisine_service.dart';
import 'package:sae_mobile/services/resto_service.dart';
import 'package:sae_mobile/UI/detail_screen_resto.dart';
import 'package:sae_mobile/config/utils.dart';

class RestoView extends StatefulWidget {
  const RestoView({super.key});

  @override
  State<RestoView> createState() => _RestoViewState();
}

class _RestoViewState extends State<RestoView> {
  final CuisineService _cuisineService = CuisineService();
  final RestoService _restoService = RestoService();
  final TextEditingController _searchController = TextEditingController();

  List<Cuisine> _allCuisines = [];
  List<Cuisine> _selectedCuisines = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _loadData() async {
    try {
      _allCuisines = await _cuisineService.getCuisines();
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Erreur chargement cuisines: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre de recherche
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un restaurant...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),

        // Filtres par cuisine
        ExpansionTile(
          title: Row(
            children: [
              const Icon(Icons.restaurant, size: 20),
              const SizedBox(width: 8),
              Text(
                'Types de cuisine (${_selectedCuisines.length} sélectionnés)',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          initiallyExpanded: false,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allCuisines.map((cuisine) {
                    final isSelected = _selectedCuisines.contains(cuisine);
                    return FilterChip(
                      label: Text(cuisine.nameC),
                      selected: isSelected,
                      selectedColor: Colors.orange.withOpacity(0.2),
                      checkmarkColor: Colors.orange,
                      onSelected: (selected) => _toggleCuisine(cuisine, selected),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),

        // Liste des restaurants
        Expanded(
          child: _buildRestoList(),
        ),
      ],
    );
  }

  void _toggleCuisine(Cuisine cuisine, bool selected) {
    setState(() {
      if (selected) {
        _selectedCuisines.add(cuisine);
      } else {
        _selectedCuisines.remove(cuisine);
      }
    });
  }

  Widget _buildRestoList() {
    return FutureBuilder<List<Resto>>(
      future: _restoService.getRestosWithCuisines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun restaurant trouvé'));
        }

        final filteredRestos = _applyFilters(snapshot.data!);

        if (filteredRestos.isEmpty) {
          return const Center(child: Text('Aucun résultat pour ces filtres'));
        }

        return ListView.builder(
          itemCount: filteredRestos.length,
          itemBuilder: (context, index) => _resto2widget(filteredRestos[index], context),
        );
      },
    );
  }

  List<Resto> _applyFilters(List<Resto> restos) {
    // Filtre par cuisine
    if (_selectedCuisines.isNotEmpty) {
      restos = restos.where((resto) {
        return resto.cuisines?.any((cuisine) =>
            _selectedCuisines.any((c) => c.idC == cuisine.idC)
        ) ?? false;
      }).toList();
    }

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      restos = restos.where((resto) =>
          resto.name.toLowerCase().contains(_searchQuery)
      ).toList();
    }

    return restos;
  }

  Widget _resto2widget(Resto resto, BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreenResto(resto: resto),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    resto.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (resto.type != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: type2color(resto.type),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        resto.type!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (resto.commune != null)
                Text(
                  '📍 ${resto.commune}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              const SizedBox(height: 8),
              if (resto.cuisines != null && resto.cuisines!.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: resto.cuisines!
                      .map((cuisine) => Chip(
                    label: Text(
                      cuisine.nameC,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.orange.shade50,
                    visualDensity: VisualDensity.compact,
                  ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}