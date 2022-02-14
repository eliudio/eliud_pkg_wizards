import 'package:eliud_core/core/wizards/registry/new_app_wizard_info_with_action_specification.dart';
import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/model/menu_item_model.dart';
import 'package:eliud_core/wizards/helpers/menu_helpers.dart';
import 'package:eliud_pkg_medium/platform/medium_platform.dart';
import 'package:flutter/material.dart';

import 'builders/page/blocked_page_builder.dart';

class BlockedPageWizard extends NewAppWizardInfoWithActionSpecification {
  static String BLOCKED_PAGE_ID = 'blocked';
  static String BLOCKED_ASSET_PATH =
      'packages/eliud_pkg_wizards/assets/blocked.png';
  static String BLOCKED_COMPONENT_IDENTIFIER = "blocked";

  static bool hasAccessToLocalFileSystem = AbstractMediumPlatform.platform!.hasAccessToLocalFilesystem();

  BlockedPageWizard() : super('blocked', 'Blocked',  'Generate Blocked Page');

  @override
  NewAppWizardParameters newAppWizardParameters() => ActionSpecificationParametersBase(
    requiresAccessToLocalFileSystem: false,
    availableInLeftDrawer: false,
    availableInRightDrawer: false,
    availableInAppBar: false,
    availableInHomeMenu: false,
    available: true,
  );

  @override
  List<MenuItemModel>? getThoseMenuItems(AppModel app) =>[
      menuItem(app, BLOCKED_PAGE_ID, 'Blocked', Icons.do_not_disturb)];

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
    if (parameters is ActionSpecificationParametersBase) {
      var blockedPageSpecifications = parameters.actionSpecifications;

      if (blockedPageSpecifications.shouldCreatePageDialogOrWorkflow()) {
        List<NewAppTask> tasks = [];
        var memberId = member.documentID!;
        tasks.add(() async {
          print("Blocked Page");
          var blockedPage = await BlockedPageBuilder(
              BLOCKED_COMPONENT_IDENTIFIER,
              hasAccessToLocalFileSystem ? BLOCKED_ASSET_PATH : null,
              BLOCKED_PAGE_ID,
              app,
              memberId,
              homeMenuProvider(),
              appBarProvider(),
              leftDrawerProvider(),
              rightDrawerProvider())
              .create();
        });
        return tasks;
      }
    } else {
      throw Exception('Unexpected class for parameters: ' + parameters.toString());
    }
  }

  @override
  AppModel updateApp(NewAppWizardParameters parameters, AppModel adjustMe, ) => adjustMe;

  @override
  String? getPageID(String pageType) {
    if (pageType == 'blockedPageId') return BLOCKED_PAGE_ID;
    return null;
  }
}
