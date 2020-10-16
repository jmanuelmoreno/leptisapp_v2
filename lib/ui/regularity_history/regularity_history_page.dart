import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/regularity_history/regularity_history_actions.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/ui/common/loading_view.dart';
import 'package:leptisapp/ui/common/platform_adaptive_progress_indicator.dart';

import 'package:leptisapp/ui/regularity_history/regularity_history_list.dart';
import 'package:leptisapp/ui/regularity_history/regularity_history_page_view_model.dart';


class RegularityHistoryPage extends StatelessWidget {
  RegularityHistoryPage({
    @required this.memberId,
  });
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegularityHistoryPageViewModel>(
      distinct: true,
      onInit: (store) {
        print('RegularityHistoryPage.build - StoreConnector.onInit...');
        store.dispatch(FetchRegularityHistoryAction(
            season: store.state.bookEventState.currentSeason.id,
            memberId: this.memberId
        ));
      },
      converter: (store) => RegularityHistoryPageViewModel.fromStore(store),
      builder: (_, viewModel) => RegularityHistoryPageContent(viewModel),
    );
  }
}

class RegularityHistoryPageContent extends StatelessWidget {
  RegularityHistoryPageContent(this.viewModel);
  final RegularityHistoryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      status: viewModel.status,
      loadingContent: const PlatformAdaptiveProgressIndicator(),
      errorContent: ErrorView(
        description: 'Error cargando histórico de regularidad.',
        onRetry: null,
      ),
      successContent: RegularityHistoryList(
        regularityHistory: viewModel.regularityHistory,
      ),
    );
  }
}
