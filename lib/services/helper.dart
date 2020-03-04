import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helper/services/helper-widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

/* class list

  1. Fn -> kumpulan fungsi
  2. Wi -> kumpulan widget
  3. FormControl -> kumpulan input
  4. Clr -> kumpulan warna
  
  */

final oCcy = new NumberFormat("#,##0", "en_US");

// tampilkan text dengan mudah
text(text, {color, double size: 15, bold: false, TextAlign align: TextAlign.left, double spacing: 0, font: 'sans'}){
  return Text(text.toString(), softWrap: true, textAlign: align, style: TextStyle(
      color: color == null ? Color.fromRGBO(60, 60, 60, 1) : color, 
      fontFamily: font,
      fontSize: size,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      letterSpacing: spacing,
    ),
  );
}

html(message, {borderBottom, double padding: 0, double size: 13, bold: false, TextAlign align: TextAlign.left}){
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
    defaultTextStyle: TextStyle(fontFamily: 'sans', fontSize: size, fontWeight: bold ? FontWeight.bold : FontWeight.normal))
  );
}

mquery(context, {attr: 'width'}){
  switch (attr) {
    case 'width': return MediaQuery.of(context).size.width; break;
    case 'height': return MediaQuery.of(context).size.height; break;
    case 'p-top': return MediaQuery.of(context).padding.top; break;
  }
}

modal(context, {Widget child, Function onClose, height: 'full', Color background: Colors.white}) async {
  showModalBottomSheet(
    backgroundColor: background,
    context: context,
    builder: (BuildContext _) {
      return Container(
        height: height != 'full' ? height.toDouble() :  MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
        child: child
      );
    },
    isScrollControlled: true,
  ).then((res) { if(onClose != null) onClose(res); });
}

/* cegah glow pada scroll, ex :
  ScrollConfiguration(
    behavior: PreventScrollGlow(),
    child: ...
  )
*/

class PreventScrollGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class Fn{

  // convert penomoran ribuan
  static ribuan(int number){
    if(number == null){
      return '-';
    }

    return oCcy.format(number).replaceAll(',', '.');
  }

