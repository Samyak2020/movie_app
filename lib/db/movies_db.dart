import 'package:movie_watchlist_app/db/movie_modelDB.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MovieDB{

  MovieDB._();
  static final MovieDB db = MovieDB._();


  Future<Database> initDB() async {
    String path =  await getDatabasesPath();
    return openDatabase(
      join(path, "MYDB.db"),
      onCreate: (database, version) async{
        await  database.execute(
          """
          CREATE TABLE MovieTable(
          movie_id INTEGER PRIMARY KEY,
          is_wishlisted INTEGER DEFAULT 0,
          uid TEXT,
          trailer_id TEXT,
          title TEXT,
          name TEXT,
          poster_path TEXT,
          backdrop_path TEXT,
          language TEXT,
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
    db.insert("MovieTable", movieDBModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<List<MovieDBModel>> getData() async{
    final Database db = await initDB();
    final data = await db.query("MovieTable");
    return data.map((e) => MovieDBModel.fromMap(e)).toList();
  }

  Future<void> deleteMovie({int id}) async {
    final Database db = await initDB();
    await db.delete("MovieTable", where: "movie_id = ?", whereArgs: [id]);
  }

  Future selectAData({int movieId, int isWishlisted}) async{
    final Database db = await initDB();
    final result =
    await db.query("MovieTable",
        columns: [
          "is_wishlisted ",
          "movie_id",
          "uid",
          "title",
          "trailer_id",
          "name",
          "poster_path",
          "backdrop_path",
          "language",
          "vote_average",
          "overview",
          "release_date",
        ],
       where: "movie_id = ?" ,
       whereArgs: [movieId]
    );
    if(result != null){
      return result.map((e) => MovieDBModel.fromMap(e));
    }else{
      return [];
    }
  }

    isWishListed({int movieId}) async{
    final Database db = await initDB();
    var data = await db.rawQuery("SELECT * FROM MovieTable WHERE movie_id = $movieId");
    return data.isNotEmpty ? MovieDBModel.fromMap(data.first) : null;

  }
  }

