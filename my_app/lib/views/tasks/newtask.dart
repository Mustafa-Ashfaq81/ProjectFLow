// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/controllers/calendarapi.dart';
import '../../common/toast.dart';
import 'package:my_app/utils/cache_util.dart';

class NewTaskPage extends StatefulWidget {
  final String username;
  const NewTaskPage({Key? key, required this.username}) : super(key: key);

  @override
  State<NewTaskPage> createState() => _NewTaskPageState(username: username);
}

class _NewTaskPageState extends State<NewTaskPage> {
  final int idx = 2;
  String username;
  _NewTaskPageState({required this.username});

  DateTime? _selectedDate;
  final CalendarClient calendarClient = CalendarClient();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController headingController = TextEditingController();
  List<Map<String, dynamic>> teamMembers = [];


  @override
  void initState() {
    super.initState();
    username = widget.username;
    headingController.addListener(_validateForm);
    descController.addListener(_validateForm);
  }

  @override
  void dispose() {
    descController.dispose();
    headingController.dispose();
    _endTimeController.dispose();
    _startTimeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {});
  }

  bool _isFormValid() {
    return headingController.text.isNotEmpty && descController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: Footer(index: idx, username: username),
    );
  }

  AppBar _buildAppBar() {
   return AppBar(
    centerTitle: true, // Aligns the title to the center
    backgroundColor: Colors.black,
    automaticallyImplyLeading: false,
    title: Text('Create New Task',
      style: TextStyle(color: Colors.white), // Set text color to white
    ),
  );
}

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Task Title'),
              const SizedBox(height: 10),
              _buildTextInputField(
                hint: 'Enter task title',
                maxLines: 1,
                controller: headingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Task Details'),
              const SizedBox(height: 10),
              _buildTextInputField(
                hint: 'Enter task details',
                maxLines: null,
                controller: descController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Add Team Members'),
              const SizedBox(height: 10),
              _buildTeamMembersRow(),
              const SizedBox(height: 20),
              _buildSectionTitle('Time & Date'),
              const SizedBox(height: 10),
              _buildTimeAndDateSection(),
              const SizedBox(height: 30),
              _buildCreateTaskButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextInputField({
    required String hint,
    int? maxLines,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Container(
      width: 400.0,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: TextFormField(
        controller: controller,
        maxLength: maxLines == 1 ? 50 : 500,
        keyboardType: maxLines == 1 ? TextInputType.text : TextInputType.multiline,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          hintText: hint,
          errorStyle: const TextStyle(fontSize: 14.0),
        ),
        style: const TextStyle(fontSize: 18.0),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget _buildTeamMembersRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Row(
            children: teamMembers
                .map((member) => _buildTeamMember(member["name"], member["color"]))
                .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final List<String> allusers = await getallUsers();
              final List<String> otherusers = [];
              for (var user in allusers) {
                if (user != widget.username) {
                  otherusers.add(user);
                }
              }
              Future<String?> selectedUsername = showSearch(
                context: context,
                delegate: SearchUsers(username: widget.username, users: otherusers)
                    as SearchDelegate<String>,
              );
              selectedUsername.then((username) {
                if (username != "") {
                  setState(() {
                    teamMembers.add({"name": username, "color": Colors.yellow[100]});
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, Color color) {
    return Container(
      height: 40.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.person_outline, color: Colors.grey),
          const SizedBox(width: 8),
          Text(name),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                teamMembers.removeWhere((member) => member["name"] == name);
              });
            },
            child: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAndDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildIconContainer(icon: Icons.access_time),
            const SizedBox(width: 10),
            _buildDateTimeField('09:00 AM', 'Time Start'),
            const SizedBox(width: 10),
            const Text(
              ':',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            _buildDateTimeField('10:00 AM', 'Time End'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildIconContainer(icon: Icons.calendar_month),
            const SizedBox(width: 10),
            _buildDateTimeField('Select Date', 'Date'),
          ],
        ),
      ],
    );
  }

  Widget _buildIconContainer({required IconData icon}) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: const Color(0xFFFED36A),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Center(
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  Widget _buildDateTimeField(String hint, String label) {
    TextEditingController controller;
    if (label == 'Date') {
      controller = _dateController;
    } else if (label == 'Time Start') {
      controller = _startTimeController;
    } else if (label == 'Time End') {
      controller = _endTimeController;
    } else {
      controller = TextEditingController();
    }
    return Expanded(
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            if (label.contains('Time')) {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                final String formattedTime = pickedTime.format(context);
                setState(() {
                  controller.text = formattedTime;
                });
              }
            } else if (label == 'Date') {
              _selectDate(context);
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
          ),
          style: const TextStyle(fontFamily: 'Inter', fontSize: 16.0),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

Widget _buildCreateTaskButton() {
  return Container(
    width: double.infinity,
    height: 50.0,
    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12.0)),
    child: TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          var date = _dateController.text;
          var start = _startTimeController.text;
          var end = _endTimeController.text;
          if( date==""){
            showCustomError("There must be a deadline for this project",context);
          } else {
            if( (start == "" && end != "") || (start != "" && end == "") ) {
              showCustomError("There must be a start time for an end time and vice versa",context); 
            } else{

              DateTime comparisonDate = DateTime.parse(_dateController.text);
              DateTime today = DateTime.now();
              bool isAfter = today.isAfter(comparisonDate);
              if (!isAfter){
                var is_suitable_time = isSuitableTime(start,end);
                if(is_suitable_time == false){
                   showCustomError("You can only set a deadline that starts and ends in that day & end time must be greater than start time",context);
                }
                else {
                  var isoverlap = await isOverlappingdeadline(date,start,end,username);
                  if(isoverlap == true) {
                    showCustomError("This deadline clashes with some other project",context);
                  } else {  //no overlaps
                    handleValidTaskSubmission(
                      context,
                      username,
                      headingController.text,
                      descController.text,
                      _dateController.text,
                      _startTimeController.text,
                      _endTimeController.text,
                      teamMembers,
                      calendarClient
                    );
                  }
                }
              } else {
                  showCustomError("Deadline of Project selected should be atleast tomorrow",context);
            }
          }
         }
        } else  {
          showCustomError("Please fill in all required fields.",context);
        }
      },
      child: const Text('Create Task', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    ),
  );
}
}

Future<void> handleValidTaskSubmission(BuildContext context, String username, String heading, String desc, String date, String start_time, String end_time, List<Map<String, dynamic>> teamMembers, CalendarClient calendarClient)async{
   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Form is valid and processing data'),duration: Duration(seconds: 2),));
    List<String> collaborators= [];
  for (Map<String, dynamic> item in teamMembers) {
    if (item.containsKey('name')) {
      collaborators.add(item['name'] as String);
    } else {
      print("TEAM-MEMBERS missing 'name' key: $item");
    }
  }
  print("$date ... $start_time ... $end_time...");
  await addTask(username, heading, desc, collaborators,date,start_time,end_time);
  showmsg(message: "Task has been added successfully!");
  // if (start_time!="" && end_time!=""){
    calendarClient.insert(heading,start_time,end_time,);
    showmsg(message: "Event has been added to calendar successfully!");
  // }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(username: username),
    ));
}