  // rubah setiap huruf pada awal kata
  static ucwords(String s){
    if(s != '' && s != null){
      var splitStr = s.replaceAll(new RegExp(r"\s+\b|\b\s"), ' ').toLowerCase().split(' ');
      for (var i = 0; i < splitStr.length; i++) {
        if(splitStr[i] != ''){
          splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);     
        }
      }
      return splitStr.join(' ');
    }else{
      return '';
    }
  }

  // alert message
  static toast(String msg){
    return Fluttertoast.showToast(
      msg: msg == null ? 'Kesalahan Server' : msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      
      timeInSecForIos: 1,
      backgroundColor: Color.fromRGBO(0, 0, 0, .8),
      textColor: Colors.white,
      fontSize: 14.0
    );
  }

  // perika koneksi internet, checkConnection().then((con){ ... })
  static checkConnection() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }else{
      return false;
    }
  }

  // encode & decode
  static encode(data){ return json.encode(data); }
  static decode(data){
    if(data != null){
      return json.decode(data); 
    }
  }

  // set data ke local storage, setPrefs('user', data, enc: true);
  static setPrefs(key, data, {enc: false}) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, enc ? encode(data) : data);
  }

  // get data dari local storage, getPrefs('key').then((res){ ... });
  static getPrefs(key, {dec: false}) async{
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);
    return data == null ? 'null' : dec ? decode(data) : data;
  }

  // periksa key apa saja yang tersimpan di local storage, checkPrefs();
  static checkPrefs() async{
    var prefs = await SharedPreferences.getInstance();
    print(prefs.getKeys());
  }

  // hapus local storage, clearPrefs(['user']); -> kecuali data user
  static clearPrefs({List except}) async{
    var prefs = await SharedPreferences.getInstance(), keys = prefs.getKeys();
    for (var i = 0; i < keys.toList().length; i++) {
      if( except.indexOf(keys.toList()[i]) < 0 ){
        prefs.remove(keys.toList()[i]);
      }
    }
  }

  // validasi email, jika email valid -> return true
  static emailValidate(String email){
    return email == null || email == '' ? 'Oops!' : RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  // get waktu saat ini
  static dateTime({format: 'datetime'}){ // datetime, date, time
    var date = new DateTime.now().toString().split('.');
    var dateTime = date[0].split(' ');
    return format == 'datetime' ? date[0] : format == 'date' ? dateTime[0] : dateTime[1];  
  }

  // format tanggal harus yyyy-mm-dd hh:ii:ss
  static dateFormat(date, {format: 'd-M-y', type: 'short'}){
    var dateParse = DateTime.parse(date);
    var bln = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktoberr','November','Desember'];
  
    var x = date.split(' ')[0],
    d = int.parse(x.split('-')[2]).toString().length,
    m = int.parse(x.split('-')[1]).toString().length;

    var dd = 'd', mm = 'M';

    if(d == 1){ dd = '0d'; }
    if(m == 1){ mm = '0M'; }

    _d(dt){ return DateFormat( dt ).format(dateParse); }

    switch (format) {
      case 'd': return DateFormat(d == 1 ? '0d' : 'd').format(dateParse); break;
      case 'M': return DateFormat('MMM').format(dateParse); break;
      case 'F': return DateFormat('MMMM').format(dateParse); break;
      case 'Y': return DateFormat('y').format(dateParse); break;
      default: return type == 'short' ? DateFormat( dd+'-'+mm+'-y' ).format(dateParse) : _d(dd)+' '+bln[int.parse(_d(mm)) - 1]+' '+_d('y');
    }
  }

  // buka google map
  static openMap(latitude, longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      toast('Tidak dapat membuka map');
    }
  }

  // tampilkan waktu yang lalu, format tanggal harus yyyy-mm-dd hh:ii:ss
  static timeAgo(datetime){
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

  // hitung umur, format tanggal yyyy-mm-dd hh:ii:ss / yyyy-mm-dd
  static calcAge(date){
    if(date == null){
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

  // generate timestamp
  static generate(){
    return DateTime.now().millisecondsSinceEpoch;
  }

  // ambil huruf pertama pada string
  static firstChar(string, {length: 2}){
    var str = string.split(' ');
    var char = '';

    for (var i = 0; i < str.length; i++) {
      if(i < length){
        char += str[i].substring(0, 1);
      }
    }

    return char.toUpperCase();
  }


}

// kumpulan widget
class Wi{

  // appbar
  static appBar(context, {title = '', elevation = 1, back: true, spacing: 15, List<Widget> actions, autoLeading: false}){
    return back ? new AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: autoLeading,
      titleSpacing: 0,
      elevation: elevation.toDouble(),
      leading: IconButton( onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back), color: Colors.black87, ),
      title: title is Widget ? title : text(title, color: Colors.black87, size: 20, bold: true ),
      actions: actions,
    ) : 
    new AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: autoLeading,
      titleSpacing: spacing.toDouble(),
      elevation: elevation.toDouble(),
      title: title is Widget ? title : text(title, color: Colors.black87, size: 20, bold: true ),
      actions: actions,
    );
  }

  // box alert message
  static box(context, {dismiss: true, title, message: ''}){
    showDialog(
      context: context,
      barrierDismissible: dismiss,
      builder: (BuildContext context) {

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: mquery(context),
              margin: EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Material(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Container(
                        color: Colors.white,
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
                                    child: html(title, bold: true, size: 17), margin: EdgeInsets.only(bottom: 5), 
                                  ),
                                  html(message)
                              ],)
                            ),

                          ],
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

  // tampilkan saat data kosong
  static nodata({message: '', img: 'no-data.png', Function onRefresh, Function onTap}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(onTap: onTap, child: Image.asset('assets/img/'+img, height: 130)),
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

  // spiner animasi
  static spiner({size: 15, Color color, stroke: 2, margin: 0, marginX: 0, message: 'loading', position: 'default'}){
    Widget spinerWidget(){
      return Container(
        margin: margin == 0 ? EdgeInsets.only(left: marginX.toDouble(), right: marginX.toDouble()) : EdgeInsets.all(margin.toDouble()),
        child: SizedBox(
          child: new Container(
            padding: EdgeInsets.all(1),
            child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation( color == null ? Colors.blue : color),
              strokeWidth: stroke.toDouble()),
          ),
          height: size.toDouble(),
          width: size.toDouble(),
        )
      );
    }  

    return position == 'center' ?

    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[ spinerWidget() ],
      )
    ) : spinerWidget();
  }

  static datePicker(BuildContext context, {DateTime init, DateTime min, DateTime max}) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: init == null ? DateTime.now() : init,
      firstDate: min == null ? DateTime(1950, 0) : min,
      lastDate: max == null ? DateTime(2030) : max
    );

    if(picked != null){
      var date = picked.toString().split(' ');
      return date[0];
    }
  }

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
      
    if (picked != null) {
      return picked.toList();
    }
  }

  static options(context, {List<String> options, Function then}){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return HOptions(options: options);
      }
    ).then((res){
      if(then != null) then(res);
    });
  }

  static confirm(context, {Function then}){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return HConfirmation();
      }
    ).then((res){
      if(then != null) then(res);
    });
  }

  





}

