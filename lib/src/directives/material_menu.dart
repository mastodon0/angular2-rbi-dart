library material_menu;

import 'dart:html';
import 'material_ripple.dart' show RippleBehavior;
import 'dart:async' show StreamSubscription, Timer;
import 'package:angular2_rbi/src/directives/base_behavior.dart';

const String MENU_CONTAINER = 'mdl-menu__container';
const String OUTLINE = 'mdl-menu__outline';
const String ITEM = 'mdl-menu__item';
const String ITEM_RIPPLE_CONTAINER = 'mdl-menu__item-ripple-container';
const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';
const String RIPPLE = 'mdl-ripple';
// Statuses
const String IS_UPGRADED = 'is-upgraded';
const String IS_VISIBLE = 'is-visible';
const String IS_ANIMATING = 'is-animating';
// Alignment options
const String BOTTOM_LEFT = 'mdl-menu--bottom-left'; // This is the default.
const String BOTTOM_RIGHT = 'mdl-menu--bottom-right';
const String TOP_LEFT = 'mdl-menu--top-left';
const String TOP_RIGHT = 'mdl-menu--top-right';
const String UNALIGNED = 'mdl-menu--unaligned';

//keycodes
const int ENTER = 13;
const int ESCAPE = 27;
const int SPACE = 32;
const int UP_ARROW = 38;
const int DOWN_ARROW = 40;

//time constants
const double TRANSITION_DURATION_SECONDS = 0.3;
const double TRANSITION_DURATION_FRACTION = 0.8;
const int CLOSE_TIMEOUT = 150;

class MenuBehavior extends BaseBehavior {
  Element element;
  Element container;
  Element outline;
  Element forElement;
  bool closing = false;
  StreamSubscription clickedAwaySubscription;

  MenuBehavior(this.element);

  @override
  ngOnInit() {
    container = new DivElement();
    container.classes.add(MENU_CONTAINER);
    element.parent.insertBefore(container, element);
    element.parent.children.remove(element);
    container.append(element);

    outline = new DivElement();
    outline.classes.add(OUTLINE);
    container.insertBefore(outline, element);
    String forElId = element.getAttribute('for');
    if (forElId == null){
      forElId = element.getAttribute('data-for');
    }
    if (forElId != null) {
      forElement = document.getElementById(forElId);
      if (forElement != null) {
        subscriptions.addAll([
          forElement.onClick.listen(handleForClick),
          forElement.onKeyDown.listen(handleForKeyboardEvent)
        ]);
      }
    }
    List<Element> items = element.querySelectorAll('.' + ITEM);
    for (Element item in items) {
      subscriptions.addAll([
        item.onClick.listen(handleItemClick),
        item.onKeyDown.listen(handleItemKeyboardEvent)
      ]);
    }
    if (element.classes.contains(RIPPLE_EFFECT)) {
      element.classes.add(RIPPLE_IGNORE_EVENTS);
      for (Element item in items) {
        Element rippleContainer = new SpanElement();
        rippleContainer.classes.add(ITEM_RIPPLE_CONTAINER);

        Element ripple = new SpanElement();
        ripple.classes.add(RIPPLE);
        rippleContainer.append(ripple);
        item.append(rippleContainer);
        item.classes.add(RIPPLE_EFFECT);
        RippleBehavior rb = new RippleBehavior(item);
        children.add(rb);
        rb.ngOnInit();
      }
    }
    for (String klass in [
      BOTTOM_LEFT,
      BOTTOM_RIGHT,
      TOP_LEFT,
      TOP_RIGHT,
      UNALIGNED
    ]) {
      if (element.classes.contains(klass)) {
        outline.classes.add(klass);
      }
    }
    container.classes.add(IS_UPGRADED);
  }

  handleForClick(Event event) {
    if (element != null && forElement != null) {
      Rectangle rect = forElement.getBoundingClientRect();
      Rectangle forRect = forElement.parent.getBoundingClientRect();

      if (element.classes.contains(UNALIGNED)) {
      } else if (element.classes.contains(BOTTOM_RIGHT)) {
        container.style.right = '${forRect.right - rect.right}px';
        container.style.top =
            '${forElement.offsetTop + forElement.offsetHeight}px';
      } else if (element.classes.contains(TOP_LEFT)) {
        container.style.left = '${forElement.offsetLeft}px';
        container.style.bottom = '${forRect.bottom - rect.top}px';
      } else if (element.classes.contains(TOP_RIGHT)) {
        container.style.right = '${forRect.right- rect.right}px';
        container.style.bottom = '${forRect.bottom - rect.top}px';
      } else {
        container.style.left = '${forElement.offsetLeft}px';
        container.style.top =
            '${forElement.offsetTop + forElement.offsetHeight}px';
      }
    }
    toggle(event);
  }

  handleForKeyboardEvent(KeyboardEvent event) {
    if (element != null && container != null && forElement != null) {
      List<Element> items =
          element.querySelectorAll('.' + ITEM + ':not([disabled])');
      if (items.length > 0 && container.classes.contains(IS_VISIBLE)) {
        if (event.keyCode == UP_ARROW) {
          event.preventDefault();
          items[items.length - 1].focus();
        } else if (event.keyCode == DOWN_ARROW) {
          event.preventDefault();
          items[0].focus();
        }
      }
    }
  }

