// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/analytics/data/repositories/analytics_repository_impl.dart'
    as _i425;
import '../../features/analytics/domain/repositories/analytics_repository.dart'
    as _i1044;
import '../../features/analytics/presentation/cubit/analytics_cubit.dart'
    as _i821;
import '../../features/auth_feature/data/auth_repo_impl.dart' as _i292;
import '../../features/auth_feature/data/datasources/auth_remote_datasource.dart'
    as _i404;
import '../../features/auth_feature/domain/auth_repo.dart' as _i378;
import '../../features/auth_feature/presentation/view_model/cubit/auth_cubit.dart'
    as _i326;
import '../../features/balance/data/repositories/balance_repository_impl.dart'
    as _i17;
import '../../features/balance/domain/repositories/balance_repository.dart'
    as _i588;
import '../../features/balance/presentation/cubit/balance_cubit.dart' as _i599;
import '../../features/categories/data/repositories/category_repository_impl.dart'
    as _i894;
import '../../features/categories/domain/repositories/category_repository.dart'
    as _i266;
import '../../features/categories/presentation/cubit/category_cubit.dart'
    as _i93;
import '../../features/monthly_report/data/repositories/monthly_report_repository_impl.dart'
    as _i934;
import '../../features/monthly_report/domain/repositories/monthly_report_repository.dart'
    as _i287;
import '../../features/monthly_report/presentation/cubit/monthly_report_cubit.dart'
    as _i1028;
import '../../features/transaction/data/repositories/transaction_repository_Impl.dart'
    as _i111;
import '../../features/transaction/domain/repositories/transaction_repository.dart'
    as _i1022;
import '../../features/transaction/presentation/cubit/transaction/transaction_cubit.dart'
    as _i413;
import '../../user_setting/data/repositories/user_setting_repository_impl.dart'
    as _i878;
import '../../user_setting/domain/repositories/user_setting_repository.dart'
    as _i347;
import '../../user_setting/presentation/cubit/user_settings/user_settings_cubit.dart'
    as _i291;
import 'di_modules.dart' as _i176;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.singleton<_i974.FirebaseFirestore>(() => appModule.firestore);
    gh.singleton<_i59.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.factory<_i287.MonthlyReportRepository>(
      () => _i934.MonthlyReportRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i588.BalanceRepository>(
      () => _i17.BalanceRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i1044.AnalyticsRepository>(
      () => _i425.AnalyticsRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i347.UserSettingRepository>(
      () => _i878.UserSettingRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i1022.TransactionRepository>(
      () => _i111.TransactionRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i404.AuthRemoteDataSource>(
      () => _i404.AuthRemoteDataSource(gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i266.CategoryRepository>(
      () => _i894.CategoryRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i378.AuthRepository>(
      () => _i292.AuthRepositoryImpl(
        gh<_i404.AuthRemoteDataSource>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.factory<_i1028.MonthlyReportCubit>(
      () => _i1028.MonthlyReportCubit(gh<_i287.MonthlyReportRepository>()),
    );
    gh.factory<_i413.TransactionCubit>(
      () => _i413.TransactionCubit(gh<_i1022.TransactionRepository>()),
    );
    gh.factory<_i326.AuthCubit>(
      () => _i326.AuthCubit(gh<_i378.AuthRepository>()),
    );
    gh.factory<_i599.BalanceCubit>(
      () => _i599.BalanceCubit(gh<_i588.BalanceRepository>()),
    );
    gh.factory<_i291.UserSettingsCubit>(
      () => _i291.UserSettingsCubit(gh<_i347.UserSettingRepository>()),
    );
    gh.factory<_i821.AnalyticsCubit>(
      () => _i821.AnalyticsCubit(gh<_i1044.AnalyticsRepository>()),
    );
    gh.factory<_i93.CategoryCubit>(
      () => _i93.CategoryCubit(gh<_i266.CategoryRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i176.AppModule {}
