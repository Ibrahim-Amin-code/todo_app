import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());

  }
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase()
  {
     openDatabase(
      'todo2.db',
      version: 1,
      onCreate: (database , version)
      {
        print('Database Created');
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)'
        ).then((value) {
          print('Table Created');
        }).catchError((error){
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('Database Opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
     });
  }


  Future insertToDatabase({
    @required title,
    @required time,
    @required date,
  }) async
  {
    return await database.transaction((txn) {
      txn.rawInsert(
        'INSERT INTO tasks(title, time, date,status) VALUES("$title", "$time","$date","new")',
      ).then((value)
      {
        print('$value Inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error)
      {
        print('Error When Inserting New Record ${error.toString()}');
      });

      return null;
    });
  }


  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element)
      {
        if(element['status'] == 'new')
        {
          newTasks.add(element);
        }else if(element['status'] == 'done')
        {
          doneTasks.add(element);
        }else{
          archiveTasks.add(element);
        }

      });
      emit(AppGetDatabaseState());
     });

  }


  bool isBottomSheetShow = false;
  IconData fabIcon= Icons.edit;

  void changeBottomSheetState({
  @required bool isShow,
  @required IconData icon,
  })
  {
    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({
  @required String status,
  @required int id,
})async
  {
     await database.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ?',
        ['$status', id]).then((value) {
          getDataFromDatabase(database);
          emit(AppUpdateDatabaseState());
     });
  }


  void deleteData({
    @required int id,
  })async
  {
    await database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


}


































// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:udemy_flutter111/modules/archived_tasks/archived_tasks_screen.dart';
// import 'package:udemy_flutter111/modules/done_etasks/done_tasks_screen.dart';
// import 'package:udemy_flutter111/modules/new_tasks/new_tasks_screen.dart';
// import 'package:udemy_flutter111/shared/cubit/states.dart';
//
// class AppCubit extends Cubit<AppStates> {
//   AppCubit() : super(AppInitialState());
//
//   static AppCubit get(context) => BlocProvider.of(context);
//
//   Database database;
//   List<Map> newTasks = [];
//   List<Map> doneTasks = [];
//   List<Map> archiveTasks = [];
//   int currentIndex = 0;
//
//   List<Widget> screens = [
//     NewTasksScreen(),
//     DoneTasksScreen(),
//     ArchivedTasksScreen(),
//   ];
//
//   List<String> titles = [
//     'New Tasks',
//     'Done Tasks',
//     'Archived Tasks',
//   ];
//
//   void changeIndex(int index) {
//     currentIndex = index;
//     emit(AppChangeBottomNavBarState());
//   }
//
//   void createDatabase() {
//     openDatabase('todo.db', version: 1, onCreate: (database, version) {
//       // id integer
//       // title string
//       // date string
//       // time string
//       // status string
//
//       print('database create');
//       database.execute(
//               'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT ) '
//           ).then((value) {
//         print('Table created');
//       }).catchError((error) {
//         print('error when create table ${error.toString()}');
//       });
//     }, onOpen: (database) {
//       getDataFromDatabase(database);
//
//       print('database Opened');
//     }).then((value) {
//       database = value;
//       emit(AppCreateDatabaseState());
//     });
//   }
//
//   insertToDatabase({
//     @required String title,
//     @required String time,
//     @required String date,
//   }) async {
//     await database.transaction((txn) {
//       txn
//           .rawInsert(
//               'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
//           .then((value) {
//         print('$value Inserted Successfully');
//
//         emit(AppInsertDatabaseState());
//
//         getDataFromDatabase(database);
//       }).catchError((error) {
//         print('error when Inserting New Record ${error.toString()}');
//       });
//       return null;
//     });
//   }
//
//   void getDataFromDatabase(database) {
//     newTasks = [];
//     doneTasks = [];
//     archiveTasks = [];
//     emit(AppGetDatabaseLoadingState());
//     database.rawQuery('SELECT * FROM tasks').then((value) {
//       value.forEach((element) {
//         if (element['status'] == 'new')
//           newTasks.add(element);
//         else if (element['status'] == 'done')
//           doneTasks.add(element);
//         else
//           archiveTasks.add(element);
//       });
//
//       emit(AppGetDatabaseState());
//     });
//   }
//
//   void updateData({
//     @required String status,
//     @required int id,
//   }) async {
//     database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [
//       '$status',
//       id,
//     ]).then((value) {
//       getDataFromDatabase(database);
//       emit(AppUpdateDatabaseState());
//     });
//   }
//
//
//   void deleteData({
//     @required int id,
//   }) async {
//     database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
//     .then((value) {
//       getDataFromDatabase(database);
//       emit(AppDeleteDatabaseState());
//     });
//   }
//
//
//   bool isBottomSheetShown = false;
//   IconData fabIcon = Icons.edit;
//
//   void changeBottomSheetState({
//     @required bool isShow,
//     @required IconData icon,
//   }) {
//     isBottomSheetShown = isShow;
//     fabIcon = icon;
//     emit(AppChangeBottomSheetState());
//   }
// }
