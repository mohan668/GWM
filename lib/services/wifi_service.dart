// services/wifi_service.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uicomponentsforgwm/models/water_entry.dart';

class WaterService {
  static const String baseUrl = "http://192.168.43.44:8000"; // change if needed

  /// Upload a new entry to FastAPI
  static Future<void> uploadEntryData(Map<String, dynamic> data, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/upload_water_data"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data uploaded successfully")),
        );
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// Fetch all entries from FastAPI
  static Future<List<WaterEntry>> fetchEntryData() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_water_data"));
      if (response.statusCode == 200) {
        final List decoded = jsonDecode(response.body);
        return decoded.map((e) => WaterEntry.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  /// Delete an entry using well_id and date
  static Future<void> deleteEntry(String wellId, String date) async {
    final url = "$baseUrl/delete_water_data?well_id=$wellId&date=$date";
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Delete failed: ${response.statusCode}");
    }
  }

  /// Update an existing entry (if supported by backend)
  static Future<void> updateEntry(WaterEntry updatedEntry) async {
    final response = await http.put(
      Uri.parse("$baseUrl/update_water_data"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedEntry.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Update failed: ${response.statusCode}");
    }
  }
}
