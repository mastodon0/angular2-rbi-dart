library material_layout;

import 'dart:html';
import 'material_ripple.dart' show RippleBehavior;
import 'package:angular2_rbi/src/directives/base_behavior.dart';

const String CONTAINER = 'mdl-layout__container';
const String HEADER = 'mdl-layout__header';
const String DRAWER = 'mdl-layout__drawer';
const String CONTENT = 'mdl-layout__content';
const String DRAWER_BTN = 'mdl-layout__drawer-button';

const String ICON = 'material-icons';

const String RIPPLE_EFFECT = 'mdl-js-ripple-effect';
const String TAB_RIPPLE_CONTAINER = 'mdl-layout__tab-ripple-container';
const String RIPPLE = 'mdl-ripple';
const String RIPPLE_IGNORE_EVENTS = 'mdl-js-ripple-effect--ignore-events';

const String HEADER_SEAMED = 'mdl-layout__header--seamed';
const String HEADER_WATERFALL = 'mdl-layout__header--waterfall';
const String HEADER_SCROLL = 'mdl-layout__header--scroll';

const String FIXED_HEADER = 'mdl-layout--fixed-header';
const String OBFUSCATOR = 'mdl-layout__obfuscator';

const String TAB_BAR = 'mdl-layout__tab-bar';
const String TAB_CONTAINER = 'mdl-layout__tab-bar-container';
const String TAB = 'mdl-layout__tab';
const String TAB_BAR_BUTTON = 'mdl-layout__tab-bar-button';
const String TAB_BAR_LEFT_BUTTON = 'mdl-layout__tab-bar-left-button';
const String TAB_BAR_RIGHT_BUTTON = 'mdl-layout__tab-bar-right-button';
const String PANEL = 'mdl-layout__tab-panel';

const String HAS_DRAWER = 'has-drawer';
const String HAS_TABS = 'has-tabs';
const String HAS_SCROLLING_HEADER = 'has-scrolling-header';
const String CASTING_SHADOW = 'is-casting-shadow';
const String IS_COMPACT = 'is-compact';
const String IS_SMALL_SCREEN = 'is-small-screen';
const String IS_DRAWER_OPEN = 'is-visible';
const String IS_ACTIVE = 'is-active';
const String IS_UPGRADED = 'is-upgraded';
const String IS_ANIMATING = 'is-animating';
const String ON_LARGE_SCREEN = 'mdl-layout--large-screen-only';
const String ON_SMALL_SCREEN = 'mdl-layout--small-screen-only';

const String MAX_WIDTH = '(max-width: 1024px)';
const int TAB_SCROLL_PIXELS = 100;

const String MENU_ICON = 'menu';
const String CHEVRON_LEFT = 'chevron_left';
const String CHEVRON_RIGHT = 'chevron_right';

const int STANDARD = 0;
const int SEAMED = 1;
const int WATERFALL = 2;
const int SCROLL = 3;

class LayoutBehavior extends BaseBehavior {
  Element elem;
  Element header;
  Element drawer;
  Element content;
  Element tabBar;
  Element leftButton;
  Element rightButton;
  DivElement obfuscator;
  MediaQueryList screenSizeMediaQuery;

  LayoutBehavior(this.elem);

