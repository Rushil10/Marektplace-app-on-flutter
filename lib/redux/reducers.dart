import 'package:grocy/redux/actions.dart';
import 'package:grocy/redux/model.dart';

AppState appStateReducer(AppState state,action) {
  return AppState(
    products: productsReducer(state.products,action),
  );
}

List<dynamic> productsReducer(List<dynamic> state,action) {
  print("Hi");
  print(state);
  if(action is AddProductAction) {
    print(action.id);
    print(action.num);
    print("Product Details ");
    print(action.productsData);
    return action.productsData;
  }
  return state;
}