// kumpulan widget untuk form
class FormControl{
  final context, font = 'sans';
  FormControl({this.context});

  // text input
  static Widget input({label: '', hint: '', obsecure: false, length: 255, count: false, Function onChange, lines: 1, double mt: 35, TextEditingController controller, FocusNode node, TextInputType keyboard, TextInputAction inputAction, Function onSubmit}){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        
        Container(
          margin: EdgeInsets.only(top: mt),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              text(label, bold: true),
              count ? text(controller.text.length.toString()+'/'+length.toString()) : SizedBox.shrink()
            ],
          )
        ),

        TextField(
          controller: controller,
          focusNode: node,
          maxLines: lines,
          keyboardType: keyboard,
          textInputAction: inputAction,
          onSubmitted: onSubmit,
          onChanged: onChange,
          obscureText: obsecure,
          decoration: new InputDecoration(
            alignLabelWithHint: true,
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(fontFamily: 'sans')
          ),
          style: TextStyle(fontFamily: 'sans'),
          inputFormatters: [
            LengthLimitingTextInputFormatter(length),
          ],
        ),
      ],
    );
  }

  // radio button
  static Widget radio({label: '', List<String> values, group, double mt: 25, Function onChange}){

    List<Widget> list = [];

    for (var i = 0; i < values.length; i++) {
      list.add(
        Container(
          margin: EdgeInsets.only(right: 10, top: 10),
          height: 30,
          child: Material(
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: (){ onChange(values[i], i); },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: <Widget>[
                    Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: i,
                      groupValue: group,
                      onChanged: (int){
                        onChange(values[i], i);
                      },
                    ), text(Fn.ucwords(values[i]))
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: mt),
          child: text(label, bold: true),
        ),

        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row( children: list ))
      ],
    );
    
  }

  // widget seperti select option, bisa digunakan untuk pengambilan tanggal
  static Widget select({label: '', hint: '', double mt: 35, caret: true, TextEditingController controller, Function onTap}){
    return Container(
      margin: EdgeInsets.only(top: mt),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: text(label, bold: true),
          ),

          Material(
            child: InkWell(
              onTap: onTap,
              child: Stack(
                children: <Widget>[

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 7, bottom: 7),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black38
                        )
                      )
                    ),
                    child: text(controller.text == null || controller.text.isEmpty ? hint : controller.text, size: 16, color: controller.text == null || controller.text.isEmpty ? Colors.black54 : Colors.black87),
                  ),

                  caret ? 
                  Positioned(
                    child: Icon(Icons.keyboard_arrow_down, color: Colors.black38),
                    right: 0, top: 6,
                  ) : SizedBox.shrink(),

                ],
              )
              
            ),
          ),

        ],
      )
      
    );
  }

  static Widget select2({label: '', hint: '', double width: 100, double mt: 0, caret: true, TextEditingController controller, Function onTap}){
    return Container(
      margin: EdgeInsets.only(top: mt),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: text(label, bold: true),
          ),

          Material(
            child: InkWell(
              onTap: onTap,
              child: Stack(
                children: <Widget>[

                  Container(
                    width: width,
                    padding: EdgeInsets.only(top: 7, bottom: 7),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black38
                        )
                      )
                    ),
                    child: text(controller.text == null || controller.text.isEmpty ? hint : controller.text, size: 16, color: controller.text == null || controller.text.isEmpty ? Colors.black54 : Colors.black87),
                  ),

                  caret ? 
                  Positioned(
                    child: Icon(Icons.keyboard_arrow_down, color: Colors.black38),
                    right: 0, top: 6,
                  ) : SizedBox.shrink(),

                ],
              )
              
            ),
          ),

        ],
      )
      
    );
  }

  // fungsi untuk menampilkan dan memilih inputan
  static cupertinoSelector(context, {initialItem, List options, uppercase: false, Function onChange}){
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context){

        return Container(
          height: 190.0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)
            ),
            child: Column(
              children: <Widget>[

                  Expanded(
                    child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: initialItem,
                    ),
                    itemExtent: 40.0,
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: onChange,
                    children: new List<Widget>.generate(
                    options.length, (int index) {
                      return new Center(
                        child: text( uppercase ? Fn.ucwords(options[index]) : options[index] , size: 17),
                      );
                    }
                  )),
              ),

              ],
            ),
          ),
          
        );
      }
    );
  }

  // dropdown input
  static dropdown(context, {label: 'Label', value, List items, Function onChange}){
    return Container(
      margin: EdgeInsets.only(bottom: 0, top: 10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(bottom: 5),
            child: text(label, bold: true),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black26)
            ),
            child: DropdownButtonHideUnderline(
              
              child: ButtonTheme(
                height: 20,
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: value,
                  onChanged: onChange,
                  items: items.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: text(value),
                    );
                  }).toList(),
                ),
              )
            )
          ),
          
        ],
      ),
    );
  }

  // button
  static Widget button({
      double width: 100, double radius: 3,
      fullWidth: true, Widget child, Color color, Function onTap, 
      double mt: 35, double mb: 15, double mr: 0, double ml: 0
    }){
    
    return Container(
      margin: EdgeInsets.only(top: mt, bottom: mb, right: mr, left: ml),
      child: ConstrainedBox(
      constraints: BoxConstraints(minWidth: fullWidth ? double.infinity : width),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(radius)
          ),
          child: child, color: color,
          elevation: 0,
          padding: EdgeInsets.all(10),
          splashColor: Color.fromRGBO(255, 255, 255, .2),
          onPressed: onTap
        )
      ),
    );
  }
}

