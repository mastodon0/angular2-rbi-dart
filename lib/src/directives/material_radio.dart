library material_radio;

import 'material_ripple.dart' show RippleBehavior;
import 'dart:html';
import 'dart:async' show Timer;
import 'package:angular2_rbi/src/directives/base_behavior.dart';

// css classes
const String JS_RADIO = 'mdl-js-radio';
const String RADIO_BTN = 'mdl-radio__button';
const String RADIO_OUTER_CIRCLE = 'mdl-radio__outer-circle';
const String RADIO_INNER_CIRCLE = 'mdl-radio__inner-circle';
const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
const String RADIO_RIPPLE_CONTAINER = 'mdl-radio__ripple-container';
const String RIPPLE_CENTER = 'mdl-ripple--center';
const String RIPPLE = 'mdl-ripple';
const String IS_FOCUSED = 'is-focused';
const String IS_DISABLED = 'is-disabled';
const String IS_CHECKED = 'is-checked';
const String IS_UPGRADED = 'is-upgraded';

class RadioBehavior extends BaseBehavior {
  Element element;
  InputElement buttonElement;

  RadioBehavior(this.element);

  @override
  ngOnInit() {
    buttonElement = element.querySelector('.' + RADIO_BTN);

    Element outerCircle = new SpanElement()..classes.add(RADIO_OUTER_CIRCLE);
    Element innerCircle = new SpanElement()..classes.add(RADIO_INNER_CIRCLE);

    element.append(outerCircle);
    element.append(innerCircle);

    if (element.classes.contains(RIPPLE_EFFECT)) {
      element.classes.add(RIPPLE_IGNORE_EVENTS);
      element.classes.remove(RIPPLE_EFFECT);

      Element rippleContainer = new SpanElement()
        ..classes
            .addAll([RADIO_RIPPLE_CONTAINER, RIPPLE_EFFECT, RIPPLE_CENTER]);
      subscriptions.add(rippleContainer.onMouseUp.listen(onMouseup));
      Element ripple = new SpanElement()..classes.add(RIPPLE);
      rippleContainer.append(ripple);
      element.append(rippleContainer);
      RippleBehavior rb = new RippleBehavior(rippleContainer);
      children.add(rb);
      rb.ngOnInit();
    }

    //removed manually
    buttonElement.addEventListener('m-r-g-updated', onUpdated);

    subscriptions.addAll([
      buttonElement.onChange.listen(onChange),
      buttonElement.onFocus.listen(onFocus),
      buttonElement.onBlur.listen(onBlur),
      element.onMouseUp.listen(onMouseup)
    ]);

    // wait a click for angular2 to set values
    Timer.run(() {
      updateClasses();
      element.classes.add(IS_UPGRADED);
    });
  }

  onUpdated(Event event) {
    updateClasses();
  }

  onChange(Event event) {
    List<Element> radios = document.querySelectorAll('.' + JS_RADIO);
    String name = buttonElement.getAttribute('name');
    for (Element radio in radios) {
      Element button = radio
          .querySelector("input[type='radio'][name='${name}']." + RADIO_BTN);
      button.dispatchEvent(new CustomEvent('m-r-g-updated'));
    }
  }

  onFocus(Event event) {
    element.classes.add(IS_FOCUSED);
  }

  onBlur(Event event) {
    element.classes.remove(IS_FOCUSED);
  }

  blur() {
    Timer.run(() {
      buttonElement.blur();
    });
  }

  onMouseup(Event event) {
    blur();
  }

  updateClasses() {
    checkDisabled();
    checkToggleState();
  }

  checkToggleState() {
    if (buttonElement.checked) {
      element.classes.add(IS_CHECKED);
    } else {
      element.classes.remove(IS_CHECKED);
    }
  }

  checkDisabled() {
    if (buttonElement.disabled) {
      element.classes.add(IS_DISABLED);
    } else {
      element.classes.remove(IS_DISABLED);
    }
  }

  disable() {
    buttonElement.disabled = true;
  }

  enable() {
    buttonElement.disabled = false;
  }

  check() {
    buttonElement.checked = true;
  }

  uncheck() {
    buttonElement.checked = false;
  }

  @override
  ngOnDestroy() {
    super.ngOnDestroy();
    buttonElement.removeEventListener('m-r-g-updated', onUpdated);
  }
}
