import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/data/models/leptis/book_event.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/ui/book_events/book_events_page_view_model.dart';
import 'package:leptisapp/ui/book_events/book_event_grid.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/ui/common/loading_view.dart';
import 'package:leptisapp/ui/common/platform_adaptive_progress_indicator.dart';


class BookEventsPage extends StatelessWidget {
  BookEventsPage(this.listType);
  final BookEventListType listType;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BookEventsPageViewModel>(
      distinct: true,
      converter: (store) => BookEventsPageViewModel.fromStore(store, listType),
      builder: (_, viewModel) => BookEventsPageContent(viewModel),
    );
  }
}

class BookEventsPageContent extends StatelessWidget {
  BookEventsPageContent(this.viewModel);
  final BookEventsPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      status: viewModel.status,
      loadingContent: const PlatformAdaptiveProgressIndicator(),
      errorContent: ErrorView(
        description: 'Error cargando rutas.',
        onRetry: viewModel.refreshBookEvents,
      ),
      successContent: BookEventGrid(
        bookEvents: viewModel.bookEvents,
        onReloadCallback: viewModel.refreshBookEvents,
      ),
    );
  }
}
