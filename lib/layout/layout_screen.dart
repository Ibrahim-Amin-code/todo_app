
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class Homelayout extends StatelessWidget

{

  var scaffoldKey= GlobalKey<ScaffoldState>();
  var formKey= GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (context , state) {
            if(state is AppInsertDatabaseState)
              {
                Navigator.pop(context);
              }
        } ,
        builder:  (context , state) {
          AppCubit cubit = AppCubit.get(context);

          return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow)
                {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );
                    //     .then((value) {
                    //   Navigator.pop(context);
                    // });
                  }
                } else
                  {
                  scaffoldKey.currentState.showBottomSheet(
                        (context) => Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.white,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormFiled(
                              controller: titleController,
                              type: TextInputType.text,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'Title Must Not Be Empty';
                                } else {
                                  return null;
                                }
                              },
                              label: 'Task Title',
                              prefix: Icons.title,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultFormFiled(
                              controller: timeController,
                              type: TextInputType.datetime,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'Time Must Not Be Empty';
                                } else {
                                  return null;
                                }
                              },
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text = value.format(context);
                                  print(value.format(context));
                                });
                              },
                              label: 'Task Time',
                              prefix: Icons.watch_later_outlined,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultFormFiled(
                              controller: dateController,
                              type: TextInputType.datetime,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2021-09-20'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMEd().format(value);
                                  print(DateFormat.yMMMEd().format(value));
                                });
                              },
                              validate: (String value) {
                                if (value.isEmpty) {
                                  print('Date Must Not Be Empty');
                                }
                              },
                              label: 'Task Date',
                              prefix: Icons.calendar_today,
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20,
                  ).closed.then((value)
                  {
                   cubit.changeBottomSheetState(
                       isShow: false,
                       icon: Icons.edit,
                   );
                  });
                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'New Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived Tasks',
                ),
              ],
            ),
            body: ConditionalBuilder(

              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()) ,
            ),
          );
        },
      ),
    );
  }

  Future<String> getName() async
  {
    return 'Ibrahim Amin';
  }



}

