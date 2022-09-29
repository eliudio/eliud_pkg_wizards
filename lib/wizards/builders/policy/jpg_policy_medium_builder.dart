import 'dart:async';

import 'package:eliud_core/core/wizards/tools/documentIdentifier.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/platform_medium_model.dart';
import 'package:eliud_core/model/public_medium_model.dart';
import 'package:eliud_core/model/storage_conditions_model.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_core/tools/storage/platform_medium_helper.dart';
import 'package:eliud_core/tools/storage/public_medium_helper.dart';
import 'package:eliud_core/tools/storage/upload_info.dart';

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
    var policy = await _uploadPublicJpg(
        app, memberId, policiesAssetLocation(), policyID, );
    return policy;
  }

  Future<PlatformMediumModel> _uploadPublicJpg(
      AppModel app,
      String memberId,
      String assetPath,
      String documentID,
      /*FeedbackProgress? feedbackProgress*/) async {
    String memberMediumDocumentID = newRandomKey();

    return await PlatformMediumHelper(app, memberId, PrivilegeLevelRequiredSimple.NoPrivilegeRequiredSimple)
        .createThumbnailUploadPhotoAsset(
        constructDocumentId(uniqueId: uniqueId, documentId: memberMediumDocumentID), assetPath,
        feedbackProgress: (feedback) {}, );
  }
}
