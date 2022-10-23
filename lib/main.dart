import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firenotes/Wideget/notecard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextStyle header = GoogleFonts.roboto( textStyle: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),);
  TextEditingController controllerTitle =  TextEditingController();
  TextEditingController controllerContent = TextEditingController();

  createAlertDialog(BuildContext context){


    return showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.indigo[700],
        title: Text("Start Writing!",style: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white,)),),
        content: Container(
          height: 400,
          width: MediaQuery.of(context).size.width-10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                TextField(

                  style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  )),
                  controller: controllerTitle,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.white
                    )),
                  ),

                ),
                const SizedBox(height :4),
                SingleChildScrollView(
                  child: TextField(
                    style: const TextStyle(
                        color: Colors.white,

                    ),
                    keyboardType: TextInputType.multiline,
                    controller: controllerContent,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Note content',
                      hintStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontStyle: FontStyle.italic))
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: (){
                FirebaseFirestore.instance.collection('notes').doc().set(
                  {
                    'title':controllerTitle.text,
                    'content':controllerContent.text,
                    'creationDate':DateTime.now()
                  }
                );
              },
              child: Text(
                "Add",
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold

                  )
                ),

              )
          )
        ],
      );
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      floatingActionButton: FlatButton(
          onPressed: (){
            createAlertDialog(context);
          },
          shape: const CircleBorder(),
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.add,
              size: 30,
            ),
          )
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        elevation: 0,
        title: Center(
          child: Text(
          '🔥 Notes',style: header,
          ),
        )
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot>snapshot,){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,int index)=>GestureDetector(
                    onTap: (){

                    },
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        children: [
                          const Icon(Icons.delete,color: Colors.white,),
                          const Expanded(child: SizedBox()),
                          const Icon(Icons.delete,color: Colors.white,),
                        ],
                      ),
                    ),
                      key: Key(snapshot.data!.docs[index]['title']),
                        child:NoteCard(
                            snapshot.data!.docs[index]['title'],
                            snapshot.data!.docs[index]['content'],
                            snapshot.data!.docs[index]['creationDate'].toDate()
                        ),

                    onDismissed: (DismissDirection direction){
                        FirebaseFirestore.instance.collection('notes').doc(snapshot.data!.docs[index].id).delete();

                    },
                )
                  ),
              )

            );
          }
          else{
            return const Center();
          }
        },
      ),
    );
  }


}
