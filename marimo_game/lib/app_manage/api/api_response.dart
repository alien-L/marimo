
// api response status
enum ResponseStatus { none, loading ,completed , error }

class ApiResponse<T> {
  ResponseStatus? status;
  T? data;
  String? message;

  ApiResponse.loading(this.message) : status = ResponseStatus.loading;
  ApiResponse.completed(this.data) : status = ResponseStatus.completed;
  ApiResponse.error(this.message) : status = ResponseStatus.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
