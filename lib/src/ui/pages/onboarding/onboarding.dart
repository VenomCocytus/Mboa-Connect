import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mboa_connect/src/states_management/onboarding/profile_picture_cubit.dart';
import 'package:mboa_connect/src/ui/widgets/onboarding/profile_upload.dart';

import '../../../../styles/colors.dart';
import '../../../states_management/onboarding/onboarding_cubit.dart';
import '../../../states_management/onboarding/onboarding_state.dart';
import '../../widgets/onboarding/logo.dart';
import '../../widgets/shared/custom_text_field.dart';
import 'onboarding_router_contract.dart';

class Onboarding extends StatefulWidget {
  final IOnboardingRouter iOnboardingRouter;

  const Onboarding(this.iOnboardingRouter);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {

  String _firstName = "";
  String _lastName = "";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _logo(context),
              Spacer(),
              ProfileUplaod(),
              Spacer(flex: 1),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hint: 'First name',
                        height: 45.0,
                        onChanged: (val) {
                          _firstName = val;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: CustomTextField(
                        hint: 'Last name',
                        height: 45.0,
                        onChanged: (val) {
                          _lastName = val;
                        },
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final error = _checkInputs();
                    if (error.isNotEmpty) {
                      final snackBar = SnackBar(
                        content: Text(
                          error,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    await _connectSession();
                  },
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(
                      'Mek wi chat!',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                  ),
                ),
              ),
              Spacer(),
              BlocConsumer<OnboardingCubit, OnboardingState>(
                builder: (context, state) => state is Loading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
                listener: (_, state) {
                  if (state is OnboardingSuccess)
                    widget.iOnboardingRouter.onSessionSuccess(context, state.connectedUser);
                },
              ),
              Spacer(flex: 1)
            ],
          ),
        ),
      ),
    );
  }

  _logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Mboa',
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8.0),
        Logo(),
        SizedBox(width: 8.0),
        Text(
          'Connect',
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _connectSession() async {
      final profileImage = context.read<ProfilePictureCubit>().state;
      await context.read<OnboardingCubit>().signUp(_firstName, _lastName, profileImage!);
    }

  String _checkInputs() {
    var error = "";

    if(_firstName.isEmpty) {
      error = "Enter your first name";
    } else if(_lastName.isEmpty){
      error = "Enter your last name";
    }

    if(context.read<ProfilePictureCubit>().state == null)
      error = error + '\n' + 'Upload profile image';
      return error;
    }
}