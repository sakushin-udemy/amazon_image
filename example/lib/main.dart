import 'dart:async';

import 'package:amazon_image/amazon_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'nn_intl.dart';

const asin = 'B003O2SHKG';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        NnMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('nn'),
      ],
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int countTap = 0;
  int countLongTap = 0;

  String _asin = asin;
  late TextEditingController controller;

  AmazonImage _amazonImage = AmazonImage(asin);

  Completer<AmazonImage> _prechaceCompleter = Completer();

  @override
  void initState() {
    super.initState();

    controller = new TextEditingController(text: _asin);
  }

  @override
  void didUpdateWidget(Home oldWidget) {
    super.didUpdateWidget(oldWidget);

    final AmazonImage preacache = AmazonImage(
      asin,
      context: context,
      prechache: true,
    );

    preacache.future!
        .whenComplete(() => _prechaceCompleter.complete(preacache));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('amazon_image example app'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text('double tap: launch, imageSize:middle (default)'),
              ),
              AmazonImage(
                asin,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child:
                    Text('double tap: not launch, single and long tap: launch'),
              ),
              AmazonImage(
                asin,
                isLaunchAfterTap: true,
                isLaunchAfterDoubleTap: false,
                isLaunchAfterLongTap: true,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text('tap event'),
              ),
              AmazonImage(
                asin,
                onTap: () {
                  setState(() {
                    countTap++;
                  });
                },
                onLongTap: () {
                  setState(() {
                    countLongTap++;
                  });
                },
              ),
              Text('tap: $countTap, long tap: $countLongTap'),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text('event before launch'),
              ),
              AmazonImage(
                asin,
                context: context,
                functionBeforeLaunch: (BuildContext context) async {
                  var result = await askUser();
                  return Future.value(result);
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text('event after launch'),
              ),
              AmazonImage(
                asin,
                functionAfterLaunch: () {
                  print('did functionAfterLaunch');
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text('imageSize: small'),
              ),
              AmazonImage(
                asin,
                imageSize: ImageSize.Small,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text('imageSize: middle(defult)'),
              ),
              AmazonImage(
                asin,
                imageSize: ImageSize.Middle,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text('imageSize: large'),
              ),
              AmazonImage(
                asin,
                imageSize: ImageSize.Large,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text('precacheImage'),
              ),
              FutureBuilder<AmazonImage>(
                  future: _prechaceCompleter.future,
                  builder: (BuildContext context,
                      AsyncSnapshot<AmazonImage> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    }
                    return CircularProgressIndicator();
                  }),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text('loadImage'),
              ),
              Row(
                children: [
                  Text(
                    'input asin:',
                  ),
                  Expanded(
                    child: TextField(
                      enabled: true,
                      maxLength: asin.length,
                      style: TextStyle(color: Colors.black),
                      obscureText: false,
                      maxLines: 1,
                      controller: controller,
                      onChanged: (value) => setState(() {
                        _asin = value;
                      }),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _amazonImage = AmazonImage(_asin);
                      });
                    },
                    child: const Text('display amazon_image'),
                  ),
                ],
              ),
              _amazonImage
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> askUser() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Would you like to launch the url?'),
          children: [
            SimpleDialogOption(
              child: const Text('Yes!'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            SimpleDialogOption(
              child: const Text('NO'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
