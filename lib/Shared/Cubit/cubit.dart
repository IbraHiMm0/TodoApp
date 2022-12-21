import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/Shared/Cubit/state.dart';
import '../../Archived/ArchivedTasks.dart';
import '../../Constants/constants.dart';
import '../../DoneTasks/DoneTasks.dart';
import '../../NewTasks/NewTasks.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit(): super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);

  int Cur = 0;
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isShow = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();



  List<Widget> screens = [
     NewTasks(),
     DoneTasks(),
     ArchivedTasks(),
  ];
  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived',
  ];


  void changeIndex(int index){
    Cur = index;
    emit(AppChangeBottomNavBar());
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];


  void createDatabase()  {
    openDatabase('Todo.db', version: 1,
        onCreate: (database, version) {
          print('DataBase Created');
          database
              .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT , date TEXT,time TEXT,status TEXT) ')
              .then((value) {
            print('Table Created');
          }).catchError((error) {
            print('Error When Creating DB ${error.toString()}');
          });
        }, onOpen: (database) {

          getDataBase(database);


          print('DataBase Opened');
        }).then((value) {
          database=value;
          emit(AppCreateDataBase());
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,

  }) async {
     await database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value)
      {
        print('$value Inserted Successfully');
        emit(AppInsertDataBase());
        getDataBase(database);
      }).catchError((error) {
        print('Error When Inserting DB ${error.toString()}');
      });

      return Future(() => null);
    });
  }

  void getDataBase(database)  {

    newTasks=[];
    doneTasks=[];
    archiveTasks=[];

    emit(AppGetDataBaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {



       value.forEach((element)
       {
         if(element['status']=='new'){
            newTasks.add(element);
         }
         else if(element['status']=='done'){
           doneTasks.add(element);
         }
         else{
             archiveTasks.add(element);
         }

       });
       emit(AppGetDataBase());
     });
  }

  void updateData({
  required String? status,
  required int id,
}) async{
      database.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ?',
        ['$status', id]).then((value) {
          getDataBase(database);
          emit(AppUpdateDataBase());
      });
  }

  void deleteData({
    required int id,
  }) async{
    database.rawDelete(
        'Delete from tasks WHERE id = ?',
        [id]).then((value) {
      getDataBase(database);
      emit(AppDeleteDataBase());
    });
  }

  void changeBottomSheetState({
  required bool isShoww,
    required IconData icon,
}){
    isShow=isShoww;
    fabIcon=icon;

    emit(AppChangeBottomSheetState());

  }


}