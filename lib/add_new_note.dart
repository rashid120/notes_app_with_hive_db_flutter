import 'package:flutter/material.dart';
import 'package:notes_app_hive_db/boxes/boxes.dart';
import 'package:notes_app_hive_db/home_screen/home_screen.dart';
import 'package:notes_app_hive_db/models/notes_model.dart';

class AddNewNote extends StatefulWidget {
   const AddNewNote({super.key, this.notesModel, required this.view});

  final NotesModel? notesModel;
  final bool view;

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {

  TextEditingController noteTitleController = TextEditingController();
  TextEditingController noteDescriptionController = TextEditingController();

  late bool _view;
  late bool _update;

  @override
  void initState() {
    super.initState();
    _view = widget.view;
    _update = widget.view;
  }

  @override
  void dispose() {
    noteTitleController.dispose();
    noteDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _view ? onlyViewNote(widget.notesModel) : editNote();
  }

  Widget onlyViewNote(NotesModel? notesModel){
    var media = MediaQuery.of(context).size;
    var view = MediaQuery.of(context).viewInsets;

    noteTitleController.text = notesModel!.title;
    noteDescriptionController.text = notesModel.description;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        actions: [
          InkWell(child: const Icon(Icons.edit), onTap: () {
            setState(() {_view = false;});
            },),
          const SizedBox(width: 10,),
          InkWell(child: const Icon(Icons.delete_forever), onTap: () async {
            await notesModel.delete();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyHomePage(),),(route) => false,);
            },),
          const SizedBox(width: 10,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: media.width * 0.05, top: 10),
              child: TextField(
                controller: noteTitleController,
                decoration: const InputDecoration.collapsed(hintText: 'Title', hintStyle: TextStyle(fontSize: 23,)),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                maxLines: 2,
                enabled: false,
              ),
            ),
            Container(color: Colors.green.shade200, width: double.infinity, height: 1,),
            Padding(
              padding: EdgeInsets.only(left: media.width * 0.05),
              child: TextField(
                controller: noteDescriptionController,
                decoration: const InputDecoration.collapsed(hintText: 'Note'),
                style: const TextStyle(fontSize: 16, color: Colors.black),
                keyboardType: TextInputType.multiline,
                enabled: false,
                minLines: 1,
                maxLines: (view.bottom <= 0) ? 5 : view.bottom.floor(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget editNote(){
    var media = MediaQuery.of(context).size;
    var view = MediaQuery.of(context).viewInsets;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: media.width * 0.05, top: 10),
              child: TextField(
                controller: noteTitleController,
                decoration: const InputDecoration.collapsed(hintText: 'Title', hintStyle: TextStyle(fontSize: 23, )),
                style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.text,
                autocorrect: true,
                textInputAction: TextInputAction.next,
                maxLines: 2,
              ),
            ),
            Container(color: Colors.green.shade200, width: double.infinity, height: 1,),
            Padding(
              padding: EdgeInsets.only(left: media.width * 0.05),
              child: TextField(
                controller: noteDescriptionController,
                decoration: const InputDecoration.collapsed(hintText: 'Note'),
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.multiline,
                autocorrect: true,
                minLines: 1,
                maxLines: (view.bottom <= 0) ? 5 : view.bottom.floor(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.green.shade400,
        backgroundColor: Colors.blueGrey,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
        onPressed: () async {

          if(_update){
            widget.notesModel?.title = noteTitleController.text;
            widget.notesModel?.description = noteDescriptionController.text;
            widget.notesModel?.save();
            setState(() {_view = true;});
          }else {

            final data = NotesModel(title: noteTitleController.text, description: noteDescriptionController.text);
            final box = Boxes.getData();
            box.add(data);
            data.save();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyHomePage(),),(route) => false,);
          }
        },
        child: const Icon(Icons.done_all, color: Colors.white,),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
