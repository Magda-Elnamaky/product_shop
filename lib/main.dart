
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'product_widgets.dart';

/*
============================================================
PART 1 - LIFECYCLE QUESTIONS
============================================================

1. Which methods are called when a page opens for the first time?

   initState(), didChangeDependencies(), and build().

2. Which method runs again after pressing the heart button?

   setState() triggers a rebuild, so build() runs again.

3. Which methods run when leaving a page?

   deactivate() runs when the widget is removed from the tree.
   dispose() runs when the State object is permanently removed.

4. Which methods run when resizing the browser, and why?

   didChangeDependencies() and build() can run again because
   MediaQuery provides information about the screen size.
*/

/*
============================================================
PART 4 - SHORT ANSWERS
============================================================

1. What is the difference between context.go and context.push?

   context.go navigates to a new location in the router.

   Example:
   context.goNamed('products');

   context.push adds a new page on top of the current page.

   Example:
   context.pushNamed<String>(
     'details',
     pathParameters: {
       'name': 'Laptop',
       'price': '15000.0',
     },
   );

2. Why did we use go for Login -> Products and push for
   Products -> Details?

   We use go for Login -> Products because we want to navigate
   to the Products location.

   We use push for Products -> Details because we want to open
   Details on top of Products and return to Products afterward.

3. What is the difference between a path parameter and a
   query parameter?

   A path parameter is part of the URL path.

   Example:
   /details/Laptop/15000.0

   A query parameter is written after ? in the URL.

   Example:
   /products?user=Guest
*/

// ============================================================
// GO_ROUTER CONFIGURATION
// ============================================================

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final username =
            state.uri.queryParameters['user'] ?? 'Guest';

        return ProductsPage(username: username);
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        final name = state.pathParameters['name']!;

        final price = double.parse(
          state.pathParameters['price']!,
        );

        return ProductDetailsPage(
          name: name,
          price: price,
        );
      },
    ),
  ],
);

// ============================================================
// MAIN APP
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    print('LoginPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('LoginPage: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    print('LoginPage: build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shopping_bag,
                  size: 90,
                  color: Colors.teal,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final enteredUsername =
                          usernameController.text.trim();

                      final username = enteredUsername.isEmpty
                          ? 'Guest'
                          : enteredUsername;

                      /*
                      PART 2 - NAVIGATOR IMPLEMENTATION

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsPage(
                            username: username,
                          ),
                        ),
                      );
                      */

                      // PART 3 - GO_ROUTER IMPLEMENTATION
                      context.goNamed(
                        'products',
                        queryParameters: {
                          'user': username,
                        },
                      );
                    },
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print('LoginPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    usernameController.dispose();

    print('LoginPage: dispose');
    super.dispose();
  }
}

// ============================================================
// PRODUCTS PAGE
// ============================================================

class ProductsPage extends StatefulWidget {
  final String username;

  const ProductsPage({
    super.key,
    required this.username,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int favoritesCount = 0;

  double screenWidth = 0;
  double screenHeight = 0;

  String cartMessage = '';

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Laptop',
      'price': 15000.0,
      'favorite': false,
      'image': 'assets/images/laptop.jpg',
    },
    {
      'name': 'Phone',
      'price': 10000.0,
      'favorite': false,
      'image': 'assets/images/phone.jpg',
    },
    {
      'name': 'Headphones',
      'price': 1200.0,
      'favorite': false,
      'image': 'assets/images/headphones.jpg',
    },
    {
      'name': 'Keyboard',
      'price': 800.0,
      'favorite': false,
      'image': 'assets/images/keyboard.jpg',
    },
    {
      'name': 'Mouse',
      'price': 400.0,
      'favorite': false,
      'image': 'assets/images/mouse.jpg',
    },
    {
      'name': 'Monitor',
      'price': 5000.0,
      'favorite': false,
      'image': 'assets/images/monitor.jpg',
    },
    {
      'name': 'Tablet',
      'price': 7000.0,
      'favorite': false,
      'image': 'assets/images/tablet.jpg',
    },
    {
      'name': 'Smart Watch',
      'price': 2500.0,
      'favorite': false,
      'image': 'assets/images/smart_watch.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    print('ProductsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final size = MediaQuery.sizeOf(context);

    screenWidth = size.width;
    screenHeight = size.height;

    print(
      'ProductsPage: didChangeDependencies -> '
      'width: ${size.width}, height: ${size.height}',
    );
  }

  // Update the favorite status and counter.
  void toggleFavorite(int index) {
    setState(() {
      final bool isFavorite =
          products[index]['favorite'] as bool;

      products[index]['favorite'] = !isFavorite;

      if (!isFavorite) {
        favoritesCount++;
      } else {
        favoritesCount--;
      }
    });
  }

  // Open details and receive the result.
  Future<void> openProductDetails(int index) async {
    final product = products[index];

    /*
    PART 2 - NAVIGATOR IMPLEMENTATION

    final String? result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
          name: product['name'] as String,
          price: (product['price'] as num).toDouble(),
        ),
      ),
    );
    */

    // PART 3 - GO_ROUTER IMPLEMENTATION
    final String? result = await context.pushNamed<String>(
      'details',
      pathParameters: {
        'name': product['name'] as String,
        'price': (product['price'] as num).toString(),
      },
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        cartMessage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ProductsPage: build');

    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Products - ${widget.username}'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Welcome, ${widget.username}!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Favorites counter required by the assignment.
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Favorites: $favoritesCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Text(
            'Screen width: ${screenWidth.toStringAsFixed(0)}',
          ),

          if (cartMessage.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                cartMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          Expanded(
            child: isSmallScreen
                ? ProductsListView(
                    products: products,
                    onFavoritePressed: toggleFavorite,
                    onProductTap: openProductDetails,
                  )
                : ProductsGridView(
                    products: products,
                    onFavoritePressed: toggleFavorite,
                    onProductTap: openProductDetails,
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    print('ProductsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('ProductsPage: dispose');
    super.dispose();
  }
}

// ============================================================
// PRODUCT DETAILS PAGE
// ============================================================

class ProductDetailsPage extends StatefulWidget {
  final String name;
  final double price;

  const ProductDetailsPage({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState
    extends State<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    print('ProductDetailsPage: initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('ProductDetailsPage: didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    print('ProductDetailsPage: build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_bag,
                size: 100,
                color: Colors.teal,
              ),
              const SizedBox(height: 20),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Price: ${widget.price.toStringAsFixed(2)} EGP',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  /*
                  PART 2 - NAVIGATOR IMPLEMENTATION

                  Navigator.pop<String>(
                    context,
                    '${widget.name} added to cart',
                  );
                  */

                  // PART 3 - GO_ROUTER IMPLEMENTATION
                  context.pop<String>(
                    '${widget.name} added to cart',
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print('ProductDetailsPage: deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('ProductDetailsPage: dispose');
    super.dispose();
  }
}

