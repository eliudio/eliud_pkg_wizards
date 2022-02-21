import 'package:eliud_core/core/wizards/registry/new_app_wizard_info_with_action_specification.dart';
import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/icon_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/model/menu_item_model.dart';
import 'package:eliud_core/style/frontend/has_text.dart';
import 'package:eliud_core/tools/action/action_model.dart';
import 'package:eliud_pkg_medium/platform/medium_platform.dart';
import 'package:flutter/material.dart';

import 'builders/page/about_page_builder.dart';
import 'builders/widgets/membership_parameters_widget.dart';
import 'builders/workflows/membership_workflow_builder.dart';

class MembershipWorkflowWizard extends NewAppWizardInfo {
  MembershipWorkflowWizard()
      : super(
          'membershipworkflow',
          'Membership Workflow',
        );

  @override
  NewAppWizardParameters newAppWizardParameters() => MembershipParameters(
        manuallyPaidMembership: true,
        membershipPaidByCard: false,
        autoCcy: 'gbp',
        autoAmount: 20,
        manualCcy: 'gbp',
        manualAmount: 20,
        payTo: "Mr Minkey",
        country: "United Kingdom",
        bankIdentifierCode: "Bank ID Code",
        payeeIBAN: "IBAN 543232187632167",
        bankName: "Bank Of America",
      );

  @override
  List<NewAppTask>? getCreateTasks(
    AppModel app,
    NewAppWizardParameters parameters,
    MemberModel member,
    HomeMenuProvider homeMenuProvider,
    AppBarProvider appBarProvider,
    DrawerProvider leftDrawerProvider,
    DrawerProvider rightDrawerProvider,
  ) {
    if (parameters is MembershipParameters) {
      if ((parameters.membershipPaidByCard) ||
          (parameters.manuallyPaidMembership)) {
        var memberId = member.documentID!;
        List<NewAppTask> tasks = [];
        tasks.add(() async {
          print("Membership workflow");
          await MembershipWorkflowBuilder(
            app.documentID!,
            parameters: parameters,
          ).create();
        });
        return tasks;
      }
    } else {
      throw Exception(
          'Unexpected class for parameters: ' + parameters.toString());
    }
  }

  @override
  AppModel updateApp(
    NewAppWizardParameters parameters,
    AppModel adjustMe,
  ) =>
      adjustMe;

  @override
  String? getPageID(String pageType) => null;

  @override
  ActionModel? getAction(AppModel app, String actionType, ) => null;

  @override
  List<MenuItemModel>? getMenuItemsFor(
          AppModel app, NewAppWizardParameters parameters, MenuType type) =>
      null;

  @override
  Widget wizardParametersWidget(
      AppModel app, BuildContext context, NewAppWizardParameters parameters) {
    if (parameters is MembershipParameters) {
      return MembershipParametersWidget(
        app: app,
        parameters: parameters,
      );
    } else {
      return text(app, context,
          'Unexpected class for parameters: ' + parameters.toString());
    }
  }
}

class MembershipParameters extends NewAppWizardParameters {
  bool manuallyPaidMembership;
  bool membershipPaidByCard;
  double manualAmount;
  String manualCcy;
  double autoAmount;
  String autoCcy;
  String payTo;
  String country;
  String bankIdentifierCode;
  String payeeIBAN;
  String bankName;

  MembershipParameters({
    required this.manuallyPaidMembership,
    required this.membershipPaidByCard,
    required this.manualCcy,
    required this.manualAmount,
    required this.autoCcy,
    required this.autoAmount,
    required this.payTo,
    required this.country,
    required this.bankIdentifierCode,
    required this.payeeIBAN,
    required this.bankName,
  }) {}
}
