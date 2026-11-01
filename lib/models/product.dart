import 'package:flutter/material.dart';
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  final IconData icon;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.icon,
  });
}