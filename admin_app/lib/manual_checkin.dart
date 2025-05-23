import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auto_checkin.dart';

Future<String?> getUserWorkMode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('workMode'); // returns null if not found
}

class MyCheckin extends StatefulWidget {
  const MyCheckin({super.key});

  @override
  _MyCheckinState createState() => _MyCheckinState();
}

class _MyCheckinState extends State<MyCheckin> {
  bool isWorkFromHome = false;
  String? workMode;

  @override
  void initState() {
    super.initState();
    loadUserWorkMode(); // <-- call here
  }

  Future<void> loadUserWorkMode() async {
    workMode = await getUserWorkMode();
    setState(() {
      isWorkFromHome = workMode == 'WFH';
    });
  }

  TimeOfDay _enterTime = const TimeOfDay(hour: 8, minute: 00);
  TimeOfDay _exitTime = const TimeOfDay(hour: 10, minute: 30);
  int _selectedIndex = 1; // Set default index to 1 for the "Manual" page
  void _showEntryTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _enterTime = value!;
      });
    });
  }

  void _showExitTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _exitTime = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color(0xFF6962AD),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: const Color(0xFF6962AD),
            color: const Color(0xFF000000),
            activeColor: const Color(0xFF000000),
            tabBackgroundColor: const Color(0xFF83C0C1),
            gap: 45,
            padding: const EdgeInsets.all(16),
            selectedIndex: _selectedIndex, // Use the current active index
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'HOME',
              ),
              GButton(
                icon: Icons.watch_later,
                text: 'Manual',
              ),
              GButton(
                icon: Icons.history,
                text: 'History',
              ),
              GButton(
                icon: Icons.arrow_back_ios_new_rounded,
                text: 'Log Out',
              ),
            ],
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index; // Update index on tab change
              });

              if (index == 0) {
                Navigator.pushNamed(context, 'map');
              } else if (index == 1) {
                Navigator.pushNamed(context, 'checkin');
              } else if (index == 2) {
                Navigator.pushNamed(context, 'history');
              } else if (index == 3) {
                Navigator.pushNamed(context, 'login');
              }
            },
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: LocationListenerWidget()), // Use it inside layout
              if (!isWorkFromHome)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Tooltip(
                    message:
                        'Manual check-in is disabled for Work From Office employees.',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Manual check-in not allowed',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF96E9C6),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _enterTime.format(context),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F4F4F),
                        fontFamily: 'QuickSandBold',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isWorkFromHome ? _showEntryTimePicker : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isWorkFromHome
                            ? const Color(0xFF6962AD)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: Text(
                        'Set Check-in Time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isWorkFromHome
                              ? Color(0xFF96E9C6)
                              : Colors.black26,
                          fontFamily: 'QuickSandBold',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF96E9C6),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _exitTime.format(context),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F4F4F),
                        fontFamily: 'QuickSandBold',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isWorkFromHome ? _showExitTimePicker : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isWorkFromHome
                            ? const Color(0xFF6962AD)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: Text(
                        'Set Check-out Time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isWorkFromHome
                              ? Color(0xFF96E9C6)
                              : Colors.black26,
                          fontFamily: 'QuickSandBold',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
