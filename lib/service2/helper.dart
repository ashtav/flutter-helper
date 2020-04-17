import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'helper-widget.dart';



// text('lorem ipsum dolor')
text(text, {color, size: 15, bold: false, TextAlign align: TextAlign.left, spacing: 0, font: 'sans', TextOverflow overflow}){
  return Text(
    text.toString(), overflow: overflow, softWrap: true, textAlign: align, style: TextStyle(
      color: color == null ? Color.fromRGBO(60, 60, 60, 1) : color, 
      fontFamily: font,
      fontSize: size.toDouble(),
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      letterSpacing: spacing.toDouble(),
    ),
  );
}

// html('lorem ipsum <b>dolor</b>')
html(message, {borderBottom, double padding: 0, double size: 13, bold: false, Color color, TextAlign align: TextAlign.left}){
  return Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: borderBottom == null ? Colors.transparent : borderBottom
        )
      )
    ),
    child: Html(data: message, customTextAlign: (node) { return align; },
    defaultTextStyle: TextStyle(fontFamily: 'sans', fontSize: size, color: color == null ? Colors.black87 : color, fontWeight: bold ? FontWeight.bold : FontWeight.normal))
  );
}



// class ----------

class Dt {
  static final y = DateTime.now().year;
  static final m = DateTime.now().month;
  static final d = DateTime.now().day;
  static final h = DateTime.now().hour;
  static final i = DateTime.now().minute;
  static final s = DateTime.now().second;
}

class Cl {
  static black({double opacity: 1}){
    return Color.fromRGBO(60, 60, 60, opacity);
  }

  static black05(){
    return Color.fromRGBO(242, 242, 242, 1);
  }

  static softGrey(){
    return Color.fromRGBO(217, 228, 237, 1);
  }

  static softBlue(){
    return Color.fromRGBO(226, 242, 254, 1);
  }

  static softGreen(){
    return Color.fromRGBO(217, 242, 212, 1);
  }

  static softOrange(){
    return Color.fromRGBO(251, 237, 224, 1);
  }

  static softYellow(){
    return Color.fromRGBO(247, 246, 202, 1);
  }

  static softSilver(){
    return Color.fromRGBO(245, 247, 251, 1);
  }
}

class Message{

  static error(e, {Timer timer}){
    print('error : '+e.toString());
    Wi.toast(e.message);

    if(timer != null){
      timer.toString();
    }
  }

  static connection(context, {Timer timer}){
    Wi.box(context, title: 'Network Connection!', message: 'Sepertinya terjadi masalah pada koneksi internet Anda, periksa jaringan dan pastikan koneksi internet Anda stabil.');
    if(timer != null){
      timer.cancel();
    }
  }
}

// get size of screen, Mquery.width(context)
class Mquery{

  static width(context){
    return MediaQuery.of(context).size.width;
  }

  static height(context){
    return MediaQuery.of(context).size.height;
  }

}

// ScrollConfiguration(behavior: PreventScrollGlow(), child: Widget
class PreventScrollGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

// body: PreventSwipe(child: Widget)
class PreventSwipe extends StatelessWidget {
  final Widget child; PreventSwipe({this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (_){},
      child: child,
    );
  }
}

// Unfocus(child: Widget)
class Unfocus extends StatelessWidget {
  final Widget child; Unfocus({this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){ focus(context, FocusNode()); },
      child: child,
    );
  }
}

// Button()
class Button extends StatelessWidget {
  Button({this.key, this.child, this.elevation : 0, this.onTap, this.onLongPress, this.padding, this.color, this.splash, this.highlightColor, this.radius, this.border}); 
  
  final Key key;
  final Widget child;
  final Function onTap;
  final Function onLongPress;
  final EdgeInsetsGeometry padding;
  final Color color, splash, highlightColor;
  final BorderRadiusGeometry radius;
  final BoxBorder border;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: key,
      elevation: elevation,
      color: color == null ? Colors.transparent : color,
      borderRadius: radius,
      child: InkWell(
        onLongPress: onLongPress,
        splashColor: splash,
        highlightColor: highlightColor,
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: border,
            // color: color,
          ),
          padding: padding == null ? EdgeInsets.all(0) : padding,
          child: child
        )
      ),
    );
  }
}

