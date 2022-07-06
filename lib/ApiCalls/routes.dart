class Routes {
  String baseUrl =
      "http://127.0.0.1:5000"; //"http://makeup-api-backend-flask.herokuapp.com";

  String login = "/login";
  String signup = "/signup";

  String getAllProducts = "/products";
  String getProductById = "/products/{id}";
  String getProductsByCategory = "/products/{category}/{value}";

  //Transactions
  String getAllTransactions = "/transactions";
  String getTransactionById = "/transactions/{id}";
  String updateTransaction = "/transactions/update";
  String addTransaction = "/transactions/add";
  String deleteTransactionById = "/transactions/delete";
}
