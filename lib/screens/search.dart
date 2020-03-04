import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/block/movie_bloc/movie_bloc.dart';
import 'package:movieapp/block/movie_bloc/movie_event.dart';
import 'package:movieapp/block/movie_bloc/movie_state.dart';
import 'package:movieapp/block/search_block/search_bloc.dart';
import 'package:movieapp/block/search_block/search_event.dart';
import 'package:movieapp/block/search_block/search_state.dart';
import 'package:movieapp/data/model/api_result_model.dart';
import 'package:movieapp/data/repositoties/movie_repositories.dart';
import 'package:movieapp/screens/home.dart';
import 'package:movieapp/screens/network.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textEditingController;
  bool filter = false;
  FocusNode focusNode;
  SearchMovieBloc searchMovieBloc;
  List<Results> moviesList = [];
  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          focusNode.unfocus();
        },
        child: Column(
          children: <Widget>[
            searchBox(),
            Expanded(
              child: BlocBuilder<SearchMovieBloc, SearchMovieState>(
                  builder: (context, state) {
                if (state is SearchMovieInitialState) {
                  return Text("Search");
                } else if (state is SearchMovieLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchMovieLoadedState) {
                  return Home(state.movies);
                } else if (state is SearchMovieErrorState) {
                  return NetworkError();
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      height: 130,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 16, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 33,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF222222),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: TextFormField(
                    controller: textEditingController,
                    autofocus: true,
                    focusNode: focusNode,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) {
                      setState(() {
                        searchMovieBloc =
                            BlocProvider.of<SearchMovieBloc>(context);
                        searchMovieBloc.add(FetchMovieBySearchEvent(
                            query: textEditingController.text));
                        print("done");
                      });
                    },
                    cursorColor: Color(0xFFdddddd),
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins-Regular",
                        color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search.. ",
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white54,
                        fontFamily: "Poppins-Regular",
                      ),
                      suffixIcon: InkWell(
                        child: Icon(
                          Icons.close,
                          size: 23,
                          color: Color(0xFF888888),
                        ),
                        onTap: () {
                          setState(() {
                            textEditingController.clear();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // IconButton(
            //   splashColor: Colors.transparent,
            //   onPressed: () {
            //     setState(() {
            //       filter = !filter;
            //     });
            //   },
            //   icon: Icon(
            //     Icons.filter_list,
            //     size: 33,
            //     color: Colors.white,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
