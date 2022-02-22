import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core/core/wizards/widgets/action_specification_widget.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/app_policy_model.dart';
import 'package:eliud_core/model/icon_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/model/menu_item_model.dart';
import 'package:eliud_core/model/public_medium_model.dart';
import 'package:eliud_core/style/frontend/has_text.dart';
import 'package:eliud_core/tools/action/action_model.dart';
import 'package:eliud_core/wizards/helpers/menu_helpers.dart';
import 'package:eliud_pkg_medium/platform/medium_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'builders/policy/app_policy_builder.dart';
import 'builders/policy/policy_medium_builder.dart';
import 'builders/policy/policy_page_builder.dart';

class NewPolicyWizard extends NewAppWizardInfo {
  static String POLICY_PAGE_ID = 'policy';
  PublicMediumModel? policyMedium;
  AppPolicyModel? policyModel;

  NewPolicyWizard() : super('policy', 'App policy');

  @override
  NewAppWizardParameters newAppWizardParameters() {
    return NewPolicyParameters();
  }

  @override
  List<MenuItemModel>? getMenuItemsFor(
      AppModel app, NewAppWizardParameters parameters, MenuType type) {
    if (parameters is NewPolicyParameters) {
      if (parameters.actionSpecifications.should(type)) {
        return [menuItem(app, POLICY_PAGE_ID, 'Policy', Icons.rule)];
      }
    } else {
      throw Exception(
          'Unexpected class for parameters: ' + parameters.toString());
    }
    return null;
  }

  @override
  Widget wizardParametersWidget(
      AppModel app, BuildContext context, NewAppWizardParameters parameters) {
    if (parameters is NewPolicyParameters) {
      bool hasAccessToLocalFileSystem =
          AbstractMediumPlatform.platform!.hasAccessToLocalFilesystem();
      return ActionSpecificationWidget(
          app: app,
          enabled: hasAccessToLocalFileSystem,
          actionSpecification: parameters.actionSpecifications,
          label: 'Generate Example Policy');
    } else {
      return text(app, context,
          'Unexpected class for parameters: ' + parameters.toString());
    }
  }

  List<NewAppTask>? getCreateTasks(
    AppModel app,
    NewAppWizardParameters parameters,
    MemberModel member,
    HomeMenuProvider homeMenuProvider,
    AppBarProvider appBarProvider,
    DrawerProvider leftDrawerProvider,
    DrawerProvider rightDrawerProvider,
    PageProvider pageProvider,
    ActionProvider actionProvider,
  ) {
    if (parameters is NewPolicyParameters) {
      var policySpecifications = parameters.actionSpecifications;
      var appId = app.documentID!;
      if (policySpecifications.shouldCreatePageDialogOrWorkflow()) {
        List<NewAppTask> tasks = [];
        var memberId = member.documentID!;

        // policy medium
        tasks.add(() async {
          print("Policy Medium");
          policyMedium = await PolicyMediumBuilder(app, memberId).create();
          if (policyMedium != null) {
            policyModel =
                await AppPolicyBuilder(appId, memberId, policyMedium!).create();
            parameters.registerTheAppPolicy(policyModel!);
          }
        });

        // policy
/*
        tasks.add(() async {
          if (policyMedium != null) {
            policyModel =
            await AppPolicyBuilder(appId, memberId, policyMedium!).create();
            parameters.registerTheAppPolicy(policyModel!);
          }
        });
*/

        // policy page
        tasks.add(() async {
          if (policyMedium != null) {
            print("Policy Page");
            await PolicyPageBuilder(
                    POLICY_PAGE_ID,
                    app,
                    memberId,
                    homeMenuProvider(),
                    appBarProvider(),
                    leftDrawerProvider(),
                    rightDrawerProvider(),
                    pageProvider,
                    actionProvider,
                    policyMedium!,
                    'Policy')
                .create();
          }
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
  ) {
    if (parameters is NewPolicyParameters) {
      adjustMe.policies = parameters.appPolicyModel;
      return adjustMe;
    } else {
      throw Exception(
          'Unexpected class for parameters: ' + parameters.toString());
    }
  }

  @override
  String? getPageID(NewAppWizardParameters parameters, String pageType) => null;

  @override
  ActionModel? getAction(
    NewAppWizardParameters parameters,
    AppModel app,
    String actionType,
  ) =>
      null;
}

class NewPolicyParameters extends ActionSpecificationParametersBase {
  static bool hasAccessToLocalFileSystem =
      AbstractMediumPlatform.platform!.hasAccessToLocalFilesystem();

  AppPolicyModel? appPolicyModel;

  NewPolicyParameters()
      : super(
          requiresAccessToLocalFileSystem: false,
          availableInLeftDrawer: hasAccessToLocalFileSystem,
          availableInRightDrawer: false,
          availableInAppBar: false,
          availableInHomeMenu: false,
          available: false,
        );

  void registerTheAppPolicy(AppPolicyModel theAppPolicyModel) {
    appPolicyModel = theAppPolicyModel;
  }
}
