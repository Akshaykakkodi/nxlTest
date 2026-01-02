// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../../application/auth/auth_bloc.dart' as _i75;
import '../../../infrastructure/auth/auth_facade_impl.dart' as _i418;
import '../../../infrastructure/products/get_product_details/get_product_details_usecase.dart'
    as _i474;
import '../../../infrastructure/products/get_product_list/get_all_products.dart'
    as _i324;
import '../../../infrastructure/products/i_product_facade_impl.dart' as _i319;
import '../../auth/i_auth_facade.dart' as _i551;
import '../../products/i_products_facade.dart' as _i506;
import '../dio_client.dart' as _i894;
import 'app_injection_module.dart' as _i975;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final appInjectionModule = _$AppInjectionModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => appInjectionModule.prefs,
    preResolve: true,
  );
  gh.lazySingleton<_i361.Dio>(() => appInjectionModule.dio);
  gh.lazySingleton<_i551.IAuthFacade>(
    () => _i418.AuthFacadeImpl(gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i894.DioClient>(() => _i894.DioClient(gh<_i361.Dio>()));
  gh.lazySingleton<_i474.GetProductDetailsUsecase>(
    () => _i474.GetProductDetailsUsecase(gh<_i894.DioClient>()),
  );
  gh.lazySingleton<_i324.GetAllProducts>(
    () => _i324.GetAllProducts(gh<_i894.DioClient>()),
  );
  gh.lazySingleton<_i506.IProductsFacade>(
    () => _i319.IProductFacadeImpl(
      gh<_i474.GetProductDetailsUsecase>(),
      gh<_i324.GetAllProducts>(),
    ),
  );
  gh.factory<_i75.AuthBloc>(() => _i75.AuthBloc(gh<_i551.IAuthFacade>()));
  return getIt;
}

class _$AppInjectionModule extends _i975.AppInjectionModule {}
