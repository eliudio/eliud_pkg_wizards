import 'package:eliud_core_main/model/app_bar_model.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:eliud_core_main/model/body_component_model.dart';
import 'package:eliud_core_main/model/drawer_model.dart';
import 'package:eliud_core_main/model/home_menu_model.dart';
import 'package:eliud_core_main/model/page_model.dart';
import 'package:eliud_core_main/model/platform_medium_model.dart';
import 'package:eliud_core_main/model/storage_conditions_model.dart';
import 'package:eliud_core_main/wizards/builders/page_builder.dart';
import 'package:eliud_core_main/wizards/tools/document_identifier.dart';
import 'package:eliud_core_main/model/abstract_repository_singleton.dart'
    as mainrepo;
import 'package:eliud_core_helpers/etc/random.dart';
import 'package:eliud_core_main/storage/platform_medium_helper.dart';
import 'package:eliud_pkg_fundamentals_model/model/abstract_repository_singleton.dart';
import 'package:eliud_pkg_fundamentals_model/model/booklet_component.dart';
import 'package:eliud_pkg_fundamentals_model/model/booklet_model.dart';
import 'package:eliud_pkg_fundamentals_model/model/section_model.dart';
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
  ) : super(
          uniqueId,
          pageId,
          app,
          memberId,
          theHomeMenu,
          theAppBar,
          leftDrawer,
          rightDrawer,
        );

  Future<PageModel> _setupPage() async {
    return await mainrepo.AbstractRepositorySingleton.singleton
        .pageRepository(app.documentID)!
        .add(_page());
  }

  PageModel _page() {
    List<BodyComponentModel> components = [];
    components.add(BodyComponentModel(
        documentID: "1",
        componentName: AbstractBookletComponent.componentName,
        componentId: constructDocumentId(
            uniqueId: uniqueId, documentId: blockedIdentifier)));

    return PageModel(
        documentID: constructDocumentId(uniqueId: uniqueId, documentId: pageId),
        appId: app.documentID,
        title: "Blocked !",
        description: "Blocked !",
        drawer: leftDrawer,
        endDrawer: rightDrawer,
        appBar: theAppBar,
        homeMenu: theHomeMenu,
        layout: PageLayout.listView,
        conditions: StorageConditionsModel(
          privilegeLevelRequired:
              PrivilegeLevelRequiredSimple.noPrivilegeRequiredSimple,
        ),
        bodyComponents: components);
  }

  static String blockedIdentifier = "blocked";

  Future<PlatformMediumModel> uploadBlockedImage() async {
    return await PlatformMediumHelper(app, memberId,
            PrivilegeLevelRequiredSimple.noPrivilegeRequiredSimple)
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
          imagePositionRelative: RelativeImagePosition.aside,
          imageAlignment: SectionImageAlignment.right,
          imageWidth: .33,
          links: []));
    }

    return BookletModel(
      documentID: constructDocumentId(
          uniqueId: uniqueId, documentId: blockedIdentifier),
      description: "Blocked!",
      sections: entries,
      appId: app.documentID,
      conditions: StorageConditionsModel(
          privilegeLevelRequired:
              PrivilegeLevelRequiredSimple.noPrivilegeRequiredSimple),
    );
  }

  Future<void> _setupBlocked(PlatformMediumModel blockedImage) async {
    await AbstractRepositorySingleton.singleton
        .bookletRepository(app.documentID)!
        .add(_blocked(blockedImage));
  }

  Future<PageModel> create() async {
    if (blockedAssetLocation != null) {
      var blockedImage = await uploadBlockedImage();
      await _setupBlocked(blockedImage);
      return await _setupPage();
    } else {
      return PageWithTextBuilder(
        uniqueId,
        'Blocked',
        'Blocked',
        'You are blocked',
        pageId,
        app,
        memberId,
        theHomeMenu,
        theAppBar,
        leftDrawer,
        rightDrawer,
      ).create();
    }
  }
}