Future<bool> isOverlappingdeadline(String date, String start_time, String end_time, String username) async {

  List<Map<String, dynamic>> deadlines = [];
  List<Map<String, dynamic>>? cachedDeadlines =
  CacheUtil.getData('deadlines_$username');
  if (cachedDeadlines != null) {
    deadlines = cachedDeadlines;
  } else {
    print('deadlines-cache-null');
    deadlines = await getdeadlines(username);
    CacheUtil.cacheData('deadlines_$username', deadlines);
  }
  // print("checking for overlap in $deadlines");
  for (var deadline in deadlines) {
    print("checking for deadline $deadline");
    if (deadline['duedate'] == date){
        if(isTimeInRange(deadline['start_time'], deadline['end_time'], start_time)) {return true;}
        if(isTimeInRange(deadline['start_time'], deadline['end_time'], end_time)) {return true;}
    }
  }
  return false;
}

bool isTimeInRange(String startTime, String endTime, String checkTime) {

  var startTimeParsed = startTime.split(" ")[0].split(":");
  var startTimeclk = startTime.split(" ")[1];
  var startTimehr = int.parse(startTimeParsed[0]);
  var startTimemin = int.parse(startTimeParsed[1]);

  var endTimeParsed = endTime.split(" ")[0].split(":");
  var endTimeclk = endTime.split(" ")[1];
  var endTimehr = int.parse(endTimeParsed[0]);
  var endTimemin = int.parse(endTimeParsed[1]);

  var checkTimeParsed = checkTime.split(" ")[0].split(":");
  var checkTimeclk = checkTime.split(" ")[1];
  var checkTimehr = int.parse(checkTimeParsed[0]);
  var checkTimemin = int.parse(checkTimeParsed[1]);

  if(checkTimeclk == "PM"){checkTimehr += 12;}
  if(startTimeclk == "PM"){startTimehr += 12;}
  if(endTimeclk == "PM"){endTimehr += 12;}

  print("start $startTimehr");
  print("end $endTimehr");
  print("check $checkTimehr");

  final startTimeInMinutes = (startTimehr * 60) + startTimemin;
  final endTimeInMinutes = (endTimehr * 60) + endTimemin;
  final checkTimeInMinutes = (checkTimehr * 60) + checkTimemin;

  return (checkTimeInMinutes >= startTimeInMinutes && checkTimeInMinutes < endTimeInMinutes) ||
      (checkTimeInMinutes < startTimeInMinutes && endTimehr > startTimehr);

}

bool isSuitableTime(String startTime, String endTime){
  var startTimeParsed = startTime.split(" ")[0].split(":");
  var startTimeclk = startTime.split(" ")[1];
  var startTimehr = int.parse(startTimeParsed[0]);
  var startTimemin = int.parse(startTimeParsed[1]);

  var endTimeParsed = endTime.split(" ")[0].split(":");
  var endTimeclk = endTime.split(" ")[1];
  var endTimehr = int.parse(endTimeParsed[0]);
  var endTimemin = int.parse(endTimeParsed[1]);

  if(startTimeclk == "PM"){startTimehr += 12;}
  if(endTimeclk == "PM"){endTimehr += 12;}

  if(startTimehr>endTimehr) {return false;}
  if(startTimehr == endTimehr && startTimemin >= endTimemin) {return false;}
  return true;
}