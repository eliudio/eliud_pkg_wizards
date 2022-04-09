import 'package:eliud_core/core/wizards/builders/page_builder.dart';
import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core/core/wizards/tools/documentIdentifier.dart';
import 'package:eliud_core/model/abstract_repository_singleton.dart'
    as corerepo;
import 'package:eliud_core/model/app_bar_model.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/body_component_model.dart';
import 'package:eliud_core/model/drawer_model.dart';
import 'package:eliud_core/model/home_menu_model.dart';
import 'package:eliud_core/model/page_model.dart';
import 'package:eliud_core/model/public_medium_model.dart';
import 'package:eliud_core/model/storage_conditions_model.dart';
import 'package:eliud_pkg_etc/model/abstract_repository_singleton.dart';
import 'package:eliud_pkg_etc/model/policy_presentation_component.dart';
import 'package:eliud_pkg_etc/model/policy_presentation_model.dart';

class PolicyPageBuilder extends PageBuilder {
  final PublicMediumModel policy;
  final String title;

  PolicyPageBuilder(
      String uniqueId,
    String pageId,
    AppModel app,
    String memberId,
    HomeMenuModel theHomeMenu,
    AppBarModel theAppBar,
    DrawerModel leftDrawer,
    DrawerModel rightDrawer,
    this.policy,
    this.title,
  ) : super(uniqueId, pageId, app, memberId, theHomeMenu, theAppBar, leftDrawer,
            rightDrawer, );

  PolicyPresentationModel _getPesentationModel(
      PublicMediumModel? policyModel) {
    return PolicyPresentationModel(
      documentID: constructDocumentId(uniqueId: uniqueId, documentId: policy.documentID!),
      appId: app.documentID!,
      description: title,
      policy: policyModel,
      conditions: StorageConditionsModel(
          privilegeLevelRequired:
              PrivilegeLevelRequiredSimple.NoPrivilegeRequiredSimple),
    );
  }

  Future<PolicyPresentationModel> _createPresentationComponent(
      PublicMediumModel? policyModel) async {
    return await policyPresentationRepository(appId: app.documentID!)!
        .add(_getPesentationModel(policyModel));
  }

  Future<PageModel> _setupPage() async {
    return await corerepo.AbstractRepositorySingleton.singleton
        .pageRepository(app.documentID!)!
        .add(_page());
  }

  PageModel _page() {
    List<BodyComponentModel> components = [
      BodyComponentModel(
          documentID: policy.documentID,
          componentName: AbstractPolicyPresentationComponent.componentName,
          componentId: constructDocumentId(uniqueId: uniqueId, documentId: policy.documentID!))
    ];

    return PageModel(
        documentID: constructDocumentId(uniqueId: uniqueId, documentId: pageId),
        appId: app.documentID!,
        title: title,
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

  Future<PageModel> create() async {
    await _createPresentationComponent(policy);
    return await _setupPage();
  }
}
