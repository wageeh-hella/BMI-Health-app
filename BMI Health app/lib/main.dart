import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          darkMode ? ThemeData.dark() : ThemeData(primarySwatch: Colors.green),
      home: HomePage(
        toggleTheme: () {
          setState(() {
            darkMode = !darkMode;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;

  HomePage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Health App'),
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Icon(Icons.health_and_safety, size: 90, color: Colors.green),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Health Dashboard',
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(height: 30),
          buildBtn(context, 'Calculate BMI', BmiInputPage()),
          buildBtn(context, 'BMI History', HistoryPage()),
          buildBtn(context, 'BMI Information', InfoPage()),
          buildBtn(context, 'Health Tips', TipsPage()),
          buildBtn(context, 'Settings', SettingsPage()),
        ],
      ),
    );
  }

  Widget buildBtn(BuildContext context, String title, Widget page) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Text(title),
      ),
    );
  }
}

class BmiInputPage extends StatefulWidget {
  @override
  _BmiInputPageState createState() => _BmiInputPageState();
}

class _BmiInputPageState extends State<BmiInputPage> {
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();

  static List<String> history = [];

  void calculate(BuildContext context) {
    double h = double.tryParse(height.text) ?? 0;
    double w = double.tryParse(weight.text) ?? 0;

    if (h > 0 && w > 0) {
      double bmi = w / ((h / 100) * (h / 100));
      String status;

      if (bmi < 18.5) {
        status = 'Underweight';
      } else if (bmi < 25) {
        status = 'Normal';
      } else if (bmi < 30) {
        status = 'Overweight';
      } else {
        status = 'Obese';
      }

      history.add('BMI: ${bmi.toStringAsFixed(2)} - $status');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(bmi: bmi, status: status),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid values')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI Calculator')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: height,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: weight,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => calculate(context),
              child: Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final double bmi;
  final String status;

  ResultPage({required this.bmi, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = status == 'Normal' ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(title: Text('Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your BMI', style: TextStyle(fontSize: 22)),
            SizedBox(height: 10),
            Text(
              bmi.toStringAsFixed(2),
              style: TextStyle(fontSize: 40, color: color),
            ),
            SizedBox(height: 10),
            Text(
              status,
              style: TextStyle(fontSize: 20, color: color),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Back Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI History')),
      body: ListView.builder(
        itemCount: _BmiInputPageState.history.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.history),
            title: Text(_BmiInputPageState.history[i]),
          );
        },
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI Information')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'BMI is a health indicator based on height and weight.\n\n'
          'Underweight < 18.5\n'
          'Normal 18.5 – 24.9\n'
          'Overweight 25 – 29.9\n'
          'Obese 30+',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class TipsPage extends StatelessWidget {
  final List<String> tips = [
    'Drink enough water daily',
    'Exercise at least 30 minutes',
    'Eat fruits and vegetables',
    'Avoid junk food',
    'Get enough sleep',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Health Tips')),
      body: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.check),
            title: Text(tips[i]),
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: notifications,
            onChanged: (val) {
              setState(() {
                notifications = val;
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('App Version 1.0'),
          ),
        ],
      ),
    );
  }
}
