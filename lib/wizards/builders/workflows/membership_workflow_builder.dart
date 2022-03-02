import 'package:eliud_core/core/wizards/tools/documentIdentifier.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/display_conditions_model.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_membership/membership_package.dart';
import 'package:eliud_pkg_membership/tasks/approve_membership_task_model.dart';
import 'package:eliud_pkg_membership/tasks/request_membership_task_model.dart';
import 'package:eliud_pkg_pay/tasks/creditcard_pay_type_model.dart';
import 'package:eliud_pkg_pay/tasks/fixed_amount_pay_model.dart';
import 'package:eliud_pkg_pay/tasks/manual_pay_type_model.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_model.dart';
import 'package:eliud_pkg_workflow/model/abstract_repository_singleton.dart';
import 'package:eliud_pkg_workflow/model/workflow_model.dart';
import 'package:eliud_pkg_workflow/model/workflow_notification_model.dart';
import 'package:eliud_pkg_workflow/model/workflow_task_model.dart';
import 'package:eliud_pkg_workflow/tools/action/workflow_action_model.dart';

import '../../membership_workflow_wizard.dart';

class MembershipWorkflowBuilder {
  final String uniqueId;
  final String appId;
  final MembershipParameters parameters;

  MembershipWorkflowBuilder(this.uniqueId,
      this.appId,
      {required this.parameters,
      });

  Future<void> create() async {
    if (parameters.manuallyPaidMembership) {
      await workflowRepository(appId: appId)!
          .add(_workflowForManuallyPaidMembership());
    }
    if (parameters.membershipPaidByCard) {
      await workflowRepository(appId: appId)!
          .add(_workflowForMembershipPaidByCard());
    }
  }

  WorkflowModel _workflowForManuallyPaidMembership() {
    return workflowForManuallyPaidMembership(
        amount: parameters.manualAmount,
        ccy: parameters.manualCcy,
        payTo: parameters.payTo,
        country: parameters.country,
        bankIdentifierCode: parameters.bankIdentifierCode,
        payeeIBAN: parameters.payeeIBAN,
        bankName: parameters.bankName);
  }

  WorkflowModel _workflowForMembershipPaidByCard() {
    return workflowForMembershipPaidByCard(
      amount: parameters.autoAmount,
      ccy: parameters.autoCcy,
    );
  }

  WorkflowActionModel requestMembershipAction(AppModel app) =>
      WorkflowActionModel(app,
          conditions: DisplayConditionsModel(
            privilegeLevelRequired: PrivilegeLevelRequired.NoPrivilegeRequired,
            packageCondition: MembershipPackage.MEMBER_HAS_NO_MEMBERSHIP_YET,
          ),
          workflow: _workflowForManuallyPaidMembership());

  WorkflowModel workflowForManuallyPaidMembership(
      {required double amount,
      required String ccy,
      required String payTo,
      required String country,
      required String bankIdentifierCode,
      required String payeeIBAN,
      required String bankName}) {
    return _workflowForMembership(
        "membership_paid_manually",
        "Paid Membership (manually paid)",
        20,
        "GBP",
        ManualPayTypeModel(
            payTo: payTo,
            country: country,
            bankIdentifierCode: bankIdentifierCode,
            payeeIBAN: payeeIBAN,
            bankName: bankName));
  }

  WorkflowModel workflowForMembershipPaidByCard({double? amount, String? ccy}) {
    return _workflowForMembership(
        "membership_paid_manually",
        "Paid Membership (Credit card payment)",
        20,
        "GBP",
        CreditCardPayTypeModel(requiresConfirmation: true));
  }

  WorkflowModel _workflowForMembership(String documentID, String name,
      double amount, String ccy, PayTypeModel payTypeModel) {
    return WorkflowModel(
        appId: appId,
        documentID: constructDocumentId(uniqueId: uniqueId, documentId: documentID),
        name: name,
        workflowTask: [
          WorkflowTaskModel(
            seqNumber: 1,
            documentID: "request_membership",
            responsible: WorkflowTaskResponsible.CurrentMember,
            task: RequestMembershipTaskModel(
              identifier: newRandomKey(),
              executeInstantly: false,
              description: 'Please join. It costs 20 GBP, 1 time cost',
            ),
          ),
          WorkflowTaskModel(
            seqNumber: 2,
            documentID: "pay_membership",
            responsible: WorkflowTaskResponsible.CurrentMember,
            confirmMessage: WorkflowNotificationModel(
                message:
                    "Your payment and membership request is now with the owner for review. You will be notified soon",
                addressee: WorkflowNotificationAddressee.CurrentMember),
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
            responsible: WorkflowTaskResponsible.Owner,
            confirmMessage: WorkflowNotificationModel(
                message:
                    "You payment has been verified and you're now a member. Welcome! Feedback: ",
                addressee: WorkflowNotificationAddressee.First),
            rejectMessage: WorkflowNotificationModel(
                message:
                    "You payment has been verified and unfortunately something went wrong. Feedback: ",
                addressee: WorkflowNotificationAddressee.First),
            task: ApproveMembershipTaskModel(
              identifier: newRandomKey(),
              executeInstantly: false,
              description: 'Verify payment and confirm membership',
            ),
          ),
        ]);
  }
}
