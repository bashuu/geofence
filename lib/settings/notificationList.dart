import 'package:flutter/material.dart';
import '../models/globals.dart' as globals;
import '../models/database.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getUserNotification(globals.currentUser.id);
    setState(() {
      isLoading = false;
      globals.userNotifications.sort((a, b) => b.time.compareTo(a.time));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          toolbarHeight: 50.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.darkerWhite,
          leading: IconButton(
            color: Colors.ligthBlack,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Байршлын түүх",
            style: TextStyle(
              color: Colors.ligthBlack,
            ),
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10);
            },
            itemCount: globals.userNotifications.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 125,
                width: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.darkerWhite,
                  border: Border.all(
                    color: Colors.ligthBlack,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 57,
                      height: 57,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.brightOrange.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Colors.brightOrange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: (const Icon(
                          Icons.supervisor_account,
                          color: Colors.ligthBlack,
                          size: 20.0,
                        )),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              globals.userNotifications[index].title,
                              style: const TextStyle(fontSize: 16),
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              globals.userNotifications[index].body,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 70),
                      child: Text(
                        globals.userNotifications[index].time
                            .toString()
                            .substring(
                              0,
                              globals.userNotifications[index].time
                                  .toString()
                                  .indexOf(' '),
                            ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
