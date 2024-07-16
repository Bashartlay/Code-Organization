import '../services/post_service.dart';
import '../models/post_entity.dart';
import '../models/error_model.dart';
import 'package:either_dart/either.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call({Params params});
}

class GetPostsUseCase
    implements UseCase<Either<ErrorModel, List<PostEntity>>, void> {
  final PostRepository _postRepository;

  GetPostsUseCase({required PostRepository postRepository})
      : _postRepository = postRepository;

  @override
  Future<Either<ErrorModel, List<PostEntity>>> call({void params}) {
    return _postRepository.getPosts();
  }
}
