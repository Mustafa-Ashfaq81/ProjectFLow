// ignore_for_file: avoid_print, prefer_const_constructors, empty_constructor_bodies

import 'package:flutter/material.dart';

/*

This file contains the implementation of the SearchTasks class.  This class is responsible for handling user's search
and has been used on the notes page as well as the home page
SearchDelegate for searching through a list of task headings
Allows users to quickly find tasks by typing queries which are matched against task titles

*/

class SearchTasks extends SearchDelegate<String> {
  final String username;
  final List<String> headings;

  SearchTasks({required this.username, required this.headings}) {
    print("username $username headings $headings");
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

  SearchUsers({required this.username, required this.users}) {}

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
