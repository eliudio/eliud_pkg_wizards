import 'package:eliud_core/core/wizards/tools/document_identifier.dart';
import 'package:eliud_core/model/abstract_repository_singleton.dart';
import 'package:eliud_core/model/app_policy_model.dart';
import 'package:eliud_core/model/platform_medium_model.dart';
import 'package:eliud_core/model/storage_conditions_model.dart';

class AppPolicyBuilder {
  final String uniqueId;
  final String appId;
  final String memberId;
  PlatformMediumModel policy;

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
              PrivilegeLevelRequiredSimple.noPrivilegeRequiredSimple),
    );
  }

  Future<AppPolicyModel> create() async {
    var policyModel = await _getAppPolicy();
    await appPolicyRepository(appId: appId)!.add(policyModel);
    return policyModel;
  }
}
