import 'package:eliud_core/core/wizards/builders/page_builder.dart';
import 'package:eliud_core/core/wizards/tools/document_identifier.dart';
import 'package:eliud_core/model/abstract_repository_singleton.dart'
    as corerepo;
import 'package:eliud_core/model/app_policy_model.dart';
import 'package:eliud_core/model/body_component_model.dart';
import 'package:eliud_core/model/page_model.dart';
import 'package:eliud_core/model/storage_conditions_model.dart';
import 'package:eliud_pkg_etc/model/abstract_repository_singleton.dart';
import 'package:eliud_pkg_etc/model/policy_presentation_component.dart';
import 'package:eliud_pkg_etc/model/policy_presentation_model.dart';

class PolicyPageBuilder extends PageBuilder {
  final AppPolicyModel appPolicy;
  final String title;
  final String description;

  PolicyPageBuilder(
    super.uniqueId,
    super.pageId,
    super.app,
    super.memberId,
    super.theHomeMenu,
    super.theAppBar,
    super.leftDrawer,
    super.rightDrawer,
    this.appPolicy,
    this.title,
    this.description,
  );

  PolicyPresentationModel _getPesentationModel() {
    var ppm = PolicyPresentationModel(
      documentID: constructDocumentId(
          uniqueId: uniqueId, documentId: appPolicy.documentID),
      appId: app.documentID,
      description: title,
      policies: appPolicy,
      conditions: StorageConditionsModel(
          privilegeLevelRequired:
              PrivilegeLevelRequiredSimple.noPrivilegeRequiredSimple),
    );
    return ppm;
  }

  Future<PolicyPresentationModel> _createPresentationComponent() async {
    var ppm = _getPesentationModel();
    var ppr = policyPresentationRepository(appId: app.documentID)!;
    return await ppr.add(ppm);
  }

  Future<PageModel> _setupPage() async {
    return await corerepo.AbstractRepositorySingleton.singleton
        .pageRepository(app.documentID)!
        .add(_page());
  }

  PageModel _page() {
    List<BodyComponentModel> components = [
      BodyComponentModel(
          documentID: appPolicy.documentID,
          componentName: AbstractPolicyPresentationComponent.componentName,
          componentId: constructDocumentId(
              uniqueId: uniqueId, documentId: appPolicy.documentID))
    ];

    return PageModel(
        documentID: constructDocumentId(uniqueId: uniqueId, documentId: pageId),
        appId: app.documentID,
        title: title,
        description: description,
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

  Future<PageModel> create() async {
    await _createPresentationComponent();
    return await _setupPage();
  }
}
