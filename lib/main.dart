import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:waste/firebase_options.dart';
import 'package:waste/services/authService.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: AuthService().currentUser == null? const MyHomePage() : const Home(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool register = true;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               register? const LoginForm() : const RegisterForm(),
                const SizedBox(height: 10,),
                register? const Text("Don't have an account?") : const Text("Already have an account?"),
                TextButton(
                onPressed: () {
                  if(register == true){
                    setState(() {
                      register = false;
                    });
                  } else {
                    setState(() {
                      register = true;
                    });
                  }
                },
                child: register? const  Text('Register') : const Text('Login'),
              ),

              ],
              
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const  Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Login',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address.';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _email = value!;
              });
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true, // Hides the password characters
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password.';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _password = value!;
              });
            },
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Handle forgot password functionality
                  print('Forgot password clicked');
                },
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
         
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton.filled(child: const Text('Login'), onPressed: () async{
              showDialog(context: context, builder: (context){
                return Center(child: CircularProgressIndicator(),);
              });
               if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if(await AuthService().login( _email, _password)){
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Home()));
                    }  else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login Failed, Wrong credentials!'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                    
                  }
            }),
          ],
        )
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:  EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Register',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name.';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _name = value!;
              });
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration:const  InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address.';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _email = value!;
              });
            },
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true, // Hides the password characters
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password.';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _password = value!;
              });
            },
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton.filled(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Implement registration logic using _name, _email, and _password
                     if(await AuthService().register(_name, _email, _password)){}
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Home()));
                    print('Name: $_name, Email: $_email, Password: $_password');
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Home()));
                    }  else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login Failed, Wrong credentials!'),
                        duration: Duration(seconds: 3),
                      ),
                    );  
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initState() {
    super.initState();
    // Initialize the plugin (move this to a suitable place in your app)
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (res) {});
  }

  void setReminder(BuildContext context) async {
  const androidNotificationDetails = AndroidNotificationDetails(
      'channel id', 'channel name',
      importance: Importance.max, priority: Priority.high);
  const notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      0, // notification ID (unique for each notification)
      'Reminder: Next Pickup',
      'Your next pickup is scheduled for Tuesday, May 07, 2024 at 8:00 AM.',
      notificationDetails);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Reminder set for your next pickup!'),
      duration: Duration(seconds: 3),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading:  Theme(
          data: ThemeData(iconTheme: IconThemeData(color: Colors.white)),
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text('Waste Management App', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width* 0.7,
          backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(AuthService().currentUser!=null? AuthService().currentUser!.displayName!: 'UserName'),
              accountEmail: Text(AuthService().currentUser!=null? AuthService().currentUser!.email!: 'UserName'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.purple,
                child: Text('JD', style: TextStyle(color: Colors.white)),
              ),
            ),
           
           ListTile(
              title: Text('Schedule Pickup'),
              leading: Icon(Icons.calendar_today),
              onTap: () async {
                // Show date picker dialog
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(), // Disable picking past dates (optional)
                  lastDate: DateTime.now().add(Duration(days: 30)), // Limit selection to 30 days from now (optional)
                );

                if (selectedDate != null) {
                  // Handle successful date selection
                  // Show confirmation dialog (optional)
                  final confirmed = await showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(selectedDate: selectedDate),
                  );

                  if (confirmed ?? false) {
                    // Send schedule data to Firestore (replace with your implementation)
                   final userId = AuthService().currentUser?.uid;
                  final docRef = FirebaseFirestore.instance.collection('schedulePickup').doc(userId);
                  
                  // Check if the document exists
                  final docSnapshot = await docRef.get();
                  if (docSnapshot.exists) {
                    // If the document exists, delete it
                    await docRef.delete();
                  }
                  
                  // Add the document with updated data
                  await docRef.set({
                    'date': selectedDate.toIso8601String(),
                    'userId': userId,
                  });

                    // Show success message (optional)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Pickup scheduled for ${selectedDate.toIso8601String()}'),
                      ),
                    );
                  }
                }
              },
            ),


            Spacer(),
             ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.logout_outlined),
              onTap: () {
                 AuthService().signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const MyHomePage()));
              },  
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),

        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Upcoming Pickup Section
             Card(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('schedulePickup')
          .doc(AuthService().currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text('Error fetching schedule data');
        }

        final pickupData = snapshot.data?.data() as Map<String, dynamic>?;

        final pickupDate = pickupData != null && pickupData.containsKey('date')
            ? DateTime.parse(pickupData['date'] as String)
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Next Pickup:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 10.0),
                pickupDate != null
                    ? Text(formattedDate(pickupDate))
                    : Text('No schedule as of yet'),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.alarm),
                SizedBox(width: 10.0),
                pickupDate != null ? Text(formattedTime(pickupDate)) : Text(''),
              ],
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Handle "Set Reminder" button press (optional)
                setReminder(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reminder set for your next pickup!'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child: Text('Set Reminder'),
            ),
          ],
        );
      },
    ),
  ),
),


              SizedBox(height: 20.0),

              // Waste Sorting Guide Section (Grid of buttons)
              Text(
                'What to Throw Where?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  _WasteCategoryButton(text: 'Recycle', icon: Icons.recycling, onpressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecycleInfoScreen()),
                  );
                  },),
                  _WasteCategoryButton(text: 'Compost', icon: Icons.nature, onpressed: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompostInfoScreen()),
                    );
                    }),
                  _WasteCategoryButton(text: 'Trash', icon: Icons.delete, onpressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrashInfoScreen()),
                  );
                  }),
                  _WasteCategoryButton(text: 'E-waste', icon: Icons.electrical_services, onpressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EWasteInfoScreen()),
                  );

                  }),
                  _WasteCategoryButton(text: 'Hazardous', icon: Icons.warning, onpressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HazardousWasteInfoScreen()),
                    );
                  }),
                ],
              ),
              SizedBox(height: 20.0),

              // Report an Issue Section
              Text(
                'Report an Issue',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              ElevatedButton.icon(
                onPressed: () async {
                    // Open a dialog to collect report details
                    final reportDetails = await showDialog<String>(
                      context: context,
                      builder: (context) => ReportIssueDialog(),
                    );

                    if (reportDetails != null) {
                      // Handle successful report submission with details (replace with your implementation)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Issue reported: $reportDetails'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                },
                icon: Icon(Icons.report),
                label: Text('Missed Pickup or Overflowing Bin'),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}

String formattedTime(DateTime? dateTime) {
  // Use intl package for formatting (assuming you have it installed)
  final formatter = DateFormat('h:mm a'); // Example format: 8:00 AM
  return dateTime != null? formatter.format(dateTime): 'No Schedule yet';
}


String formattedDate(DateTime? date) {
  // Use intl package for formatting (assuming you have it installed)
  final formatter = DateFormat('EEEE, MMMM d, y'); // Example format: Tuesday, May 07, 2024
  return date != null?  formatter.format(date): '';
}


class ConfirmationDialog extends StatelessWidget {
  final DateTime selectedDate;

  const ConfirmationDialog({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Pickup'),
      content: Text('Schedule pickup for ${selectedDate.toIso8601String()}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Confirm'),
        ),
      ],
    );
  }
}


class _WasteCategoryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()  onpressed;

  const _WasteCategoryButton({required this.text, required this.icon, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed:onpressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(120.0, 50.0),
      ),
    );
  }
}

