import 'package:flutter/material.dart';

class EnterChildName extends StatefulWidget {
  const EnterChildName({super.key});

  @override
  State<EnterChildName> createState() => _EnterChildNameState();
}

class _EnterChildNameState extends State<EnterChildName> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailCont = TextEditingController();

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
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
                  "Баталгаажуулах",
                  style: TextStyle(
                    color: Colors.ligthBlack,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Center(
                    child: Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.darkerWhite,
                          border: Border.all(
                            color: Colors.darkerWhite,
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: TextField(
                        controller: emailCont,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            size: 20,
                          ),
                          hintText: 'Хэрэглэгчийн нэр',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      "exmaple@mail.com мэйл-руу илгээсэн нэг удаагын баталгаажуулах кодыг энд оруулна уу.",
                      style: TextStyle(
                        color: Colors.ligthBlack,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                  Container(
                    height: 60.0,
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/homePage');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.brightOrange), // background color
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 100)), // size
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // border radius
                        )),
                      ),
                      child: const Text(
                        "Баталгаажуулах",
                        style: TextStyle(color: Colors.ligthBlack),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
