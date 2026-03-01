class NetworkUrls {
  // Auth
  static String login() => 'auth/login';
  static String register() => 'auth/register';

  // Products
  static String listProducts() => 'products';
  static String getProductById(String id) => 'products/$id';
  static String suggestedProducts() => 'products/suggested';
  static String mostRatedProducts() => 'products/most-rated';
  static String similarProducts(String id) => 'products/$id/similar';
  static String addReview(String id) => 'products/$id/review';
  static String getReviews(String id) => 'products/$id/reviews';
  static String addToCart(String id) => 'products/$id/cart';
  static String getCart() => 'products/cart';
  static String searchProducts(String query) => 'products/search?q=$query';

  // Categories
  static String listCategories() => 'category';

  // Orders
  static String initiateOrder() => 'orders/initiate';
  static String confirmOrder(String id) => 'orders/confirm_order';
  static String trackOrder(String id) => 'orders/$id/trackOrder';
  static String getOrderDetails(String id) =>
      'orders/confirmation_order_details/$id';

  // User
  static String userProfile(String id) => 'auth/user/$id';
  static String getProfile() => 'profile';
  static String userAddresses() => 'user/addresses';
  static String getAddresses() => 'user/addresses';
  static String addAddress() => 'user/addresses';

  // Upload
  static String uploadImage() => 'upload/image';
}
