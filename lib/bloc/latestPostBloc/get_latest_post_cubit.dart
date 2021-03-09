import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/postModel/post_model.dart';
import '../../repository/wp_repository.dart';

part 'get_latest_post_state.dart';

class GetLatestPostCubit extends Cubit<GetLatestPostState> {
  final WpRepsitory wp;

  GetLatestPostCubit(this.wp) : super(GetLatestPostInitial()) {
    getLatestPost(1);
  }

  List<PostModel> postList = [];

  List<PostModel> filterPostList = [];

  List<PostModel> searchList = [];

  void addPostToList(List<PostModel> _postList) {
    postList.addAll(_postList);
  }

  List<PostModel> getAllPost() {
    return [...postList];
  }

  void addFilterPost(List<PostModel> _postList) {
    filterPostList.addAll(_postList);
  }

  List<PostModel> getAllFilterPost() {
    return [...filterPostList];
  }


  void addSearchList(List<PostModel> _postList) {
    searchList.addAll(_postList);
  }

  List<PostModel> getAllSearchList() {
    return [...searchList];
  }

  void searchPost(String searchText, int page) {
    if (page == 1) searchList.clear();
    emit(GetLatestPostLoading());
    wp.searchPost(searchText, page).then((value) {
      addSearchList(value);
      emit(GetLatestPostSuccess(value));
    }).catchError((e) {
      if (page == 1)
        emit(GetLatestPostFail(e.toString()));
      else
        emit(GetLatestPostSuccess([]));
    });
  }

  void getLatestPost(int page) {
    emit(GetLatestPostLoading());
    wp.getLatestPost(page).then((value) {
      addPostToList(value);
      emit(GetLatestPostSuccess(value));
    }).catchError((e) {
      if (page == 1)
        emit(GetLatestPostFail(e.toString()));
      else {
        emit(GetLatestPostSuccess([]));
      }
    });
  }

  void getPostByCategory(int id, int page) {
    if (page == 1) filterPostList.clear();
    emit(GetLatestPostLoading());
    wp.getPostByCategory(id, page).then((value) {
      addFilterPost(value);
      emit(GetLatestPostSuccess(value));
    }).catchError((e) {
      if (page == 1)
        emit(GetLatestPostFail(e.toString()));
      else
        emit(GetLatestPostSuccess([]));
    });
  }
}
