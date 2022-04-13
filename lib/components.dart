import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/task_model.dart';

Widget buildTaskItem(TaskModel model, context) {
  return Dismissible(
    key: Key(model.id.toString()), //required Key could be any String
    background: Container(color: Colors.redAccent),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model.id.toString());
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(model.time),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.title,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5.0),
                Text(model.date,
                    style: const TextStyle(color: Colors.blueGrey)),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          if (model.status == 'new')
            Expanded(
              flex: 1,
              child: MaterialButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .updateData(status: 'done', id: model.id);
                  },
                  child: const Icon(
                    Icons.done_outline_outlined,
                    color: Colors.deepPurpleAccent,
                  )),
            ),
          if (model.status == 'new' || model.status == 'done')
            Expanded(
              flex: 1,
              child: MaterialButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .updateData(status: 'archived', id: model.id);
                  },
                  child: const Icon(
                    Icons.archive_outlined,
                    color: Colors.deepPurpleAccent,
                  )),
            ),
        ],
      ),
    ),
  );
}

Widget taskBuilder(List<TaskModel> tasks) => ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
            child: Container(
                width: double.infinity,
                height: 2.5,
                color: Colors.grey[300])), //_____
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.menu, size: 150, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No Tasks yet.',
              style: TextStyle(fontSize: 25, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
