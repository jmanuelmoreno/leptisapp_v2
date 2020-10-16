import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/ui/common/info_message_view.dart';
import 'package:leptisapp/ui/common/loading_view.dart';
import 'package:leptisapp/ui/common/platform_adaptive_progress_indicator.dart';
import 'package:leptisapp/ui/regularity/regularity_add_list.dart';
import 'package:leptisapp/ui/regularity/regularity_add_page_view_model.dart';


class RegularityAddPage extends StatelessWidget {
  RegularityAddPage();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegularityAddPageViewModel>(
      distinct: true,
      converter: (store) => RegularityAddPageViewModel.fromStore(store, context),
      builder: (_, viewModel) => RegularityAddPageContent(viewModel),
    );
  }
}

class RegularityAddPageContent extends StatelessWidget {
  RegularityAddPageContent(this.viewModel);
  final RegularityAddPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      status: viewModel.status,
      loadingContent: const PlatformAdaptiveProgressIndicator(),
      errorContent: ErrorView(
        description: 'Error cargando regularidad.',
        onRetry: viewModel.refreshRegularity,
      ),
      successContent: RegularityAddList(
        regularity: viewModel.regularity,
        onReloadCallback: viewModel.refreshRegularity,
        onAddPointCallback: viewModel.addPointRegularity,
      ),
    );
  }
}
