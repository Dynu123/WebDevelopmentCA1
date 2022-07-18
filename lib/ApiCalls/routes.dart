class Routes {
  String baseUrl = "http://127.0.0.1:5000";
      //"https://finmanager-api-backend-flask.herokuapp.com";

  String login = "/login";
  String signup = "/signup";
  String updateProfile = "/user/update";

  //Transactions
  String getAllTransactions = "/transactions";
  String getTransactionById = "/transactions/{id}";
  String updateTransaction = "/transactions/update";
  String addTransaction = "/transactions/add";
  String deleteTransactionById = "/transactions/delete/{id}";
  String getTransactionByType = "/transactions/{type}";
}
