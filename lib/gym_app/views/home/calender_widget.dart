import 'package:flutter/material.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:vff_group/gym_app/utils/app_colors.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  late DateTime _selectedDateAppBBar;
  @override
  Widget build(BuildContext context) {
    return CalendarAgenda(
      controller: _calendarAgendaControllerAppBar,
      selectedDayPosition: SelectedDayPosition.center,
      
      weekDay: WeekDay.short,
      dayNameFontSize: 12,
      dayNumberFontSize: 16,
      dayBGColor: Colors.grey.withOpacity(0.15),
      titleSpaceBetween: 15,
      backgroundColor: Colors.transparent,
      // fullCalendar: false,
      fullCalendarScroll: FullCalendarScroll.horizontal,
      fullCalendarDay: WeekDay.short,
      selectedDateColor: Colors.white,
      dateColor: Colors.black,
      locale: 'en',

      initialDate: DateTime.now(),
      calendarEventColor: AppColors.primaryColor2,
      firstDate: DateTime.now().subtract(const Duration(days: 140)),
      lastDate: DateTime.now().add(const Duration(days: 60)),

      onDateSelected: (date) {
        _selectedDateAppBBar = date;
        //setDayEventWorkoutList();
      },
      selectedDayLogo: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: AppColors.primaryG,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
