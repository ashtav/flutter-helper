import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'helper-widget.dart';

/* class list

  1. Fn -> kumpulan fungsi
  2. Wi -> kumpulan widget
  3. FormControl -> kumpulan input
  4. Clr -> kumpulan warna
  
  */

final oCcy = new NumberFormat("#,##0", "en_US");

String __api = 'https://kpm-api-test.kembarputra.com';

setExistApi() async {
  var prefs = await SharedPreferences.getInstance(),
      apiString = prefs.getString('api');

  if(apiString != null){
    __api = prefs.getString('api');
  }
}

api(url){
  setExistApi();
  return __api+'/'+url;
}

debug(String label, data){
  print('# '+label+' -> '+data.toString());
}

// tampilkan text dengan mudah
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

mquery(context, {attr: 'width'}){
  switch (attr) {
    case 'width': return MediaQuery.of(context).size.width; break;
    case 'height': return MediaQuery.of(context).size.height; break;
    case 'p-top': return MediaQuery.of(context).padding.top; break;
  }
}

modal(context, {Widget child, Function onClose, height: 'full', bool fullScreen: false, Color color, double radius: 0}) async {
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
          height: fullScreen ? _height : height != 'full' ? height.toDouble() :  _height - MediaQuery.of(context).padding.top,
          child: child
        ),
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

  // set default initial timer
  static timer(){
    return Timer(Duration(seconds: 0), (){ });
  }

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

  // set data ke local storage, setPrefs('user', data, true);
static setPrefs(key, data, {enc}) async{
  var prefs = await SharedPreferences.getInstance();

  // jika enc tidak null, set enc by param
  if(enc != null){
    prefs.setString(key, enc ? encode(data) : data);
  }else{
    // set enc by data type, [] = List, {} = Map
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
      prefs.setString(key, data);
    }

    else{
      prefs.setDouble(key, data);
    }

  }
}

  // get data dari local storage, getPrefs('key').then((res){ ... });
  static getPrefs(key, {dec: false, type: String}) async{
    var prefs = await SharedPreferences.getInstance();

    switch (type) {
      case List: return decode(prefs.getString(key)); break;
      case Map: return decode(prefs.getString(key)); break;
      case bool: return prefs.getBool(key); break;
      case int: return prefs.getInt(key); break;
      case String: return prefs.getString(key) == null ? null : dec ? decode(prefs.getString(key)) : prefs.getString(key); break;
      case double: return prefs.getDouble(key);
      default: print('--- get preferences: the result is null!'); return null;
    }
  }

  // set node focus
  static focus(context, node){
    FocusScope.of(context).requestFocus(node);
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
      case 'd-m-Y h:i:s': return DateFormat( dd+'-'+mm+'-y' ).format(dateParse)+' '+date.split(' ')[1]; break;
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

  static formatBytes(bytes, {decimals: 2}){
    if(bytes == 0) return '0 Bytes';

    var k = 1024,
        dm = decimals < 0 ? 0 : decimals,
        sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

    var i = (math.log(bytes) / math.log(k)).floor();

    return (bytes / math.pow(k, i)).toStringAsFixed(dm)+' '+sizes[i];
  }

  static cutHalf(String s, {int maxLength: 40}){
    if(s.length < maxLength) return s;

    var ls = s.length,
        first = s.substring(0, ((ls/3).round()) + (maxLength/3).round()),
        end = s.substring(ls - 7, ls);

    return first+'...'+end;
  }


}

// kumpulan widget
class Wi{

  static listExpanded({Widget title, List list, bool expand: false, Function onExpand, Function onListTap}){
    return ListExpanded(title: title, list: list, expand: expand, onExpand: onExpand, onListTap: onListTap);
  }

