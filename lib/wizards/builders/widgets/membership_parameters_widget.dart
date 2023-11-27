import 'package:eliud_core_main/apis/wizard_api/action_specification_widget.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:eliud_core_main/apis/style/frontend/has_container.dart';
import 'package:eliud_core_main/apis/style/frontend/has_dialog_field.dart';
import 'package:eliud_core_main/apis/style/frontend/has_list_tile.dart';
import 'package:eliud_core_main/apis/style/frontend/has_text.dart';
import 'package:eliud_core_helpers/helpers/parse_helper.dart';
import 'package:flutter/material.dart';

import '../../membership_workflow_wizard.dart';

class MembershipParametersWidget extends StatefulWidget {
  final AppModel app;
  final MembershipParameters parameters;

  MembershipParametersWidget({
    super.key,
    required this.app,
    required this.parameters,
  });

  @override
  State<StatefulWidget> createState() {
    return _MembershipParametersWidgetState();
  }
}

class _MembershipParametersWidgetState
    extends State<MembershipParametersWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
      h4(widget.app, context, 'Generate a Membership Button'),
      Container(height: 20),
      ActionSpecificationWidget(
          app: widget.app,
          actionSpecification: widget.parameters.joinSpecifications,
          label: 'Join Button'),
      ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
        h4(widget.app, context, 'Join method'),
        radioListTile(
            widget.app,
            context,
            0,
            widget.parameters.joinMedhod.index,
            'Join for Free',
            'Join for Free', (int? newValue) {
          setState(() {
            widget.parameters.joinMedhod = toJoinMethod(newValue);
          });
        }),
        radioListTile(
            widget.app,
            context,
            1,
            widget.parameters.joinMedhod.index,
            'Join with manual payment',
            'Join with manual payment', (int? newValue) {
          setState(() {
            widget.parameters.joinMedhod = toJoinMethod(newValue);
          });
        }),
        radioListTile(
            widget.app,
            context,
            2,
            widget.parameters.joinMedhod.index,
            'Join with card payment',
            'Join with card payment', (int? newValue) {
          setState(() {
            widget.parameters.joinMedhod = toJoinMethod(newValue);
          });
        }),
      ]),
      if (widget.parameters.joinMedhod != JoinMethod.joinForFree)
        topicContainer(widget.app, context,
            title: 'Payment details',
            collapsible: true,
            collapsed: true,
            children: [
              getListTile(context, widget.app,
                  leading: Icon(Icons.description),
                  title: dialogField(widget.app, context,
                      initialValue: widget.parameters.manualCcy,
                      valueChanged: (value) {
                    widget.parameters.manualCcy = value;
                  },
                      decoration: const InputDecoration(
                        hintText: 'Ccy',
                        labelText: 'Ccy',
                      ),
                      keyboardType: TextInputType.number)),
              getListTile(context, widget.app,
                  leading: Icon(Icons.description),
                  title: dialogField(
                    widget.app,
                    context,
                    initialValue: widget.parameters.manualAmount.toString(),
                    valueChanged: (value) {
                      widget.parameters.manualAmount = doubleParse(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Amount',
                      labelText: 'Amount',
                    ),
                  )),
              if (widget.parameters.joinMedhod ==
                  JoinMethod.joinWithManualPayment)
                getListTile(context, widget.app,
                    leading: Icon(Icons.description),
                    title: dialogField(
                      widget.app,
                      context,
                      initialValue: widget.parameters.payTo,
                      valueChanged: (value) {
                        widget.parameters.payTo = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Pay To',
                        labelText: 'Pay To',
                      ),
                    )),
              if (widget.parameters.joinMedhod ==
                  JoinMethod.joinWithManualPayment)
                getListTile(context, widget.app,
                    leading: Icon(Icons.description),
                    title: dialogField(
                      widget.app,
                      context,
                      initialValue: widget.parameters.country,
                      valueChanged: (value) {
                        widget.parameters.country = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Country',
                        labelText: 'Country',
                      ),
                    )),
              if (widget.parameters.joinMedhod ==
                  JoinMethod.joinWithManualPayment)
                getListTile(context, widget.app,
                    leading: Icon(Icons.description),
                    title: dialogField(
                      widget.app,
                      context,
                      initialValue: widget.parameters.bankIdentifierCode,
                      valueChanged: (value) {
                        widget.parameters.bankIdentifierCode = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Bank Identifier Code',
                        labelText: 'Bank Identifier Code',
                      ),
                    )),
              if (widget.parameters.joinMedhod ==
                  JoinMethod.joinWithManualPayment)
                getListTile(context, widget.app,
                    leading: Icon(Icons.description),
                    title: dialogField(
                      widget.app,
                      context,
                      initialValue: widget.parameters.payeeIBAN,
                      valueChanged: (value) {
                        widget.parameters.payeeIBAN = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Payee IBAN',
                        labelText: 'Payee IBAN',
                      ),
                    )),
              if (widget.parameters.joinMedhod ==
                  JoinMethod.joinWithManualPayment)
                getListTile(context, widget.app,
                    leading: Icon(Icons.description),
                    title: dialogField(
                      widget.app,
                      context,
                      initialValue: widget.parameters.bankName,
                      valueChanged: (value) {
                        widget.parameters.bankName = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Bank Name',
                        labelText: 'Bank Name',
                      ),
                    )),
            ]),
    ]);
  }
}
