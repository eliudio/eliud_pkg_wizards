import 'package:eliud_core/core/registry.dart';
import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core_model/model/app_model.dart';
import 'package:eliud_core/model/app_policy_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/model/menu_item_model.dart';
import 'package:eliud_core/model/platform_medium_model.dart';
import 'package:eliud_core/model/public_medium_model.dart';
import 'package:eliud_core_model/style/frontend/has_text.dart';
import 'package:eliud_core/tools/action/action_model.dart';
import 'package:eliud_core/wizards/helpers/menu_helpers.dart';
import 'package:eliud_pkg_wizards/wizards/pdf_wizard_param_widget.dart';
import 'package:flutter/material.dart';
import 'builders/policy/app_policy_builder.dart';
import 'builders/policy/pdf_from_url_policy_medium_builder.dart';
import 'builders/policy/policy_page_builder.dart';

class NewPolicyFromPdfWizard extends NewAppWizardInfo {
  static String policyPageId = 'policy';

  NewPolicyFromPdfWizard() : super('policy-from_pdf', 'App policy from pdf');

  @override
  String getPackageName() => "eliud_pkg_wizards";

  @override
  NewAppWizardParameters newAppWizardParameters() {
    return NewPolicyFromPdfParameters();
  }

  @override
  List<MenuItemModel>? getMenuItemsFor(String uniqueId, AppModel app,
      NewAppWizardParameters parameters, MenuType type) {
    if (parameters is NewPolicyFromPdfParameters) {
      if (parameters.actionSpecifications.should(type)) {
        return [menuItem(uniqueId, app, policyPageId, 'Policy', Icons.rule)];
      }
    } else {
      throw Exception('Unexpected class for parameters: $parameters');
    }
    return null;
  }

  @override
  Widget wizardParametersWidget(
      AppModel app, BuildContext context, NewAppWizardParameters parameters) {
    if (parameters is NewPolicyFromPdfParameters) {
      return PdfWizardParametersWidget(
        app: app,
        parameters: parameters,
      );
    } else {
      return text(app, context, 'Unexpected class for parameters: $parameters');
    }
  }

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
    if (parameters is NewPolicyFromPdfParameters) {
      var policySpecifications = parameters.actionSpecifications;
      var appId = app.documentID;
      if (policySpecifications.shouldCreatePageDialogOrWorkflow()) {
        List<NewAppTask> tasks = [];
        var memberId = member.documentID;

        tasks.add(() async {
          print("Policy Medium");
          var policyMedium = await PdfFromUrlPolicyMediumBuilder(
                  parameters.pdfUrl ?? "",
                  parameters.baseName ?? "",
                  uniqueId,
                  app,
                  memberId)
              .create();
          parameters.registerTheAppPolicyMedium(policyMedium);
        });

        AppPolicyModel? policyModel;
        tasks.add(() async {
          print("Policy Model");
          var policyMedium = parameters.appPolicyMedium;
          if (policyMedium != null) {
            policyModel =
                await AppPolicyBuilder(uniqueId, appId, memberId, policyMedium)
                    .create();
            if (policyModel != null) {
              parameters.registerTheAppPolicy(policyModel!);
            }
          }
        });

        tasks.add(() async {
          print("Policy Page");
          if (policyModel != null) {
            await PolicyPageBuilder(
              uniqueId,
              policyPageId,
              app,
              memberId,
              homeMenuProvider(),
              appBarProvider(),
              leftDrawerProvider(),
              rightDrawerProvider(),
              policyModel!,
              'Policy',
              'Policy',
            ).create();
          }
        });
        return tasks;
      }
    } else {
      throw Exception('Unexpected class for parameters: $parameters');
    }
    return null;
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
  PublicMediumModel? getPublicMediumModel(String uniqueId,
          NewAppWizardParameters parameters, String mediumType) =>
      null;
}

class NewPolicyFromPdfParameters extends ActionSpecificationParametersBase {
  static bool hasAccessToLocalFileSystem =
      Apis.apis().getMediumApi().hasAccessToLocalFilesystem();

  AppPolicyModel? appPolicyModel;
  PlatformMediumModel? appPolicyMedium;
  String? pdfUrl;
  String? baseName;

  NewPolicyFromPdfParameters()
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

  void registerTheAppPolicyMedium(PlatformMediumModel theAppPolicyMedium) {
    appPolicyMedium = theAppPolicyMedium;
  }
}
