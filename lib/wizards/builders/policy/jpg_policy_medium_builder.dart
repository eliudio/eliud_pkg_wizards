import 'dart:async';

import 'package:eliud_core_main/wizards/tools/document_identifier.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:eliud_core_main/model/platform_medium_model.dart';
import 'package:eliud_core_main/model/storage_conditions_model.dart';
import 'package:eliud_core_helpers/etc/random.dart';
import 'package:eliud_core_main/storage/platform_medium_helper.dart';

class JpgPolicyMediumBuilder {
  final String uniqueId;
  final AppModel app;
  final String memberId;

  JpgPolicyMediumBuilder(this.uniqueId, this.app, this.memberId);

// Policy
  String policiesAssetLocation() =>
      'packages/eliud_pkg_wizards/assets/new_app/legal/policies.jpg';

  Future<PlatformMediumModel> create() async {
    var policyID = 'policy_id';
    var policy = await _uploadPlatformJpg(
      app,
      memberId,
      policiesAssetLocation(),
      policyID,
    );
    return policy;
  }

  Future<PlatformMediumModel> _uploadPlatformJpg(
    AppModel app,
    String memberId,
    String assetPath,
    String documentID,
    /*FeedbackProgress? feedbackProgress*/
  ) async {
    String memberMediumDocumentID = newRandomKey();

    return await PlatformMediumHelper(app, memberId,
            PrivilegeLevelRequiredSimple.noPrivilegeRequiredSimple)
        .createThumbnailUploadPhotoAsset(
      constructDocumentId(
          uniqueId: uniqueId, documentId: memberMediumDocumentID),
      assetPath,
      feedbackProgress: (feedback) {},
    );
  }
}
