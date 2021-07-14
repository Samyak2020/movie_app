
import 'package:movie_watchlist_app/db/movie_modelDB.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MovieDB{

  MovieDB._();
  static final MovieDB db = MovieDB._();

  // Name, desc, data, rating, picture

  Future<Database> initDB() async {
    String path =  await getDatabasesPath();
    return openDatabase(
      join(path, "MYDB.db"),
      onCreate: (database, version) async{
        await  database.execute(
          """
          CREATE TABLE MovieTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          movie_id INTEGER,
          is_wishlisted INTEGER,
          uid TEXT,
          title TEXT,
          name TEXT,
          poster_path TEXT,
          vote_average REAL,
          overview TEXT,
          release_date TEXT
          )
          """
        );
      },
      version : 4,
    );
  }

  Future<bool> insertData(MovieDBModel movieDBModel) async {
    final Database db = await initDB();
    db.insert("MovieTable", movieDBModel.toMap());
    return true;
  }

  Future<List<MovieDBModel>> getData() async{
    final Database db = await initDB();
    final data = await db.query("MovieTable");
    return data.map((e) => MovieDBModel.fromMap(e)).toList();
  }

  Future<void> deleteMovie({int id}) async {
    final Database db = await initDB();
    await db.delete("MovieTable", where: "id=?", whereArgs: [id]);
  }

}