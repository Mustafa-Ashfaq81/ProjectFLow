import 'package:flutter/material.dart';
import 'package:my_app/views/home.dart';
import 'package:my_app/components/search.dart';
import 'package:my_app/components/footer.dart';
import 'package:my_app/models/usermodel.dart';
import 'package:my_app/models/taskmodel.dart';
import '../../common/toast.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController headingController = TextEditingController();
  List<Map<String, dynamic>> teamMembers = [];

  void showCustomError(String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.redAccent,
    action: SnackBarAction(
      label: 'Dismiss',
      onPressed: () {
        // Some code to undo the change if needed.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

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
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
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
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          handleValidTaskSubmission(
            context,
            username,
            headingController.text,
            descController.text,
            teamMembers,
          );
        } else 
        {
          showCustomError("Please fill in all required fields.");
        }
      },
      child: const Text('Create Task', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
    ),
  );
}
}

Future<void> handleValidTaskSubmission(BuildContext context, String username, String heading, String desc, List<Map<String, dynamic>> teamMembers)async{
   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Form is valid and processing data'),duration: Duration(seconds: 2),));
    List<String> collaborators= [];
  for (Map<String, dynamic> item in teamMembers) {
    if (item.containsKey('name')) {
      collaborators.add(item['name'] as String);
    } else {
      print("TEAM-MEMBERS missing 'name' key: $item");
    }
  }
  await addTask(username, heading, desc, collaborators);
  showmsg(message: "Task has been added successfully!");
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(username: username),
    ));
}