  @override
  ngOnInit() {
    DivElement container = new DivElement()..classes.add(CONTAINER);
    elem.parent.insertBefore(container, elem);
    elem.parent.children.remove(elem);
    container.append(elem);

    for (Element el in elem.children) {
      if (el.classes.contains(HEADER)) {
        header = el;
      }
      if (el.classes.contains(DRAWER)) {
        drawer = el;
      }
      if (el.classes.contains(CONTENT)) {
        content = el;
      }
    }

    if (header != null) {
      tabBar = header.querySelector('.' + TAB_BAR);
    }

    int mode = STANDARD;

    if (header != null) {
      if (header.classes.contains(HEADER_SEAMED)) {
        mode = SEAMED;
      } else if (header.classes.contains(HEADER_WATERFALL)) {
        mode = WATERFALL;
        subscriptions.addAll([
          header.onTransitionEnd.listen(headerTransitionEndHandler),
          header.onClick.listen(headerClickHandler)
        ]);
      } else if (header.classes.contains(HEADER_SCROLL)) {
        mode = SCROLL;
        container.classes.add(HAS_SCROLLING_HEADER);
      }

      if (mode == STANDARD) {
        header.classes.add(CASTING_SHADOW);
        if (tabBar != null) {
          tabBar.classes.add(CASTING_SHADOW);
        }
      } else if (mode == SEAMED || mode == SCROLL) {
        header.classes.remove(CASTING_SHADOW);
        if (tabBar != null) {
          tabBar.classes.remove(CASTING_SHADOW);
        }
      } else if (mode == WATERFALL) {
        subscriptions.add(content.onScroll.listen(contentScrollHandler));
        contentScrollHandler(null);
      }
    }
    if (drawer != null) {
      Element drawerButton;
      drawerButton = elem.querySelector('.$DRAWER_BTN');
      if (drawerButton == null) {
        Element drawerButtonIcon = new Element.tag('i')
          ..classes.add(ICON)
          ..text = MENU_ICON;

        drawerButton = new DivElement()
          ..classes.add(DRAWER_BTN)
          ..append(drawerButtonIcon);
      }
      if (drawer.classes.contains(ON_LARGE_SCREEN)) {
        drawerButton.classes.add(ON_LARGE_SCREEN);
      } else if (drawer.classes.contains(ON_SMALL_SCREEN)) {
        drawerButton.classes.add(ON_SMALL_SCREEN);
      }
      subscriptions.add(drawerButton.onClick.listen(drawerToggleHandler));

      elem.classes.add(HAS_DRAWER);
      if (elem.classes.contains(FIXED_HEADER)) {
        header.insertBefore(drawerButton, header.firstChild);
      } else {
        elem.insertBefore(drawerButton, content);
      }
      obfuscator = new DivElement()
        ..classes.add(OBFUSCATOR);
      subscriptions.add(obfuscator.onClick.listen(drawerToggleHandler));
      elem.append(obfuscator);
    }

    screenSizeMediaQuery = window.matchMedia(MAX_WIDTH);
    screenSizeMediaQuery.addListener(screenSizeHandler);
    screenSizeHandler(null);

    if (header != null && tabBar != null) {
      elem.classes.add(HAS_TABS);
      DivElement tabContainer = new DivElement()..classes.add(TAB_CONTAINER);

      header.insertBefore(tabContainer, tabBar);
      header.children.remove(tabBar);

      Element leftButtonIcon = new Element.tag('i')
        ..classes.add(ICON)
        ..text = CHEVRON_LEFT;

      leftButton = new DivElement()
        ..classes.add(TAB_BAR_BUTTON)
        ..classes.add(TAB_BAR_LEFT_BUTTON)
        ..append(leftButtonIcon);
      subscriptions.add(leftButton.onClick.listen(leftButtonClickHandler));

      Element rightButtonIcon = new Element.tag('i')
        ..classes.add(ICON)
        ..text = CHEVRON_RIGHT;

      rightButton = new DivElement()
        ..classes.add(TAB_BAR_BUTTON)
        ..classes.add(TAB_BAR_RIGHT_BUTTON)
        ..append(rightButtonIcon);
      subscriptions.add(rightButton.onClick.listen(rightButtonClickHandler));

      tabContainer.append(leftButton);
      tabContainer.append(tabBar);
      tabContainer.append(rightButton);

      subscriptions.add(tabBar.onScroll.listen(tabScrollHandler));
      tabScrollHandler(null);

      if (tabBar.classes.contains(RIPPLE_EFFECT)) {
        tabBar.classes.add(RIPPLE_IGNORE_EVENTS);
      }

      for (Element tab in tabs) {
        //new MaterialLayoutTab(tab, tabs, panels, this);
        if (tabBar.classes.contains(RIPPLE_EFFECT)) {
          SpanElement rippleContainer = new SpanElement();
          rippleContainer.classes.add(TAB_RIPPLE_CONTAINER);
          rippleContainer.classes.add(RIPPLE_EFFECT);
          SpanElement ripple = new SpanElement();
          ripple.classes.add(RIPPLE);
          rippleContainer.append(ripple);
          tab.append(rippleContainer);
          RippleBehavior rb = new RippleBehavior(tab);
          children.add(rb);
          rb.ngOnInit();
        }
        subscriptions.add(tab.onClick.listen(tabClickHandler));
      }
    }
    elem.classes.add(IS_UPGRADED);
  }

