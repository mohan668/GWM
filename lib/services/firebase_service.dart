import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/water_entry.dart';

class FirebaseService {
  static final _collection = FirebaseFirestore.instance.collection('water_entries');

  /// Upload or update an entry to Firestore
  static Future<void> uploadEntryData(Map<String, dynamic> data, BuildContext context) async {
    try {
      final wellId = data['well_id'];
      final date = data['date'];

      final query = await _collection
          .where('well_id', isEqualTo: wellId)
          .where('date', isEqualTo: date)
          .get();

      if (query.docs.isNotEmpty) {
        // Update existing entry
        await _collection.doc(query.docs.first.id).update(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data updated successfully")),
        );
      } else {
        // Create new entry
        await _collection.add(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data uploaded successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// Fetch all entries from Firestore
  static Future<List<WaterEntry>> fetchEntryData() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return WaterEntry.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch data: $e");
    }
  }

  /// Delete an entry using well_id and date
  static Future<void> deleteEntry(String wellId, String date) async {
    try {
      final query = await _collection
          .where('well_id', isEqualTo: wellId)
          .where('date', isEqualTo: date)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('No matching entry found');
      }

      await _collection.doc(query.docs.first.id).delete();
    } catch (e) {
      throw Exception('Failed to delete entry: $e');
    }
  }

  /// Update an entry with a full WaterEntry object
  static Future<void> updateEntry(WaterEntry updatedEntry) async {
    try {
      final query = await _collection
          .where('well_id', isEqualTo: updatedEntry.wellId)
          .where('date', isEqualTo: updatedEntry.date)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('No matching entry found to update');
      }

      await _collection.doc(query.docs.first.id).update(updatedEntry.toJson());
    } catch (e) {
      throw Exception('Failed to update entry: $e');
    }
  }
}
