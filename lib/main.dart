import 'package:flutter/material.dart';
import 'package:flutter_p1/DatabaseHelper.dart';
// 更新資料用dialog
// 搜尋按鈕

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  myState createState() => myState();
}

class myState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController txt01 = new TextEditingController();
  final TextEditingController txt02 = new TextEditingController();
  final TextEditingController txt03 = new TextEditingController();
  static List<Item> items = <Item>[];
  bool showItemButton = false;
  bool isSearch = false;

  /*@override
  void initState() {
    super.initState();
    txt03.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {

  }*/

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(backgroundColor: Colors.black,),
       body: Center(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,

           children: <Widget>[
             Container(
               height: 40,
               margin: const EdgeInsets.only(bottom: 10),

               child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisSize: MainAxisSize.min,

                 children: <Widget>[
                   IconButton(
                     onPressed: () {
                       setState(() {
                         showItemButton = !showItemButton;
                       });
                     },
                     icon: const Icon(Icons.edit),
                   ),

                   IconButton(
                     onPressed: () async {
                       await _dbHelper.deleteAllItems();
                       setState(() {});
                     },
                     icon: const Icon(Icons.delete_outline),
                   ),

                   // SizedBox(width: 10,),

                   Expanded(
                       child: Center(
                         child: Container(
                           width: 250,
                           padding: EdgeInsets.only(top:1),
                           margin: EdgeInsets.only(top:5),
                           alignment: Alignment.center,

                           child: TextField(
                             controller: txt03,
                             onChanged: (value) async {
                               if(txt03.text == ""){
                                 items = await _dbHelper.getAllItems();
                                 isSearch = false;
                                 setState(() {});
                               }
                             },

                             decoration: InputDecoration(
                               contentPadding: const EdgeInsets.only(top: 10,left: 15),
                               filled: true,
                               fillColor: Colors.white,
                               border: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(15),
                                 borderSide: BorderSide(color: Colors.black,width: 2),
                               ),

                               suffixIcon: IconButton(
                                   onPressed: () async {
                                     if(txt03.text != "") {
                                        items = await _dbHelper.getItem(txt03.text);
                                        isSearch = true;
                                        setState(() {});
                                     }
                                     else {
                                       items = await _dbHelper.getAllItems();
                                       isSearch = false;
                                       setState(() {});
                                     }
                                   },
                                   icon: Icon(Icons.search),
                               ),
                             ),
                           ),
                         ),
                       )
                   ),
                 ],
               ),
             ),

             Expanded(
                 child: FutureBuilder<List<Item>> (
                     future: isSearch ? Future.value(items) : _dbHelper.getAllItems(),
                     builder: (context,snapshot) {
                       if (snapshot.connectionState == ConnectionState.waiting) { //Future是否還在執行
                         return CircularProgressIndicator(); //生成加載指示器，圓形跑動的那個
                       }
                       else if (snapshot.hasError) {
                         return Text('error: ${snapshot.error}');
                       }
                       else if (snapshot.data == null || !snapshot.hasData || snapshot.data!.isEmpty) {
                         //!snapshot.hasData 判斷是否為null
                         // snapshot.data!.isEmpty 則是判斷是否為空列表（[]）
                         // snapshot.data!.isEmpty 如果判斷到null，會導致NullPointerException
                         return Text('no data');
                       }

                       if(!isSearch) items = snapshot.data!;
                       return ListView.builder(
                           itemCount: items.length,
                           itemBuilder: (context,index) {
                             return ListTile(
                               title: Text(items[index].name),
                               subtitle: Text(items[index].password),
                               leading: Icon(
                                 Icons.message,
                                 color: Colors.black87,
                               ),

                               trailing: showItemButton ? Row(
                                 mainAxisSize: MainAxisSize.min,

                                 children: <Widget>[
                                   IconButton(
                                     onPressed: () async {
                                       await _showUpdateDialog(context, index);
                                       setState(() {});
                                     },
                                     icon: Icon(Icons.update),
                                   ),

                                   IconButton(
                                     onPressed: () async {
                                       await _dbHelper.deleteItem(items[index].id!);
                                       items.removeAt(index); /////
                                       setState(() {});
                                     },
                                     icon: Icon(Icons.delete_forever),
                                   ),
                                 ],
                               ) : null,
                             );
                           }
                       );
                     }
                 )
             ),
           ],
         ),
       ),

       floatingActionButton: FloatingActionButton(
           onPressed: () async {
             await Navigator.push(context,
                 MaterialPageRoute(builder: (context) => LoginPage())
             );
             setState(() {});
           },
           child: Icon(Icons.add),
       ),
       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
     );
  }




  Future<void> _showUpdateDialog(BuildContext context,int index) async {
    await showDialog(
      context: context,
      builder: (context){
        txt01.text = items[index].name;
        txt02.text = items[index].password;

        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 1),
          content: Container(
            height: 350,
            width: 100,

            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  const Text(
                    'name:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  Container(
                    width: 220,
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: txt01,

                      decoration: InputDecoration(
                        contentPadding:  const EdgeInsets.all(2),
                      ),
                    ),
                  ),

                  const Text(
                    'password:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  Container(
                    width: 220,
                    child: TextField(
                      controller: txt02,
                      decoration: InputDecoration(
                        contentPadding:  const EdgeInsets.all(2),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 100,left: 155),
                    child: ElevatedButton(
                      onPressed: () async {
                        String str = "修改成功！";
                        var color = Colors.green;

                        if(txt01.text != "" && txt02.text != ""){
                          await _dbHelper.updateItem(Item(
                            id: items[index].id,
                            name: txt01.text,
                            password: txt02.text,
                          ));
                        }
                        else if(txt01.text == "") {str = "姓名不能為空"; color = Colors.red;}
                        else if(txt02.text == "") {str = "密碼不能為空"; color = Colors.red;}



                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$str'),
                              duration: Duration(seconds: 2),
                              backgroundColor: color,
                            )
                        );

                        Navigator.pop(context);
                      },

                      child: const Text('update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



class LoginPage extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController txt01 = new TextEditingController();
  final TextEditingController txt02 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined,color: Colors.white,),
        ),
      ),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,

          children: <Widget>[
            const Text(
              'name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            Container(
              width: 200,
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: txt01,
                decoration: InputDecoration(
                  hintText: 'ken...',
                  contentPadding:  const EdgeInsets.all(2),
                ),
              ),
            ),

            const Text(
              'password:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            Container(
              width: 200,
              child: TextField(
                controller: txt02,
                decoration: InputDecoration(
                  hintText: '123...',
                  contentPadding:  const EdgeInsets.all(2),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 100,left: 120),
              child: ElevatedButton(
                  onPressed: () async {
                    String str = "新增成功！";
                    var color = Colors.green;

                    if(txt01.text != "" && txt02.text != ""){}
                    else if(txt01.text == "") {str = "姓名不能為空"; color = Colors.red;}
                    else if(txt02.text == "") {str = "密碼不能為空"; color = Colors.red;}

                    await _dbHelper.insertItem(Item(
                        name: txt01.text,
                        password: txt02.text,
                    ));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('$str'),
                          duration: Duration(seconds: 2),
                          backgroundColor: color,
                      )
                    );
                  },

                  child: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}