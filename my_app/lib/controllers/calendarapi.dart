import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:my_app/common/toast.dart';
import 'package:my_app/components/image.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarClient {
  static final _scopes = [CalendarApi.calendarScope];

  void insert(title, startTime, endTime) async {
    var _clientID;
    if (kIsWeb){
      _clientID = ClientId("12273615091-8aa1ois5l7b31tmirhcp6p7lihgmh1hk.apps.googleusercontent.com");
    } else {    //android
      _clientID = ClientId("12273615091-rjfklbbdqr6591ioa8lss1lk3eor2j67.apps.googleusercontent.com");
    }
    if (_clientID != null) {
    await clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) {
      var calendar = CalendarApi(client);
      print("got-cal");
      calendar.calendarList.list().then((value) => print("VAL________$value"));
      print("got-cal-2");

      String calendarId = "primary";
      Event event = Event(); // Create object of event

      event.summary = title;

      EventDateTime start = EventDateTime();
      start.dateTime = startTime;
      start.timeZone = "GMT+05:00";
      event.start = start;

      EventDateTime end = EventDateTime();
      end.timeZone = "GMT+05:00";
      end.dateTime = endTime;
      event.end = end;
      print("got-events");
      try {
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDD_________________${value.status}");
          if (value.status == "confirmed") {
            print('Event added in google calendar');
          } else {
            print("Unable to add event in google calendar");
          }
        });
      } catch (e) {
        print('Error creating event $e');
      }
    });
    } else {
      showerrormsg(message: "client-id-null");
      print("null-client-id");

    }
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:  => $url");

    if (!kIsWeb){ //android
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        showerrormsg(message: "could not launch the url");
        print('Could not launch $url');
      }
    }
  }
}