import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/events/event_actions.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/ui/common/loading_view.dart';
import 'package:leptisapp/ui/common/platform_adaptive_progress_indicator.dart';
import 'package:leptisapp/ui/events/event_list.dart';
import 'package:leptisapp/ui/events/event_page_view_model.dart';


class EventPage extends StatelessWidget {
  EventPage();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EventPageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchEventAction()),
      converter: (store) => EventPageViewModel.fromStore(store),
      builder: (_, viewModel) => EventPageContent(viewModel),
    );
  }
}

class EventPageContent extends StatelessWidget {
  EventPageContent(this.viewModel);
  final EventPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      status: viewModel.status,
      loadingContent: const PlatformAdaptiveProgressIndicator(),
      errorContent: ErrorView(
        description: 'Error cargando eventos.',
        onRetry: viewModel.refreshEvents,
      ),
      successContent: EventList(
        events: viewModel.events,
        onReloadCallback: viewModel.refreshEvents,
      ),
    );
  }
}
