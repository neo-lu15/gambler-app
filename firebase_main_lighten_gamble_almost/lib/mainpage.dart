import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'main.dart';

class MainPage extends StatefulWidget{
  // MainPage(){
  //   print("MainPage Creator");
  // }
  // String title="My Casino";
  // int sort_way=0;
  _MainPage MainPage_state=_MainPage();

  void trans_refresh(){
      MainPage_state.refresh();
  }

  void listen(int value){
    // this.sort_way=value;
    // print("got value: "+this.sort_way.toString());
    MainPage_state.lets_sorting(value);
  }
    @override
    State<MainPage> createState(){
      // print("create Stating");
      MainPage_state=new _MainPage();
      return MainPage_state;
    }
}

class _MainPage extends State<MainPage> {

  int temp=0;
  int state_sorting_way=0;
  int refresh_or_not=1;

  List<Game> game_array=[];
  List<String> sort_way_string=["人數: ","總金額: ","賠率: "];
  List game_color=[Colors.green,Colors.blueGrey,Color.fromARGB(255, 241, 210, 3)];
  List word_color=[Colors.white,Colors.white,Colors.black];
  List show_array1=[];
  List show_array2=[];

  Timer ?tic_tac;

  void initState(){
    refresh_or_not=1;
    print("state: initstate");
    super.initState();
    initial_array();
    Timer tic_tac=Timer.periodic(Duration(milliseconds: 10000), (timer) { 
        refresh();
        // print("done refreshing");
    });
  }

  double find_max(double a, double b){
      return a>=b?  a: b;
  }

  String math_display(dynamic i){
      if(i>=1000&&i<1000000){
        return (i/1000).toStringAsFixed(2)+" K";
      }else if(i>=1000000){
        return (i/1000000).toStringAsFixed(2)+" M";
      }else return i.toString();
  }

  void initial_array() async{ //not synchronic
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Sample/");
    final snap=await dbref.get();
    if(snap.exists){
      print("i got it");
      dynamic get=snap.value;
      get.forEach((key, value) {
        Map diction=get[key];
        game_array.add(Game(diction["team1"],diction["team2"],diction["odd1"],diction["odd2"],diction["people_num1"],diction["people_num2"], diction["dollar1"], diction["dollar2"], diction["status"],diction["ans"], diction["folder"]));  // to here
      });
      lets_sorting(state_sorting_way);
      // game_array.sort((a,b)=> (b.people_num1+b.people_num2).compareTo(a.people_num1+a.people_num2));
      game_array.sort((a, b) => a.status.compareTo(b.status));
      // game_array.forEach((element) { 
      //     show_array1.add(element.people_num1);
      //     show_array2.add(element.people_num2);
      // });
      // state_sorting_way=0;
      setState(() {}); //for re-render
    }else{
        print("I don't get it");
    }
    // await dbref.onValue.listen((event) {
    //   dynamic get=event.snapshot.value;
   
  }

  void lets_sorting(int sort_way){
    if(sort_way==0){
        game_array.sort((a,b)=> (b.people_num1+b.people_num2).compareTo(a.people_num1+a.people_num2));
        // game_array.sort((a, b) => a.status.compareTo(b.status));
        show_array1=[];
        show_array2=[];
        game_array.forEach((element) { 
          show_array1.add(element.people_num1);
          show_array2.add(element.people_num2);
      });
    }else if(sort_way==1){
      game_array.sort((a,b)=>(b.dollar1+b.dollar2).compareTo(a.dollar1+a.dollar2));
      // game_array.sort((a, b) => a.status.compareTo(b.status));
      show_array1=[];
      show_array2=[];
      game_array.forEach((element) { 
          show_array1.add(element.dollar1);
          show_array2.add(element.dollar2);
      });
    }else{
        game_array.sort((a,b)=>find_max(b.odd1,b.odd2).compareTo(find_max(a.odd1,a.odd2)));
        // game_array.sort((a, b) => a.status.compareTo(b.status));
        show_array1=[];
        show_array2=[];
        game_array.forEach((element) { 
          show_array1.add(element.odd1);
          show_array2.add(element.odd2);
        });
    }
    state_sorting_way=sort_way;
    setState(() {
      
    });
  }

