import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Table and web-socket test'),
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

  Widget textInput() {
    return TextField(
      textAlign: TextAlign.center,
    );
  }

  final channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );
  final _controller = TextEditingController();

  TableRow _row() {
    return TableRow(
      children: [
        textInput(),
        textInput(),
        textInput(),
      ]
    );
  }

  @override
  void initState() {
    super.initState();

  }

  BorderSide border() {
    return const BorderSide(
      color: Colors.black,
      width: 3
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: channel.stream,
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.hasData ? snapshot.data.toString() : 'no data',
                        );

                      }
                    ),
                    TextField(
                      controller: _controller,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        if (_controller.text.isNotEmpty) {
                          channel.sink.add(_controller.text);
                        }
                      },
                      child: Text(
                        'Send',
                      ),
                    )
                    
                  ],
                ),
              ),
              Table(

                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.black,
                    width: 3,
                  ),
                  right: border(),
                  bottom: border(),
                  top: border(),
                  left: border(),
                  verticalInside: const BorderSide(
                    color: Colors.black,
                    width: 3
                  )
                ),
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                children: [
                  _row(),
                  _row(),
                  _row(),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
