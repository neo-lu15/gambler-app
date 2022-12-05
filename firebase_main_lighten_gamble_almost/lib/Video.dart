import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'dart:math';
// final Uri _url = Uri.parse('https://flutter.dev');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        // "/": (context) => MyHomePage(),
        "/second":(context) => MyPage2(),
        "/third":(context) => ThirdPage(),
      },
      initialRoute: "/third",
    );
  }
}

class MyHomePage extends StatefulWidget {
  int randomnumber;
  MyHomePage(this.randomnumber);
  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List url_list=[Uri.parse('https://flutter.dev'),Uri.parse('https://www.flutterbeads.com/change-lock-device-orientation-portrait-landscape-flutter/')];
  List photo=['images/sea.jfif','images/second.jfif'];

  void initState(){  
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

class MyPage2 extends StatefulWidget {
  const MyPage2({Key? key}) : super(key: key);

  @override
  State<MyPage2> createState() => MyPage2State();
}

class MyPage2State extends State<MyPage2> {
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
                    return MyHomePage(randomnumber) ; 
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





class ThirdPage extends StatefulWidget{
  @override
  State<ThirdPage> createState() => _ThirdPage();
}

class _ThirdPage extends State<ThirdPage>{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(title: Text("3"),),
          body: Center(
            child: ElevatedButton(child: Text("Go forward"),onPressed: (){
              Navigator.pushNamed(context, "/second");
            },),
          ),
      );
  }
}
