// ignore_for_file: unused_import, avoid_print, unnecessary_const

import 'dart:developer';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/*

A class that provides methods to interact with Google Calendar
It handles operations such as inserting, deleting, and retrieving calendar events

*/

class CalendarClient {
  static const _scopes = const [CalendarApi.calendarScope];

  /*
   * Inserts an event into Google Calendar.
   * Requires OAuth2 consent from the user. Industry Standard Authorization Protocol
   * [title] The title of the event.
   * [startTime] The start time of the event in the format 'HH:mm'.
   * [endTime] The end time of the event in the format 'HH:mm'.
   */

  Future<void> insert(String title, String startTime, String endTime) async {
    var clientID = ClientId(
        "1073810950980-50c8312c67hehvrllgnttp6hf3ltodlp.apps.googleusercontent.com",
        "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");

    await clientViaUserConsent(clientID, _scopes, prompt)
        .then((AuthClient client) {
      var calendar = CalendarApi(client);

      String calendarId = "primary";
      Event event = Event();

      event.summary = title;

      // Parse startTime for the desired format

      DateTime? startDateTime = parseDateTime(startTime);

      EventDateTime start = EventDateTime();
      start.dateTime = startDateTime;
      start.timeZone = "GMT+05:00";
      event.start = start;

      // Parse endTime for the desired format

      DateTime? endDateTime = parseDateTime(endTime);

      EventDateTime end = EventDateTime();

      end.timeZone = "GMT+05:00";
      end.dateTime = endDateTime;
      event.end = end;

      calendar.events.insert(event, calendarId).then((value) {
        if (value.status == "confirmed") {
          print('Event added in google calendar');
        } else {
          print("Unable to add event in google calendar");
        }
      }).catchError((e) {
        print('Error creating event $e');
      });
    }).catchError((e) {
      print('Authorization failed: $e');
    });
  }

  /*
   * Deletes an event from Google Calendar.
   * [calendarId] The ID of the calendar containing the event.
   * [eventId] The ID of the event to be deleted.
   */

  Future<void> delete(String calendarId, String eventId) async {
    var clientID = ClientId(
        "1073810950980-50c8312c67hehvrllgnttp6hf3ltodlp.apps.googleusercontent.com",
        "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");

    await clientViaUserConsent(clientID, _scopes, prompt)
        .then((AuthClient client) {
      var calendar = CalendarApi(client);
      String calendarId = "primary";

      calendar.events.delete(calendarId, eventId).then((value) {
        print('Event deleted from Google Calendar');
      }).catchError((e) {
        print('Error deleting event: $e');
      });
    }).catchError((e) {
      print('Authorization failed: $e');
    });
  }

  /*
   * Retrieves events from Google Calendar.
   * Returns a list of events.
   */

  Future<List<Event>> getEvents() async {
    var clientID = ClientId(
        "1073810950980-50c8312c67hehvrllgnttp6hf3ltodlp.apps.googleusercontent.com",
        "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");
    List<Event> events = [];

    try {
      var client = await clientViaUserConsent(clientID, _scopes, prompt);
      var calendar = CalendarApi(client);
      String calendarId = "primary";
      var eventsResult = await calendar.events.list(calendarId);
      events = eventsResult.items!;
      return events;
    } catch (e) {
      print('Error fetching events: $e');
      return events;
    }
  }

  /*
   * Parses a string to DateTime.
   * [timeString] The string containing the time information.
   * Returns a DateTime object or null if parsing fails.
   */

  DateTime? parseDateTime(String timeString) {
    try {
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String dateTimeString = "$currentDate $timeString";
      return DateFormat('yyyy-MM-dd h:mm a').parse(dateTimeString);
    } catch (e) {
      print('Error parsing datetime: $e');
      return null;
    }
  }

  /*
    Opens a URL in the default browser
    Functionality visible once the API is in process 
    */

  void prompt(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
