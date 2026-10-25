
import 'package:flutter/material.dart';

// ============================================================
// PRODUCTS LIST VIEW - SMALL SCREENS
// ============================================================

class ProductsListView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function(int index) onFavoritePressed;
  final void Function(int index) onProductTap;

  const ProductsListView({
    super.key,
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductTile(
          name: products[index]['name'] as String,
          price: (products[index]['price'] as num).toDouble(),
          imagePath: products[index]['image'] as String,
          isFavorite: products[index]['favorite'] as bool,
          isGrid: false,
          onFavoritePressed: () {
            onFavoritePressed(index);
          },
          onTap: () {
            onProductTap(index);
          },
        );
      },
    );
  }
}

// ============================================================
// PRODUCTS GRID VIEW - LARGE SCREENS
// ============================================================

class ProductsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final void Function(int index) onFavoritePressed;
  final void Function(int index) onProductTap;

  const ProductsGridView({
    super.key,
    required this.products,
    required this.onFavoritePressed,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return ProductTile(
          name: products[index]['name'] as String,
          price: (products[index]['price'] as num).toDouble(),
          imagePath: products[index]['image'] as String,
          isFavorite: products[index]['favorite'] as bool,
          isGrid: true,
          onFavoritePressed: () {
            onFavoritePressed(index);
          },
          onTap: () {
            onProductTap(index);
          },
        );
      },
    );
  }
}

// ============================================================
// PRODUCT TILE
// ============================================================

class ProductTile extends StatelessWidget {
  final String name;
  final double price;
  final String imagePath;
  final bool isFavorite;
  final bool isGrid;
  final VoidCallback onFavoritePressed;
  final VoidCallback onTap;

  const ProductTile({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.isFavorite,
    required this.isGrid,
    required this.onFavoritePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: isGrid ? buildGridTile() : buildListTile(),
      ),
    );
  }

  // Product card used in GridView.
  Widget buildGridTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 6,
            right: 2,
            top: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                onPressed: onFavoritePressed,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 4,
            bottom: 8,
          ),
          child: Text(
            '${price.toStringAsFixed(2)} EGP',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.teal,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Product row used in ListView.
  Widget buildListTile() {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: double.infinity,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${price.toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onFavoritePressed,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

