import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:test/domain/core/dio_client.dart';
import 'package:test/domain/core/failures.dart';
import 'package:test/domain/products/model/all_product_data_model.dart';

@lazySingleton
class GetAllProducts {
  final DioClient dioClient;

  GetAllProducts(this.dioClient);

  Future<Either<MainFailure, List<AllProductsDataModel>>> execute() async {
    try {
      final response = await dioClient.get("/products");
      if (response.statusCode == 200) {
        final productsResponse = AllProductsDataModel.listFromJson(
          response.data,
        );
        return right(productsResponse);
      } else {
        return left(MainFailure(message: "Failed to fetch products"));
      }
    } catch (e) {
      return left(MainFailure(message: e.toString()));
    }
  }
}
