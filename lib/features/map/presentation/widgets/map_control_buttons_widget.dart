import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';

class MapControlButtons extends StatelessWidget {
  const MapControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: 100,
      child: Column(
        children: [
          // Current Location Button
          FloatingActionButton(
            mini: true,
            heroTag: "location",
            onPressed: () {
              context.read<MapBloc>().add(GetCurrentLocation());
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 8),
          
          // Map Type Button (for future use)
          FloatingActionButton(
            mini: true,
            heroTag: "mapType",
            onPressed: () {
              // Toggle map type (satellite/normal) - implementation later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Map type toggle - Coming soon')),
              );
            },
            child: const Icon(Icons.layers),
          ),
          const SizedBox(height: 8),
          
          // Zoom In Button
          FloatingActionButton(
            mini: true,
            heroTag: "zoomIn",
            onPressed: () {
              // Zoom in functionality - will be implemented with map controller
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Zoom in')),
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 4),
          
          // Zoom Out Button
          FloatingActionButton(
            mini: true,
            heroTag: "zoomOut",
            onPressed: () {
              // Zoom out functionality - will be implemented with map controller
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Zoom out')),
              );
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}