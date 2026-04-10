import 'package:flutter/material.dart';

class CategoryCollectionModel {
  final int id;
  final String title;
  final String imagePath;
  final Color color;
  final double price;
  final int itemCount;

  CategoryCollectionModel({
    this.id = 0,
    required this.title,
    required this.imagePath,
    required this.color,
    required this.price,
    required this.itemCount,
  });
}
