import 'package:eliud_core/core/wizards/registry/new_app_wizard_info_with_action_specification.dart';
import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core/core/wizards/tools/document_identifier.dart';
import 'package:eliud_core_model/model/app_model.dart';
import 'package:eliud_core/model/icon_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/model/menu_item_model.dart';
import 'package:eliud_core/model/public_medium_model.dart';
import 'package:eliud_core/tools/action/action_model.dart';
import 'package:flutter/material.dart';

import 'builders/page/about_page_builder.dart';

class AboutPageWizard extends NewAppWizardInfoWithActionSpecification {
  static String aboutPageId = 'about';
  static String aboutComponentIdentifier = "about";
  static String aboutAssetPath = 'packages/eliud_pkg_wizards/assets/about.png';

  AboutPageWizard() : super('about', 'About', 'Generate a default About Page');

  @override
  String getPackageName() => "eliud_pkg_wizards";

  @override
  NewAppWizardParameters newAppWizardParameters() =>
      ActionSpecificationParametersBase(
        requiresAccessToLocalFileSystem: false,
        availableInLeftDrawer: true,
        availableInRightDrawer: false,
        availableInAppBar: false,
        availableInHomeMenu: true,
        available: false,
      );

  @override
  List<MenuItemModel>? getThoseMenuItems(String uniqueId, AppModel app) =>
      [menuItemAbout(uniqueId, app, aboutPageId, 'About')];

  MenuItemModel menuItemAbout(String uniqueId, AppModel app, pageID, text) =>
      MenuItemModel(
          documentID:
              constructDocumentId(uniqueId: uniqueId, documentId: pageID),
          text: text,
          description: text,
          icon: IconModel(
              codePoint: Icons.info.codePoint,
              fontFamily: Icons.settings.fontFamily),
          action: GotoPage(app,
              pageID:
                  constructDocumentId(uniqueId: uniqueId, documentId: pageID)));

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
      var aboutPageSpecifications = parameters.actionSpecifications;
      if (aboutPageSpecifications.shouldCreatePageDialogOrWorkflow()) {
        var memberId = member.documentID;
        List<NewAppTask> tasks = [];
        tasks.add(() async {
          print("About Page");
          await AboutPageBuilder(
            uniqueId,
            aboutComponentIdentifier,
            aboutAssetPath,
            aboutPageId,
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
