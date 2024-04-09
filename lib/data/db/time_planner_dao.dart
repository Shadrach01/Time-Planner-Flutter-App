import 'package:sembast/sembast.dart';
import 'package:time_planner_app/data/data_class/user_data.dart';
import 'package:time_planner_app/data/db/app_database.dart';
import 'package:time_planner_app/data/data_class/toDo.dart';
import 'package:time_planner_app/util/constants.dart';

class TimePlannerDao {
  // A store with int keys and Map<String, dynamic> values.
  // This is preicsely what we need since we convert Todo objects to Map
  final _timePlannerStore = intMapStoreFactory.store(Constants.TODO_STORE_NAME);
  final _timePlannerUsernameDetails =
      intMapStoreFactory.store(Constants.USERNAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future addUserName(UserData userData) async {
    await _timePlannerUsernameDetails.add(
      await _db,
      userData.toMap(),
    );
  }

  Future insert(ToDo todo) async {
    await _timePlannerStore.add(
      await _db,
      todo.toMap(),
    );
  }

  Future update(ToDo todo) async {
    // Get the actual todo by its Id using finder
    final finder = Finder(
      filter: Filter.byKey(todo.id),
    );
    await _timePlannerStore.update(
      await _db,
      todo.toMap(),
      finder: finder,
    );
  }

  Future delete(ToDo todo) async {
    // Get the actual todo by its Id using finder
    final finder = Finder(
      filter: Filter.byKey(todo.id),
    );
    await _timePlannerStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<ToDo>> getAllInSortedOrder() async {
    final finder = Finder(
      sortOrders: [
        SortOrder('todoDate'),
        SortOrder('time'),
      ],
    );

    final recordSnapShot = await _timePlannerStore.find(
      await _db,
      finder: finder,
    );

    // Map iterates over the whole list and gives us acccess to every element
    // it also returns a new list containing different values (ToDo objects)
    return recordSnapShot.map((snapshot) {
      final todo = ToDo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }

  Future<List<ToDo>> getTodosForDate(int selectedDate) async {
    final finder = Finder(
      filter: Filter.equals('todoDate', selectedDate),
      sortOrders: [
        SortOrder('time'),
      ],
    );

    final recordSnapShot = await _timePlannerStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapShot.map(
      (snapshot) {
        final todo = ToDo.fromMap(snapshot.value);
        todo.id = snapshot.key;
        return todo;
      },
    ).toList();
  }
}
