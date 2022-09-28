import 'package:eliud_core/core/wizards/tools/documentIdentifier.dart';
import 'package:eliud_core/model/abstract_repository_singleton.dart';
import 'package:eliud_core/model/app_policy_model.dart';
import 'package:eliud_core/model/page_model.dart';
import 'package:eliud_core/model/platform_medium_model.dart';
import 'package:eliud_core/model/public_medium_model.dart';
import 'package:eliud_core/model/storage_conditions_model.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_core/tools/storage/platform_medium_helper.dart';
import 'package:eliud_core/tools/storage/upload_info.dart';

class AppPolicyBuilder {
  final String uniqueId;
  final String appId;
  final String memberId;
  PublicMediumModel policy;

  AppPolicyBuilder(
    this.uniqueId,
    this.appId,
    this.memberId,
    this.policy,
  );

  Future<AppPolicyModel> _getAppPolicy() async {
    return AppPolicyModel(
      documentID:
          constructDocumentId(uniqueId: uniqueId, documentId: 'policies'),
      appId: appId,
      name: 'Policy',
      policy: policy,
      conditions: StorageConditionsModel(
          privilegeLevelRequired:
              PrivilegeLevelRequiredSimple.NoPrivilegeRequiredSimple),
    );
  }

  Future<AppPolicyModel> create() async {
    var policyModel = await _getAppPolicy();
    await appPolicyRepository(appId: appId)!.add(policyModel);
    return policyModel;
  }
}
