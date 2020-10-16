import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/ui/book_event_details/book_event_details_page.dart';
import 'package:leptisapp/ui/book_event_details/book_event_page_view_model.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/ui/common/loading_view.dart';
import 'package:leptisapp/ui/common/platform_adaptive_progress_indicator.dart';


class BookEventPage extends StatelessWidget {
  BookEventPage();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BookEventPageViewModel>(
      distinct: true,
      converter: (store) => BookEventPageViewModel.fromStore(store),
      builder: (_, viewModel) => BookEventPageContent(viewModel),
    );
  }
}

class BookEventPageContent extends StatelessWidget {
  BookEventPageContent(this.viewModel);
  final BookEventPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      status: viewModel.status,
      loadingContent: const PlatformAdaptiveProgressIndicator(),
      errorContent: ErrorView(
        description: 'Error cargando detalle de ruta.',
        onRetry: viewModel.refreshBookEvents,
      ),
      successContent: BookEventDetailsPage(
        bookEvent: viewModel.bookEvent,
        onReloadCallback: viewModel.refreshBookEvents,
        showBackButton: false,
      ),
    );
  }
}