// SlideUp(child: Widget)
class SlideUp extends StatefulWidget {
  final Widget child;
  final int delay;
  final horizontal, speed;

  SlideUp({@required this.child, this.delay, this.horizontal: false, this.speed: 0.35});

  @override
  _SlideUpState createState() => _SlideUpState();
}

class _SlideUpState extends State<SlideUp> with TickerProviderStateMixin {
  AnimationController _animController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: widget.horizontal ? Offset(widget.speed, 0.0) : Offset(0.0, widget.speed), end: Offset.zero).animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animController,
    );
  }
}

// AnimatedCount(400, bold: true, prefix: '%')
class AnimatedCount extends StatefulWidget {
  AnimatedCount(this.number, {this.bold: false, this.prefix: '', this.color: Colors.black87, this.size: 15});
  
  final bold, prefix;
  final Color color;
  final double size, number;
  
  @override
  createState() => new AnimatedCountState();
}

class AnimatedCountState extends State<AnimatedCount> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = _controller;
    super.initState();

    _animation = new Tween<double>(
      begin: _animation.value,
      end: widget.number.toDouble(),
    ).animate(new CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: _controller,
    ));

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    super.dispose(); _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return text( _animation.value.toStringAsFixed(0)+widget.prefix, bold: widget.bold, color: widget.color, size: widget.size);
      },
    );
  }
}





// methods ----------

String __api = 'https://kpm-api-test.kembarputra.com';

setExistApi() async {
  var prefs = await SharedPreferences.getInstance(),
      apiString = prefs.getString('api');

  if(apiString != null){
    __api = prefs.getString('api');
  }
}

// api url, api('https://api-url.com')
api(url){
  setExistApi();
  return __api+'/'+url;
}

// modal(context, child: Widget, then: (res){ })
modal(context, {Widget child, Function then, double height, bool fullScreen: false, Color color, double radius: 0}) async {
  var _height = MediaQuery.of(context).size.height;

  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext _) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
        child: Container(
          color: color == null ? Colors.white : color,
          height: fullScreen ? _height : height != null ? height.toDouble() :  _height - MediaQuery.of(context).padding.top,
          child: child
        ),
      );
    },
    isScrollControlled: true,
  ).then((res) { if(then != null) then(res); });
}

// ribuan(1500) -> 1.500, ribuan(1300.2), -> 1.300,2
// ribuan(50, cur: '\$') -> $50, ribuan(1300.50, fixed: 1) -> 1.300,5
ribuan(number, {String cur, int fixed}){
  final nf = new NumberFormat("#,##0", "en_US");
  if(number == null){ return 'null'; }

  var n = number.toString(), split = [];
  if(n.indexOf('.') > -1){
    n.split('.').forEach((f){
      split.add(f);
    });

    split[1] = fixed == null ? ','+split[1] : fixed == 0 ? '' : ','+split[1].substring(0, fixed);
    var res = nf.format(int.parse(split[0])).replaceAll(',', '.')+''+split[1];
    return cur != null ? cur+''+res : res;
  }

  number = number is String ? int.parse(number) : number;
  var res = nf.format(number).replaceAll(',', '.');
  return cur != null ? cur+''+res : res;
}

// ucwords('lorem ipsum') -> Lorem Ipsum
ucwords(String str){
  if(str == '' || str == null) {
    return '';
  }

  var split = str.replaceAll(new RegExp(r"\s+\b|\b\s"), ' ').toLowerCase().split(' ');
  for (var i = 0; i < split.length; i++) {
    if(split[i] != ''){
      split[i] = split[i][0].toUpperCase() + split[i].substring(1);     
    }
  }
  return split.join(' ');
}

