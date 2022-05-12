import 'package:eliud_core/core/wizards/builders/page_builder.dart';
import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core/core/wizards/tools/documentIdentifier.dart';
import 'package:eliud_core/model/abstract_repository_singleton.dart'
    as corerepo;
import 'package:eliud_core/model/app_bar_model.dart';
import 'package:eliud_core/model/body_component_model.dart';
import 'package:eliud_core/model/drawer_model.dart';
import 'package:eliud_core/model/home_menu_model.dart';
import 'package:eliud_core/model/menu_def_model.dart';
import 'package:eliud_core/model/model_export.dart';
import 'package:eliud_core/model/page_model.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_core/tools/storage/platform_medium_helper.dart';
import 'package:eliud_pkg_fundamentals/model/abstract_repository_singleton.dart';
import 'package:eliud_pkg_fundamentals/model/booklet_component.dart';
import 'package:eliud_pkg_fundamentals/model/booklet_model.dart';
import 'package:eliud_pkg_fundamentals/model/section_model.dart';
import 'package:eliud_pkg_text/wizards/builders/page/page_with_text.dart';

class BlockedPageBuilder extends PageBuilder {
  final String? blockedAssetLocation;
  final String componentId;

  BlockedPageBuilder(
      String uniqueId,
      this.componentId,
      this.blockedAssetLocation,
      String pageId,
      AppModel app,
      String memberId,
      HomeMenuModel theHomeMenu,
      AppBarModel theAppBar,
      DrawerModel leftDrawer,
      DrawerModel rightDrawer,
      )
      : super(uniqueId, pageId, app, memberId, theHomeMenu, theAppBar, leftDrawer,
            rightDrawer, );

  Future<PageModel> _setupPage() async {
    return await corerepo.AbstractRepositorySingleton.singleton
        .pageRepository(app.documentID!)!
        .add(_page());
  }

  PageModel _page() {
    List<BodyComponentModel> components = [];
    components.add(BodyComponentModel(
        documentID: "1",
        componentName: AbstractBookletComponent.componentName,
        componentId: constructDocumentId(uniqueId: uniqueId, documentId: blockedIdentifier)));

    return PageModel(
        documentID: constructDocumentId(uniqueId: uniqueId, documentId: pageId),
        appId: app.documentID!,
        title: "Blocked !",
        drawer: leftDrawer,
        endDrawer: rightDrawer,
        appBar: theAppBar,
        homeMenu: theHomeMenu,
        layout: PageLayout.ListView,
        conditions: StorageConditionsModel(
          privilegeLevelRequired: PrivilegeLevelRequiredSimple.NoPrivilegeRequiredSimple,
        ),
        bodyComponents: components);
  }

  static String blockedIdentifier = "blocked";

  Future<PlatformMediumModel> uploadBlockedImage() async {
    return await PlatformMediumHelper(app, memberId,
            PrivilegeLevelRequiredSimple.NoPrivilegeRequiredSimple)
        .createThumbnailUploadPhotoAsset(
      newRandomKey(),
      blockedAssetLocation!,
    );
  }

  BookletModel _blocked(PlatformMediumModel blockedImage) {
    List<SectionModel> entries = [];
    {
      entries.add(SectionModel(
          documentID: "1",
          title: "Blocked!",
          description: "Unfortunately you are blocked.",
          image: blockedImage,
          imagePositionRelative: RelativeImagePosition.Aside,
          imageAlignment: SectionImageAlignment.Right,
          imageWidth: .33,
          links: []));
    }

    return BookletModel(
      documentID: constructDocumentId(uniqueId: uniqueId, documentId: blockedIdentifier),
      description: "Blocked!",
      sections: entries,
      appId: app.documentID!,
      conditions: StorageConditionsModel(
          privilegeLevelRequired:
              PrivilegeLevelRequiredSimple.NoPrivilegeRequiredSimple),
    );
  }

  Future<void> _setupBlocked(PlatformMediumModel blockedImage) async {
    await AbstractRepositorySingleton.singleton
        .bookletRepository(app.documentID!)!
        .add(_blocked(blockedImage));
  }

  Future<PageModel> create() async {
    if (blockedAssetLocation != null) {
      var blockedImage = await uploadBlockedImage();
      await _setupBlocked(blockedImage);
      return await _setupPage();
    } else {
      return PageWithTextBuilder(uniqueId,
          'Blocked',
          'You are blocked',
          pageId,
          app,
          memberId,
          theHomeMenu,
          theAppBar,
          leftDrawer,
          rightDrawer,  )
          .create();
    }
  }
}
