import 'package:flutter_bloc/flutter_bloc.dart';
import '../usecases/get_posts_usecase.dart';
import '../models/post_entity.dart';
import '../models/error_model.dart';

sealed class PostState {}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostSuccess extends PostState {
  final List<PostEntity> posts;

  PostSuccess({required this.posts});
}

final class PostError extends PostState {
  final String errorMessage;

  PostError({required this.errorMessage});
}

sealed class PostEvent {}

final class GetPosts extends PostEvent {}

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase _getPostsUseCase;

  PostBloc(this._getPostsUseCase) : super(PostInitial()) {
    on<GetPosts>(
      (event, emit) async {
        emit(PostLoading());
        final result = await _getPostsUseCase.call();

        result.fold((error) {
          emit(PostError(errorMessage: error.errorMessage));
        }, (posts) {
          emit(
            PostSuccess(
              posts: posts,
            ),
          );
        });
      },
    );
  }
}
