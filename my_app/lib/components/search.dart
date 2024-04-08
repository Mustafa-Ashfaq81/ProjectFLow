// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class SearchTasks extends SearchDelegate<String> {
  final String username;
  final List<String> headings;

  SearchTasks({required this.username, required this.headings}) {
    // print("headings $headings username $username");
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: Color(0xff000000), 
            ),
          ),
        );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> res = [];
    for (var title in headings) {
      if (title.toLowerCase().contains(query.toLowerCase())) {
        res.add(title);
      }
    }
    if (res.isNotEmpty == true) {
      return ListView.builder(
          itemCount: res.length,
          itemBuilder: (context, index) {
            var result = res[index];
             return ListTile(
            title: Text(result),
            onTap: () {
              close(context, result);
            },
          );
          });
    } else {
      return const Center(
        child: Text('No search results found for your query'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> res = [];
    for (var title in headings) {
      if (title.toLowerCase().contains(query.toLowerCase())) {
        res.add(title);
      }
    }

    if (res.isNotEmpty == true) {
      return ListView.builder(
          itemCount: res.length,
          itemBuilder: (context, index) {
            var result = res[index];
             return ListTile(
            title: Text(result),
            onTap: () {
              close(context, result);
            },
          );
          });
    } else {
      return const Center(
        child: Text('No search results found for your query'),
      );
    }
  }
}

class SearchUsers extends SearchDelegate<String> {
  final String username;
  final List<String> users;

  SearchUsers({required this.username, required this.users}) {
    // print("username $username other-users $users");
  }

  // APP Bar styling below according to our color scheme

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: Color(0xff000000), 
            ),
          ),
        );
  }


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> res = [];
    for (var user in users) {
      if (user.toLowerCase().contains(query.toLowerCase())) {
        res.add(user);
      }
    }
    if (res.isNotEmpty) {
      return ListView.builder(
        itemCount: res.length,
        itemBuilder: (context, index) {
          var result = res[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              close(context, result);
            },
          );
        },
      );
    } else {
      return const Center(
        child: Text('No search results found for your query'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> res = [];
    for (var user in users) {
      if (user.toLowerCase().contains(query.toLowerCase())) {
        res.add(user);
      }
    }

    if (res.isNotEmpty == true) {
      return ListView.builder(
        itemCount: res.length,
        itemBuilder: (context, index) {
          var result = res[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              close(context, result);
            },
          );
        },
      );
    } else {
      return const Center(
        child: Text('No search results found for your query'),
      );
    }
  }
}