  static alertMsg({@required Widget child, double mBottom: 15, double padding: 15, Color color, BoxBorder border, theme: 'default'}){

    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.only(bottom: mBottom),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color == null ? theme == 'default' ? Colors.blueGrey[50] : Colors.blue[100] : color,
        borderRadius: BorderRadius.circular(4),
        border: border == null ? theme == 'default' ? Border.all(color: Colors.blueGrey[100]) : Border.all(color: Colors.blue[200]) : border
      ),
      child: child,
    );
  }

  // show dialog
  static dialog(context, {dismiss: true, bool setMaterial: false, MainAxisAlignment position, @required Widget child, Function then}){
    return showDialog(
      context: context,
      barrierDismissible: dismiss,
      builder: (BuildContext context){
        return !setMaterial ? child : Column(
          mainAxisAlignment: position == null ? MainAxisAlignment.center : position,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: mquery(context),
              margin: EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Material(
                  child: child,
                ),
              ),
            )
          ]
        );
      }
    ).then((res){
      if(then != null){
        then(res);
      }
    });
  }

  // appbar
  static appBar(context, {title = '', Color color, elevation = 1, back: true, spacing: 15, List<Widget> actions, autoLeading: false}){
    return back ? new AppBar(
      backgroundColor: color == null ? Colors.white : color,
      automaticallyImplyLeading: autoLeading,
      titleSpacing: 0,
      elevation: elevation.toDouble(),
      leading: IconButton( onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back), color: Colors.black87, ),
      title: title is Widget ? title : text(title, color: Colors.black87, size: 20, bold: true ),
      actions: actions,
    ) : 
    new AppBar(
      backgroundColor: color == null ? Colors.white : color,
      automaticallyImplyLeading: autoLeading,
      titleSpacing: spacing.toDouble(),
      elevation: elevation.toDouble(),
      title: title is Widget ? title : text(title, color: Colors.black87, size: 20, bold: true ),
      actions: actions,
    );
  }

  // box alert message
  static box(context, {dismiss: true, Color color, title, message: ''}){
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
                  color: Colors.transparent,
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
                                    child: title is Widget ? title : html(title, bold: true, size: 17), margin: EdgeInsets.only(bottom: 5), 
                                  ),
                                  message is Widget ? message : html(message)
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
  static nodata({message: '', img: 'no-data.png', Function onRefresh, double marginY: 0, Function onTap}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: marginY, bottom: marginY),
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
  static spiner({size: 15, Color color, stroke: 2, margin: 1, marginX: 0, position: 'center'}){
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
      firstDate: min == null ? DateTime(1800, 0) : min,
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

  static confirm(context, {Function then, String message: 'Yakin ingin menghapus data ini?'}){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return HConfirmation(message: message);
      }
    ).then((res){
      if(then != null) then(res);
    });
  }

  static itext({@required icon, @required Widget child, double space: 7, MainAxisAlignment mainAxisAlignment}){
    return Row(
      mainAxisAlignment: mainAxisAlignment == null ? MainAxisAlignment.start : mainAxisAlignment,
      children: <Widget>[
        icon is IconData ? Icon(icon, size: 14, color: Colors.black54) : icon,
        
        Container(
          margin: EdgeInsets.only(left: space),
          child: child
        )
      ],
    );
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

  static white({double opacity: 1}){
    return Color.fromRGBO(255, 255, 255, opacity);
  }

  static softSilver(){
    return Color.fromRGBO(245, 247, 251, 1);
  }
}

// class ini dapat digunakan sebagai button, atau element dengan splash
class Inkl extends StatelessWidget {
  Inkl({this.key, this.child, this.elevation : 0, this.onTap, this.onLongPress, this.padding, this.color, this.splash, this.highlightColor, this.radius, this.border}); 
  
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
  void dispose() {
    super.dispose(); _controller.dispose();
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

  static toggle({Function onChange, bool value: false, bool enabled: true, String label}){
    return HToggle(onChange: onChange, value: value, enabled: enabled, label: label);
  }

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
            color: enabled ? Colors.white : Clr.black(opacity: .07)
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
    return HNumberInput(
      label: label, controller: controller, node: node, inputAction: inputAction, onSubmit: onSubmit, onChange: onChange
    );
  }

