import 'dart:async';

import 'package:eliud_core_main/storage/public_medium_helper.dart';
import 'package:eliud_core_main/wizards/tools/document_identifier.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:eliud_core_main/model/public_medium_model.dart';
import 'package:eliud_core_helpers/etc/random.dart';

class PdfPolicyMediumBuilder {
  final String uniqueId;
  final AppModel app;
  final String memberId;

  PdfPolicyMediumBuilder(this.uniqueId, this.app, this.memberId);

// Policy
  String policiesAssetLocation() =>
      'packages/eliud_pkg_wizards/assets/new_app/legal/policies.pdf';

  Future<PublicMediumModel> create() async {
    var policyID = 'policy_id';
    var policy = await _uploadPublicPdf(
      app,
      memberId,
      policiesAssetLocation(),
      policyID,
    );
    return policy;
  }

  Future<PublicMediumModel> _uploadPublicPdf(
    AppModel app,
    String memberId,
    String assetPath,
    String documentID,
    /*FeedbackProgress? feedbackProgress*/
  ) async {
    String memberMediumDocumentID = newRandomKey();

    var completer = Completer<PublicMediumModel>();
    await PublicMediumHelper(
      app,
      memberId,
    ).createThumbnailUploadPdfAsset(
        constructDocumentId(
            uniqueId: uniqueId, documentId: memberMediumDocumentID),
        assetPath,
        documentID,
        feedbackProgress: (feedback) {}, feedbackFunction: (value) {
      completer.complete(value);
    });
    return await completer.future;
  }
}