// periksa koneksi seluler & wifi, checkConnection().then((con){ })
checkConnection() async{
  var connectivityResult = await (Connectivity().checkConnectivity()),
      mobile = connectivityResult == ConnectivityResult.mobile,
      wifi = connectivityResult == ConnectivityResult.wifi;

  return mobile || wifi ? true : false;
}

// requestPermissions(location: true),then((allowed){ })
requestPermissions({location: false, Function then}) async{
  _permissionStatus() async{
    PermissionStatus status = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    then(status == PermissionStatus.unknown || status == PermissionStatus.denied ? false : true);
  }

  _checkPermission(PermissionStatus status) async{
    if(status == PermissionStatus.unknown || status == PermissionStatus.denied){
      await PermissionHandler().requestPermissions([PermissionGroup.location]);
      if(then != null) _permissionStatus();
    }else{ if(then != null) then(true); }
  }

  if(location){
    PermissionHandler().checkPermissionStatus(PermissionGroup.location).then(_checkPermission);
  }

}

setTimer(second, {then}){
  return Timer(Duration(seconds: second), (){
    if(then != null) then(true);
  });
}

// encode & decode, encode(object) -> string, decode(string) -> object
encode(data){ return json.encode(data); }
decode(data){ if(data != null) return json.decode(data); }

// set data lokal, setPrefs('key', data)
setPrefs(key, data, {enc: false}) async{
  var prefs = await SharedPreferences.getInstance();

  if(data is List || data is Map){
    prefs.setString(key, encode(data));
  }

  else if(data is bool){
    prefs.setBool(key, data);
  }

  else if(data is int){
    prefs.setInt(key, data);
  }

  else if(data is String){
    prefs.setString(key, enc ? encode(data) : data);
  }

  else{
    prefs.setDouble(key, data);
  }
}

// get data lokal, getPrefs('key', type: String).then((res){ });
getPrefs(key, {dec: false, type: String}) async{
  var prefs = await SharedPreferences.getInstance();

  switch (type) {
    case List: return decode(prefs.getString(key)); break;
    case Map: return decode(prefs.getString(key)); break;
    case bool: return prefs.getBool(key); break;
    case int: return prefs.getInt(key); break;
    case String: return prefs.getString(key) == null ? null : dec ? decode(prefs.getString(key)) : prefs.getString(key); break;
    case double: return prefs.getDouble(key);
  }
}

// periksa data lokal, checkPrefs()
checkPrefs() async{
  var prefs = await SharedPreferences.getInstance();
  print(prefs.getKeys());
}

// bersihkan data lokal, clearPrefs() -> clear all, clearPrefs(except: ['user']) -> kecuali user
clearPrefs({List except}) async{
  var prefs = await SharedPreferences.getInstance(), keys = prefs.getKeys();
  for (var i = 0; i < keys.toList().length; i++) {
    if(except == null){
      prefs.remove(keys.toList()[i]);
    }else{
      if(except.indexOf(keys.toList()[i]) < 0){
        prefs.remove(keys.toList()[i]);
      }
    }
  }
}

// set fokus textfield, focus(context, emailNode)
focus(context, node){
  FocusScope.of(context).requestFocus(node);
}

// validasi email, emailValidate('lorem@gmail.com') -> true
emailValidate(String email){
  return email == null || email == '' ? false : RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

// format valid -> yyyy-mm-dd hh:ii:ss
dateTime({format: 'datetime'}){ // datetime, date, time
  var date = new DateTime.now().toString().split('.');
  var dateTime = date[0].split(' ');

  switch (format) {
    case 'now-': return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute - 1, 0); break;
    case 'now+': return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute + 1, 0); break;
    case 'datetime': return date[0]; break;
    case 'date': return dateTime[0]; break;
    default: return dateTime[1]; break;
  }
}

