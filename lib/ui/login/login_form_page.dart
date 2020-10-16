import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:leptisapp/redux/app/app_state.dart';
import 'package:leptisapp/redux/leptis/login/auth_actions.dart';
import 'package:leptisapp/redux/leptis/login/auth_state.dart';
import 'package:leptisapp/ui/login/login_form_page_view_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginFormPageViewModel>(
        distinct: true,
        converter: (store) => LoginFormPageViewModel.fromStore(store),
        builder: (_, viewModel) => LoginPageContent(viewModel),
        onWillChange: (viewModel) {
          if(viewModel.status == AuthStatus.authenticated)
            Navigator.of(context).pop();
        }
    );
  }
}

class LoginPageContent extends StatelessWidget {
  LoginPageContent(this.viewModel);
  final LoginFormPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    print('LoginPageContent.build - viewModel.msg=${viewModel.msg}');
    return LoginFormView(
      status: viewModel.status,
      msg: viewModel.msg,
    );
  }
}


class LoginFormView extends StatefulWidget {

  const LoginFormView({
    @required this.status,
    this.msg,
  });

  final AuthStatus status;
  final dynamic msg;

  @override
  _LoginFormViewState createState() => _LoginFormViewState();
}

class _LoginFormViewState extends State<LoginFormView> {
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();

      var store = StoreProvider.of<AppState>(context);
      store.dispatch(LogInAction(username: _username, password: _password));
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void initState() {
    print('LoginFormViewState.initState - Start');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(LoginFormView oldWidget) {
    print('LoginFormViewState.didUpdateWidget - Start');
    super.didUpdateWidget(oldWidget);

    //print("LoginFormViewState.didUpdateWidget - widget.status=${widget.status}, widget.msg=${widget.msg}");
    if(widget.status == AuthStatus.fail) {
      setState(() => _isLoading = false);
      _showSnackBar(widget.msg.toString());
      var store = StoreProvider.of<AppState>(context);
      store.dispatch(LogOutAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 68.0,
      child: Image.asset('assets/images/leptis_trans.png'),
    );

    final username = TextFormField(
      //keyboardType: TextInputType.emailAddress,
      autofocus: false,
      //initialValue: 'jmanuel.moreno',
      decoration: InputDecoration(
        hintText: 'Usuario Intranet',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (val) => _username = val,
    );

    final password = TextFormField(
      autofocus: false,
      //initialValue: '44956521p',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (val) => _password = val,
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.orangeAccent.shade100,
        color: Theme.of(context).accentColor,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: _submit,
          child: const Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    Future<Null> _neverSatisfied() async {
      return showDialog<Null>(
        context: context,
        //barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new AlertDialog(
            title: const Text('Información'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  const Text('Solicita tu contraseña al administrador de la intranet.'),
                  //new Text('You\’re like me. I’m never satisfied.'),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final forgotLabel = FlatButton(
      child: const Text(
        '¿Olvidaste la contraseña?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () { _neverSatisfied(); },
    );

    final loginForm = new Column(
      children: <Widget>[
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              const SizedBox(height: 48.0),
              username,
              const SizedBox(height: 8.0),
              password,
              const SizedBox(height: 24.0),
            ],
          ),
        ),
        _isLoading ? const CircularProgressIndicator() : loginButton,
        forgotLabel
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black54),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            loginForm
          ],
        ),
      ),
    );
  }
}