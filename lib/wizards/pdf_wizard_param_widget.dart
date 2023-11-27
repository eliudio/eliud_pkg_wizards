import 'package:eliud_core_main/apis/wizard_api/action_specification_widget.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:eliud_core_main/apis/style/frontend/has_container.dart';
import 'package:eliud_core_main/apis/style/frontend/has_dialog_field.dart';
import 'package:eliud_core_main/apis/style/frontend/has_list_tile.dart';
import 'package:flutter/material.dart';

import 'new_policy_from_pdf_wizard.dart';

class PdfWizardParametersWidget extends StatefulWidget {
  final AppModel app;
  final NewPolicyFromPdfParameters parameters;

  PdfWizardParametersWidget({
    super.key,
    required this.app,
    required this.parameters,
  });

  @override
  State<StatefulWidget> createState() {
    return _PdfWizardParametersWidgetState();
  }
}

class _PdfWizardParametersWidgetState extends State<PdfWizardParametersWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
      ActionSpecificationWidget(
          app: widget.app,
          actionSpecification: widget.parameters.actionSpecifications,
          label: 'Generate Page'),
      topicContainer(widget.app, context,
          title: 'Shop Page Image',
          collapsible: true,
          collapsed: true,
          children: [
            getListTile(context, widget.app,
                leading: Icon(Icons.description),
                title: dialogField(
                  widget.app,
                  context,
                  initialValue: widget.parameters.baseName ?? "policy",
                  valueChanged: (value) {
                    widget.parameters.baseName = value;
                  },
                  maxLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Base name',
                    labelText: 'Base name',
                  ),
                )),
            getListTile(context, widget.app,
                leading: Icon(Icons.description),
                title: dialogField(
                  widget.app,
                  context,
                  initialValue: widget.parameters.pdfUrl ??
                      "http://www.xyz.com/policy.pdf",
                  valueChanged: (value) {
                    widget.parameters.pdfUrl = value;
                  },
                  maxLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Url of pdf',
                    labelText: 'Url of pdf',
                  ),
                )),
          ]),
    ]);
  }
}