// format valid -> yyyy-mm-dd hh:ii:ss, dateFormat('2020-04-12 22:30:15', format: 'd-m-y') -> 12-04-2020 || ...format: 'd/m/y') -> 12/04/2020
dateFormat(date, {format: 'dmy'}){
  var bln = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktoberr','November','Desember'];

  var pattern = {'d': 2, 'm': 1, 'M': 1, 'y': 0, 'h': 3, 'i': 4, 's': 5}, // pola
      dateTime = date.replaceAll(':', '-').replaceAll(' ', '-'), result = [];

  format.split('').forEach((f){
    if(pattern[f] != null){
      if(f == 'M'){
        result.add(bln[ int.parse(dateTime.split('-')[pattern[f]]) - 1 ]);
      }else{
        result.add(dateTime.split('-')[pattern[f]]);
      }
    }else{
      result.add(f);
    }
  });

  return result.join('').toString();
}

// generate timestamp -> nomor acak by today
timestamp(){
  return DateTime.now().millisecondsSinceEpoch;
}

// format valid -> yyyy-mm-dd hh:ii:ss, waktu yang lalu, timeAgo('2020-04-12 22:30:15') -> 2 jam yang lalu
timeAgo(datetime){
  Duration compare(DateTime x, DateTime y) {
    return Duration(microseconds: (x.microsecondsSinceEpoch - y.microsecondsSinceEpoch).abs());
  }

  var split = datetime.toString().split(' ');
  var date = split[0].split('-');
  var time = split[1].split(':');

  DateTime x = DateTime.now();
  DateTime y = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));  
  
  var diff = compare(x, y);

  // return 'minute: '+diff.inMinutes.toString()+', second: '+diff.inSeconds.toString();

  if(diff.inSeconds >= 60){
    if(diff.inMinutes >= 60){
      if(diff.inHours >= 24){
        return diff.inDays.toString()+' hari yang lalu';
      }else{
        return diff.inHours.toString()+' jam yang lalu';
      }
    }else{
      return diff.inMinutes.toString()+' menit yang lalu';
    }
  }else{
    return 'baru saja';
  }
}

// hitung umur, calcAge('1995-11-05') -> 26
calcAge(date){
  if(date == null || date == ''){
    return '-';
  }else{
    var today = DateTime.now(),
        birthDate = DateTime.parse(date),
        age = today.year - birthDate.year,
        m = today.month - birthDate.month;

    if (m < 0 || (m == 0 && today.day < birthDate.day)) {
        age--;
    }

    return age;
  }
}

// buka google map by kordinat, openMap(-8502322, 1520239)
openMap(latitude, longitude) async {
  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  }
}

// firstChar('lorem ipsum') -> LI, firstChar('lorem ipsum', length: 1) -> L
firstChar(string, {length: 2}){
  var str = string.split(' ');
  var char = '';

  for (var i = 0; i < str.length; i++) {
    if(i < length){
      char += str[i].substring(0, 1);
    }
  }

  return char.toUpperCase();
}

// get file size, formatBytes(1500) -> 1.46 KB
formatBytes(bytes, {decimals: 2}){
  if(bytes == 0) return '0 Bytes';

  var k = 1024,
      dm = decimals < 0 ? 0 : decimals,
      sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

  var i = (math.log(bytes) / math.log(k)).floor();

  return (bytes / math.pow(k, i)).toStringAsFixed(dm)+' '+sizes[i];
}

// potong pertengahan string, cutHalf('lorem ipsum dolor set amet', maxLength: 5) -> lorem ipsum...er amet
cutHalf(String str, {int maxLength: 40}){
  if(str.length < maxLength) return str;

  var ls = str.length,
      first = str.substring(0, ((ls/3).round()) + (maxLength/3).round()),
      end = str.substring(ls - 7, ls);

  return first+'...'+end;
}




// widgets ----------

class Wi {

