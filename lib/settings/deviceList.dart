// ignore: file_names
import 'package:flutter/material.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({super.key});

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  List<String> notification = ["Not1", "Not2", "Not3"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: Container(),
          toolbarHeight: 50.0,
          backgroundColor: Colors.darkerWhite,
          leading: IconButton(
            color: Colors.ligthBlack,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Баталгаажсан төхөөрөмжүүд",
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
              return Container(
                height: 1,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.ligthBlack,
                ),
              );
            },
            itemCount: notification.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 125,
                width: MediaQuery.of(context).size.height * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.darkerWhite,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
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
                        Icons.phone_android,
                        color: Colors.ligthBlack,
                        size: 20.0,
                      )),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            "Samsung S21",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("SAM94-34129-22194-ID"),
                          SizedBox(
                            height: 10,
                          ),
                          Text("2023/03/20 10:29")
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.15,
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.delete)),
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
