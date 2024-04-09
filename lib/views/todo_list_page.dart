import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:time_planner_app/ToDoForm/todo_create_page.dart';
import 'package:time_planner_app/model/time_planner_model.dart';
import 'package:time_planner_app/util/todo_tile.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  // List of colors for the TodoTiles
  final List<Color> todoTileColors = [
    Colors.red,
    Colors.white,
  ];

  PageController? _pageController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _calculateinitialPageIndex(),
      viewportFraction: 0.2,
    );
  }

  @override
  Widget build(BuildContext context) {
    var faker = Faker();
    return ScopedModelDescendant<TimePlannerModel>(
      builder: (context, child, model) {
        // if (!model.usernameLoaded) {
        //   return const Center(
        //     child: CircularProgressIndicator(
        //       color: Colors.blue,
        //       strokeWidth: 2.0,
        //     ),
        //   );
        // }
        // String userName = model.userData.userName;
        return Scaffold(
          body: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hello ${faker.person.firstName()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                        mini: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TodoCreatePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Text(
                    'Your task \ntoday is almost complete!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      height: 1,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    flex: 2,
                    child: PageView.builder(
                      padEnds: false,
                      pageSnapping: false,
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _daysInMonth(
                        DateTime.now().year,
                        DateTime.now().month,
                      ),
                      itemBuilder: (context, index) {
                        // Calculate the day for each iteration
                        int daysToAdd = index - DateTime.now().day + 1;

                        DateTime currentDate =
                            DateTime.now().add(Duration(days: daysToAdd));

                        // Format the date to display only the day of the month
                        String formattedDate =
                            DateFormat('d').format(currentDate);

                        // Format the date to display the day of the week
                        String formattedDay =
                            DateFormat('EE').format(currentDate);

                        // Check if this item corresponds to the current date
                        bool isCurrentDate =
                            DateTime.now().day == currentDate.day;
                        bool isSelectedDate = _selectedDate != null &&
                            _selectedDate!.day == currentDate.day;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = currentDate;
                            });
                            DateTime selectedDate = currentDate;
                            model.loadTodos(selectedDate.day);
                          },
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              height: 100,
                              width: 50,
                              decoration: BoxDecoration(
                                  // color: Colors.white,
                                  gradient: LinearGradient(
                                    colors: isSelectedDate
                                        ? [
                                            const Color(0xFFFF2400),
                                            const Color(0xFFFF2400),
                                            const Color(0xFF8B0000),
                                          ]
                                        : [
                                            Colors.white.withOpacity(0.8),
                                            Colors.white.withOpacity(0.7),
                                            Colors.white.withOpacity(0.6)
                                          ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(0.0, 1.0),
                                    stops: const [0.0, 0.5, 1.0],
                                    tileMode: TileMode.clamp,
                                  ),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: isCurrentDate || isSelectedDate
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      formattedDay,
                                      style: TextStyle(
                                        color: isCurrentDate || isSelectedDate
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    flex: 14,
                    child: ScopedModelDescendant<TimePlannerModel>(
                      builder: (context, child, model) {
                        if (model.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (model.toDos.isEmpty) {
                          return const Center(
                            child: Text(
                              'No todo set for this date yet. \nPleae add a new todo',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: model.toDos.length,
                            itemBuilder: (context, index) {
                              return TodoTile(
                                todoIndex: index,
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int _calculateinitialPageIndex() {
    DateTime currentDate = DateTime.now();

    // Calculate the index corresponding to the current date
    int currentIndex = currentDate.day - 1;

    return currentIndex;
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
