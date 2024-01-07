import 'package:eliud_core/access/access_bloc.dart';
import 'package:eliud_core_main/apis/wizard_api/new_app_wizard_info.dart';
import 'package:eliud_core_main/apis/apis.dart';
import 'package:eliud_core/core_package.dart';
import 'package:eliud_core/eliud.dart';
import 'package:eliud_core_main/tools/etc/member_collection_info.dart';
import 'package:eliud_core_model/model/access_model.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:eliud_core_main/model/member_model.dart';
import 'package:eliud_core/package/package.dart';
import 'package:eliud_pkg_etc/etc_package.dart';
import 'package:eliud_pkg_fundamentals/fundamentals_package.dart';
import 'package:eliud_pkg_membership/membership_package.dart';
import 'package:eliud_pkg_pay/pay_package.dart';
import 'package:eliud_pkg_shop/shop_package.dart';
import 'package:eliud_pkg_text/text_package.dart';
import 'package:eliud_pkg_wizards/wizards/membership_workflow_wizard.dart';
import 'package:eliud_pkg_wizards/wizards/new_policy_wizard.dart';
import 'package:eliud_pkg_workflow/workflow_package.dart';
import 'wizards/about_page_wizard.dart';
import 'wizards/blocked_page_wizard.dart';

import 'package:eliud_pkg_wizards/wizards_package_stub.dart'
    if (dart.library.io) 'wizards_mobile_package.dart'
    if (dart.library.html) 'wizards_web_package.dart';

abstract class WizardsPackage extends Package {
  WizardsPackage() : super('eliud_pkg_wizards');

  @override
  Future<List<PackageConditionDetails>>? getAndSubscribe(
          AccessBloc accessBloc,
          AppModel app,
          MemberModel? member,
          bool isOwner,
          bool? isBlocked,
          PrivilegeLevel? privilegeLevel) =>
      null;

  @override
  List<String>? retrieveAllPackageConditions() => null;

  @override
  void init() {
    // wizards
    Apis.apis().getWizardApi().register(BlockedPageWizard());
    Apis.apis().getWizardApi().register(AboutPageWizard());
    Apis.apis().getWizardApi().register(NewPolicyWizard());
    // Apis.apis().getWizardApi().register(NewPolicyFromPdfWizard());
    Apis.apis().getWizardApi().register(MembershipWorkflowWizard());
  }

  @override
  List<MemberCollectionInfo>? getMemberCollectionInfo() => null;

  static WizardsPackage instance() => getWizardsPackage();

  /*
   * Register depending packages
   */
  @override
  void registerDependencies(Eliud eliud) {
    eliud.registerPackage(CorePackage.instance());
    eliud.registerPackage(TextPackage.instance());
    eliud.registerPackage(FundamentalsPackage.instance());
    eliud.registerPackage(EtcPackage.instance());
    eliud.registerPackage(ShopPackage.instance());
    eliud.registerPackage(MembershipPackage.instance());
    eliud.registerPackage(WorkflowPackage.instance());
    eliud.registerPackage(PayPackage.instance());
  }
}
