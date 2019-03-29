typedef void EventCallback(arg);

//保存事件名和回调方法，通过指定方式回调
class EventBus {
  var _emap = new Map<Object, List<EventCallback>>();

  //注册订阅者
  void register(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _emap[eventName] ??= new List<EventCallback>();
    _emap[eventName].add(f);
  }

  //取消订阅者
  void unRegister(eventName, [EventCallback f]) {
    if (eventName == null || f == null) return;
    var list = _emap[eventName];
    if (list == null) return;
    list.remove(f);
  }

  //触发事件
  void submit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }

  //单例模式
  factory EventBus() => get();
  static EventBus _eventBus;

  EventBus._internal() {
    //初始化
  }

  static EventBus get() {
    if (_eventBus == null) {
      _eventBus = new EventBus._internal();
    }
    return _eventBus;
  }
}
