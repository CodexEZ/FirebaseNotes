

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget NoteCard(String title, String content, DateTime creationDate){
  return FlatButton(
    onPressed: (){},
    child: Container(
      width: 900,
      child: Card(
        color: Colors.white24,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                    textStyle: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 20,
                      color:Colors.white
)
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                    '${creationDate.day}-${creationDate.month}-${creationDate.year}',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color:Colors.white
                      )
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Text(
                content,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color:Colors.white
                    )
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}