class ReportIssueDialog extends StatefulWidget {
  @override
  _ReportIssueDialogState createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends State<ReportIssueDialog> {
  final _formKey = GlobalKey<FormState>();
  String _reportDetails = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report an Issue'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some details about the issue.';
            }
            return null;
          },
          decoration: InputDecoration(hintText: 'Describe the missed pickup or overflowing bin'),
          onChanged: (value) => setState(() => _reportDetails = value),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Submit report details (replace with your implementation)
              Navigator.pop(context, _reportDetails);
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}


class HazardousWasteInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Hazardous Waste', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What is considered hazardous waste?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              const Text(
                'Hazardous waste poses a potential threat to human health and the environment. Here are some common examples:',
              ),
              SizedBox(height: 10.0),
              _buildHazardousWasteList(), // Call the function to build the list
              SizedBox(height: 10.0),
              const Text(
                '**Important:** Improper disposal of hazardous waste can be harmful.  **Always check with your local authorities for approved disposal locations.**',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              const Text(
                '**Effects of hazardous waste:**',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Improper disposal of hazardous waste can lead to:',
              ),
              SizedBox(height: 5.0),
              const Text(
                '- Contamination of soil and water',
              ),
              SizedBox(height: 5.0),
              const Text(
                '- Health problems in humans and animals',
              ),
              SizedBox(height: 5.0),
              const Text(
                '- Environmental damage',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildHazardousWasteList() {
  // Define a list of hazardous waste items
  final hazardousWasteItems = [
    'Paint and paint thinners',
    'Batteries',
    'Household cleaners',
    'Herbicides and pesticides',
    'Fluorescent bulbs and tubes',
    'Motor oil and antifreeze',
  ];

  // Build the list view
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(), // Disable list scrolling
    itemCount: hazardousWasteItems.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: Icon(Icons.warning, color: Colors.red),
        title: Text(hazardousWasteItems[index]),
      );
    },
  );
}


class EWasteInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('E-waste', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What is considered E-waste?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              const Text(
                'E-waste refers to electronic devices nearing the end of their useful life. Here are some common examples:',
              ),
              SizedBox(height: 10.0),
              _buildEWasteList(), // Call the function to build the list
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildEWasteList() {
  // Define a list of E-waste items
  final eWasteItems = [
    'Computers (laptops, desktops, monitors)',
    'Mobile phones and chargers',
    'Televisions',
    'Printers and ink cartridges',
    'Small appliances (toasters, microwaves)',
    'Large appliances (refrigerators, washing machines)',
  ];

  // Build the list view
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(), // Disable list scrolling
    itemCount: eWasteItems.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: Icon(Icons.electrical_services),
        title: Text(eWasteItems[index]),
      );
    },
  );
}


class TrashInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Trash', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What goes in the trash?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              const Text(
                'Here are some general items that typically belong in the trash:',
              ),
              SizedBox(height: 10.0),
              _buildTrashList(), // Call the function to build the list
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTrashList() {
  // Define a list of trash items
  final trashItems = [
    'Plastic bags and wrappers (not all plastics are recyclable, check locally)',
    'Food-soiled paper (pizza boxes, tissues)',
    'Hygiene products',
    'Metal lids and foil (unless heavily greasy)',
    'Ceramics and glass (broken or non-recyclable types)',
    'Chemicals and hazardous waste (dispose of responsibly)',
  ];

  // Build the list view
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(), // Disable list scrolling
    itemCount: trashItems.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: Icon(Icons.delete),
        title: Text(trashItems[index]),
      );
    },
  );
}


class RecycleInfoScreen extends StatefulWidget {
  const RecycleInfoScreen({super.key});

  @override
  State<RecycleInfoScreen> createState() => _RecycleInfoScreenState();
}

class _RecycleInfoScreenState extends State<RecycleInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Recyclables', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What can be recycled?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              const Text(
                'Most household items with the recycling symbol can be recycled. Here are some common examples:',
              ),
              SizedBox(height: 10.0),
              _buildRecyclableList(), // Call the function to build the list
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecyclableList() {
    // Define a list of recyclable items
    final recyclableItems = [
      'Plastic bottles and containers (check for local recycling guidelines)',
      'Metal cans (aluminum, steel)',
      'Glass bottles and jars',
      'Paperboard (cereal boxes, cardboard boxes)',
      'Newspaper and magazines',
      'Cardboard (flatten before recycling)',
    ];

    // Build the list view
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Disable list scrolling
      itemCount: recyclableItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.recycling),
          title: Text(recyclableItems[index]),
        );
      },
    );
  }
}

class CompostInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Compost', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What can be composted?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              const Text(
                'Composting helps reduce waste and create nutrient-rich soil. Here are some common compostable items:',
              ),
              SizedBox(height: 10.0),
              _buildCompostableList(), // Call the function to build the list
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildCompostableList() {
  // Define a list of compostable items
  final compostableItems = [
    'Food scraps (fruits, vegetables, coffee grounds, eggshells)',
    'Yard waste (leaves, grass clippings, small twigs)',
    'Tea bags and coffee filters (unbleached only)',
    'Newspaper and cardboard (shredded)',
  ];

  // Build the list view
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(), // Disable list scrolling
    itemCount: compostableItems.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: Icon(Icons.nature),
        title: Text(compostableItems[index]),
      );
    },
  );
}
