import 'package:eliud_core/core/blocs/access/access_bloc.dart';
import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core/model/access_model.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/package/package.dart';
import 'package:eliud_pkg_wizards/wizards/membership_workflow_wizard.dart';
import 'package:eliud_pkg_wizards/wizards/new_policy_from_pdf_wizard.dart';
import 'package:eliud_pkg_wizards/wizards/new_policy_wizard.dart';
import 'wizards/about_page_wizard.dart';
import 'wizards/blocked_page_wizard.dart';

import 'package:eliud_pkg_wizards/wizards_package_stub.dart'
if (dart.library.io) 'wizards_mobile_package.dart'
if (dart.library.html) 'wizards_web_package.dart';

abstract class WizardsPackage extends Package {
  WizardsPackage() : super('eliud_pkg_wizards');

  @override
  Future<List<PackageConditionDetails>>? getAndSubscribe(AccessBloc accessBloc, AppModel app, MemberModel? member, bool isOwner, bool? isBlocked, PrivilegeLevel? privilegeLevel) => null;

  @override
  List<String>? retrieveAllPackageConditions() => null;

  @override
  void init() {
    // wizards
    NewAppWizardRegistry.registry().register(BlockedPageWizard());
    NewAppWizardRegistry.registry().register(AboutPageWizard());
    NewAppWizardRegistry.registry().register(NewPolicyWizard());
    // NewAppWizardRegistry.registry().register(NewPolicyFromPdfWizard());
    NewAppWizardRegistry.registry().register(MembershipWorkflowWizard());
 }

  @override
  List<MemberCollectionInfo>? getMemberCollectionInfo() => null;

  static WizardsPackage instance() => getWizardsPackage();
}
