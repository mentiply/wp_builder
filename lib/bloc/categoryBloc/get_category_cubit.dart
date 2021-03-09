import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/categoryModel/category_model.dart';
import '../../repository/wp_repository.dart';

part 'get_category_state.dart';

class GetCategoryCubit extends Cubit<GetCategoryState> {
  final WpRepsitory _wp;
  GetCategoryCubit(this._wp) : super(GetCategoryInitial()){
    getCategory(1);
  }

  List<CategoryModel> _categoryList= [];

  void addCategoryToList(List<CategoryModel> _cat){
    _categoryList.addAll(_cat);
  }

  List<CategoryModel> getAllCategory(){
    return [..._categoryList];
  }

  void getCategory(int page){
    emit(GetCategoryLoading());
    _wp.getCategory(page)
    .then((value) {
      addCategoryToList(value);
      emit(GetCategorySuccess(value));})
    .catchError((e) {
      if(page == 1) emit(GetCategoryFail(e.toString()));
      else emit(GetCategorySuccess([]));
    });
  }
}
