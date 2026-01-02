import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:test/domain/core/dio_client.dart';
import 'package:test/domain/core/failures.dart';
import 'package:test/domain/products/model/all_product_data_model.dart';

@lazySingleton
class GetProductDetailsUsecase {
  final DioClient dioClient;

  GetProductDetailsUsecase(this.dioClient);

  Future<Either<MainFailure, AllProductsDataModel>> execute(int id) async {
    try {
      final response = await dioClient.get("/products/$id");
      if (response.statusCode == 200) {
        final productsResponse = AllProductsDataModel.fromJson(response.data);
        return right(productsResponse);
      } else {
        return left(MainFailure(message: "Failed to fetch product"));
      }
    } catch (e) {
      return left(MainFailure(message: e.toString()));
    }
  }
}
