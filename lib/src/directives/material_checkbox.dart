library material_checkbox;

import 'material_ripple.dart' show RippleBehavior;
import 'dart:html';
import 'dart:async';
import 'package:angular2_rbi/src/directives/base_behavior.dart';

// css classes

const String CHECKBOX_INPUT = 'mdl-checkbox__input';
const String BOX_OUTLINE = 'mdl-checkbox__box-outline';
const String FOCUS_HELPER = 'mdl-checkbox__focus-helper';
const String TICK_OUTLINE = 'mdl-checkbox__tick-outline';
const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
const String CHECKBOX_RIPPLE_CONTAINER = 'mdl-checkbox__ripple-container';
const String RIPPLE_CENTER = 'mdl-ripple--center';
const String RIPPLE = 'mdl-ripple';
const String IS_FOCUSED = 'is-focused';
const String IS_DISABLED = 'is-disabled';
const String IS_CHECKED = 'is-checked';
const String IS_UPGRADED = 'is-upgraded';
const int TINY_TIMEOUT = 1;

class CheckboxBehavior extends BaseBehavior {
  Element element;
  InputElement inputElement;
  CheckboxBehavior(Element this.element);

  @override
  ngOnInit() {
    if (element != null) {
      if (!element.classes.contains(IS_UPGRADED)) {
        inputElement = element.querySelector('.' + CHECKBOX_INPUT);
        Element boxOutline = new SpanElement()..classes.add(BOX_OUTLINE);
        Element tickContainer = new SpanElement()..classes.add(FOCUS_HELPER);
        Element tickOutline = new SpanElement()..classes.add(TICK_OUTLINE);
        boxOutline.append(tickOutline);
        element.append(tickContainer);
        element.append(boxOutline);
        if (element.classes.contains(RIPPLE_EFFECT)) {
          element.classes.add(RIPPLE_IGNORE_EVENTS);
          Element rippleContainer = new SpanElement()
            ..classes.addAll(
                [CHECKBOX_RIPPLE_CONTAINER, RIPPLE_EFFECT, RIPPLE_CENTER]);
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
          element.onMouseUp.listen(onMouseUp)
        ]);
        // wait a click for angular2 to set value
        Timer.run(() {
          updateClasses();
          element.classes.add(IS_UPGRADED);
        });
      }
    }
  }

  onChange(Event event) {
    updateClasses();
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

  onMouseUp(Event event) {
    blur();
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

  disable() {
    inputElement.disabled = true;
    updateClasses();
  }

  enable() {
    inputElement.disabled = false;
    updateClasses();
  }

  check() {
    inputElement.checked = true;
    updateClasses();
  }

  uncheck() {
    inputElement.checked = false;
    updateClasses();
  }
}
