import 'package:flutter/material.dart';
import 'package:tasks_list/dbhelper.dart';

class tododui extends StatefulWidget {
  @override
  _tododuiState createState() => _tododuiState();
}

class _tododuiState extends State<tododui> {
  final dbhelper= Databasehelper.instance;

  final texteditingcontroller= TextEditingController();
  bool validated=true;
  String errText="";
  String todoedited="";
  var myitems=List();
  List<Widget> children= new List<Widget>();

  void addtodo() async{
    Map<String, dynamic> row={
      Databasehelper.columnName:todoedited,

    };
    final id=await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited="";
    setState(() {
      validated =true;
      errText="";
    });
    }

    Future<bool> query() async{
    myitems=[];
    children=[];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              row['todo'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Libre Baskerville',
              ),
            ),
            onLongPress: (){
              dbhelper.deletedata(row['id']);
              setState(() {

              });
            },
          ),
        ),
      )
      );
    });
    return Future.value(true);
    }

  void showalertdialog(){
    texteditingcontroller.text="";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context,setState){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Add Task",
                style: TextStyle(
                  fontFamily: 'Libre Baskerville',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: texteditingcontroller,
                    autofocus: true,
                    onChanged: (_val){
                      todoedited= _val;
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null: errText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed:(){
                            if(texteditingcontroller.text.isEmpty){
                              setState((){
                                errText="can't be empty";
                                validated= false;
                              });
                            }
                            else if(texteditingcontroller.text.length>512){
                              setState((){
                                errText="Too many character";
                                validated= false;
                              });
                            }
                            else{
                              addtodo();
                            }
                          },
                          child: Text(
                            'ADD',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white,
                              fontFamily: 'Libre Baskerville',
                            ),
                          ),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        }
    );
  }

  // Widget mycard(String task){
  //   return Card(
  //     elevation: 5.0,
  //     margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
  //     child: Container(
  //       padding: EdgeInsets.all(5.0),
  //       child: ListTile(
  //         title: Text(
  //           "$task",
  //           style: TextStyle(
  //             fontSize: 18.0,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         onLongPress: (){
  //           print('task deleted');
  //         },
  //       ),
  //     ),
  //   );
  //
  // }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context,snap){
          if(snap.hasData==null){
            return Center(
              child: Text('No Data'),
            );
          } else{
             if(myitems.length==0){
               return Scaffold(
                 backgroundColor: Colors.black,
                   floatingActionButton: FloatingActionButton(
            onPressed: showalertdialog,
            backgroundColor: Colors.blue,
            child: Icon(
            Icons.add,
             ),
             ),
                 appBar: AppBar(
                   title: Text(
             'My Tasks',
              style: TextStyle(
              fontWeight: FontWeight.bold,
                fontFamily: 'Libre Baskerville',
               ),
               ),
              centerTitle: true,
              backgroundColor: Colors.black,
              ),
                  body: Center(
                    child:  Text(
                      'No Task Available',
                      style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      fontFamily: 'Libre Baskerville',
                      ),
                    ),
                  ),

               );
             } else{
               return Scaffold(
                 backgroundColor: Colors.black,
                 floatingActionButton: FloatingActionButton(
                   onPressed: showalertdialog,
                   backgroundColor: Colors.blue,
                   child: Icon(
                     Icons.add,
                   ),
                 ),
                 appBar: AppBar(
                   title: Text(
                     'My Tasks',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontFamily: 'Libre Baskerville',
                     ),
                   ),
                   centerTitle: true,
                   backgroundColor: Colors.black,
                 ),
                 body: SingleChildScrollView(
                   child: Column(
                     children: children,
                   ),
                 ) ,
               );
             }
          }
        },
      future: query() ,
    );
  }
}


// Scaffold(
// backgroundColor: Colors.black,

// body: SingleChildScrollView(
// child: Column(
// children: <Widget>[
// mycard("water the plants"),
// mycard("eat food"),
// mycard("home work\nhindi\nenglish\nmaths"),
// mycard("play a game"),
// mycard("drink water"),
// mycard("eat food"),
// mycard("laptop"),
// mycard("watch movie"),
// mycard("eat food"),
// ],
// ),
// ),
// );