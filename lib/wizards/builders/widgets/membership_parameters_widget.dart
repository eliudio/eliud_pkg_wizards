import 'package:eliud_core/core/blocs/access/access_bloc.dart';
import 'package:eliud_core/core/blocs/access/access_event.dart';
import 'package:eliud_core/core/wizards/registry/action_specification.dart';
import 'package:eliud_core/core/wizards/widgets/action_specification_widget.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/style/frontend/has_container.dart';
import 'package:eliud_core/style/frontend/has_dialog.dart';
import 'package:eliud_core/style/frontend/has_dialog_field.dart';
import 'package:eliud_core/style/frontend/has_divider.dart';
import 'package:eliud_core/style/frontend/has_list_tile.dart';
import 'package:eliud_core/style/frontend/has_progress_indicator.dart';
import 'package:eliud_core/style/frontend/has_text.dart';
import 'package:eliud_core/tools/helpers/parse_helper.dart';
import 'package:eliud_core/tools/screen_size.dart';
import 'package:eliud_core/tools/widgets/header_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../membership_workflow_wizard.dart';

class MembershipParametersWidget extends StatefulWidget {
  final AppModel app;
  final MembershipParameters parameters;

  MembershipParametersWidget({
    Key? key,
    required this.app,
    required this.parameters,
  }) : super(key: key);

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
      if (widget.parameters.joinMedhod != JoinMethod.JoinForFree)
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
                      widget.parameters.manualAmount = double_parse(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Amount',
                      labelText: 'Amount',
                    ),
                  )),
              if (widget.parameters.joinMedhod ==
                  JoinMethod.JoinWithManualPayment)
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
                  JoinMethod.JoinWithManualPayment)
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
                  JoinMethod.JoinWithManualPayment)
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
                  JoinMethod.JoinWithManualPayment)
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
                  JoinMethod.JoinWithManualPayment)
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
