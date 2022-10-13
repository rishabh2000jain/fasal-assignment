class ApiResponseWrapper<T> {
  T? responseData;
  Exception? error;
  String? displayMessage;
  set apiResponse(T data) {
    responseData = data;
  }

  set apiError(Exception error) {
    this.error = error;
  }
  T? get data => responseData;
  bool get hasData => data != null;
  bool get hasError => error != null;
}
