///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// Add a selected circle

import 'package:firebase/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase/Pallete.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  String ?game_folder;
  Game game=Game("Default", "Default", 0.1, 0.1, 0, 0, 50, 50, 0, 0, "Default");
  int vote_for=-1; // read the database 
  int money_drop=0;  // maybe not
  String name = "kira yoshikage";
  DatabaseReference ?dbref;
  int percent1=0;
  int init_state=0;


  Future<void> _choose_for_left(BuildContext context,String team) {
    return showDialog<void>(context:context,builder:(context) {
      TextEditingController money_input = TextEditingController();
      int money=0;

      return AlertDialog(
        title: Text("選擇 ${team}"),
        content:TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "投入金額"),
          controller: money_input,
          // onSubmitted: (value) {
          //   print("value ${value}");
          // },  
        ),
        actions: [
          
           ElevatedButton(
            child: Text('取消', style: TextStyle(color: Colors.white)),
            onPressed: () {
              vote_for=-1;
              print("vote_for=${vote_for},money_drop=${money_drop}");
              
              Navigator.of(context).pop("cancel");
            },
          ),
          ElevatedButton(
            child: Text('確定'),
            onPressed: () {
              if(team==game.team1){
                vote_for=0;
                //revise database
              }else{
                vote_for=1;
              }
              money_drop=int.parse(money_input.text);
              print("vote_for=${vote_for},money_drop=${money_drop}");
              
              // money_input.dispose();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }, );
  }
  Future<void> _revise_money_drop(BuildContext context,String team) {
    return showDialog<void>(context:context,builder:(context) {
      TextEditingController money_input = TextEditingController();
      int money=0;

      return AlertDialog(
        title: Text("${team} : 更改金額"),
        content:TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "投入金額"), //(money range)
          controller: money_input,
          // onSubmitted: (value) {
          //   print("value ${value}");
          // },  
        ),
        actions: [
          ElevatedButton(
            child: Text('取消下注', style: TextStyle(color: Colors.white)),
            onPressed: () {
              money_drop=0;
              vote_for=-1;
              print("vote_for=${vote_for},money_drop=${money_drop}");
              //revise the database
              //if team1 else team2
              Navigator.of(context).pop("cancel");
            },
          ),
           ElevatedButton(
            child: Text('取消', style: TextStyle(color: Colors.white)),
            onPressed: () {
              print("vote_for=${vote_for},money_drop=${money_drop}");
              Navigator.of(context).pop("cancel");
            },
          ),
          ElevatedButton(
            child: Text('確定'),
            onPressed: () {
              if(team==game.team1){
                vote_for=0;
                 //revise database,add money back
              }else{
                vote_for=1;
              }
              //if money_input==null??
              money_drop=int.parse(money_input.text);
              print("vote_for=${vote_for},money_drop=${money_drop}");
              // money_input.dispose();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }, );
  }

  Future<void> check_for_quit(BuildContext context,String team) {
    return showDialog<void>(context:context,builder:(context) {

      return AlertDialog(
        title: Text("是否要取消下注${team}"),
        actions: [
          ElevatedButton(
            child: Text('否', style: TextStyle(color: Colors.white)),
            onPressed: () {
              print("vote_for=${vote_for},money_drop=${money_drop}");
              Navigator.of(context).pop("cancel");
            },
          ),
           ElevatedButton(
            child: Text('是', style: TextStyle(color: Colors.white)),
            onPressed: () {
              money_drop=0;
              if(team==game.team1){
                vote_for=1;
                print("vote_for=${vote_for},money_drop=${money_drop}");
                //  Navigator.of(context).pop("cancel");
                
                 //revise database,add money back
              }else{
                vote_for=0;
                print("vote_for=${vote_for},money_drop=${money_drop}");
                //  Navigator.of(context).pop("cancel");
                // _choose_for_left(context, game.team1);
              }
              
              
              
              Navigator.of(context).pop("cancel");
            },
          ),
        ],
      );
    }, );
  }

  String math_display(dynamic i){
      if(i>=1000&&i<1000000){
        return (i/1000).toStringAsFixed(2)+" K";
      }else if(i>=1000000){
        return (i/1000000).toStringAsFixed(2)+" M";
      }else return i.toString();
  }

  // void initState(){
  //   print("initializing");
  //   super.initState();
  //   // game_folder = ModalRoute.of(context)!.settings.arguments as String; 
  //   initGame();
  //   // setState(() {
      
  //   // });
  // }

  void initGame()async{
    final game_folder = await ModalRoute.of(context)!.settings.arguments as String; 
    // print("game folder="+game_folder);
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Sample/").child(game_folder);
    await dbref.onValue.listen((event) {
         dynamic get=event.snapshot.value;
        //  print("get=");
        //  print(get);
         game=Game(get["team1"], get["team2"], get["odd1"], get["odd2"], get["people_num1"], get["people_num2"], get["dollar1"], get["dollar2"], get["status"], get["ans"], get["folder"]);
        //  print("game get");
         percent1=(game.dollar1/(game.dollar1+game.dollar2)*100).toInt();
        //  setState(() {
           
        //  });
    });
    if(init_state<=10){
      init_state++;
      print("set_state");
      setState(() {
        
      });
    }
    // setState(() {});
    
  }

  @override
  Widget build(BuildContext context) {
    
    initGame();
    
    print("still building");
    

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Pallete.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Game",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);  
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                          child: Container(
                            height: 60,
                            width: 60,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset("photos/C8763.png",//change ， To people's photo(prize)
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Consumer<Information_center>(builder:(context, notifier, child) => 
                                  Text(
                                    "${notifier.user_title}  ",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: Consumer<Information_center>(builder:(context, notifier, child) => 
                                    Text(
                                      notifier.user_name,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20,
                                        color: Pallete.primaryColor,
                                      ),
                                    ),
                                  )
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.money,color: Colors.white,),
                                Consumer<Information_center>(builder:(context, notifier, child) => 
                                  Text(
                                    notifier.user_money.toString(), //change!!
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],

                              
                            ),
                            // const Padding(
                            //   padding:
                            //       EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.money),
                            //       Text(
                            //         "Remainning Money.", //change!!
                            //         textAlign: TextAlign.start,
                            //         overflow: TextOverflow.clip,
                            //         style: TextStyle(
                            //           fontWeight: FontWeight.w400,
                            //           fontStyle: FontStyle.normal,
                            //           fontSize: 14,
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 0, 0),
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Pallete.redSideColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 0),
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset("photos/"+game.team1+".png",//change!!
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 8, 0, 0),
                                      child:  
                                      Text( // why can't use variable
                                        game.team1,//change!!
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 280,
                                decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          percent1.toString()+"%",//change!!
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 50,
                                            color: Pallete.redSideColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                  0,
                                                  0,
                                                  0),
                                          child: LinearPercentIndicator(
                                            percent: percent1/100,//change!!
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            lineHeight: 24,
                                            animation: true,
                                            progressColor: Pallete.redSideColor,
                                            backgroundColor:
                                                Pallete.backgroundColor,
                                            barRadius:
                                                const Radius.circular(20),
                                            padding: EdgeInsets.all(0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children:  [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 5, 0),
                                                child: Text(
                                                  math_display(game.dollar1),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.attach_money,
                                                color: Pallete.redSideColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 5, 0),
                                                child: Text(
                                                  "1:"+game.odd1.toString(),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.mood,
                                                color: Pallete.redSideColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 5, 0),
                                                child: Text(
                                                  math_display(game.people_num1),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.people,
                                                color: Pallete.redSideColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 5, 0),
                                                child: Text(
                                                  math_display(game.dollar1),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.money,
                                                color: Pallete.redSideColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(1, 0),
                                      child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Container(
                                            width: 120,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: ElevatedButton.icon(
                                                label: const Text(
                                                  "Bet Left",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                icon: const FaIcon(
                                                  size: 20,
                                                  FontAwesomeIcons.coins,
                                                ),
                                                
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Pallete.redSideColor,
                                                ),
                                                onPressed: (()async {
                                                  // print("")
                                                  if(vote_for==-1){
                                                      _choose_for_left(context, "獨行俠"); //change

                                                  }else if(vote_for==0){
                                                      _revise_money_drop(context, "獨行俠",);
                                                  }else if(vote_for==1){
                                                      await  check_for_quit(context,"拓荒者");
                                                      if(vote_for==1){
                                                        print("system: not changed");
                                                      }else if(vote_for==0){
                                                        print("system: changed");
                                                        _choose_for_left(context, "獨行俠");
                                                      }
                                                  }else{
                                                    print("error");
                                                  }
                                                  
                                                  print(this.vote_for);
                                                }),
                                              ),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 12, 0, 0),
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Pallete.blueSideColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 0),
                                      child: Container(
                                        height: 120,
                                        width: 120,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset("photos/"+game.team2+".png",//change!!
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 8, 0, 0),
                                      child: Text(
                                        game.team2,//change!!
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width * 0.44,
                                height: 280,
                                decoration: BoxDecoration(
                                  color: Pallete.cardColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          (100-percent1).toString()+"%",//change!!
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 50,
                                            color: Pallete.blueSideColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02,
                                                  0,
                                                  0,
                                                  0),
                                          child: LinearPercentIndicator(
                                            percent: (100-percent1)/100,//change!!
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            lineHeight: 24,
                                            animation: true,
                                            progressColor:
                                                Pallete.blueSideColor,
                                            backgroundColor:
                                                Pallete.backgroundColor,
                                            barRadius:
                                                const Radius.circular(20),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children:  [
                                              Icon(
                                                Icons.attach_money,
                                                color: Pallete.blueSideColor,
                                                size: 24,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  math_display(game.dollar2),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children:  [
                                              Icon(
                                                Icons.mood,
                                                color: Pallete.blueSideColor,
                                                size: 24,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  "1:"+game.odd2.toString(),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children:  [
                                              Icon(
                                                Icons.people,
                                                color: Pallete.blueSideColor,
                                                size: 24,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  math_display(game.people_num2),//change!! // still need modify
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children:[
                                              Icon(
                                                Icons.money,
                                                color: Pallete.blueSideColor,
                                                size: 24,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  math_display(game.dollar2),//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1, 0),
                                      child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Container(
                                            width: 120,
                                            child: ElevatedButton.icon(
                                              icon: const FaIcon(
                                                size: 20,
                                                FontAwesomeIcons.coins,
                                              ),
                                              label: const Text(
                                                "Bet Right",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Pallete.blueSideColor,
                                              ),
                                              onPressed: (()async{
                                               if(vote_for==-1){
                                                      _choose_for_left(context, "拓荒者"); //change

                                                  }else if(vote_for==1){
                                                      _revise_money_drop(context, "拓荒者",);
                                                  }else if(vote_for==0){
                                                    await  check_for_quit(context,"獨行俠");
                                                      if(vote_for==0){
                                                        print("system: not changed");
                                                      }else if(vote_for==1){
                                                        print("system: changed");
                                                        _choose_for_left(context, "拓荒者"); // no cancel
                                                      }
                                                  }else{
                                                    print("error");
                                                  }
                                                  
                                                  print(this.vote_for);
                                              }),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Pallete.cardColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [  // start comment
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
                      child: 
                      ListView.builder(
                        itemCount: 4,
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          if(index==3){
                            TextEditingController the_word=TextEditingController();
                            return  TextField(
                              style: TextStyle(color: Colors.white),
                              controller: the_word,
                              decoration: InputDecoration(
                                // hintText: "輸入評論 : ",
                                // hintStyle: TextStyle(color: Colors.white),
                                labelText: "輸入評論 : ",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(15),
                                suffixIcon: IconButton(
                                  icon:Icon(Icons.arrow_right),
                                  onPressed: () {
                                    print("submit ==> ${the_word.text}");
                                  },  
                                ),

                              ),

                            );
                          }else{
                          return Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 12),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ///***If you have exported images you must have to copy those images in assets/images directory.
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),//change!!
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12, 0, 10, 0),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.65,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Pallete.commentBgColor,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 8, 12, 8),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  "Sandra Smith",//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14,
                                                    color: Pallete
                                                        .commentNameColor,
                                                  ),
                                                ),
                                                Text(
                                                  "Star Burst Stream!!!",//change!!
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14,
                                                    color: Pallete.commentColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                ]),
                          );
                        }},
                        
                        // children: [
                        //   Padding(
                        //     padding: const EdgeInsetsDirectional.fromSTEB(
                        //         0, 0, 0, 12),
                        //     child: Row(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         mainAxisSize: MainAxisSize.max,
                        //         children: [
                        //           ///***If you have exported images you must have to copy those images in assets/images directory.
                        //           ClipRRect(
                        //             borderRadius: BorderRadius.circular(40),
                        //             child: Image.network(
                        //               'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                        //               width: 40,
                        //               height: 40,
                        //               fit: BoxFit.cover,
                        //             ),//change!!
                        //           ),
                        //           Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             mainAxisSize: MainAxisSize.max,
                        //             children: [
                        //               Padding(
                        //                 padding: const EdgeInsetsDirectional
                        //                     .fromSTEB(12, 0, 10, 0),
                        //                 child: Container(
                        //                   constraints: BoxConstraints(
                        //                     maxWidth: MediaQuery.of(context)
                        //                             .size
                        //                             .width *
                        //                         0.65,
                        //                   ),
                        //                   decoration: BoxDecoration(
                        //                       color: Pallete.commentBgColor,
                        //                       shape: BoxShape.rectangle,
                        //                       borderRadius:
                        //                           BorderRadius.circular(12)),
                        //                   child: Padding(
                        //                     padding: const EdgeInsetsDirectional
                        //                         .fromSTEB(12, 8, 12, 8),
                        //                     child: Column(
                        //                       mainAxisSize: MainAxisSize.max,
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: const [
                        //                         Text(
                        //                           "Sandra Smith",//change!!
                        //                           textAlign: TextAlign.start,
                        //                           overflow: TextOverflow.clip,
                        //                           style: TextStyle(
                        //                             fontWeight: FontWeight.w400,
                        //                             fontStyle: FontStyle.normal,
                        //                             fontSize: 14,
                        //                             color: Pallete
                        //                                 .commentNameColor,
                        //                           ),
                        //                         ),
                        //                         Text(
                        //                           "I'm not really sure about this...",//change!!
                        //                           textAlign: TextAlign.start,
                        //                           overflow: TextOverflow.clip,
                        //                           style: TextStyle(
                        //                             fontWeight: FontWeight.w400,
                        //                             fontStyle: FontStyle.normal,
                        //                             fontSize: 14,
                        //                             color: Pallete.commentColor,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                                      
                        //             ],
                        //           ),
                        //         ]),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsetsDirectional.fromSTEB(
                        //         0, 0, 0, 12),
                        //     child: Row(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         mainAxisSize: MainAxisSize.max,
                        //         children: [
                        //           ///***If you have exported images you must have to copy those images in assets/images directory.
                        //           ClipRRect(
                        //             borderRadius: BorderRadius.circular(40),
                        //             child: Image.network(
                        //               'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDJ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                        //               width: 40,
                        //               height: 40,
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ),
                        //           Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             mainAxisSize: MainAxisSize.max,
                        //             children: [
                        //               Padding(
                        //                 padding: const EdgeInsetsDirectional
                        //                     .fromSTEB(12, 0, 10, 0),
                        //                 child: Container(
                        //                   constraints: BoxConstraints(
                        //                     maxWidth: MediaQuery.of(context)
                        //                             .size
                        //                             .width *
                        //                         0.65,
                        //                   ),
                        //                   decoration: BoxDecoration(
                        //                       color: Pallete.commentBgColor,
                        //                       shape: BoxShape.rectangle,
                        //                       borderRadius:
                        //                           BorderRadius.circular(12)),
                        //                   child: Padding(
                        //                     padding: const EdgeInsetsDirectional
                        //                         .fromSTEB(12, 8, 12, 8),
                        //                     child: Column(
                        //                       mainAxisSize: MainAxisSize.max,
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: const [
                        //                         Text(
                        //                           "Sandra Smith",
                        //                           textAlign: TextAlign.start,
                        //                           overflow: TextOverflow.clip,
                        //                           style: TextStyle(
                        //                             fontWeight: FontWeight.w400,
                        //                             fontStyle: FontStyle.normal,
                        //                             fontSize: 14,
                        //                             color: Pallete
                        //                                 .commentNameColor,
                        //                           ),
                        //                         ),
                        //                         Text(
                        //                           "I'm not really sure about this. I think GDSC sucks.",
                        //                           textAlign: TextAlign.start,
                        //                           overflow: TextOverflow.clip,
                        //                           style: TextStyle(
                        //                             fontWeight: FontWeight.w400,
                        //                             fontStyle: FontStyle.normal,
                        //                             fontSize: 14,
                        //                             color: Pallete.commentColor,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                                      
                        //             ],
                        //           ),
                        //         ]),
                        //   ),
                        //   Padding(
                        //     padding: const EdgeInsetsDirectional.fromSTEB(
                        //         0, 0, 0, 12),
                        //     child: Row(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         mainAxisSize: MainAxisSize.max,
                        //         children: [
                        //           ///***If you have exported images you must have to copy those images in assets/images directory.
                        //           ClipRRect(
                        //             borderRadius: BorderRadius.circular(40),
                        //             child: Image.network(
                        //               'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDJ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',//change!!
                        //               width: 40,
                        //               height: 40,
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ),
                        //           Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             mainAxisSize: MainAxisSize.max,
                        //             children: [
                        //               Padding(
                        //                 padding: const EdgeInsetsDirectional
                        //                     .fromSTEB(12, 0, 10, 0),
                        //                 child: Container(
                        //                   constraints: BoxConstraints(
                        //                     maxWidth: MediaQuery.of(context)
                        //                             .size
                        //                             .width *
                        //                         0.65,
                        //                   ),
                        //                   decoration: BoxDecoration(
                        //                       color: Pallete.commentBgColor,
                        //                       shape: BoxShape.rectangle,
                        //                       borderRadius:
                        //                           BorderRadius.circular(12)),
                        //                   child: Padding(
                        //                     padding: const EdgeInsetsDirectional
                        //                         .fromSTEB(12, 8, 12, 8),
                        //                     child: Column(
                        //                       mainAxisSize: MainAxisSize.max,
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: const [
                        //                         Text(
                        //                           "Sandra Smith",//change!!
                        //                           textAlign: TextAlign.start,
                        //                           overflow: TextOverflow.clip,
                        //                           style: TextStyle(
                        //                             fontWeight: FontWeight.w400,
                        //                             fontStyle: FontStyle.normal,
                        //                             fontSize: 14,
                        //                             color: Pallete
                        //                                 .commentNameColor,
                        //                           ),
                        //                         ),
                        //                         Text(
                        //                           "I'm not really sure about this. I think GDSC sucks.",//change!!
                        //                           textAlign: TextAlign.start,
                        //                           overflow: TextOverflow.clip,
                        //                           style: TextStyle(
                        //                             fontWeight: FontWeight.w400,
                        //                             fontStyle: FontStyle.normal,
                        //                             fontSize: 14,
                        //                             color: Pallete.commentColor,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                      
                        //             ],
                        //           ),
                        //         ]),
                        //   )
                        // ],
                      ),
                    )
                  ],
                  
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            //   child: Container(
            //     margin: EdgeInsets.all(0),
            //     padding: EdgeInsets.all(0),
            //     width: MediaQuery.of(context).size.width * 0.9,
            //     decoration: BoxDecoration(
            //       color: Pallete.cardColor,
            //       shape: BoxShape.rectangle,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Row(
            //       children: [
            //         Text("留言 : ",style:TextStyle(color: Colors.white)),
            //         TextField()
            //       ],
            //     )
            //   )
            // ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Pallete.cardColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container()
              )
            )
          ],
        ),
      ),
    );
  }
}
