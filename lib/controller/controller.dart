
import 'dart:convert';
import 'package:fahleelnew/components/network_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class Controller with ChangeNotifier {
  FlutterTts flutterTts = FlutterTts();
  bool quelistReady = false;
  int timer = 7;
  bool status = false;
  List<bool> selectedTile = [];
  double pitch = 1.0;
  double speechrate = 0.4;
  List<String> languages = [];

  List<Map<String, dynamic>> queuetList = [];
  List<Map<String, dynamic>> queuetList1 = [];

  List<Map<String, dynamic>> settings = [];
  int? tileCount;
  int? showToken;
  String? branchColor;
  // double volume = 1.0;
  double? adv_vol = .0;

  double fontsize = 0.0;
  bool isLoading = true;
  bool isListLoading = true;

  getSettings(BuildContext context) async {
    
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
             isLoading = true;
          notifyListeners();
          print("...........getset");
          Uri url = Uri.parse("http://146.190.8.166/API/initialize.php");

          // isDownloaded = true;
       

          Map body = {'branch_id': "1"};
         
          http.Response response = await http.post(url, body: body);
          var map = jsonDecode(response.body);
          print("init map-----$map");

          settings.clear();
          for (var item in map) {
            settings.add(item);
          }

          tileCount = int.parse(settings[0]["token_row"]);
          showToken = int.parse(settings[0]["show_token"]);
          fontsize = double.parse(settings[0]["font_size"]);
          speechrate = double.parse(settings[0]["speech_rate"]);
          adv_vol = double.parse(settings[0]["adv_volume"]);
          // adv_vol = 1;
          notifyListeners();

          print("fontxisee-----$adv_vol");
          notifyListeners();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          // branch_id = prefs.getString("branch_id");
          prefs.setString("token_row", tileCount.toString());
          isLoading = false;
          notifyListeners();
          print("isloadun-----$isLoading");
       
          print("tilecount----$tileCount");
          return adv_vol;
          /////////////// insert into local db /////////////////////
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

/////////////////////////////////////////////////////////////////////
  getQueueList(BuildContext context, int i) async {
    print("called------$i");
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {print("...........getQ");
          if (i == 0) {
            isListLoading = true;
            notifyListeners();
          }
          Uri url = Uri.parse("http://146.190.8.166/API/queue_list.php");
          // Uri url = Uri.parse("http://146.190.8.166/API/test_api.php");

        

          Map body = {'branch_id': "1"};
          print("body----$body");
          http.Response response = await http.post(url, body: body);
          var map = jsonDecode(response.body);
          // var map = null;
          // if (map == null) {
          //   map = [
          //     {
          //       "queue_token": "A777",
          //       "cab_id": "room 77",
          //       "queue_id": "102",
          //       "msg": "Token number A 7 7 7  proceed to room 77",
          //       "voice_status": "0",
          //     },
          //     {
          //       "queue_token": "145",
          //       "cab_id": "room 14",
          //       "queue_id": "105",
          //       "msg": "Token number 145 proceed to room 14",
          //       "voice_status": "0",
          //     },
          //     {
          //       "queue_token": "05",
          //       "cab_id": "room 7",
          //       "queue_id": "044",
          //       "msg": "Token number 05 proceed to room 7",
          //       "voice_status": "0",
          //     },
          //     {
          //       "queue_token": "45",
          //       "cab_id": "room 7",
          //       "queue_id": "044",
          //       "msg": "Token number 45 proceed to room 7",
          //       "voice_status": "0",
          //     },
          //   ];
          //   // int maplength = map.length;
          //   // timer = timer * maplength;
          // }

          queuetList.clear();
          queuetList1.clear();
          for (var item in map) {
            // if (item["isSpeak"] == "0") {
            queuetList.add(item);
            var map1 = {
              "queue_token": item["queue_token"],
              "cab_id": item["cab_id"],
              "queue_id": item["queue_id"],
              "msg": item["msg"],
              "voice_status": item["voice_status"],
              "isSpeak": "0"
            };
            queuetList1.add(map1);
            var map2 = {
              "queue_token": item["queue_token"],
              "cab_id": item["cab_id"],
              "queue_id": item["queue_id"],
              "msg": item["msg"],
              "voice_status": item["voice_status"],
              "isSpeak": "1"
            };
            queuetList1.add(map2);
            // // }
          }
          notifyListeners();
          // for(var item in queuetList){
          //    if (item["isSpeak"] == "0") {
          //     queuetList1.add(item);
          //   }
          // }
          print("quelist map11-----$queuetList1");
          // int length = (queuetList.length / 2).toInt();
          selectedTile = List.generate(queuetList1.length, (index) => false);
          quelistReady = true;
          notifyListeners();
          // // for (int i = 0; i < queuetList.length; i++) {
          // //   Future.delayed(const Duration(milliseconds: 500), () {
          // _speak(queuetList[i]["msg"], "speak", i, context, queuetList);
          // //   });
          // // }

          if (i == 0) {
            isListLoading = false;
            notifyListeners();
          }

          /////////////// insert into local db /////////////////////
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  ///////////////////////////////////////////
  updateList(BuildContext context, String str) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          Uri url = Uri.parse("http://146.190.8.166/API/update_list.php");

          // if (i == 0) {
          //   isListLoading = true;
          //   notifyListeners();
          // }
          // String str = jsonEncode(list);

          print("str----$str");
          Map body = {'arr': str};
          print("sssssbody----$body");
          http.Response response = await http.post(url, body: body);
          var map = jsonDecode(response.body);
          print("update list----$map");

          /////////////// insert into local db /////////////////////
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }
  // tokenListGenerate() {
  //   patientList = [
  //     TokenListClass(counter: "1", tokenNum: "105", name: "Anusha K"),
  //     TokenListClass(
  //         counter: "5",
  //         tokenNum: "106",
  //         name: "Anil Mundachali pothodi mele chovva Kannur 6"),
  //     TokenListClass(counter: "2", tokenNum: "107", name: "Prathyesh Makreri"),
  //     TokenListClass(
  //         counter: "6", tokenNum: "108", name: "Dhanush subash achachan"),
  //     TokenListClass(counter: "6", tokenNum: "108", name: "Shilpa Byju"),
  //     TokenListClass(counter: "6", tokenNum: "110", name: "Anugraha"),
  //     TokenListClass(counter: "1", tokenNum: "111", name: "Appu"),
  //     TokenListClass(counter: "6", tokenNum: "110", name: "Dheeshna"),
  //     TokenListClass(counter: "4", tokenNum: "111", name: "Greeshma"),
  //     TokenListClass(counter: "3", tokenNum: "110", name: "Asha"),
  //   ];
  //   // notifyListeners();
  // }

  // timerSet() {
  //   print("patientList------$patientList");

  //   for (int i = 5; i < patientList.length; i++) {
  //     patientList.add(TokenListClass(
  //         counter: patientList[i].counter,
  //         tokenNum: patientList[i].tokenNum,
  //         name: patientList[i].name));
  //   }

  //   notifyListeners();
  // }

  setColor(int index, bool value) {
    selectedTile[index] = value;
    print("selectdhh-----${selectedTile[index]}");
    notifyListeners();
  }

  setSelectdeTile() {
    selectedTile = List.generate(queuetList.length, (index) => false);

    notifyListeners();
  }
}
