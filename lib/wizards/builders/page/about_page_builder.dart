import 'package:eliud_core_main/wizards/builders/page_builder.dart';
import 'package:eliud_core_main/wizards/tools/document_identifier.dart';
import 'package:eliud_core_main/model/abstract_repository_singleton.dart'
    as mainrepo;
import 'package:eliud_core_main/model/app_bar_model.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:eliud_core_main/model/body_component_model.dart';
import 'package:eliud_core_main/model/drawer_model.dart';
import 'package:eliud_core_main/model/home_menu_model.dart';
import 'package:eliud_core_main/model/page_model.dart';
import 'package:eliud_core_main/model/platform_medium_model.dart';
import 'package:eliud_core_main/model/storage_conditions_model.dart';
import 'package:eliud_core_helpers/etc/random.dart';
import 'package:eliud_core_main/storage/platform_medium_helper.dart';
import 'package:eliud_pkg_fundamentals_model/model/abstract_repository_singleton.dart';
import 'package:eliud_pkg_fundamentals_model/model/booklet_component.dart';
import 'package:eliud_pkg_fundamentals_model/model/booklet_model.dart';
import 'package:eliud_pkg_fundamentals_model/model/link_model.dart';
import 'package:eliud_pkg_fundamentals_model/model/section_model.dart';
import 'package:eliud_pkg_text/wizards/builders/page/page_with_text.dart';

class AboutPageBuilder extends PageBuilder {
  final String componentId;
  final String? aboutAssetLocation;
  final double imageWidth = 0.3;
  final RelativeImagePosition imagePosition = RelativeImagePosition.aside;
  final SectionImageAlignment alignment = SectionImageAlignment.left;

  AboutPageBuilder(
    String uniqueId,
    this.componentId,
    this.aboutAssetLocation,
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
      componentId:
          constructDocumentId(uniqueId: uniqueId, documentId: componentId),
    ));

    return PageModel(
        documentID: constructDocumentId(uniqueId: uniqueId, documentId: pageId),
        appId: app.documentID,
        title: "About",
        description: "About",
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

  Future<String?> _store(PlatformMediumModel platformMediumModel) async {
    return (await AbstractRepositorySingleton.singleton
            .bookletRepository(app.documentID)!
            .add(_header(platformMediumModel)))
        .documentID;
  }

  Future<PlatformMediumModel> installAboutImage() async {
    return await PlatformMediumHelper(app, memberId,
            PrivilegeLevelRequiredSimple.noPrivilegeRequiredSimple)
        .createThumbnailUploadPhotoAsset(newRandomKey(), aboutAssetLocation!);
  }

  static String title = 'About me';
  static String description = 'About me';
  static String text =
      "Welcome to my new app. .\n\nMy name is X. .\n\nI am the founder of Y. I enjoy making nice things and people love my litte pieces of art. So, one day I decided to share my products with the wider world. That's how Y was created. I hope you enjoy my shop.\n\nX";

  BookletModel _header(PlatformMediumModel memberMediumModel) {
    List<SectionModel> entries = [];
    {
      List<LinkModel> links = [];
      entries.add(SectionModel(
          documentID: "1",
          title: "About me",
          description: description,
          image: memberMediumModel,
          imagePositionRelative: imagePosition,
          imageAlignment: alignment,
          imageWidth: imageWidth,
          links: links));
    }

    return BookletModel(
      documentID:
          constructDocumentId(uniqueId: uniqueId, documentId: componentId),
      description: "About",
      sections: entries,
      appId: app.documentID,
      conditions: StorageConditionsModel(
          privilegeLevelRequired:
              PrivilegeLevelRequiredSimple.noPrivilegeRequiredSimple),
    );
  }

  Future<PageModel> create() async {
    if (aboutAssetLocation != null) {
      var image = await installAboutImage();
      await _store(image);
      return await _setupPage();
    } else {
      return PageWithTextBuilder(
        uniqueId,
        title,
        description,
        text,
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
