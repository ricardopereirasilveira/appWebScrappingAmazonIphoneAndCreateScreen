import 'package:amazon_webscrapping/article.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Scrapping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Web Scrapping'),
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
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();

    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse('https://www.amazon.com/s?k=iphone');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll(" h2 > a > span")
        .map((e) => e.innerHtml.trim())
        .toList();

    final urls = html
        .querySelectorAll("h2 > a")
        .map((e) => "http://amazon.com/${e.attributes['href']}")
        .toList();

    final urlImages = html
        .querySelectorAll("span > a > div > img")
        .map((e) => '${e.attributes["src"]}')
        .toList();

    print("Count: ${titles.length}");

    setState(() {
      articles = List.generate(
        titles.length,
        (index) => Article(
          title: titles[index],
          url: urls[index],
          urlImage: urlImages[index],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];

          return ListTile(
            leading: Image.network(
              article.urlImage,
              width: 50,
              fit: BoxFit.fitHeight,
            ),
            title: Text(article.title),
            subtitle: Text(article.url),
          );
        },
      ),
    );
  }
}
