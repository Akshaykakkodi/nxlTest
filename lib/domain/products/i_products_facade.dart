import 'package:dartz/dartz.dart';
import 'package:test/domain/core/failures.dart';
import 'package:test/domain/products/model/all_product_data_model.dart';

interface class IProductsFacade {
  Future<Either<MainFailure, AllProductsDataModel>> getProduct(int id) {
    throw UnimplementedError();
  }

  Future<Either<MainFailure, List<AllProductsDataModel>>> getAllProducts() {
    throw UnimplementedError();
  }
}
