import 'package:eliud_pkg_wizards/wizards_package.dart';

WizardsPackage getWizardsPackage() => WizardsMobilePackage();

class WizardsMobilePackage extends WizardsPackage {
  @override
  List<Object?> get props => [];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WizardsMobilePackage && runtimeType == other.runtimeType;

  @override
  int get hashCode => packageName.hashCode;
}
