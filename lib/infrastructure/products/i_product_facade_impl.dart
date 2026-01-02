import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:test/domain/core/failures.dart';
import 'package:test/domain/products/i_products_facade.dart';
import 'package:test/domain/products/model/all_product_data_model.dart';
import 'package:test/infrastructure/products/get_product_details/get_product_details_usecase.dart';
import 'package:test/infrastructure/products/get_product_list/get_all_products.dart';

@LazySingleton(as: IProductsFacade)
class IProductFacadeImpl implements IProductsFacade {
  final GetProductDetailsUsecase getProductDetailsUsecase;

  final GetAllProducts getAllProductsUsecase;

  IProductFacadeImpl(this.getProductDetailsUsecase, this.getAllProductsUsecase);

  @override
  Future<Either<MainFailure, AllProductsDataModel>> getProduct(int id) async {
    return await getProductDetailsUsecase.execute(id);
  }

  @override
  Future<Either<MainFailure, List<AllProductsDataModel>>>
  getAllProducts() async {
    return await getAllProductsUsecase.execute();
  }
}
