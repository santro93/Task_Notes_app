import 'package:flutter/material.dart';


class PagginationOnListView extends StatefulWidget {
  const PagginationOnListView({Key? key}) : super(key: key);

  @override
  State<PagginationOnListView> createState() => _PagginationOnListViewState();
}

class _PagginationOnListViewState extends State<PagginationOnListView> {
  final ScrollController _scrollController = new ScrollController();
  List<String> item = [];
  bool loading = false;
  bool allLoaded = false;

  mockFetch() async {
    if (allLoaded == true) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));

    List<String> newData = item.length > 60
        ? []
        : List.generate(19, (index) => "List item ${index + item.length}");

    if (newData.isNotEmpty) {
      item.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        print("NewData Called");
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finite Scrolling"),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (item.isNotEmpty) {
          return Stack(
            children: [
              ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index < item.length) {
                      return ListTile(
                        title: Text(item[index]),
                      );
                    } else {
                      return Container(
                        width: constraints.maxWidth,
                        height: 50,
                        child: const Center(
                          child: Text("No more data to load"),
                        ),
                      );
                    }
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                    );
                  },
                  itemCount: item.length + (allLoaded ? 1 : 0)),
              if (loading) ...[
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: constraints.maxWidth,
                    height: 80,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              ]
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
