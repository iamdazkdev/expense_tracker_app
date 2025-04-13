import 'package:daily_expense_tracker_app/core/models/categories/category_model.dart';
import 'package:daily_expense_tracker_app/features/categories/view/widgets/category_form.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late DbFirestoreClientBase _dbFirestoreClient;

  Future<List<CategoryModel>> loadData() async {
    try {
      final result = await _dbFirestoreClient.getQueryOrderBy(
        collectionPath: "categories",
        mapper: (data, documentId) => CategoryModel.fromJson(data!),
        orderByField: "name",
      );
      return result;
    } catch (err) {
      throw Exception('Failed to load categories: $err');
    }
  }

  @override
  void initState() {
    super.initState();
    _dbFirestoreClient = DbFirestoreClient();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản lý danh mục",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            // Trigger re-fetching of categories
          });
        },
        child: FutureBuilder<List<CategoryModel>>(
          future: loadData(), // Call loadData() to fetch categories
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No categories available'),
              );
            } else {
              List<CategoryModel> categories = snapshot.data!;
              return ListView.separated(
                itemCount: categories.length,
                itemBuilder: (builder, index) {
                  CategoryModel category = categories[index];
                  return ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (builder) => CategoryForm(
                                category: category,
                                isEdit: true,
                                onSave: () {
                                  setState(() {
                                    // Reload data after save or delete
                                  });
                                },
                              ));
                    },
                    leading: CircleAvatar(
                      backgroundColor: category.color.withOpacity(0.2),
                    ),
                    title: Text(
                      category.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.merge(
                          const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                    ),
                    subtitle: Text(category.note!,
                        style: Theme.of(context).textTheme.bodySmall?.apply(
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    width: double.infinity,
                    color: Colors.grey.withAlpha(25),
                    height: 1,
                    margin: const EdgeInsets.only(left: 75, right: 20),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (builder) => CategoryForm(
              onSave: () {
                setState(() {
                  // Reload data after adding a new category
                });
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
