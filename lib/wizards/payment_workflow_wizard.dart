import 'package:eliud_core/core/wizards/registry/registry.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/display_conditions_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/model/menu_item_model.dart';
import 'package:eliud_core/style/frontend/has_text.dart';
import 'package:eliud_pkg_etc/tools/bespoke_models.dart';
import 'package:eliud_pkg_shop/shop_package.dart';
import 'package:eliud_pkg_shop/tools/bespoke_models.dart';
import 'package:flutter/material.dart';

import 'builders/widgets/payment_parameters_widget.dart';
import 'builders/workflows/payment_workflow_builder.dart';

class PaymentWorkflowWizard extends NewAppWizardInfo {
  PaymentWorkflowWizard()
      : super(
          'paymentworkflow',
          'Payment Workflow',
        );

  @override
  NewAppWizardParameters newAppWizardParameters() => PaymentParameters(
        payTo: "Mr Minkey",
        country: "United Kingdom",
        bankIdentifierCode: "Bank ID Code",
        payeeIBAN: "IBAN 543232187632167",
        bankName: "Bank Of America",
        manualPaymentCart: true,
        creditCardPaymentCart: false,
      );

  @override
  List<NewAppTask>? getCreateTasks(
    AppModel app,
    NewAppWizardParameters parameters,
    MemberModel member,
    HomeMenuProvider homeMenuProvider,
    AppBarProvider appBarProvider,
    DrawerProvider leftDrawerProvider,
    DrawerProvider rightDrawerProvider,
  ) {
    if (parameters is PaymentParameters) {
      if ((parameters.creditCardPaymentCart) ||
          (parameters.manualPaymentCart)) {
        List<NewAppTask> tasks = [];
        tasks.add(() async {
          print("Payment workflow");
          await PaymentWorkflowBuilder(
            app.documentID!,
            parameters: parameters,
          ).create();
        });
        return tasks;
      }
    } else {
      throw Exception(
          'Unexpected class for parameters: ' + parameters.toString());
    }
  }

  @override
  AppModel updateApp(
    NewAppWizardParameters parameters,
    AppModel adjustMe,
  ) =>
      adjustMe;

  @override
  String? getPageID(String pageType) => null;

  @override
  ActionModel? getAction(AppModel app, String actionType) => null;
/*

  WorkflowActionModel payCart(AppModel app) => WorkflowActionModel(app,
      conditions: DisplayConditionsModel(
        privilegeLevelRequired: PrivilegeLevelRequired.NoPrivilegeRequired,
        packageCondition: ShopPackage.CONDITION_CARTS_HAS_ITEMS,
      ),
      workflow: _workflowForCreditCardPaymentCart());
*/

  @override
  List<MenuItemModel>? getMenuItemsFor(
          AppModel app, NewAppWizardParameters parameters, MenuType type) =>
      null;

  @override
  Widget wizardParametersWidget(
      AppModel app, BuildContext context, NewAppWizardParameters parameters) {
    if (parameters is PaymentParameters) {
      return PaymentParametersWidget(
        app: app,
        parameters: parameters,
      );
    } else {
      return text(app, context,
          'Unexpected class for parameters: ' + parameters.toString());
    }
  }
}

class PaymentParameters extends NewAppWizardParameters {
  bool manualPaymentCart;
  bool creditCardPaymentCart;
  String payTo;
  String country;
  String bankIdentifierCode;
  String payeeIBAN;
  String bankName;

  PaymentParameters({
    required this.manualPaymentCart,
    required this.creditCardPaymentCart,
    required this.payTo,
    required this.country,
    required this.bankIdentifierCode,
    required this.payeeIBAN,
    required this.bankName,
  }) {}
}