  // Wi.toast('lorem ipsum')
  static toast(String msg){
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      
      timeInSecForIos: 1,
      backgroundColor: Color.fromRGBO(0, 0, 0, .7),
      textColor: Colors.white,
      fontSize: 14.0
    );
  }

  static alertMsg({
    @required child, EdgeInsetsGeometry margin, EdgeInsetsGeometry padding, 
    Color color, BoxBorder border}){

    return Container(
      padding: padding == null ? EdgeInsets.all(15) : padding,
      margin: margin,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color == null ? Colors.blueGrey[50] : color,
        borderRadius: BorderRadius.circular(4),
        border: border == null ? Border.all(color: Colors.blueGrey[100]) : border
      ),
      child: child is String ? html(child) : child,
    );
  }

  // dialog(context, child: Widget)
  static dialog(context, {dismiss: true, forceClose: true, MainAxisAlignment position, @required Widget child, Function then}){
    Future<bool> onWillPop() {
      return Future.value(forceClose);
    }

    return showDialog(
      context: context,
      barrierDismissible: dismiss,
      builder: (BuildContext context){
        return new WillPopScope(
          onWillPop: onWillPop,
          child: Column(
            mainAxisAlignment: position == null ? MainAxisAlignment.center : position,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Mquery.width(context),
                margin: EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Material(
                    child: child,
                  ),
                ),
              )
            ]
          )
        );
      }
    ).then((res){ if(then != null) then(res); });
  }

  // appBar: Wi.appBar(context, ...)
  static appBar(context, {title = '', Color color, elevation = 1, back: true, spacing: 15, List<Widget> actions, autoLeading: false}){
    return new AppBar(
      backgroundColor: color == null ? Colors.white : color,
      automaticallyImplyLeading: autoLeading,
      titleSpacing: back ? 0 : 15,
      elevation: elevation.toDouble(),
      leading: back ? IconButton( onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back), color: Colors.black87, ) : null,
      title: title is Widget ? title : text(title, color: Colors.black87, size: 20, bold: true ),
      actions: actions,
    );
  }

  // box alert message, box(context, title: 'Lorem', message: 'Ipsum dolor set amet')
  static box(context, {dismiss: true, Color color, title, message: ''}){
    showDialog(
      context: context,
      barrierDismissible: dismiss,
      builder: (BuildContext context) {

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: Mquery.width(context),
              margin: EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Material(
                  // color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Container(
                        color: color == null ? Colors.white : color,
                        child: Column(
                          children: <Widget>[
                      
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.black12))
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  title == null ? SizedBox.shrink() : Container(
                                    child: title is Widget ? title : html(title, bold: true, size: 14), margin: EdgeInsets.only(bottom: 0), 
                                  ),
                                  message is Widget ? message : html(message)
                              ],)
                            ),

                          ],
                        ),
                      ),

                      Container(
                        child: Button(
                          onTap: (){ Navigator.pop(context); },
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width: Mquery.width(context),
                            child: text('Tutup', bold: true, align: TextAlign.center)
                          )
                        ),
                      )
                    ],
                  ),
                )
              )
            )
          ],
        );
      }
    );
  }

  // noData()
  static noData({message: '', img: 'empty.png', Function onRefresh, double margin: 0, Function onTap}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: margin, bottom: margin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(onTap: onTap, child: Image.asset('assets/img/'+img, height: 150, fit: BoxFit.cover,)),
                Container(
                  padding: EdgeInsets.all(10),
                  child: text(message, color: Colors.black54, size: 15, align: TextAlign.center)
                ),
                Container(
                  child: onRefresh != null ? IconButton(
                    icon: Icon(Icons.refresh, color: Colors.black54,),
                    onPressed: onRefresh,
                  ) : SizedBox.shrink(),
                )
              ],
            ),
            padding: EdgeInsets.all(10),
          )
        ],
      )
    );
  }

  // body: Wi.spiner(size: 50)
  static spiner({double size: 20, Color color, double stroke: 2, double margin: 0}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
          Container(
            margin: EdgeInsets.all(margin),
            child: SizedBox(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation( color == null ? Colors.blue : color),
                  strokeWidth: stroke),
              ),
              height: size, width: size,
          ),

        ]
      )
    );
  }

  // datePicker(context, init: DateTime.now(), min: dateTime(format: 'now-')).then((res){ })
  static datePicker(BuildContext context, {DateTime init, DateTime min, DateTime max}) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: init == null ? DateTime.now() : init,
      firstDate: min == null ? DateTime(1800, 0) : min,
      lastDate: max == null ? DateTime(2030) : max
    );

    if(picked != null){
      var date = picked.toString().split(' ');
      return date[0];
    }
  }

  // dateRangePicker(context, min: DateTime(Dt.y, Dt.m, Dt.d)).then((res){ })
  static dateRangePicker(BuildContext context, {
    DateTime firstDate, DateTime lastDate, DateTime min, DateTime max}) async {
    var y = DateTime.now().year, m = DateTime.now().month, d = DateTime.now().day;

    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: firstDate == null ? DateTime(y, m, d) : firstDate,
        initialLastDate: firstDate == null ? DateTime(y, m, d + 3) : firstDate,
        firstDate: min == null ? DateTime(y) : min,
        lastDate: max == null ? DateTime(y + 1) : max
    );
      
    if (picked != null) return picked.toList();
  }

  // options(context, options: ['Edit','Delete'], then: (res){ })
  static options(context, {List<String> options, Function then}){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return ListOption(options: options);
      }
    ).then((res){
      if(then != null) then(res);
    });
  }

  // confirm(context, message: 'Lorem ipsum?', textButton: ['No','Yes'], then: (res){ });
  static confirm(context, {@required String message, List<String> textButton, Function then}){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return WidgetConfirmation(message: message, textButton: textButton);
      }
    ).then((res){
      if(then != null) then(res);
    });
  }

  // icon & text, itext(icon: Icons.lock, child: 'lorem ipsum')
  static itext({@required icon, @required child, double space: 7, MainAxisAlignment align}){
    return Row(
      mainAxisAlignment: align == null ? MainAxisAlignment.start : align,
      children: <Widget>[
        icon is IconData ? Icon(icon, size: 14, color: Colors.black54) : icon,
        
        Container(
          margin: EdgeInsets.only(left: space),
          child: child is Widget ? child : Text(child)
        )
      ],
    );
  }

}

