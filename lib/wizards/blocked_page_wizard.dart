import 'package:eliud_core_main/apis/apis.dart';
import 'package:eliud_core_main/apis/wizard_api/action_specification_parameters_base.dart';
import 'package:eliud_core_main/apis/wizard_api/new_app_wizard_info_with_action_specification.dart';
import 'package:eliud_core_main/apis/wizard_api/new_app_wizard_info.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:eliud_core_main/model/member_model.dart';
import 'package:eliud_core_main/model/menu_item_model.dart';
import 'package:eliud_core_main/model/public_medium_model.dart';
import 'package:eliud_core_main/apis/action_api/action_model.dart';
import 'package:eliud_core_main/wizards/helpers/menu_helpers.dart';
import 'package:flutter/material.dart';

import 'builders/page/blocked_page_builder.dart';

class BlockedPageWizard extends NewAppWizardInfoWithActionSpecification {
  static String blockedPageId = 'blocked';
  static String blockedAssetPath =
      'packages/eliud_pkg_wizards/assets/blocked.png';
  static String blockedComponentId = "blocked";

  static bool hasAccessToLocalFileSystem =
      Apis.apis().getMediumApi().hasAccessToLocalFilesystem();

  BlockedPageWizard()
      : super('blocked', 'Blocked', 'Generate a default Blocked Page');

  @override
  String getPackageName() => "eliud_pkg_wizards";

  @override
  NewAppWizardParameters newAppWizardParameters() =>
      ActionSpecificationParametersBase(
        requiresAccessToLocalFileSystem: false,
        availableInLeftDrawer: false,
        availableInRightDrawer: false,
        availableInAppBar: false,
        availableInHomeMenu: false,
        available: true,
      );

  @override
  List<MenuItemModel>? getThoseMenuItems(String uniqueId, AppModel app) =>
      [menuItem(uniqueId, app, blockedPageId, 'Blocked', Icons.do_not_disturb)];

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
    if (parameters is ActionSpecificationParametersBase) {
      var blockedPageSpecifications = parameters.actionSpecifications;

      if (blockedPageSpecifications.shouldCreatePageDialogOrWorkflow()) {
        List<NewAppTask> tasks = [];
        var memberId = member.documentID;
        tasks.add(() async {
          print("Blocked Page");
          await BlockedPageBuilder(
            uniqueId,
            blockedComponentId,
            hasAccessToLocalFileSystem ? blockedAssetPath : null,
            blockedPageId,
            app,
            memberId,
            homeMenuProvider(),
            appBarProvider(),
            leftDrawerProvider(),
            rightDrawerProvider(),
          ).create();
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
  String? getPageID(
      String uniqueId, NewAppWizardParameters parameters, String pageType) {
    if (pageType == 'blockedPageId') return blockedPageId;
    return null;
  }

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
