import 'package:eliud_pkg_wizards/wizards_package.dart';

WizardsPackage getWizardsPackage() => WizardsWebPackage();

class WizardsWebPackage extends WizardsPackage {

  @override
  List<Object?> get props => [
  ];

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is WizardsWebPackage &&
              runtimeType == other.runtimeType;

}
