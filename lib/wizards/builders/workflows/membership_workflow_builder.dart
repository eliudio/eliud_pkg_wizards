import 'package:eliud_core/core/wizards/tools/document_identifier.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_membership/tasks/approve_membership_task_model.dart';
import 'package:eliud_pkg_membership/tasks/request_membership_task_model.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_types/creditcard_pay_type_model.dart';
import 'package:eliud_pkg_pay/tasks/fixed_amount_pay_model.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_types/manual_pay_type_model.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_types/pay_type_model.dart';
import 'package:eliud_pkg_workflow/model/abstract_repository_singleton.dart';
import 'package:eliud_pkg_workflow/model/workflow_model.dart';
import 'package:eliud_pkg_workflow/model/workflow_notification_model.dart';
import 'package:eliud_pkg_workflow/model/workflow_task_model.dart';

import '../../membership_workflow_wizard.dart';

class MembershipWorkflowBuilder {
  final String uniqueId;
  final String appId;
  final MembershipParameters parameters;

  MembershipWorkflowBuilder(
    this.uniqueId,
    this.appId, {
    required this.parameters,
  });

  Future<void> create() async {
    if (parameters.joinMedhod == JoinMethod.joinWithManualPayment) {
      await workflowRepository(appId: appId)!.add(_workflowForMembership(
          "Paid Membership (manually paid)",
          parameters.manualAmount,
          parameters.manualCcy,
          ManualPayTypeModel(
              payTo: parameters.payTo,
              country: parameters.country,
              bankIdentifierCode: parameters.bankIdentifierCode,
              payeeIBAN: parameters.payeeIBAN,
              bankName: parameters.bankName)));
    } else if (parameters.joinMedhod == JoinMethod.joinByCard) {
      await workflowRepository(appId: appId)!.add(_workflowForMembership(
          "Paid Membership (Credit card payment)",
          parameters.manualAmount,
          parameters.manualCcy,
          CreditCardPayTypeModel(requiresConfirmation: true)));
    } else if (parameters.joinMedhod == JoinMethod.joinForFree) {
      await workflowRepository(appId: appId)!.add(_workflowForFreeMembership());
    }
  }

  static String membershipId = 'membership';

  WorkflowModel _workflowForMembership(
      String name, double amount, String ccy, PayTypeModel payTypeModel) {
    return WorkflowModel(
        appId: appId,
        documentID:
            constructDocumentId(uniqueId: uniqueId, documentId: membershipId),
        name: name,
        workflowTask: [
          WorkflowTaskModel(
            seqNumber: 1,
            documentID: "request_membership",
            responsible: WorkflowTaskResponsible.currentMember,
            task: RequestMembershipTaskModel(
              identifier: newRandomKey(),
              executeInstantly: false,
              description: 'Please join. It costs 20 GBP, 1 time cost',
            ),
          ),
          WorkflowTaskModel(
            seqNumber: 2,
            documentID: "pay_membership",
            responsible: WorkflowTaskResponsible.currentMember,
            confirmMessage: WorkflowNotificationModel(
                message:
                    "Your payment and membership request is now with the owner for review. You will be notified soon",
                addressee: WorkflowNotificationAddressee.currentMember),
            rejectMessage: null,
            task: FixedAmountPayModel(
                identifier: newRandomKey(),
                executeInstantly: true,
                description: 'To join, pay 20 GBP',
                paymentType: payTypeModel,
                ccy: ccy,
                amount: amount),
          ),
          WorkflowTaskModel(
            seqNumber: 3,
            documentID: "confirm_membership",
            responsible: WorkflowTaskResponsible.owner,
            confirmMessage: WorkflowNotificationModel(
                message:
                    "You payment has been verified and you're now a member. Welcome! Feedback: ",
                addressee: WorkflowNotificationAddressee.first),
            rejectMessage: WorkflowNotificationModel(
                message:
                    "You payment has been verified and unfortunately something went wrong. Feedback: ",
                addressee: WorkflowNotificationAddressee.first),
            task: ApproveMembershipTaskModel(
              identifier: newRandomKey(),
              executeInstantly: false,
              description: 'Verify payment and confirm membership',
            ),
          ),
        ]);
  }

  // Unfortunately we need this dummy workflow for the sole purpose to refer to the workflow from a menu item
  static dummyWorkflowModel(String appId, String uniqueId) {
    return WorkflowModel(
        appId: appId,
        documentID:
            constructDocumentId(uniqueId: uniqueId, documentId: membershipId));
  }

  WorkflowModel _workflowForFreeMembership() {
    return WorkflowModel(
        appId: appId,
        documentID:
            constructDocumentId(uniqueId: uniqueId, documentId: membershipId),
        name: 'Free membership',
        workflowTask: [
          WorkflowTaskModel(
            seqNumber: 1,
            documentID: "request_membership",
            responsible: WorkflowTaskResponsible.currentMember,
            task: RequestMembershipTaskModel(
              identifier: newRandomKey(),
              executeInstantly: false,
              description: 'Please join. It costs 20 GBP, 1 time cost',
            ),
          ),
          WorkflowTaskModel(
            seqNumber: 2,
            documentID: "confirm_membership",
            responsible: WorkflowTaskResponsible.owner,
            confirmMessage: WorkflowNotificationModel(
                message:
                    "You payment has been verified and you're now a member. Welcome! Feedback: ",
                addressee: WorkflowNotificationAddressee.first),
            rejectMessage: WorkflowNotificationModel(
                message:
                    "You payment has been verified and unfortunately something went wrong. Feedback: ",
                addressee: WorkflowNotificationAddressee.first),
            task: ApproveMembershipTaskModel(
              identifier: newRandomKey(),
              executeInstantly: false,
              description: 'Verify payment and confirm membership',
            ),
          ),
        ]);
  }
}
