import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/Archived/ArchivedTasks.dart';
import 'package:todoapp/Constants/constants.dart';
import 'package:todoapp/DoneTasks/DoneTasks.dart';
import 'package:todoapp/NewTasks/NewTasks.dart';
import 'package:todoapp/Shared/Cubit/cubit.dart';
import 'package:todoapp/Shared/Cubit/state.dart';

class HomeLayout extends StatelessWidget {


  //@override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state){
          if(state is AppInsertDataBase){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context,AppStates state){

          AppCubit cubit =AppCubit.get(context);

          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.Cur],
              ),
              backgroundColor: Color(0xFF329679),
            ),

            body: state is! AppGetDataBaseLoadingState ? cubit.screens[cubit.Cur]:
            Center(child: CircularProgressIndicator()),



            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF329679),
              onPressed: () {

                if (cubit.isShow) {
                  if(cubit.formKey.currentState!.validate())
                  {
                    cubit.insertToDatabase(
                        title: cubit.titleController.text,
                        time: cubit.timeController.text,
                        date: cubit.dateController.text);
                  }
                }
                else {
                  cubit.scaffoldKey.currentState?.showBottomSheet(
                          (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(18.0),
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: cubit.titleController,
                                keyboardType: TextInputType.text,
                                validator: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },

                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder:OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.teal
                                      ),
                                      borderRadius:BorderRadius.circular(10)

                                  ),

                                  labelText: 'Task Title',
                                  labelStyle: TextStyle(
                                    color: Colors.green[300]
                                  ),
                                  focusColor: Colors.black,

                                  prefixIcon: Icon(
                                    Icons.title,
                                    color:Colors.green[400] ,
                                  ),
                                ),

                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                controller: cubit.timeController,
                                keyboardType: TextInputType.datetime,
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    cubit.timeController.text=value!.format(context).toString();
                                    print(value.format(context));
                                  });
                                },
                                readOnly:true,
                                validator: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'Time must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder:OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.teal
                                      ),
                                      borderRadius:BorderRadius.circular(10)

                                  ),
                                  labelText: 'Time Title',
                                  labelStyle: TextStyle(
                                      color: Colors.green[300]
                                  ),
                                  prefixIcon: Icon(
                                    Icons.watch_later_outlined,
                                    color:Colors.green[400] ,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                readOnly: true,
                                controller: cubit.dateController,
                                keyboardType: TextInputType.datetime,
                                onTap: () async
                                {
                                  DateTime? pic = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  ).then((value) {
                                    print(DateFormat.yMMMMd().format(value!));
                                    cubit.dateController.text=DateFormat.yMMMMd().format(value);
                                  });
                                },
                                validator: (String? val) {
                                  if (val!.isEmpty) {
                                    return 'Date must not be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder:OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.teal
                                      ),
                                      borderRadius:BorderRadius.circular(10)

                                  ),
                                  labelText: 'Date Title',
                                  labelStyle: TextStyle(
                                      color: Colors.green[300]
                                  ),
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color:Colors.green[400] ,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 20.0
                  ).closed.then((value) {

                    cubit.changeBottomSheetState(
                        isShoww: false,
                        icon: Icons.edit
                    );

                  });
                  cubit.changeBottomSheetState(
                      isShoww: true,
                      icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(0xFF329679),
              selectedItemColor: Colors.grey[300],
              unselectedItemColor: const Color(0xFF116530),
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.Cur,
              onTap: (index) {

                cubit.changeIndex(index);
              },

              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',

                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_box),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_rounded),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Future<String> getName() async {
  //   return 'LOL';
  // }


}

