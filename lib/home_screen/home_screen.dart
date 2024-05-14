import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app_hive_db/add_new_note.dart';
import 'package:notes_app_hive_db/boxes/boxes.dart';
import 'package:notes_app_hive_db/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Auto refresh UI

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  bool _animIcon = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Search your notes', style: TextStyle(fontSize: 18, color: Colors.white),),
        titleSpacing: 0.0,
        actions: [
          InkWell(child: AnimatedIcon(icon: AnimatedIcons.list_view, progress: _animationController, color: Colors.white,), onTap: () {
            if(_animIcon) {
              _animationController.forward();
            }else{
              _animationController.reverse();
            }
            setState(() {_animIcon = !_animIcon;});
          },),
          const SizedBox(width: 10,),
          const CircleAvatar(radius: 20,),
          const SizedBox(width: 10,)
        ],
      ),

      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(), //listenable Auto refresh UI
          builder: (context, box, child) {
            var data = box.values.toList().cast<NotesModel>(); // convert box to list
            return _animIcon ? gridView(data, box) : listView(data, box);
          },
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              // padding: EdgeInsets.zero,
              decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.blueGrey)]),
                child: Column(
                  children: [
                    Text("Hive notes"),
                    ListTile(leading: Icon(Icons.bubble_chart_outlined), title: Text("Notes"),)
                  ],
                )
            ),
            ValueListenableBuilder<Box<NotesModel>>(valueListenable: Boxes.getData().listenable(), builder: (context, box, child) {
              var data = box.values.toList().cast<NotesModel>();
              return ListView.builder( shrinkWrap: true,itemCount: box.length, itemBuilder: (context, index) {
                return ListTile(title: Text(data[index].title),splashColor: Colors.green.shade200, onTap: () {

                },);
              },);
            },)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        splashColor: Colors.green.shade400,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewNote(view: false,),));
        },
        tooltip: 'New note',
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  Widget gridView(var data, Box<NotesModel> box){
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
      ),
      itemCount: box.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data[index].title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17), overflow: TextOverflow.ellipsis, maxLines: 1,),
                  Padding(padding: const EdgeInsets.only(left: 8, top: 5), child: Text(data[index].description, overflow: TextOverflow.ellipsis, maxLines: 4,),)
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewNote(notesModel: data[index],view: true,),));
              },
            ),
          ),
        );
      },);
  }

  Widget listView(var data, Box<NotesModel> box){
    return ListView.builder(
      itemCount: box.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data[index].title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17), overflow: TextOverflow.ellipsis, maxLines: 1,),
                  Padding(padding: const EdgeInsets.only(left: 8, top: 5), child: Text(data[index].description, overflow: TextOverflow.ellipsis, maxLines: 4,),)
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewNote(notesModel: data[index],view: true,),));
              },
            ),
          ),
        );
      },);
  }
}
