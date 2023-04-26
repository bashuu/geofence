import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../models/database.dart';
import '../models/globals.dart' as globals;
import '../models/user.dart';

class LocationDetails extends StatefulWidget {
  const LocationDetails({super.key});

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  PanelController panelController = PanelController();
  TextEditingController locationSearchController = TextEditingController();
  bool _isLoading = false;

  List<String> historyList = ["User1", "User2", "User3"];
  List<String> chipSelect = [
    "2023/03/12",
    "2023/03/13",
    "2023/03/14",
    "2023/03/15",
  ];
  int? _value = 1;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    getUser().then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  Future<void> getUser() async {
    await getAllLocationUsers(globals.locationDetails).then((value) {
      Logger().e(globals.locationUser.length);
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
          title: Text(
            globals.locationDetails.name,
            style: const TextStyle(
              color: Colors.ligthBlack,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.brightOrange),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SlidingUpPanel(
        panel: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 55,
                  height: 6,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                ),
              ),
              const Text(
                "Таны код : ",
                style: TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
        controller: panelController,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.6,
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 30.0,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.ligthBlack,
                    border: Border.all(
                      color: Colors.ligthBlack,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Хаяг:",
                    style: TextStyle(color: Colors.darkerWhite),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on,
                      color: Colors.brightOrange,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      globals.locationDetails.address,
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              Container(
                height: 30.0,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.ligthBlack,
                    border: Border.all(
                      color: Colors.ligthBlack,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Бүртгэлтэй хүмүүс :",
                    style: TextStyle(color: Colors.darkerWhite),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: globals.locationUser.length,
                        separatorBuilder: (context, index) {
                          // add a divider between items
                          return const Divider(
                            height: 5,
                            color: Colors.ligthBlack,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.brightOrange,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100))),
                                child: const Icon(
                                  Icons.person,
                                  size: 32,
                                ),
                              ),
                              Container(
                                child: Text(
                                  globals.locationUser[index].name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                    Icons.arrow_forward_ios_outlined),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/userDetails');
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ),
              Container(
                height: 30.0,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.ligthBlack,
                  border: Border.all(
                    color: Colors.ligthBlack,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Миний байршлын түүх :",
                    style: TextStyle(color: Colors.darkerWhite),
                  ),
                ),
              ),
              Center(
                child: Wrap(
                  spacing: 10.0,
                  children: List<Widget>.generate(
                    chipSelect.length,
                    (int index) {
                      return Column(
                        children: [
                          ChoiceChip(
                            selectedColor: Colors.brightOrange,
                            shadowColor: Colors.darkerWhite,
                            backgroundColor: Colors.ligthBlack.withOpacity(0.3),
                            label: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.ligthBlack,
                                border: Border.all(
                                  color: Colors.ligthBlack,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                            ),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                            },
                          ),
                          const SizedBox(
                              height:
                                  5), // add space between the chip and the label text
                          Text(
                            chipSelect[index],
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: globals.locationUser.length,
                        separatorBuilder: (context, index) {
                          // add a divider between items
                          return const Divider(
                            height: 5,
                            color: Colors.ligthBlack,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Text(
                              globals.locationUser[index].name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.brightOrange,
                    border: Border.all(
                      color: Colors.brightOrange,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                child: TextButton(
                  onPressed: () {
                    panelController.isPanelOpen
                        ? panelController.close()
                        : panelController.open();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.brightOrange), // background color
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 100)), // size
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // border radius
                    )),
                  ),
                  child: const Text(
                    "Хэрэглэгч нэмэx",
                    style: TextStyle(color: Colors.ligthBlack),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