  get tabs => tabBar.querySelectorAll('.' + TAB);
  get panels => content.querySelectorAll('.' + PANEL);

  screenSizeHandler(Event event) {
    if (screenSizeMediaQuery.matches) {
      elem.classes.add(IS_SMALL_SCREEN);
    } else {
      elem.classes.remove(IS_SMALL_SCREEN);
      if (drawer != null) {
        drawer.classes.remove(IS_DRAWER_OPEN);
        obfuscator.classes.remove(IS_DRAWER_OPEN);
      }
    }
  }

  rightButtonClickHandler(Event event) {
    tabBar.scrollLeft += TAB_SCROLL_PIXELS;
  }

  leftButtonClickHandler(Event event) {
    tabBar.scrollLeft -= TAB_SCROLL_PIXELS;
  }

  tabScrollHandler(event) {
    if (tabBar.scrollLeft > 0) {
      leftButton.classes.add(IS_ACTIVE);
    } else {
      leftButton.classes.remove(IS_ACTIVE);
    }
    if (tabBar.scrollLeft < tabBar.scrollWidth - tabBar.offsetWidth) {
      rightButton.classes.add(IS_ACTIVE);
    } else {
      rightButton.classes.remove(IS_ACTIVE);
    }
  }

  drawerToggleHandler(Event event) {
    drawer.classes.toggle(IS_DRAWER_OPEN);
    obfuscator.classes.toggle(IS_DRAWER_OPEN);
  }

  headerTransitionEndHandler(Event event) {
    header.classes.remove(IS_ANIMATING);
  }

  headerClickHandler(Event event) {
    if (header.classes.contains(IS_COMPACT)) {
      header.classes.remove(IS_COMPACT);
      header.classes.add(IS_ANIMATING);
    }
  }

  contentScrollHandler(Event event) {
    if (header.classes.contains(IS_ANIMATING)) {
      return;
    }
    if (content.scrollTop > 0 && !header.classes.contains(IS_COMPACT)) {
      header.classes.add(CASTING_SHADOW);
      header.classes.add(IS_COMPACT);
      header.classes.add(IS_ANIMATING);
    } else if (content.scrollTop <= 0 && header.classes.contains(IS_COMPACT)) {
      header.classes.remove(CASTING_SHADOW);
      header.classes.remove(IS_COMPACT);
      header.classes.add(IS_ANIMATING);
    }
  }

  resetTabState() {
    for (Element el in tabs) {
      el.classes.remove(IS_ACTIVE);
    }
  }

  resetPanelState() {
    for (Element el in panels) {
      el.classes.remove(IS_ACTIVE);
    }
  }

  tabClickHandler(Event event) {
    AnchorElement tab = event.currentTarget;
    if (tab.href.contains('#')) {
      event.preventDefault();
      selectTab(tab);
    }
  }

  selectTab(AnchorElement tab) {
    String href = tab.href.split('#')[1];
    Element panel = content.querySelector('#' + href);
    resetTabState();
    resetPanelState();
    tab.classes.add(IS_ACTIVE);
    panel.classes.add(IS_ACTIVE);
  }
}