  void refresh(){
    print("refresh_or_not : ${refresh_or_not}");
    if(refresh_or_not==1){
       game_array=[];
      // show_array=[];
       initial_array();
    }
     
      // setState(() {
        
      // });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    refresh_or_not=0;
    print("Deleting tic_tac");
    print(tic_tac);
    tic_tac?.cancel();
    
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
      // print("state: build");
      return Center(
        child: ListView.builder(itemCount: game_array.length,itemBuilder: (context, index) {
            // print("status="+game_array[index].status.toString());
            if(index==0){
              return Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: OutlinedButton(
                    onPressed: (){
                      Navigator.pushNamed(context,"/Game",arguments:game_array[index].folder);
                      // print("go to gambling page");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Container(
                          //   width: 20,
                          //   height: 20,
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.black),
                          //     color: game_color[game_array[index].status],
                          //   ),
                          // ),
                          Column(
                            children: [
                              Container(width: 80,height: 80,child: Image.asset("photos/"+game_array[index].team1+".png"),
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                              Text(game_array[index].team1.toString(),style: TextStyle(color: Color.fromARGB(255, 50, 46, 46),))
                            ],
                          ),
                          Text("vs",style: TextStyle(color: game_color[game_array[index].status])),
                          Column(
                            children: [
                              Container(width: 80,height: 80,child: Image.asset("photos/"+game_array[index].team2+".png"),
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                              Text(game_array[index].team2.toString(),style: TextStyle(color: Color.fromARGB(255, 50, 46, 46)))
                            ],
                          ),
                          
                          Text(show_array1[index]<1? show_array1[index].toString() : math_display(show_array1[index]),style: TextStyle(color: Color.fromARGB(255, 50, 46, 46))),
                          Text(":",style: TextStyle(color: Color.fromARGB(255, 50, 46, 46))),
                          Text(show_array2[index]<1? show_array2[index].toString() : math_display(show_array2[index]),style: TextStyle(color: Color.fromARGB(255, 50, 46, 46))),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            else{
              return Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: OutlinedButton(
                    onPressed: (){
                      Navigator.pushNamed(context,"/Game",arguments:game_array[index].folder);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: game_color[game_array[index].status],
                            ),
                          ),
                          Column(
                            children: [
                              Container(width: 80,height: 80,child: Image.asset("photos/"+game_array[index].team1+".png"),
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                              Text(game_array[index].team1.toString())
                            ],
                          ),
                          Text("vs"),
                          Column(
                            children: [
                              Container(width: 80,height: 80,child: Image.asset("photos/"+game_array[index].team2+".png"),
                                margin: EdgeInsets.only(bottom: 10),
                              ),
                              Text(game_array[index].team2.toString())
                            ],
                          ),
                          
                          Text(show_array1[index]<1? show_array1[index].toString() : math_display(show_array1[index])),
                          Text(":"),
                          Text(show_array2[index]<1? show_array2[index].toString() : math_display(show_array2[index])),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            // else{
            //     return Column(
            //   children: [
            //    Container(
            //       child: ElevatedButton(onPressed: (){
            //         print("go to gambling detail");
            //       },child: Text(game_array[index].name,style: TextStyle(color: word_color[game_array[index].status]),),  
            //        style: ElevatedButton.styleFrom(
            //           backgroundColor: game_color[game_array[index].status],
            //         ),
            //       ),width: 200,
            //     ),Container(padding: game_array[index].status==0? EdgeInsets.symmetric(vertical: 5):EdgeInsets.all(0)
            //               ,margin: EdgeInsets.only(bottom: 20)
            //               ,width: game_array[index].status==0? 200:0,color: game_array[index].status==0? Colors.grey:Colors.red,
            //               child: game_array[index].status==0?Center(child: Text(sort_way_string[state_sorting_way]+show_array[index].toString()),):Container()
            //     )
            //   ],
            // );
            // }
         })
      );
     
  }
}