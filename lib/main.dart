import 'package:flutter/material.dart';
import 'package:flutter_application_3/socket_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool conectado = false;
  String host = 'localhost';
  String port = '3000';

  SocketClient socket = SocketClient();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setListener();
  }

  void setListener() {
    socket.streamSocket.getConnectionState.listen((state) {
      setState(() {
        conectado = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (value) => setState(() {
                  host = value;
                }),
              ),
              TextField(
                onChanged: (value) => setState(() {
                  port = value;
                }),
              ),
              Text(
                '$host:$port',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  socket.connectAndListen(host, port);
                },
                child: Text('Connect'),
              ),
              Text(
                'Conectado: $conectado',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
