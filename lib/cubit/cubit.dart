import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/screens/archived_tasks.dart';
import 'package:todo_app/screens/done_tasks.dart';
import 'package:todo_app/screens/new_tasks.dart';
import 'package:todo_app/task_model.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen()
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  TaskModel? taskModel;
  List<TaskModel> newTasks = [];
  List<TaskModel> doneTasks = [];
  List<TaskModel> archivedTasks = [];

  insertToDatabase({
    required String title,
    required String date,
    required String time,
    required String order,
  }) {
    taskModel = TaskModel(
      id: '',
      status: 'new',
      title: title,
      date: date,
      time: time,
      order: order,
    );
    FirebaseFirestore.instance
        .collection('task')
        .add(taskModel!.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('task')
          .doc(value.id)
          .update({'id': value.id}).then((value) {
        emit(AppInsertDatabaseState());
        getDataFromDatabase();
      }).catchError((error) {
        log(error.toString());
      });
    }).catchError((error) {
      log(error.toString());
    });
  }

  void getDataFromDatabase() {
    emit(AppDatabaseLoadingState());
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    FirebaseFirestore.instance
        .collection('task')
        .orderBy('order', descending: false)
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (element.data()['status'] == 'new') {
          newTasks.add(TaskModel.fromJson(element.data()));
        }
        if (element.data()['status'] == 'done') {
          doneTasks.add(TaskModel.fromJson(element.data()));
        }
        if (element.data()['status'] == 'archived') {
          archivedTasks.add(TaskModel.fromJson(element.data()));
        }
      }
      emit(AppGetDatabaseState());
    }).catchError((error) {
      log(error.toString());
    });
  }

  void updateData({
    required String status,
    required String id,
  }) {
    FirebaseFirestore.instance
        .collection('task')
        .doc(id)
        .update({'status': status}).then((value) {
      getDataFromDatabase();
    }).catchError((error) {
      log(error.toString());
    });
  }

  void deleteData({required String id}) {
    FirebaseFirestore.instance
        .collection('task')
        .doc(id)
        .delete()
        .then((value) {
      getDataFromDatabase();
    }).catchError((error) {
      log(error.toString());
    });
  }
}
