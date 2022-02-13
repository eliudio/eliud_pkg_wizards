
import 'package:eliud_core/package/package.dart';
import 'package:eliud_pkg_wizards/wizards_package.dart';

class WizardsMobilePackage extends WizardsPackage {

  @override
  List<Object?> get props => [
  ];

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is WizardsMobilePackage &&
              runtimeType == other.runtimeType;

}
