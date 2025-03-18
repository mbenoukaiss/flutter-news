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

import '../feed/domain/port/article_fetcher.dart' as _i836;
import '../feed/domain/usecase/get_articles.dart' as _i1036;
import '../feed/infrastructure/adapter/article_fetcher_adapter.dart' as _i105;
import '../feed/presentation/bloc/articles_bloc.dart' as _i18;
import 'config.dart' as _i574;
import 'module.dart' as _i946;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final module = _$Module();
    await gh.singletonAsync<_i574.Config>(
      () => _i574.Config.create(),
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => module.dio);
    gh.singleton<_i836.ArticleFetcher>(
      () => _i105.ArticleFetcherAdapter(gh<_i574.Config>(), gh<_i361.Dio>()),
    );
    gh.singleton<_i1036.GetArticles>(
      () => _i1036.GetArticles(gh<_i836.ArticleFetcher>()),
    );
    gh.singleton<_i18.ArticlesBloc>(
      () => _i18.ArticlesBloc(gh<_i1036.GetArticles>()),
    );
    return this;
  }
}

class _$Module extends _i946.Module {}