  handleItemKeyboardEvent(KeyboardEvent event) {
    if (element != null && container != null) {
      List<Element> items =
          element.querySelectorAll('.' + ITEM + ':not([disabled])');
      if (items.length > 0 && container.classes.contains(IS_VISIBLE)) {
        int currentIndex = items.indexOf(event.target);
        if (event.keyCode == UP_ARROW) {
          event.preventDefault();
          if (currentIndex > 0) {
            items[currentIndex - 1].focus();
          } else {
            items[items.length - 1].focus();
          }
        } else if (event.keyCode == DOWN_ARROW) {
          event.preventDefault();
          if (items.length > currentIndex + 1) {
            items[currentIndex + 1].focus();
          } else {
            items[0].focus();
          }
        } else if (event.keyCode == SPACE || event.keyCode == ENTER) {
          event.preventDefault();
          MouseEvent e = new MouseEvent('mousedown');
          event.target.dispatchEvent(e);
          MouseEvent e1 = new MouseEvent('mouseup');
          event.target.dispatchEvent(e1);
          MouseEvent e2 = new MouseEvent('click');
          event.target.dispatchEvent(e2);
        } else if (event.keyCode == ESCAPE) {
          event.preventDefault();
          hide();
        }
      }
    }
  }

  handleItemClick(Event event) {
    Element target = event.target as Element;
    if (target.getAttribute('disabled') != null) {
      event.stopPropagation();
    } else {
      closing = true;
      Duration duration = new Duration(milliseconds: CLOSE_TIMEOUT);
      new Timer(
          duration,
          (() {
            closing = false;
            hide();
          }));
    }
  }

  toggle(Event event) {
    if (container.classes.contains(IS_VISIBLE)) {
      hide();
    } else {
      show(event);
    }
  }

  hide() {
    if (element != null && container != null && outline != null) {
      List<Element> items = element.querySelectorAll('.' + ITEM);
      for (Element item in items) {
        item.style.transitionDelay = null;
      }
      Rectangle rect = element.getBoundingClientRect();
      element.classes.add(IS_ANIMATING);
      applyClip(rect.height, rect.width);
      container.classes.remove(IS_VISIBLE);
      addAnimationEndListener();
    }
  }

  show(Event event) {
    if (element != null && container != null && outline != null) {
      Rectangle rect = element.getBoundingClientRect();
      int height = rect.height.toInt();
      int width = rect.width.toInt();
      container.style.width = '${width}px';
      container.style.height = '${height}px';
      outline.style.width = '${width}px';
      outline.style.height = '${height}px';

      double transitionDuration =
          TRANSITION_DURATION_SECONDS * TRANSITION_DURATION_FRACTION;

      List<Element> items = element.querySelectorAll('.' + ITEM);
      for (Element item in items) {
        String itemDelay;
        if (element.classes.contains(TOP_LEFT) ||
            element.classes.contains(TOP_RIGHT)) {
          itemDelay = '${(height - item.offsetTop - item.offsetHeight)/
          height * transitionDuration}s';
        } else {
          itemDelay = '${item.offsetTop/height * transitionDuration}s';
        }
        item.style.transitionDelay = itemDelay;
      }
      applyClip(height, width);
      window.animationFrame.then((_) {
        doAnimation(height, width);
      });
      addAnimationEndListener();
      Function clickedAway;
      clickedAway = ((Event e) {
        if (e != event && (closing == false || closing == null)) {
          clickedAwaySubscription.cancel();
          subscriptions.remove(clickedAwaySubscription);
          document.removeEventListener('click', clickedAway);
          hide();
        }
      });
      clickedAwaySubscription = document.onClick.listen(clickedAway);
      subscriptions.add(clickedAwaySubscription);
    }
  }

  doAnimation(height, width) {
    element.classes.add(IS_ANIMATING);
    element.style.clip = 'rect(0 ${width}px ${height}px 0)';
    container.classes.add(IS_VISIBLE);
  }

  applyClip(height, width) {
    if (element.classes.contains(UNALIGNED)) {
      element.style.clip = '';
    } else if (element.classes.contains(BOTTOM_RIGHT)) {
      element.style.clip = 'rect(0 ${width}px 0 ${width}px)';
    } else if (element.classes.contains(TOP_LEFT)) {
      element.style.clip = 'rect(${height}px 0 ${height}px 0)';
    } else if (element.classes.contains(TOP_RIGHT)) {
      element.style.clip =
          'rect(${height}px ${width}px ${height}px ${width}px)';
    } else {
      element.style.clip = '';
    }
  }

  addAnimationEndListener() {
    element.addEventListener('transitionend', transitionCleanup);
    element.addEventListener('webkitTransitionend', transitionCleanup);
  }

  transitionCleanup(Event event) {
    element.removeEventListener('transitionend', transitionCleanup);
    element.removeEventListener('webkitTransitionend', transitionCleanup);
    element.classes.remove(IS_ANIMATING);
  }

  @override
  ngOnDestroy() {
    super.ngOnDestroy();
    transitionCleanup(null);
  }

}
