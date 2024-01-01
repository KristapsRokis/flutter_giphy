import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';



class GiphyPage extends StatefulWidget {
  @override
  _GiphyPageState createState() => _GiphyPageState();
}

class _GiphyPageState extends State<GiphyPage> {

  final TextEditingController controller = TextEditingController();
  final String apiKey = "9nzoMoOQTIawG5HhLqzXTbnpkYEbarLr";
  final String baseUrl = "https://api.giphy.com/v1/gifs/search";
  bool showLoading = false;
  bool showError = false;
  String errorMesage = "";
  List<dynamic>? data;
  int offset = 0;

  late ScrollController _scrollController;
  Timer? _debounce;


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !showLoading) {
      _loadMore();
    }
  }

  void _loadMore() {
    _getData(controller.text, loadMore: true);
  }

  void _getData(String searchInput, {bool loadMore = false}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!loadMore) {
        offset = 0;
        showLoading = true;
        showError = false;
        setState(() {
          data = null;
        });
      }

      try {
        final Uri uri = Uri.parse(baseUrl).replace(
          queryParameters: {
            "api_key": apiKey,
            "limit": "30",
            "offset": offset.toString(),
            "rating": "G",
            "lang": "en",
            "q": searchInput,
          },
        );

        final res = await Dio().get(uri.toString());
        final responseData = res.data["data"] as List<dynamic>;

        setState(() {
          if (loadMore) {
            data?.addAll(responseData);
          } else {
            data = responseData;
          }

          offset = (res.data["pagination"]["offset"] + res.data["pagination"]["count"]).toInt();

          showLoading = false;
          showError = false;
        });
      } catch (e) {
        print("Error fetching data: $e");

        setState(() {
          showLoading = false;
          showError = true;
          errorMesage = "Error fetching data. Please try again.";
        });
      }
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Theme(
            data: ThemeData.dark(),
            child: Column(
              children: [
                "Giphy".text.white.xl4.make().objectCenter(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('searchTextField'),
                        controller: controller,
                        onChanged: (value) => _getData(value),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelText: "Search gifs",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    30.widthBox,
                    ElevatedButton(
                      key: const Key('go'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        _getData(controller.text);
                      },
                      child: const Text(
                        "Go",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ).h8(context)
                  ],
                ).p8(),

                if (showLoading)
                  const CircularProgressIndicator(key: Key('loading')).centered()
                else if (showError)
                  errorMesage.text.red400.xl.makeCentered()
                else
                  VxConditional(
                    condition: data != null,
                    builder: (context) => Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                        ),
                        itemBuilder: (context, index) {
                          final url = data![index]["images"]["fixed_height"]["url"].toString();
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailView(url: url),
                                ),
                              );
                            },
                            child: Card(
                              child: Container(
                                color: Colors.black.withOpacity(0.8),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: data!.length,
                      ),
                    ),
                    fallback: (context) => "Nothing found".text.gray400.xl3.makeCentered(),
                  ).h(context.percentHeight * 81),
              ],
            ).p16(),
          );
        },
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  final String url;

  const DetailView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: Center(
        child: Image.network(
          url,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