class Clr{
  static black({double opacity: 1}){
    return Color.fromRGBO(60, 60, 60, opacity);
  }

  static white({double opacity: 1}){
    return Color.fromRGBO(255, 255, 255, opacity);
  }

  static softSilver(){
    return Color.fromRGBO(245, 247, 251, 1);
  }
}

// class ini dapat digunakan sebagai button, atau element dengan splash
class Inkl extends StatelessWidget {
  Inkl({this.key, this.child, this.elevation : 0, this.onTap, this.onLongPress, this.padding, this.color, this.splash, this.radius, this.border}); 
  
  final Key key;
  final Widget child;
  final Function onTap;
  final Function onLongPress;
  final EdgeInsetsGeometry padding;
  final Color color, splash;
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

// showUp animasi
class ShowUp extends StatefulWidget {
  final Widget child;
  final int delay;
  final horizontal, speed;

  ShowUp({@required this.child, this.delay, this.horizontal: false, this.speed: 0.35});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  AnimationController _animController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: widget.horizontal ? Offset(widget.speed, 0.0) : Offset(0.0, widget.speed), end: Offset.zero)
            .animate(curve);

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
    super.dispose();
    _animController.dispose();
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

// countup dari 0 ke n -> nilai yang diset
class AnimatedCount extends StatefulWidget {
  AnimatedCount({this.count, this.bold: false, this.n: '', this.color: Colors.black87, this.size: 15}); final count, bold, n;
  final Color color;
  final double size;
  
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
      end: widget.count.toDouble(),
    ).animate(new CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: _controller,
    ));

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return text( _animation.value.toStringAsFixed(0)+widget.n, bold: widget.bold, color: widget.color, size: widget.size);
      },
    );
  }
}

