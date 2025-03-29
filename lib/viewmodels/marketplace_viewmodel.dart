import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_waste/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';

class marketplaceView {
  Widget card({required ProductItem product, required BuildContext context}) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  value: progress.progress,
                  color: Theme.of(context).textTheme.labelLarge!.color,
                ),
              ),
            ),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
            fit: BoxFit.cover,
            imageUrl: product.imageUrl,
            imageBuilder: (context, imageProvider) {
              return Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CustomText(
                              textName: product.title,
                              softWrap: true,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              textColor: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: CustomText(
                              textName: "Rs.${product.price.toString()}",
                              softWrap: true,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              textColor: Colors.black.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

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
