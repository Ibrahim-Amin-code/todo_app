import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
// import 'package:udemy_flutter111/shared/cubit/cubit.dart';

Widget defaultButton({
   double width = double.infinity,
   Color background = Colors.blue,
   bool isUpperCase = true,
   double radius = 0,
  @required Function function,
  @required String text,
}) =>
    Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
            isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormFiled({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onChange,
  Function onSubmit,
  Function onTap,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      validator: validate,
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
      ),
    );

  Widget buildTaskItem(Map model , context) => Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction)
    {
      AppCubit.get(context).deleteData(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${model['time']}'
            ,),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey
                ),),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
              icon: Icon(Icons.check_box,color: Colors.green,),
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'] ,
                );
              }),
            IconButton(
                icon: Icon(Icons.archive,color: Colors.black45,),
                onPressed: () {
                  AppCubit.get(context).updateData(
                      status: 'archive',
                      id: model['id'] ,
                  );
                }),
          ],
        ),
    ),
  );

  Widget taskBuilder({
    @required List<Map> tasks,
  }) => ConditionalBuilder(
    condition: tasks.length > 0 ,
    builder:(context) =>ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(tasks[index] , context),
      separatorBuilder: (context, index) => Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,size: 100,color: Colors.grey,),
          Text('No Tasks Yet Please Add Some Tasks...',style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
        ],

      ),
    ) ,
  );