// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;

// class PeriodicRequester extends StatelessWidget {
//   Stream<http.Response> getQ() async* {
//     Uri url = Uri.parse("http://146.190.8.166/API/queue_list.php");
//     Map body = {'branch_id': "1"};
//     yield* Stream.periodic(Duration(seconds: 5), (_) {
//       return http.post(url, body: body);
//     }).asyncMap((event) async => await event);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<http.Response>(
//       stream: getQ(),
//       builder: (context, snapshot) => snapshot.hasData
//           // ? Center(child: Text(snapshot.data!.body))
//           ?ListView.builder(
//             itemCount: snapshot.data!.body.length,
//             itemBuilder: (context, index) {
//             return Text(snapshot.data!.body[index]["patient_name"].toString())
//           },)
//           : Text("No Data",style: TextStyle(color: Colors.white),),
//     );
//   }
// }
