import 'package:flutter/cupertino.dart';

class AssignCodePage extends StatefulWidget {
  const AssignCodePage({Key? key}) : super(key: key);

  @override
  State<AssignCodePage> createState() => _AssignCodePageState();
}

class _AssignCodePageState extends State<AssignCodePage> {
  _AssignCodePageState();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


// SizedBox(
// width: 200,
// height: 50,
// child: ElevatedButton(
// style: ElevatedButton.styleFrom(
// backgroundColor: Color(0xFFD06700),
// foregroundColor: Colors.black,
// //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
// //fixedSize: const Size(0, 50),
// shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
// ),
// child: Text('Send Code', style: TextStyle(fontSize: 18)),
// onPressed: () {
// showDialog<String>(
// context: context,
// builder: (BuildContext context) => AlertDialog(
// title: Text('Send Code'),
// content: Text('resetChatMessage'),
// actions: <Widget>[
// TextButton(
// child: Text('cancel'),
// onPressed: () {
// Navigator.of(context).pop();
// },
// ),
// TextButton(
// onPressed: () async {
// if(result != null && result?.code != null){
// int? length = result!.code?.length;
// String? code = result?.code.toString().split("/").last;
// print(code! + "+++++++++++++++++++++++++++++" + result!.code.toString());
// await _mesRef.set({
// code.toString(): {
// "status": false
// }
// });
// Navigator.of(context).pop();
// }
// },
// child: Text('confirm'),
// ),
// ],
// ),
// );
// },
// ),
// )