// form input ----------


class FormControl {

  static search({hint: '', length: 255, TextEditingController controller, FocusNode node, autofocus: true, TextInputType keyboard, TextInputAction inputAction, Function onSubmit, Function onChange}){
    return TextField(
      controller: controller,
      focusNode: node,
      autofocus: autofocus,
      keyboardType: keyboard,
      textInputAction: inputAction,
      onSubmitted: onSubmit,
      onChanged: onChange,
      decoration: new InputDecoration(
        alignLabelWithHint: true,
        border: InputBorder.none,
        isDense: true,
        hintText: hint,
        hintStyle: TextStyle(fontFamily: 'sans'),
        contentPadding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10)
      ),
      style: TextStyle(fontFamily: 'sans'),
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
    );
  }

  static transparent({
    hint: '', length: 255, maxlines: 1, minLines, double fontSize: 16, FontWeight weight,
    EdgeInsetsGeometry padding,
    TextEditingController controller, FocusNode node, autofocus: false, bool enabled: true, TextInputType keyboard, TextInputAction inputAction, Function onSubmit, Function onChange}){
    
    return TextField(
      controller: controller,
      focusNode: node,
      autofocus: autofocus,
      keyboardType: keyboard,
      textInputAction: inputAction,
      enabled: enabled,
      onSubmitted: onSubmit,
      onChanged: onChange,
      minLines: minLines,
      maxLines: maxlines,
      decoration: new InputDecoration(
        alignLabelWithHint: true,
        border: InputBorder.none,
        isDense: true,
        hintText: hint,
        hintStyle: TextStyle(fontFamily: 'sans', fontSize: fontSize),
        contentPadding: padding == null ? EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10) : padding
      ),
      style: TextStyle(fontFamily: 'sans', fontSize: fontSize, fontWeight: weight),
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
    );
  }

  // switch button, FormControl.toggle(value: data, onChange: (b){ data = b; })
  static toggle({@required Function onChange, bool value: false, bool enabled: true}){
    return FormToggle(onChange: onChange, config: {'value': value, 'enabled': enabled});
  }

  // form input
  static input({
    label, hint: '', length: 255, int minLines: 1, int maxLines, double mb: 25, TextEditingController controller, FocusNode node, bool enabled: true,
    TextInputType keyboard, TextInputAction inputAction, Function onSubmit, Function onChange, bool obsecure: false
      
    }){

    InputDecoration inputDecoration = new InputDecoration(
      alignLabelWithHint: true,
      border: InputBorder.none,
      isDense: true,
      hintText: hint,
      hintStyle: TextStyle(fontFamily: 'sans'),
      contentPadding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        label == null ? SizedBox.shrink() : 
        Container(
          margin: EdgeInsets.only(bottom: 7),
          child: text(label, bold: true)
        ),

        Container(
          margin: EdgeInsets.only(bottom: mb),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(4),
            color: enabled ? Colors.white : Cl.black05()
          ),
          child: maxLines != null ? TextField(
            controller: controller, focusNode: node, minLines: minLines,
            maxLines: maxLines, keyboardType: keyboard, textInputAction: inputAction, onSubmitted: onSubmit,
            enabled: enabled, onChanged: onChange, decoration: inputDecoration,
            style: TextStyle(fontFamily: 'sans'),
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
            ],
          ) :
          
          TextField(
            controller: controller,
            focusNode: node,
            keyboardType: keyboard,
            textInputAction: inputAction,
            onSubmitted: onSubmit,
            enabled: enabled,
            onChanged: onChange,
            obscureText: obsecure,
            decoration: inputDecoration,
            style: TextStyle(fontFamily: 'sans'),
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
            ],
          ),
        )
      ],
    );
  }

  static number({label, @required TextEditingController controller, FocusNode node, TextInputAction inputAction, Function onSubmit, Function onChange}){
    return FormNumber(
      label: label, controller: controller, node: node, inputAction: inputAction, onSubmit: onSubmit, onChange: onChange
    );
  }

  // FormControl.radio(values: ['lorem','ipsum','dolor'], checked: 'ipsum', onChange: (c){ print(c);  }),
  static radio({label, @required List values, @required String checked, Function onChange, double mb: 25, double mt: 0}){
    return WidgetRadio(label: label, params: {'checked': checked, 'values': values}, onChange: onChange, mb: mb, mt: mt);
  }

  // FormControl.checkbox(values: ['lorem','ipsum','dolor'], checked: 'ipsum', onChange: (c){ print(c);  }),
  static checkbox({label, @required List values, @required List checked, Function onChange, bool enabled: true, double marginY}){
    return WidgetCheckbox(label: label, values: values, checked: checked, onChange: onChange, enabled: enabled, marginY: marginY);
  }

  // FormControl.optionBox(values: ['lorem','ipsum','set'], checked: 'lorem', onChange: (c){ print(c); }),
  static optionBox({label, @required List values, @required String checked, Function onChange}){
    return OptionBox(label: label, config: {'values': values, 'checked': checked}, onChange: onChange);
  }

  // FormControl.dropdown(controller: controller, options: ['lorem','ipdum','dolor']),
  static dropdown({String label, @required TextEditingController controller, @required List options, List values}){
    return WidgetDropdown(label: label, options: options, controller: controller, values: values);
  }

  // FormControl.select(context, controller: controller, onTap: (){ ...new page })
  static select(context, {String label, Widget icon, TextEditingController controller, Function onTap}){
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label == null ? SizedBox.shrink() : 
          Container(
            margin: EdgeInsets.only(bottom: 7),
            child: text(label, bold: true),
          ),

          Button(
            onTap: onTap,
            radius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  width: Mquery.width(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: text(controller.text),
                ),

                icon == null ? SizedBox.shrink() :
                Positioned(
                  right: 8, top: 8,
                  child: icon,
                )
              ]
            )
          ),
        ]
      )
    );
  }

  // FormControl.button(textButton: 'Submit', isSubmit: bool, onTap: (){ })
  static button({
    String textButton, EdgeInsetsGeometry padding, EdgeInsetsGeometry margin, 
    BorderRadiusGeometry radius, bool isSubmit: false, Color color, double width, double mb: 25, Function onTap}){
    
    return Container(
      margin: margin == null ? EdgeInsets.only(bottom: mb) : margin,
      width: width == null ? null : width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Button(
          onTap: isSubmit ? null : onTap, padding: EdgeInsets.all(11),
          color: isSubmit ? Colors.red[200] : color == null ? Colors.red : color,
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              isSubmit ? Wi.spiner(color: Colors.white, size: 17) : text(textButton, color: Colors.white)
            ],
          ),
        ),
      )
    );
  }

}

