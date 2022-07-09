class Routes {
  String baseUrl =
      "https://makeup-api-backend-flask.herokuapp.com"; //"http://makeup-api-backend-flask.herokuapp.com";

  String login = "/login";
  String signup = "/signup";
  String updateProfile = "/user/update";

  String getAllProducts = "/products";
  String getProductById = "/products/{id}";
  String getProductsByCategory = "/products/{category}/{value}";

  //Transactions
  String getAllTransactions = "/transactions";
  String getTransactionById = "/transactions/{id}";
  String updateTransaction = "/transactions/update";
  String addTransaction = "/transactions/add";
  String deleteTransactionById = "/transactions/delete";
  String getTransactionByType = "/transactions/{type}";
}
