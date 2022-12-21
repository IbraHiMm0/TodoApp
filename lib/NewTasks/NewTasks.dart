import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Constants/com.dart';
import 'package:todoapp/Shared/Cubit/cubit.dart';
import 'package:todoapp/Shared/Cubit/state.dart';



class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {

      },
      builder: (context, state)
      {
        var tasks = AppCubit.get(context).newTasks;
        if (tasks.isNotEmpty) {
          return ListView.separated(
          itemBuilder: (context,index) => buildTaskItem(tasks[index],context),
          separatorBuilder: (context,index) => Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 20.0,
                end: 20.0
            ),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          itemCount: tasks.length,
        );
        }
        else {
          return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_open_sharp,
                size: 100.0,
                color: Colors.grey[300],
              ),
              Text(
                  'No Tasks Yet, Add one',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.grey[300],

                ),
              ),
            ],
          ),
        );
        }
      },
    );
  }


}

