import 'package:flutter/material.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/models/taskmodel.dart';

class TaskPage extends StatefulWidget {
  final String username;
  const TaskPage({Key? key, required this.username}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState(username:username);
}

class _TaskPageState extends State<TaskPage> {
  final int idx = 2;
  String username; 
  _TaskPageState({required this.username});

  DateTime? _selectedDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController(); // Controller for start time
  TextEditingController _endTimeController = TextEditingController(); // Controller for end time
  TextEditingController  descController  = TextEditingController(); 
  TextEditingController headingController  = TextEditingController(); 
  List<Map<String, dynamic>> teamMembers = [];

  @override
  void initState() {
    super.initState();
    username = widget.username;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: Footer(context, idx, widget.username),
    );
  }

  bool _isValidTime(String? input) 
  {
  // Regular expression to validate input format as "HH:mm"
  final RegExp timeRegExp = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
  return input != null && timeRegExp.hasMatch(input);
}

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFFE6C9),
      title: const Text(
        'Create New Task',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Task Title'),
            const SizedBox(height: 10),
            _buildTextInputField(hint: 'Enter task title', maxLines: 1),
            const SizedBox(height: 20),
            _buildSectionTitle('Task Details'),
            const SizedBox(height: 10),
            _buildTextInputField(hint: 'Enter task details', maxLines: null),
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

  Widget _buildTextInputField({required String hint, int? maxLines}) {
    return Container(
      width: 400.0,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: TextField(
        controller: hint == 'Enter task title' ? descController : headingController,
        maxLength: maxLines == 1 ? 50 : 500,
        keyboardType:
            maxLines == 1 ? TextInputType.text : TextInputType.multiline,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          hintText: hint,
        ),
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget _buildTeamMembersRow() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          Row(
            children: teamMembers
                .map((member) =>
                    _buildTeamMember(member["name"], member["color"]))
                .toList(),
          ),
          // const Spacer(),
          IconButton(
            icon: Icon(Icons.search),
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
                delegate:
                    SearchUsers(username: widget.username, users: otherusers)
                        as SearchDelegate<String>,
              );
              selectedUsername.then((username) {
                if (username != "") {
                  setState(() {
                    teamMembers
                        .add({"name": username, "color": Colors.yellow[100]});
                  });
                }
              });
            },
          ),
        ]));
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
                teamMembers.removeWhere((member) =>
                    member["name"] ==
                    name); // Remove the member by matching the name
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
  TextEditingController controller; // Now directly assigning the correct controller based on the label
  // bool isTimeField = label.contains('Time');
  if (label == 'Date') {
    controller = _dateController; // Assign the _dateController for the date field
  } else if (label == 'Time Start') {
    controller = _startTimeController; // Assign the _startTimeController for the start time field
  } else if (label == 'Time End') {
    controller = _endTimeController; // Assign the _endTimeController for the end time field
  } else {
    controller = TextEditingController(); // Fallback
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
          if (label.contains('Time')) 
          {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) 
            {
              final String formattedTime = pickedTime.format(context);
              setState(() 
              {
                controller.text = formattedTime; 
              });
            }
          } else if (label == 'Date') 
          {
            _selectDate(context);
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
        style: const TextStyle(fontFamily: 'Inter', fontSize: 16.0),
        validator: (value) {
          if (label.contains('Time') && !_isValidTime(value)) {
            return 'Enter time in HH:mm format';
          }
          return null;
        },
      ),
    ),
  );
}


  Future<void> _selectDate(BuildContext context) async 
  {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2025),
  );
  if (picked != null && picked != _selectedDate) 
  {
    setState(() 
    {
      _selectedDate = picked;
      _dateController.text = "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    });
  }
}

  Widget _buildCreateTaskButton() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12.0)),
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.green, primary: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
        onPressed: () async {
          if (_formKey.currentState!.validate())  {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form is valid and processing data')));
             List<String> collaborators= [];
            for (Map<String, dynamic> item in teamMembers) {
              if (item.containsKey('name')) {
                collaborators.add(item['name'] as String);
              } else {
                print("TEAM-MEMBERS missing 'name' key: $item");
              }
            }
            await addTask(username, headingController.text, descController.text, collaborators);
          }
          else{
            print("un-submittable-invalid-form");
          }
        },
        child: const Text('Create Task', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

