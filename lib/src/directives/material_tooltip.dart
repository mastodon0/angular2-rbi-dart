library material_tooltip;

import 'dart:html';
import 'package:angular2_rbi/src/directives/base_behavior.dart';

const String IS_ACTIVE = 'is-active';

class TooltipBehavior extends BaseBehavior {
  Element element;
  Element forElement;

  TooltipBehavior(Element this.element);

  @override
  ngOnInit() {
    String ForElId = element.getAttribute('for');
    if (ForElId == null) {
      ForElId = element.getAttribute('data-for');
    }
    if (ForElId != null) {
      forElement = document.getElementById(ForElId);
      if (forElement != null) {
        if (!forElement.attributes.containsKey('tabindex')) {
          forElement.setAttribute('tabindex', '0');
        }

        //removed manually
        forElement.addEventListener('mouseenter', handleMouseEnter, false);
        forElement.addEventListener('click', handleMouseEnter, false);
        forElement.addEventListener('touchstart', handleMouseEnter, false);

        subscriptions.addAll([
          forElement.onBlur.listen(handleMouseLeave),
          forElement.onMouseLeave.listen(handleMouseLeave)
        ]);
      }
    }
  }
  handleMouseEnter(Event event) {
    event.stopPropagation();
    Element target = event.target;
    Rectangle props = target.getBoundingClientRect();
    int left = (props.left + (props.width) / 2).round();
    int marginLeft = (-1 * element.offsetWidth / 2).round();

    if ((left + marginLeft) < 0) {
      element.style.left = '0';
      element.style.marginLeft = '0';
    } else {
      element.style.left = '${left}px';
      element.style.marginLeft = '${marginLeft}px';
    }
    element.style.top = '${props.top + props.height + 10}px';
    element.classes.add(IS_ACTIVE);
    window.addEventListener('scroll', handleMouseLeave, false);
    window.addEventListener('touchmove', handleMouseLeave, false);
  }

  handleMouseLeave(Event event) {
    event?.stopPropagation();
    element.classes.remove(IS_ACTIVE);
    window.removeEventListener('scroll', handleMouseLeave);
    window.removeEventListener('touchmove', handleMouseLeave, false);
  }

  @override
  ngOnDestroy() {
    super.ngOnDestroy();
    handleMouseLeave(null);

    forElement.removeEventListener('mouseenter', handleMouseEnter, false);
    forElement.removeEventListener('click', handleMouseEnter, false);
    forElement.removeEventListener('touchstart', handleMouseEnter, false);
  }
}
