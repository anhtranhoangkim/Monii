class ApiConfig {
  static const String baseUrl = "http://10.0.2.2:8080";

  // Auth
  static const String registerEndpoint = "/auth/register";
  static const String loginEndpoint = "/auth/login";
  static const String logoutEndpoint = "/auth/logout";

  // User
  static const String userProfileEndpoint = "/user/profile";
  static const String userLanguageEndpoint = "/user/language";
  static const String userCurrencyEndpoint = "/user/currency";

  // Categories
  static const String categoriesEndpoint = "/api/categories";

  // Transactions
  static const String transactionsEndpoint = "/api/transactions";

  // Budgets
  static const String budgetsEndpoint = "/api/budgets";

  // Analytics
  static const String totalByTypeEndpoint = "/api/analytics/total-by-type";
  static const String totalBalanceEndpoint = "/api/analytics/total-balance";
  static const String totalByCategoryEndpoint = "/api/analytics/total-by-category";
  static const String monthTrendsEndpoint = "/api/analytics/month-trends";
}
