class CrudState {

  final bool isError;
  final String errMessage;
  final bool isSuccess;
  final bool isLoad;

  CrudState({
    required this.errMessage,
    required this.isError,
    required this.isLoad,
    required this.isSuccess
  });


  CrudState copyWith({
    bool? isError,
    String? errMessage,
    bool? isSuccess,
    bool? isLoad
  }) {
    return CrudState(
        errMessage: errMessage ?? this.errMessage,
        isError: isError ?? this.isError,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess
    );
  }
}