import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  // Obtener lista de Pokémon
  static Future<List<Pokemon>> getPokemonList({int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pokemon?limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        // Obtener detalles de cada Pokémon
        List<Pokemon> pokemons = [];
        for (var result in results) {
          final pokemon = await getPokemonDetails(result['name']);
          if (pokemon != null) {
            pokemons.add(pokemon);
          }
        }

        return pokemons;
      } else {
        throw Exception('Error al cargar la lista de Pokémon');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener detalles de un Pokémon específico
  static Future<Pokemon?> getPokemonDetails(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pokemon/$name'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Pokemon.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
} 