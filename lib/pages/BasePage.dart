import '../Constants/AppLibs.dart';

abstract class BasePage extends StatefulWidget {
  BuildContext context;
  bool _leading = false;
  String _title = null;
  List<Widget> _actionList;
  State<BasePage> page;

  void configBar(bool leading, String title, List<Widget> actions) {
    this._leading = leading;
    this._title = title;
    this._actionList = actions;
  }

  //第一次加载这个页面时执行
  void initData(BuildContext context) {
    this.context = context;
  }

  Widget buildBody();

  void didChangeDependencies(BuildContext context) {}

  void didUpdateWidget(BuildContext context, BasePage oldWidget) {}

  void dispose(BuildContext context) {}

  setState(VoidCallback fn) {
    page.setState(fn);
  }

  @override
  State<StatefulWidget> createState() {
    page = _BasePage();
    return page;
  }
}

class _BasePage extends State<BasePage> with AutomaticKeepAliveClientMixin {
  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    widget.initData(context);
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies(context);
  }

  @override
  void didUpdateWidget(BasePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget(context, oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: widget._title == null
          ? null
          : AppBar(
        title: Text(
          widget._title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        leading: widget._leading ? Icon(Icons.arrow_back_ios) : null,
        actions: widget._actionList,
      ),
      backgroundColor: Color(0xffefefef),
      body: widget.buildBody(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
