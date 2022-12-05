
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'mainpage.dart';
import 'HomeScreen.dart';
// import 'Video.dart';


class Game{
  String team1;
  String team2;
  double odd1;
  double odd2;
  int people_num1;
  int people_num2;
  int dollar1;
  int dollar2;
  int status;
  int ans;
  String folder;
  // int TTL;
  Game(this.team1,this.team2,this.odd1,this.odd2,this.people_num1,this.people_num2,this.dollar1,this.dollar2,this.status,this.ans,this.folder);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // dreamly cooperate
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(create:(context) => Information_center(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Casino',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        "/":(context) => MyHomePage(title: 'My Casino'),
        "/Game":(context) => HomeScreen()
      },
      // home: const MyHomePage(title: 'My Casino'),
      // ChangeNotifierProvider(create:(context)=> Information_center()
      // ,child: const MyHomePage(title: 'My Casino'),),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Information_center extends ChangeNotifier{
    int user_money=1000000;
    String user_name="茅場晶彥";
    String user_title="封閉者";

    void Change_user_money(int gap){
        if(user_money+gap>=0){
          user_money+=gap;
          notifyListeners();
        }else print("money can't be negative");
    }

    void Change_user_name(String new_name){
        if(new_name.length>8){
          print("The new name is too long");
        }else if(new_name==null){
            print("name can't be null");
        }else{
          user_name=new_name;
          notifyListeners();
        }
    }
    void Change_user_title(String new_title){
        if(new_title==null){
            print("title can't be null");
        }else{
          user_title=new_title;
          notifyListeners();
        }
    }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sort_way=0;
  int page=1;
  // List pages=[Container(color: Colors.red,),MainPage(),Container(color: Colors.blue,)];
  List icons=[Icons.burst_mode,Icons.money,Icons.percent]; // using Listtile?
  dynamic body_content=MainPage();
  List appbar_title=["看廣告","當前賭局","換獎品"];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(appbar_title[page]),
        actions: [
           IconButton(onPressed: (){
            if(page==1){
                // print("Refreshing");
                body_content.trans_refresh();
                // pages[1].trans_refresh();
            }
          }, icon: page==1? Icon(Icons.refresh):Container()),
          IconButton(onPressed: (){
            print("Go to Personal Page");
            // Navigator.pushNamed(context, "/person");
          }, icon: Icon(Icons.person)),
         
        ],
        bottom:      
          PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child:  
              Container(
              // color: Colors.lightGreen,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text("稱號",style: TextStyle(color: Colors.white),),
                            Consumer<Information_center>(builder:(context, notifier, child) => Text(notifier.user_title)) 
                          ],
                        ),
                         Column(
                          children: [
                            Text("名字",style: TextStyle(color: Colors.white),),
                            Consumer<Information_center>(builder:(context, notifier, child) => Text(notifier.user_name)) 
                          ],
                        ),
                         Column(
                          children: [
                            Text("遊戲幣數",style: TextStyle(color: Colors.white),),
                            // Text("my money")
                            Consumer<Information_center>(builder:(context, notifier, child) => Text(notifier.user_money.toString())) 
                          ],
                         ),  
                      ],
                    ),
                    Container(height: 10,) // under space
                ],
              ),
            ),
            
        ),
      ),
      
      body: body_content,//pages[page],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.money),label: "賺金幣"),
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "主頁"),
          BottomNavigationBarItem(icon: Icon(Icons.shield_moon),label: "獎品")
        ],
        currentIndex: page,
        onTap:(value){
          // body_content.dispose();
          sort_way=0;
          if(value==0){
            body_content=Container(color: Colors.red,);
          }else if(value==1){
            body_content=MainPage();
          }else if(value==2){
            body_content=Container(color: Colors.blue,);  //neo love you
          }
          setState(() {
            page=value;
            // // print("page="+page.toString());
            // sort_way=0;
          });
        },
      ),
      floatingActionButton: page==1? FloatingActionButton(
        onPressed: () {
            sort_way=(sort_way+1)%3;
            body_content.listen(sort_way);
            // pages[1].listen(sort_way);
            setState(() {
              
            });
        },
        child: Icon(icons[sort_way])
      ):Container(),
    );
  }
}
