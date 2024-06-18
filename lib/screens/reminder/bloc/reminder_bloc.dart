import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'package:timezone/timezone.dart' as tz;

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderInitial()) {
    on<RepeatDaySelectedEvent>(_onRepeatDaySelectedEvent);
    on<ReminderNotificationTimeEvent>(_onReminderNotificationTimeEvent);
    on<OnSaveTappedEvent>(_onSaveTappedEvent);
  }

  int? selectedRepeatDayIndex;
  late DateTime reminderTime;
  int? dayTime;

  void _onRepeatDaySelectedEvent(RepeatDaySelectedEvent event, Emitter<ReminderState> emit) {
    selectedRepeatDayIndex = event.index;
    dayTime = event.dayTime;
    emit(RepeatDaySelectedState(index: selectedRepeatDayIndex));
  }

  void _onReminderNotificationTimeEvent(ReminderNotificationTimeEvent event, Emitter<ReminderState> emit) {
    reminderTime = event.dateTime;
    emit(ReminderNotificationState());
  }

  Future<void> _onSaveTappedEvent(OnSaveTappedEvent event, Emitter<ReminderState> emit) async {
    await _scheduleAtParticularTimeAndDate(reminderTime, dayTime);
    emit(OnSaveTappedState());
  }

  Future<void> _scheduleAtParticularTimeAndDate(DateTime dateTime, int? dayTime) async {
    final flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const iosPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await flutterNotificationsPlugin.zonedSchedule(
      0,
      'Fitness',
      'Hey, it\'s time to start your exercises!',
      _scheduleWeekly(dateTime, days: _createNotificationDayOfTheWeek(dayTime)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _scheduleDaily(DateTime dateTime) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      dateTime.hour,
      dateTime.minute,
    );

    return scheduledDate.isBefore(now) ? scheduledDate.add(const Duration(days: 1)) : scheduledDate;
  }

  tz.TZDateTime _scheduleWeekly(DateTime dateTime, {required List<int>? days}) {
    tz.TZDateTime scheduledDate = _scheduleDaily(dateTime);

    while (!days!.contains(scheduledDate.weekday)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  List<int> _createNotificationDayOfTheWeek(int? dayTime) {
    switch (dayTime) {
      case 0:
        return [
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
          DateTime.saturday,
          DateTime.sunday
        ];
      case 1:
        return [
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday
        ];
      case 2:
        return [DateTime.saturday, DateTime.sunday];
      case 3:
        return [DateTime.monday];
      case 4:
        return [DateTime.tuesday];
      case 5:
        return [DateTime.wednesday];
      case 6:
        return [DateTime.thursday];
      case 7:
        return [DateTime.friday];
      case 8:
        return [DateTime.saturday];
      case 9:
        return [DateTime.sunday];
      default:
        return [];
    }
  }
}
