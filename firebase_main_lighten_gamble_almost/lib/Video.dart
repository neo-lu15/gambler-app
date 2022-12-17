import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';


// final Uri _url = Uri.parse('https://flutter.dev');

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       routes: {
//         // "/": (context) => MyHomePage(),
//         "/second":(context) => MyPage2(),
//         "/third":(context) => ThirdPage(),
//       },
//       initialRoute: "/third",
//     );
//   }
// }

class GoAdverWeb extends StatefulWidget {
  int randomnumber;
  GoAdverWeb(this.randomnumber);
  

  @override
  State<GoAdverWeb> createState() => _GoAdverWebState();
}

class _GoAdverWebState extends State<GoAdverWeb> {

  List url_list=[Uri.parse('https://flutter.dev'),Uri.parse('https://www.flutterbeads.com/change-lock-device-orientation-portrait-landscape-flutter/')];
  List photo=['photos/sea.jfif','photos/second.jfif'];

  void initState(){  
    add_money();
    print("What i got: ${widget.randomnumber}");
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
  }
 
  Future<void> _launchUrl() async {
    if (!await launchUrl(url_list[widget.randomnumber])) {
      throw 'Could not launch ${url_list[widget.randomnumber]}';
    }
  }

  add_money()async{
   DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
   int money_now=0;
   final snap=await dbref.get();
   if(snap.exists){
      dynamic get=snap.value;
      money_now=get["user_money"];
      print("peep, money_now=${money_now}");
    }
    await dbref.update(
        {
          "user_money":money_now+3000
        }
    );
    print("set done user money");
  }


  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.width*0.8*16/9,
                child:  GestureDetector(
                  onTap: _launchUrl,
                  child: Image.asset(photo[widget.randomnumber]),
                  // onPressed: (){
                  //      Navigator.pushNamed(context, "/second");
                  // },
                ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height:40,
               child:  ElevatedButton(
                  onPressed: (){Navigator.pop(context,"ACK");},
                  child: Text("Go Back"),
               )
            )
          ]
        )
        ) 
    );
  }
}

class AdverVedioPayer extends StatefulWidget {
  const AdverVedioPayer({Key? key}) : super(key: key);

  @override
  State<AdverVedioPayer> createState() => AdverVedioPayerState();
}

class AdverVedioPayerState extends State<AdverVedioPayer> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  int count=0;
  List list = ['https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4','https://www.fluttercampus.com/video.mp4'];
  int randomnumber=0;

  @override
  void initState() {
    super.initState();
    randomnumber=Random().nextInt(list.length);
    _initPlayer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    videoPlayerController.addListener(() async{
       if (videoPlayerController.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
        print('video Start');
        setState(() {
          
        });
      }
      if (videoPlayerController.value.position ==videoPlayerController.value.duration && count==0){
        count++;
        String ?resultData = await Navigator.push(context,
                 MaterialPageRoute(builder:(BuildContext context) {
                    return GoAdverWeb(randomnumber) ; 
                  }) 
                );
                if(resultData!=null){
                    Navigator.pop(context);
                }
      }
    });
  }
  
  void _initPlayer() async {
    videoPlayerController = VideoPlayerController.network(
        list[randomnumber]
        );
    await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      autoInitialize: true,
      looping: false,
      showControls: false,
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: () => debugPrint('Option 1 pressed!'),
            iconData: Icons.chat,
            title: 'Option 1',
          ),
          OptionItem(
            onTap: () =>
                debugPrint('Option 2 pressed!'),
            iconData: Icons.share,
            title: 'Option 2',
          ),
        ];
      },
    );
    // chewieController.addListener(() { 
    //   if(chewieController.isPlaying()==true){
    setState(() {});
    //   }
    // })
  }

   

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(videoPlayerController.value.isPlaying.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chewie Video Player"),
      ),
      body: chewieController!=null? Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Chewie(
          controller: chewieController!,
        ),
      ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}





class jumpadverPage extends StatefulWidget{
  @override
  State<jumpadverPage> createState() => _jumpadverPage();
}

class _jumpadverPage extends State<jumpadverPage>{

  DateTime Last_Check_Time=DateTime.now();
  int check_in_state=0;
  int money_now=0;

  Future<void> day_error(BuildContext context) {
    return showDialog<void>(context:context,builder:(context) {
      return AlertDialog(
        title: Text("您今日已經簽到過了"),
        content: Text("請到明日00:00再進行簽到"),
        actions: [
            ElevatedButton(
            child: Text('取消', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(context).pop("cancel");
            },
          ),
        ],
      );
    });
  }

  check_check_in_button()async{
    // print("start check checkin");
    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
    await dbref.onValue.listen((event) {
        dynamic get=event.snapshot.value;
        String Last_Check_Time_String=get["last_check_in"].toString();
        Last_Check_Time=DateTime.utc(int.parse(Last_Check_Time_String.substring(0, 4)),int.parse(Last_Check_Time_String.substring(4, 6)),int.parse(Last_Check_Time_String.substring(6, 8)),0,0,0);
        Last_Check_Time = Last_Check_Time.add(Duration(days: 1));
        // print("peep done,get the last check in time");
        // print("Last_Check_Time=${Last_Check_Time}");
        // print("Now Time: ${DateTime.now().add(Duration(hours:8))}");
        if(DateTime.now().add(Duration(hours:8)).isAfter(Last_Check_Time)){
          // print("You can check in now");
          check_in_state=1;
        }
        // else check_in_state=0;
    });
    setState(() {
      
    });
  }
  

  String Change_to_2(String number){
    if(number.length==2){
      return number;
    }else return "0"+number;
  }

  @override
  Widget build(BuildContext context) {
    check_check_in_button();
      return Scaffold(
          // appBar: AppBar(title: Text("3"),),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(child: Text("看廣告賺金幣"),onPressed: (){
                  Navigator.pushNamed(context, "/Video_Page");
                },),
                ElevatedButton(child: Text("每日簽到"),onPressed: ()async{
                  int money_now=0;
                  if(check_in_state==1){
                    DatabaseReference dbref= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                    final snap=await dbref.get();
                    if(snap.exists){
                      dynamic get=snap.value;
                      money_now=get["user_money"];
                      print("peep, money_now=${money_now}");
                    }
                    // await dbref.onValue.listen((event) {
                    //   dynamic get=event.snapshot.value;
                    //   money_now=get["user_money"];
                    //   print("peep, money_now=${money_now}");
                    // });
                    await dbref.update(
                        {
                          "user_money":money_now+5000
                        }
                    );
                    print("set done user money");
                    
                    DatabaseReference dbref2= await FirebaseDatabase.instance.ref("Gambling_Users/").child(global_email);
                    DateTime now_time=DateTime.now().add(Duration(hours: 8));
                    await dbref2.update(
                      {
                        "last_check_in":now_time.year.toString()+Change_to_2(now_time.month.toString())+Change_to_2(now_time.day.toString())+Change_to_2(now_time.hour.toString())+Change_to_2(now_time.minute.toString())+Change_to_2(now_time.second.toString())
                      }
                    );
                    check_in_state=0;
                    print("check_in_state=${check_in_state}");
                  }else{
                    print("You can't check in");
                    day_error(context);
                  }
                  
                },style:  ElevatedButton.styleFrom(
                    backgroundColor: check_in_state==0? Colors.grey:Colors.green,
                    textStyle: TextStyle(color: Colors.black)
                  )
                ),
              ],
            ),
          ),
      );
  }
}