  // static radio({label, @required List values, @required group, Function onChange}){
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 25),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         label == null ? SizedBox.shrink() : 
  //         Container(
  //           margin: EdgeInsets.only(bottom: 7),
  //           child: text(label, bold: true),
  //         ),

  //         SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
  //           children: List.generate(values.length, (int i){
  //             return Container(
  //               margin: EdgeInsets.only(right: 10),
  //               height: 30,
  //               child: Material(
  //                 borderRadius: BorderRadius.circular(20),
  //                 child: InkWell(
  //                   onTap: (){ if(onChange != null) onChange({'value': values[i], 'index': i}); },
  //                   borderRadius: BorderRadius.circular(20),
  //                   child: Container(
  //                     padding: EdgeInsets.only(right: 15),
  //                     decoration: BoxDecoration(
  //                       border: Border.all(color: Colors.black12),
  //                       borderRadius: BorderRadius.circular(20)
  //                     ),
  //                     child: Row(
  //                       children: <Widget>[
  //                         Radio(
  //                           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                           value: i,
  //                           groupValue: group,
  //                           onChanged: (int){
  //                             if(onChange != null) onChange({'value': values[i], 'index': i});
  //                           },
  //                         ), text(Fn.ucwords(values[i]))
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }),
  //         ))
  //       ],
  //     ),
  //   );
  // }

  static radio({label, @required List values, @required String checked, Function onChange, double mb: 25, double mt: 0}){
    return HRadioButton(label: label, values: values, checked: checked, onChange: onChange, mb: mb, mt: mt);
  }

  static optionBox({label, @required List values, @required String checked, Function onChange}){
    return HOptionBox(label: label, values: values, checked: checked, onChange: onChange);
  }

  static checkbox({label, @required List values, @required List checked, Function onChange, bool enabled: true, double marginY}){
    return HCheckBox(label: label, values: values, checked: checked, onChange: onChange, enabled: enabled, marginY: marginY);
  }

  static dropdown({String label, @required TextEditingController controller, @required List options, List values, }){
    return HDropdown(label: label, options: options, controller: controller, values: values);
  }

  static select(context, {label, @required Widget options, TextEditingController controller, bool enabled: true, Function onChange}){
    return HSelect(context, label: label, options: options, controller: controller, enabled: enabled, onChange: onChange);
  }

  static select2(context, {String label, Widget icon, TextEditingController controller, Function onTap}){
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

          Inkl(
            onTap: onTap,
            radius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  width: mquery(context),
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

  static button({Widget child, EdgeInsetsGeometry padding, EdgeInsetsGeometry margin, BorderRadiusGeometry radius, Color color, double width, double mb: 25, Function onTap}){
    return Container(
      margin: margin == null ? EdgeInsets.only(bottom: mb) : margin,
      width: width == null ? null : width,
      child: Inkl(
        onTap: onTap,
        color: color == null ? Colors.blueGrey : color,
        radius: radius == null ? BorderRadius.circular(4) : radius,
        padding: padding == null ? EdgeInsets.all(11) : padding,
        child: child
      ),
    );
  }


}

class Api{

  static result(obj){
    if(obj != null){
      print(obj.request);
      print(obj.statusCode);
      print(obj.body);
    }
  }

  static post(url, {@required formData, authorization: true, Function then}) async {
    var prefs = await SharedPreferences.getInstance();

    Fn.checkConnection().then((con){
      if(con){
        http.post(api(url), body: formData, headers: !authorization ? {} : {
          HttpHeaders.authorizationHeader: prefs.getString('token'), "Accept": "application/json"
        }).then((res){
          if(then != null) then(res);
        });
      }else{
        Fn.toast('Periksa koneksi internet!');
      }
    });

    
  }

  static get(url, {Function then}) async {
    var prefs = await SharedPreferences.getInstance();

    http.get(api(url), headers: {
      HttpHeaders.authorizationHeader: prefs.getString('token'), "Accept": "application/json"
    }).then((res){ 
      if(then != null) then(res);
    });
  }

  static put(url, {@required formData, Function then}) async {
    var prefs = await SharedPreferences.getInstance();

    http.put(api(url), body: formData, headers: {
      HttpHeaders.authorizationHeader: prefs.getString('token'), "Accept": "application/json"
    }).then((res){ 
      if(then != null) then(res);
    });
  }

  static delete(url, {Function then}) async {
    var prefs = await SharedPreferences.getInstance();

    http.delete(api(url), headers: {
      HttpHeaders.authorizationHeader: prefs.getString('token'), "Accept": "application/json"
    }).then((res){ 
      if(then != null) then(res);
    });
  }
  
}


class Message{

  static error(e, {String message: 'Terjadi kesalahan', Timer timer}){
    print('error : '+e.toString());
    Fn.toast(message);

    if(timer != null){
      timer.toString();
    }
  }

  static connection(context, {Timer timer}){
    if(timer != null){
      timer.cancel();
    }
    
    Wi.box(context, title: 'Network Connection!', message: 'Sepertinya terjadi masalah pada koneksi internet Anda, periksa jaringan dan pastikan koneksi internet Anda stabil.');
  }

  static fail({obj, String message: 'Terjadi kesalahan', Timer timer}){
    Fn.toast(message);
    if(timer != null){
      timer.cancel();
    }

    if(obj != null){
      print(obj.request);
      print(obj.statusCode);
      print(obj.body);
    }
  }

}

class CircleProgressBarPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;

  CircleProgressBarPainter({
    this.backgroundColor,
    @required this.foregroundColor,
    @required this.percentage,
    this.width,
    double strokeWidth,
  }) : this.strokeWidth = strokeWidth ?? width;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final Size constrainedSize = size - Offset(this.strokeWidth, this.strokeWidth);
    final shortestSide = math.min(constrainedSize.width, constrainedSize.height);
    final foregroundPaint = Paint()
      ..color = this.foregroundColor
      ..strokeWidth = this.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final radius = (shortestSide / 2);

    // Start at the top. 0 radians represents the right edge
    final double startAngle = -(2 * math.pi * 0.25);
    final double sweepAngle = (2 * math.pi * (this.percentage ?? 0));

    // Don't draw the background if we don't have a background color
    if (this.backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = this.backgroundColor
        ..strokeWidth = this.strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, backgroundPaint);
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as CircleProgressBarPainter);
    return oldPainter.percentage != this.percentage ||
        oldPainter.backgroundColor != this.backgroundColor ||
        oldPainter.foregroundColor != this.foregroundColor ||
        oldPainter.strokeWidth != this.strokeWidth;
  }
}

class CircleProgressBar extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final double value, width;
  final Widget child;

  const CircleProgressBar({
    Key key,
    this.backgroundColor,
    this.foregroundColor,
    @required this.value,
    this.width: 5, this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor;
    final foregroundColor = this.foregroundColor;

    _color(){
      return this.value < .5 ? Colors.red : this.value < .7 ? Colors.orange : Colors.green;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        child: Center(
          child: child
        ),
        foregroundPainter: CircleProgressBarPainter(
          width: width,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor == null ? _color() : foregroundColor,
          percentage: this.value,
        ),
      ),
    );
  }
}