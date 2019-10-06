import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:e2_design/models/post_response.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String PostTable = 'post_table';
  String colId = 'id';
  String colPostText = 'post_txt';
  String colPostImage = 'post_img';
  String colPostLocation = 'post_location';
  String colPostComments = 'post_comments';
  String colPostTime = 'post_time';
  String colPostStars = 'post_stars';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'posts.db';

    // Open/create the database at a given path
    var postsDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return postsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $PostTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colPostText TEXT,$colPostImage TEXT, '
            '$colPostLocation TEXT, $colPostComments TEXT, $colPostTime TEXT,$colPostStars TEXT)');
  }

  // Fetch Operation: Get all Post objects from database
  Future<List<Map<String, dynamic>>> getPostMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $PostTable order by $colPostComments ASC');
    var result = await db.query(PostTable, orderBy: '$colPostComments ASC');
    return result;
  }

  // Insert Operation: Insert a Post object to database
  Future<int> insertPost(Post post) async {
    Database db = await this.database;
    var result = await db.insert(PostTable, post.toMap());
    return result;
  }

  // Insert Operation: Insert a Post object to database
  void insertAllPosts(List<Post> posts) async {
    Database db = await this.database;
    for (int i = 0; i <= posts.length - 1; i++) {
      await db.insert(PostTable, posts[i].toMap());
    }
  }

  // Update Operation: Update a Post object and save it to database
  Future<int> updatePost(Post Post) async {
    var db = await this.database;
    var result = await db.update(PostTable, Post.toMap(),
        where: '$colId = ?', whereArgs: [Post.id]);
    return result;
  }

  // Delete Operation: Delete a Post object from database
  Future<int> deletePost(int id) async {
    var db = await this.database;
    int result =
    await db.rawDelete('DELETE FROM $PostTable WHERE $colId = $id');
    return result;
  }

  // Delete Operation: Delete a Post object from database
  Future<int> deleteAllPosts() async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $PostTable');
    return result;
  }

  // Get number of Post objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $PostTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Post List' [ List<Post> ]
  Future<List<Post>> getPostList() async {
    var postMapList = await getPostMapList(); // Get 'Map List' from database
    int count =
        postMapList.length; // Count the number of map entries in db table

    List<Post> PostList = List<Post>();
    // For loop to create a 'Post List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      PostList.add(Post.fromMapObject(postMapList[i]));
    }

    return PostList;
  }
}