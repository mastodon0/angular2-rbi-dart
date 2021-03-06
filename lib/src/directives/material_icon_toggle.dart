library material_icon_toggle;

import 'material_ripple.dart' show RippleBehavior;
import 'dart:html';
import 'dart:async';
import 'package:angular2_rbi/src/directives/base_behavior.dart';

const String ICON_TOGGLE_INPUT = 'mdl-icon-toggle__input';
const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
const String ICON_TOGGLE_RIPPLE_CONTAINER = 'mdl-icon-toggle__ripple-container';
const String RIPPLE_CENTER = 'mdl-ripple--center';
const String RIPPLE = 'mdl-ripple';
const String IS_FOCUSED = 'is-focused';
const String IS_DISABLED = 'is-disabled';
const String IS_CHECKED = 'is-checked';
const String IS_UPGRADED = 'is-upgraded';

class IconToggleBehavior extends BaseBehavior {
  Element element;
  InputElement inputElement;

  IconToggleBehavior(this.element);

  @override
  ngOnInit() {
    inputElement = element.querySelector('.' + ICON_TOGGLE_INPUT);

    if (element.classes.contains(RIPPLE_EFFECT)) {
      element.classes.add(RIPPLE_IGNORE_EVENTS);
      Element rippleContainer = new SpanElement()
        ..classes.addAll(
            [ICON_TOGGLE_RIPPLE_CONTAINER, RIPPLE_EFFECT, RIPPLE_CENTER]);
      subscriptions.add(rippleContainer.onMouseUp.listen(onMouseUp));
      Element ripple = new SpanElement()..classes.add(RIPPLE);
      rippleContainer.append(ripple);
      element.append(rippleContainer);
      RippleBehavior rb = new RippleBehavior(rippleContainer);
      children.add(rb);
      rb.ngOnInit();
    }
    subscriptions.addAll([
      inputElement.onChange.listen(onChange),
      inputElement.onFocus.listen(onFocus),
      inputElement.onBlur.listen(onBlur),
      inputElement.onMouseUp.listen(onMouseUp)
    ]);
    // wait a click for Angular to set values
    Timer.run(() {
      updateClasses();
      element.classes.add(IS_UPGRADED);
    });
  }
  onMouseUp(Event event) {
    blur();
  }

  onFocus(Event event) {
    element.classes.add(IS_FOCUSED);
  }

  onBlur(Event event) {
    element.classes.remove(IS_FOCUSED);
  }

  blur() {
    Timer.run(() {
      inputElement.blur();
    });
  }

  updateClasses() {
    checkDisabled();
    checkToggleState();
  }

  checkToggleState() {
    if (inputElement.checked) {
      element.classes.add(IS_CHECKED);
    } else {
      element.classes.remove(IS_CHECKED);
    }
  }

  checkDisabled() {
    if (inputElement.disabled) {
      element.classes.add(IS_DISABLED);
    } else {
      element.classes.remove(IS_DISABLED);
    }
  }

  onChange(Event event) {
    updateClasses();
  }

  disable() {
    inputElement.disabled = true;
  }

  enable() {
    inputElement.disabled = false;
  }

  check() {
    inputElement.checked = true;
  }

  uncheck() {
    inputElement.checked = false;
  }
}
