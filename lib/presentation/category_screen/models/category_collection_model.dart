import 'package:flutter/material.dart';

class CategoryCollectionModel {
  final String title;
  final String imagePath;
  final Color color;
  final double price;
  final int itemCount;

  CategoryCollectionModel({
    required this.title,
    required this.imagePath,
    required this.color,
    required this.price,
    required this.itemCount,
  });
}
