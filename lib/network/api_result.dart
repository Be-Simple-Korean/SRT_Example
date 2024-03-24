enum Status { success, error }

class ApiResult<T> {
  Status status;
  T? data;
  String? message;

  ApiResult.success(this.data) : status = Status.success;
  ApiResult.error(this.message) : status = Status.error;
}
