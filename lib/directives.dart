/// directives for the standard directives

library angular2_rbi_directives;

import 'package:angular2/angular2.dart';
import 'src/directives/material_button.dart' show ButtonBehavior;
import 'src/directives/material_checkbox.dart' show CheckboxBehavior;
import 'src/directives/material_data_table.dart' show DataTableBehavior;
import 'src/directives/material_icon_toggle.dart' show IconToggleBehavior;
import 'src/directives/material_layout.dart' show LayoutBehavior;
import 'src/directives/material_menu.dart' show MenuBehavior;
import 'src/directives/material_progress.dart' show ProgressBehavior;
import 'src/directives/material_radio.dart' show RadioBehavior;
import 'src/directives/material_tabs.dart' show TabsBehavior;
import 'src/directives/material_ripple.dart' show RippleBehavior;
import 'src/directives/material_slider.dart' show SliderBehavior;
import 'src/directives/material_spinner.dart' show SpinnerBehavior;
import 'src/directives/material_switch.dart' show SwitchBehavior;
import 'src/directives/material_textfield.dart' show TextfieldBehavior;
import 'src/directives/material_tooltip.dart' show TooltipBehavior;
import 'src/directives/material_snackbar.dart' show SnackbarBehavior;

@Directive(selector: '.mdl-js-button')
class MaterialButton extends ButtonBehavior implements OnInit, OnDestroy {
  MaterialButton(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-checkbox')
class MaterialCheckbox extends CheckboxBehavior implements OnInit, OnDestroy {
  MaterialCheckbox(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-data-table')
class MaterialDataTable extends DataTableBehavior implements OnInit, OnDestroy {
  MaterialDataTable(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-icon-toggle')
class MaterialIconToggle extends IconToggleBehavior implements OnInit, OnDestroy {
  MaterialIconToggle(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-layout')
class MaterialLayout extends LayoutBehavior implements OnInit, OnDestroy {
  MaterialLayout(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-menu')
class MaterialMenu extends MenuBehavior implements OnInit, OnDestroy {
  MaterialMenu(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-progress', inputs: const ['progress', 'buffer'])
class MaterialProgress extends ProgressBehavior implements OnInit, OnDestroy {
  MaterialProgress(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-radio')
class MaterialRadio extends RadioBehavior implements OnInit, OnDestroy {
  MaterialRadio(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: 'mdl-js-ripple-effect')
class MaterialRipple extends RippleBehavior implements OnInit, OnDestroy {
  MaterialRipple(ElementRef ref) : super(ref.nativeElement);
}

@Directive(
    selector: '.mdl-js-slider', inputs: const ['min', 'max', 'value', 'step'])
class MaterialSlider extends SliderBehavior implements OnInit, OnDestroy {
  MaterialSlider(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-spinner')
class MaterialSpinner extends SpinnerBehavior implements OnInit, OnDestroy {
  MaterialSpinner(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-switch')
class MaterialSwitch extends SwitchBehavior implements OnInit, OnDestroy {
  MaterialSwitch(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-tabs')
class MaterialTabs extends TabsBehavior implements OnInit, OnDestroy {
  MaterialTabs(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-textfield')
class MaterialTextfield extends TextfieldBehavior implements OnInit, OnDestroy {
  MaterialTextfield(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-tooltip')
class MaterialTooltip extends TooltipBehavior implements OnInit, OnDestroy {
  MaterialTooltip(ElementRef ref) : super(ref.nativeElement);
}

@Directive(selector: '.mdl-js-snackbar')
class MaterialSnackbar extends SnackbarBehavior implements OnInit, OnDestroy {
  MaterialSnackbar(ElementRef ref) : super(ref.nativeElement);
}
