import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:news/feed/presentation/bloc/articles_bloc.dart";
import "package:news/themes.dart";

import "config/getit.dart";
import "feed/presentation/page/daily_news.dart";

Future main() async {
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ArticlesBloc>(
          create: (context) => getIt()..add(const ReloadArticlesEvent()),
        ),
      ],
      child: MaterialApp(
        title: "News",
        theme: theme(),
        debugShowCheckedModeBanner: false,
        home: const DailyNews(),
      ),
    );
  }
}
