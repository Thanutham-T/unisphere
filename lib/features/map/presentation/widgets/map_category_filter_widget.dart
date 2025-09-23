import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';

class MapCategoryFilter extends StatelessWidget {
  const MapCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip(
                context,
                'ทั้งหมด',
                Icons.apps,
                'all',
                state is MapLoaded ? state.selectedCategory == null : true,
              ),
              _buildCategoryChip(
                context,
                'ห้องสมุด',
                Icons.local_library,
                'library',
                state is MapLoaded ? state.selectedCategory == 'library' : false,
              ),
              _buildCategoryChip(
                context,
                'อาคาร',
                Icons.business,
                'building',
                state is MapLoaded ? state.selectedCategory == 'building' : false,
              ),
              _buildCategoryChip(
                context,
                'ร้านอาหาร',
                Icons.restaurant,
                'restaurant',
                state is MapLoaded ? state.selectedCategory == 'restaurant' : false,
              ),
              _buildCategoryChip(
                context,
                'กีฬา',
                Icons.sports_soccer,
                'sport',
                state is MapLoaded ? state.selectedCategory == 'sport' : false,
              ),
              _buildCategoryChip(
                context,
                'หอพัก',
                Icons.hotel,
                'dormitory',
                state is MapLoaded ? state.selectedCategory == 'dormitory' : false,
              ),
              _buildCategoryChip(
                context,
                'รายการโปรด',
                Icons.favorite,
                'favorites',
                state is MapLoaded ? state.selectedCategory == 'favorites' : false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    IconData icon,
    String category,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        avatar: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (category == 'all') {
            context.read<MapBloc>().add(LoadAllPlaces());
          } else if (category == 'favorites') {
            context.read<MapBloc>().add(LoadFavoritePlaces());
          } else {
            context.read<MapBloc>().add(FilterPlacesByCategory(category));
          }
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: 1,
        ),
        elevation: isSelected ? 4 : 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
    );
  }
}