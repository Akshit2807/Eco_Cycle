import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';

class marketplaceView {
  Container buildProductCard({required ProductItem product}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (buildContext, widget, imageChunkEvent) {
              if (imageChunkEvent == null) {
                return widget; // Return the actual image when it's loaded
              }
              return CircularProgressIndicator(
                color: AppColors.lightGreen,
                value: imageChunkEvent.expectedTotalBytes != null
                    ? imageChunkEvent.cumulativeBytesLoaded /
                        imageChunkEvent.expectedTotalBytes!
                    : null,
              );
            },
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Price: Rs. ${product.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem {
  final String imageUrl;
  final int price;
  final String title;

  ProductItem({
    required this.imageUrl,
    required this.price,
    required this.title,
  });
}