// apis ----------

class Api {



  // await post('user', formData: {}, debug: true, then: (res){ }, error: (err){ })
  static post(url, {@required formData, debug: false, authorization: true, Function then, Function error}) async{
    var prefs = await SharedPreferences.getInstance();

    checkConnection().then((con){
      if(con){
        try {
          http.post(api(url), body: formData, headers: !authorization ? {} : {
            HttpHeaders.authorizationHeader: prefs.getString('token'), 'Accept': 'application/json'
          }).then((res){
            if(debug){
              print('# request : '+res.request.toString());
              print('# status : '+res.statusCode.toString());
              print('# body : '+res.body.toString());
            }

            if(then != null) then(res.statusCode, res.body);
          });
        } catch (e) {
          if(e is PlatformException) {
            if(error != null) error(e.message);
          }
        }
      }else{
        Wi.toast('Check your internet connection!');
      }
    });
  }

  // await get('user', debug: true, then: (res){ }, error: (err){ })
  static get(url, {debug: false, authorization: true, Function then, Function error}) async{
    var prefs = await SharedPreferences.getInstance();

    checkConnection().then((con){
      if(con){
        try {
          http.get(api(url), headers: !authorization ? {} : {
            HttpHeaders.authorizationHeader: prefs.getString('token'), 'Accept': 'application/json'
          }).then((res){
            if(debug){
              print('# request : '+res.request.toString());
              print('# status : '+res.statusCode.toString());
              print('# body : '+res.body.toString());
            }

            if(then != null) then(res.statusCode, res.body);
          });
        } catch (e) {
          if(e is PlatformException) {
            if(error != null) error(e.message);
          }
        }
      }else{
        Wi.toast('Check your internet connection!');
      }
    });
  }

