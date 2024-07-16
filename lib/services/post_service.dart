import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/error_model.dart';
import 'package:either_dart/either.dart';

class BaseService {
  final Dio dio;
  String baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  BaseService({required this.dio});
}

class PostService extends BaseService {
  PostService({required super.dio});

  Future<Response> getPosts() async {
    return await dio.get(baseUrl);
  }
}

abstract class PostRepository {
  Future<Either<ErrorModel, List<PostModel>>> getPosts();
}

class PostRepositoryImpl implements PostRepository {
  final PostService _postService;

  PostRepositoryImpl({required PostService postService})
      : _postService = postService;

  @override
  Future<Either<ErrorModel, List<PostModel>>> getPosts() async {
    try {
      final response = await _postService.getPosts();
      if (response.statusCode == 200) {
        List<PostModel> posts = List.generate(
          response.data.length,
          (index) => PostModel.fromMap(
            response.data[index],
          ),
        );
        return Right(posts);
      } else {
        return Left(
          ErrorModel(
            errorMessage: response.statusMessage.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        ErrorModel(
          errorMessage: e.message.toString(),
        ),
      );
    }
  }
}
