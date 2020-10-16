import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/ui/drawer/drawer_view.dart';
import 'package:leptisapp/ui/drawer/drawer_view_model.dart';


class DrawerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DrawerViewModel>(
      distinct: true,
      converter: (store) => DrawerViewModel.fromStore(store, context),
      builder: (_, viewModel) => DrawerContent(viewModel),
    );
  }
}

class DrawerContent extends StatelessWidget {
  DrawerContent(this.viewModel);
  final DrawerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DrawerView(
      status: viewModel.status,
      currentUser: viewModel.currentUser,
      authOptions: viewModel.authOptions,
    );
  }
}
