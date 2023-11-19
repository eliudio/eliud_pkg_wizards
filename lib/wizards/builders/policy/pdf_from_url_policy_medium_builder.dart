import 'dart:async';

import 'package:eliud_core/core/wizards/tools/document_identifier.dart';
import 'package:eliud_core_model/model/app_model.dart';
import 'package:eliud_core/model/platform_medium_model.dart';
import 'package:eliud_core_model/model/storage_conditions_model.dart';
import 'package:eliud_core_model/tools/etc/random.dart';
import 'package:eliud_core/tools/storage/platform_medium_helper.dart';

class PdfFromUrlPolicyMediumBuilder {
  final String pdfUrl;
  final String baseName;
  final String uniqueId;
  final AppModel app;
  final String memberId;

  PdfFromUrlPolicyMediumBuilder(
      this.pdfUrl, this.baseName, this.uniqueId, this.app, this.memberId);

  Future<PlatformMediumModel> create() async {
    var policyID = 'policy_id';
    var policy = await _uploadPublicPdf(
      app,
      memberId,
      policyID,
    );
    return policy;
  }

  Future<PlatformMediumModel> _uploadPublicPdf(
    AppModel app,
    String memberId,
    String documentID,
    /*FeedbackProgress? feedbackProgress*/
  ) async {
    String memberMediumDocumentID = newRandomKey();

    return await PlatformMediumHelper(app, memberId,
            PrivilegeLevelRequiredSimple.noPrivilegeRequiredSimple)
        .createThumbnailUploadPdfFromUrl(
      constructDocumentId(
          uniqueId: uniqueId, documentId: memberMediumDocumentID),
      pdfUrl,
      baseName,
      documentID,
      feedbackProgress: (feedback) {},
    );
  }
}
