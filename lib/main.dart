import 'package:flutter/material.dart';
import 'package:traffic_lights/trafficlightstate.dart';
import 'package:flutter/services.dart';

final imageMap = {
  Color.green: Image.asset('assets/images/green.jpg'),
  Color.red: Image.asset('assets/images/red.jpg'),
  Color.yellow: Image.asset('assets/images/yellow.jpg'),
};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Lights',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Traffic Lights'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _gameState = TrafficLightState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        //center everything inside it
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 80.0,
              minHeight: 120.0
            ),
            child: AspectRatio(
              aspectRatio: 5 / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    // sized to fill available horizontal/vertical space
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Stack(children: [
                        Image.asset('assets/images/grid.jpg'),
                        GridView.builder(
                          itemCount: TrafficLightState.numCells,
                          gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: TrafficLightState.width),
                          itemBuilder: (context, index) {
                            return TextButton(
                              onPressed: () => _processPress(index),
                              child: imageMap[_gameState.board[index]] ??
                                Container(),
                            );
                          })
                        ]
                      )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              _gameState.getStatus(),
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _resetGame,
                          child: const Text(
                            'Reset',
                            style: TextStyle(fontSize: 32),
                          ),
                        )
                      ]),
                    )
                ],
              ),
            ),
        )));
  }

  void _processPress(int index) {
    setState(() {
      _gameState.playAt(index);
    });
  }

  void _resetGame() {
    setState(() {
      _gameState.reset();
    });
  }
}
