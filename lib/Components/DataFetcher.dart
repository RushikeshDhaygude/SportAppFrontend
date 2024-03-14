import 'package:flutter/material.dart';

class DataFetcher<T> extends StatelessWidget {
  final Future<List<T>> Function() fetchData;
  final Widget Function(BuildContext context, List<T> data) builder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, dynamic error)? errorBuilder;

  const DataFetcher({
    required this.fetchData,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder != null
              ? loadingBuilder!(context)
              : _defaultLoadingBuilder(context);
        } else if (snapshot.hasError) {
          return errorBuilder != null
              ? errorBuilder!(context, snapshot.error)
              : _defaultErrorBuilder(context, snapshot.error);
        } else {
          return builder(context, snapshot.data!);
        }
      },
    );
  }

  Widget _defaultLoadingBuilder(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _defaultErrorBuilder(BuildContext context, dynamic error) {
    return Center(
      child: Text(
        'Error occurred: $error',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class Organization {
  final String name;

  Organization(this.name);
}

class SampleData {
  static List<Organization> organizations = [
    Organization('Elevate'),
    Organization('Pentacle'),
    Organization('Summit'),
    Organization('Zest'),
  ];
}

class SampleOrganizationListView extends StatelessWidget {
  final List<Organization> organizations;

  SampleOrganizationListView(this.organizations);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: organizations.length,
      itemBuilder: (context, index) {
        final organization = organizations[index];
        return ListTile(
          title: Text(organization.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Add edit functionality here
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Add delete functionality here
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Organization List'),
        ),
        body: DataFetcher<Organization>(
          fetchData: () => Future.value(SampleData.organizations),
          builder: (context, data) => SampleOrganizationListView(data),
        ),
      ),
    ),
  );
}
