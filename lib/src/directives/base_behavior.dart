library base_behavior;

import 'package:angular2/angular2.dart';
import 'dart:async';

abstract class BaseBehavior implements OnInit, OnDestroy {

  List<StreamSubscription> subscriptions = [];
  List<BaseBehavior> children = [];

  @override
  ngOnDestroy() {
    for (var subscription in subscriptions) {
      if (subscription.cancel())
      subscription.cancel();
    }

    for (var child in children) {
      child.ngOnDestroy();
    }
  }

}