// daftar square widget horizontal
class HList extends StatefulWidget {
  HList({this.labels, this.values, this.width: 110}); final labels, values, width;

  @override
  _HListState createState() => _HListState();
}

class _HListState extends State<HList> {
  var l = 0;

  @override
  void initState() {
    super.initState();
    l = this.widget.labels.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          text('~ scroll ke samping', size: 13, color: Colors.blue),

          Container(
            margin: EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12)
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  children: List.generate(l, (int i){
                    return Container(
                      width: this.widget.width.toDouble(),
                      decoration: BoxDecoration(
                        border: i < l - 1 ? Border(right: BorderSide(color: Colors.black12)) : Border()
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          text(this.widget.labels[i], bold: true),
                          text(this.widget.values[i])
                        ],
                      )
                    );
                  })
                ),
              )
            ),
          )
        ]
      )
    );
  }
}


class Fc {

  static input({
    label, hint: '', length: 255, TextEditingController controller, FocusNode node,
    TextInputType keyboard, TextInputAction inputAction, Function onSubmit, Function onChange, bool obsecure: false
    
    }){
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        label == null ? SizedBox.shrink() : 
        Container(
          margin: EdgeInsets.only(bottom: 7),
          child: text(label, bold: true)
        ),

        Container(
          margin: EdgeInsets.only(bottom: 25),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white
          ),
          child: TextField(
          controller: controller,
          focusNode: node,
          // maxLines: lines,
          keyboardType: keyboard,
          textInputAction: inputAction,
          onSubmitted: onSubmit,
          onChanged: onChange,
          obscureText: obsecure,
          decoration: new InputDecoration(
            alignLabelWithHint: true,
            border: InputBorder.none,
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(fontFamily: 'sans'),
            contentPadding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)
          ),
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
    return HNumberInput(
      label: label, controller: controller, node: node, inputAction: inputAction, onSubmit: onSubmit, onChange: onChange
    );
  }

  static radio({label, @required List values, @required group, Function onChange}){
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          label == null ? SizedBox.shrink() : 
          Container(
            margin: EdgeInsets.only(bottom: 7),
            child: text(label, bold: true),
          ),

          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
            children: List.generate(values.length, (int i){
              return Container(
                margin: EdgeInsets.only(right: 10),
                height: 30,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: (){ if(onChange != null) onChange({'value': values[i], 'index': i}); },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        children: <Widget>[
                          Radio(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: i,
                            groupValue: group,
                            onChanged: (int){
                              if(onChange != null) onChange({'value': values[i], 'index': i});
                            },
                          ), text(Fn.ucwords(values[i]))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ))
        ],
      ),
    );
  }

  static dropdown({String label, @required TextEditingController controller, @required List options, List values, }){
    return HDropdown(label: label, options: options, controller: controller, values: values);
  }


}