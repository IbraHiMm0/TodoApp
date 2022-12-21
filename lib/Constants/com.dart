import 'package:flutter/material.dart';
import 'package:todoapp/Shared/Cubit/cubit.dart';

Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40.0 ,
          backgroundColor: Color(0xFF6e9621),
          child: Text(

            '${model['time']}',
            style: TextStyle(
              color: Colors.white,
              fontSize:15.0
            ),

          ),
        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${model['title']}'.toUpperCase(),

                style: TextStyle(

                  fontSize: 23.0,
                  color: Color(0xFF334b07),
                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                  //fontSize: 14.0,

                    color: Colors.green[700],

                    fontWeight: FontWeight.w300

                ),

              ),

            ],

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateData(status: 'done', id: model['id']);

            },

            icon: Icon(

              Icons.check_circle,
              color: Color(0xFF547354),

            )

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateData(status: 'archive', id: model['id']);



            },

            icon: Icon(

              Icons.archive,

              color: Color(0xFF547354),

            )

        ),







      ],

    ),

  ),
  onDismissed: (dir){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);
