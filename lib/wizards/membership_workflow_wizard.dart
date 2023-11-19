import 'package:eliud_core/core/wizards/registry/action_specification.dart';
import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core_model/model/app_model.dart';
import 'package:eliud_core/model/display_conditions_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/model/menu_item_model.dart';
import 'package:eliud_core/model/public_medium_model.dart';
import 'package:eliud_core_model/style/frontend/has_text.dart';
import 'package:eliud_pkg_membership/membership_package.dart';
import 'package:eliud_pkg_shop/tools/bespoke_models.dart';
import 'package:flutter/material.dart';

import 'builders/widgets/membership_parameters_widget.dart';
import 'builders/workflows/membership_workflow_builder.dart';

class MembershipWorkflowWizard extends NewAppWizardInfo {
  MembershipWorkflowWizard()
      : super(
          'join membership',
          'Join Membership',
        );

  @override
  String getPackageName() => "eliud_pkg_wizards";

  @override
  NewAppWizardParameters newAppWizardParameters() => MembershipParameters(
      manualCcy: 'gbp',
      manualAmount: 20,
      payTo: 'Mr Minkey',
      country: 'United Kingdom',
      bankIdentifierCode: 'Bank ID Code',
      payeeIBAN: 'IBAN 543232187632167',
      bankName: 'Bank Of America',
      joinMedhod: JoinMethod.joinForFree,
      joinSpecifications: ActionSpecification(
          requiresAccessToLocalFileSystem: false,
          availableInLeftDrawer: false,
          availableInRightDrawer: true,
          availableInAppBar: false,
          availableInHomeMenu: false,
          available: false));

  @override
  List<NewAppTask>? getCreateTasks(
    String uniqueId,
    AppModel app,
    NewAppWizardParameters parameters,
    MemberModel member,
    HomeMenuProvider homeMenuProvider,
    AppBarProvider appBarProvider,
    DrawerProvider leftDrawerProvider,
    DrawerProvider rightDrawerProvider,
  ) {
    if (parameters is MembershipParameters) {
      List<NewAppTask> tasks = [];
      tasks.add(() async {
        print("Membership workflow");
        await MembershipWorkflowBuilder(
          uniqueId,
          app.documentID,
          parameters: parameters,
        ).create();
      });
      return tasks;
    } else {
      throw Exception('Unexpected class for parameters: $parameters');
    }
  }

  @override
  AppModel updateApp(
    String uniqueId,
    NewAppWizardParameters parameters,
    AppModel adjustMe,
  ) =>
      adjustMe;

  @override
  String? getPageID(String uniqueId, NewAppWizardParameters parameters,
          String pageType) =>
      null;

  @override
  ActionModel? getAction(
    String uniqueId,
    NewAppWizardParameters parameters,
    AppModel app,
    String actionType,
  ) =>
      null;

  @override
  List<MenuItemModel>? getMenuItemsFor(String uniqueId, AppModel app,
      NewAppWizardParameters parameters, MenuType type) {
    if (parameters is MembershipParameters) {
      if (parameters.joinSpecifications.should(type)) {
        return [
          MenuItemModel(
              documentID: "join",
              text: "JOIN",
              description: "Request membership",
              icon: null,
              action: WorkflowActionModel(app,
                  conditions: DisplayConditionsModel(
                    privilegeLevelRequired:
                        PrivilegeLevelRequired.noPrivilegeRequired,
                    packageCondition:
                        MembershipPackage.memberHasNoMembershipYet,
                  ),
                  workflow: MembershipWorkflowBuilder.dummyWorkflowModel(
                      app.documentID, uniqueId)))
        ];
      }
    }
    return null;
  }

  @override
  Widget wizardParametersWidget(
      AppModel app, BuildContext context, NewAppWizardParameters parameters) {
    if (parameters is MembershipParameters) {
      return MembershipParametersWidget(
        app: app,
        parameters: parameters,
      );
    } else {
      return text(app, context, 'Unexpected class for parameters: $parameters');
    }
  }

  @override
  PublicMediumModel? getPublicMediumModel(String uniqueId,
          NewAppWizardParameters parameters, String mediumType) =>
      null;
}

enum JoinMethod { joinForFree, joinWithManualPayment, joinByCard }

JoinMethod toJoinMethod(int? value) {
  switch (value) {
    case 0:
      return JoinMethod.joinForFree;
    case 1:
      return JoinMethod.joinWithManualPayment;
    case 2:
      return JoinMethod.joinByCard;
  }
  return JoinMethod.joinForFree;
}

class MembershipParameters extends NewAppWizardParameters {
  final ActionSpecification joinSpecifications;
  JoinMethod joinMedhod;
  double manualAmount;
  String manualCcy;
  String payTo;
  String country;
  String bankIdentifierCode;
  String payeeIBAN;
  String bankName;

  MembershipParameters({
    required this.joinSpecifications,
    required this.joinMedhod,
    required this.manualCcy,
    required this.manualAmount,
    required this.payTo,
    required this.country,
    required this.bankIdentifierCode,
    required this.payeeIBAN,
    required this.bankName,
  });
}