  // await put('user', formData: {}, debug: true, then: (res){ }, error: (err){ })
  static put(url, {@required formData, debug: false, authorization: true, Function then, Function error}) async{
    var prefs = await SharedPreferences.getInstance();

    checkConnection().then((con){
      if(con){
        try {
          http.put(api(url), body: formData, headers: !authorization ? {} : {
            HttpHeaders.authorizationHeader: prefs.getString('token'), 'Accept': 'application/json'
          }).then((res){
            if(debug){
              print('# request : '+res.request.toString());
              print('# status : '+res.statusCode.toString());
              print('# body : '+res.body.toString());
            }

            if(then != null) then(res.statusCode, res.body);
          });
        } catch (e) {
          if(e is PlatformException) {
            if(error != null) error(e.message);
          }
        }
      }else{
        Wi.toast('Check your internet connection!');
      }
    });
  }

  // await delete('user/1', debug: true, then: (res){ }, error: (err){ })
  static delete(url, {@required formData, debug: false, authorization: true, Function then, Function error}) async{
    var prefs = await SharedPreferences.getInstance();

    checkConnection().then((con){
      if(con){
        try {
          http.delete(api(url), headers: !authorization ? {} : {
            HttpHeaders.authorizationHeader: prefs.getString('token'), 'Accept': 'application/json'
          }).then((res){
            if(debug){
              print('# request : '+res.request.toString());
              print('# status : '+res.statusCode.toString());
              print('# body : '+res.body.toString());
            }

            if(then != null) then(res.statusCode, res.body);
          });
        } catch (e) {
          if(e is PlatformException) {
            if(error != null) error(e.message);
          }
        }
      }else{
        Wi.toast('Check your internet connection!');
      }
    });
  }

}