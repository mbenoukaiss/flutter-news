//events : load
//states : loading, loaded, error

import "package:flutter_bloc/flutter_bloc.dart";
import "package:injectable/injectable.dart";
import "package:news/feed/domain/usecase/get_read_articles.dart";
import "package:news/feed/domain/usecase/toggle_read.dart";

abstract class ReadArticleState {
  const ReadArticleState();
}

class ReadArticleLoadingState extends ReadArticleState {
  const ReadArticleLoadingState();
}

class ReadArticleLoadedState extends ReadArticleState {
  final bool read;

  const ReadArticleLoadedState(this.read);
}

abstract class ReadArticlesEvent {
  const ReadArticlesEvent();
}

class LoadStatusEvent extends ReadArticlesEvent {
  const LoadStatusEvent();
}

class ToggleArticleEvent extends ReadArticlesEvent {
  final String url;
  final bool? read;

  const ToggleArticleEvent(this.url, this.read);
}

@Injectable()
class ReadArticleBloc extends Bloc<ReadArticlesEvent, ReadArticleState> {
  IsArticleRead isArticleRead;
  ToggleRead toggleRead;

  ReadArticleBloc(@factoryParam String url, this.isArticleRead, this.toggleRead)
    : super(const ReadArticleLoadingState()) {
    on<LoadStatusEvent>((event, emit) async {
      emit(ReadArticleLoadedState(await isArticleRead(url)));
    });

    on<ToggleArticleEvent>((event, emit) async {
      final bool read = await toggleRead(event.url, event.read);
      emit(ReadArticleLoadedState(read));
    });
  }
}
