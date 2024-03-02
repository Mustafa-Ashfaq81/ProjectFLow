import 'package:flutter/material.dart';

class SearchTasks extends SearchDelegate {
  final String username;
  final List<String> headings;

  SearchTasks({required this.username, required this.headings}) {
    print("headings $headings username $username");
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Color(0xff000000), // Adjust text color if needed
            ),
          ),
        );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // print("build-acts");
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
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // print("build-res");
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
            return ListTile(title: Text(result));
          });
    } else {
      return Center(
        child: Text('No search results found for your query'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // print("build-sugg");
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
            return ListTile(title: Text(result));
          });
    } else {
      return Center(
        child: Text('No search results found for your query'),
      );
    }
  }
}

class SearchUsers extends SearchDelegate<String> {
  final String username;
  final List<String> users;

  SearchUsers({required this.username, required this.users}) {
    print("username $username other-users $users");
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Color(0xff000000), // Adjust text color if needed
            ),
          ),
        );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // print("build-acts");
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
    // print("build-results");
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
      return Center(
        child: Text('No search results found for your query'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // print("build-sugg");
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
      return Center(
        child: Text('No search results found for your query'),
      );
    }
  }
}
