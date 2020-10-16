import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_actions.dart';
import 'package:leptisapp/redux/leptis/regularity/regularity_status.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/ui/common/loading_view.dart';
import 'package:leptisapp/ui/common/platform_adaptive_progress_indicator.dart';
import 'package:leptisapp/ui/regularity/regularity_list.dart';
import 'package:leptisapp/ui/regularity/regularity_page_view_model.dart';


class RegularityPage extends StatelessWidget {
  RegularityPage();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegularityPageViewModel>(
      distinct: true,
      onInit: (store) {
        print('RegularityPage.build - StoreConnector.onInit...');
        store.dispatch(FetchRegularityAction(season: store.state.bookEventState.currentSeason.id));
      },
      converter: (store) => RegularityPageViewModel.fromStore(store),
      builder: (_, viewModel) => RegularityPageContent(viewModel),
      onDidChange: (viewModel) {
        if (viewModel.regularityStatus == RegularityStatus.added) {
          viewModel.refreshRegularity();
        }
      },
    );
  }
}

class RegularityPageContent extends StatelessWidget {
  RegularityPageContent(this.viewModel);
  final RegularityPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      status: viewModel.status,
      loadingContent: const PlatformAdaptiveProgressIndicator(),
      errorContent: ErrorView(
        description: 'Error cargando regularidad.',
        onRetry: viewModel.refreshRegularity,
      ),
      successContent: RegularityList(
        regularity: viewModel.regularity,
        currentUser: viewModel.currentUser,
        onReloadCallback: viewModel.refreshRegularity,
      ),
    );
  }
}
