// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LoginParent extends StatefulWidget {
  const LoginParent({super.key});

  @override
  State<LoginParent> createState() => _LoginParentState();
}

class _LoginParentState extends State<LoginParent> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool ispasswordev = true;

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
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
                  "Нэвтрэх",
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
                    height: MediaQuery.of(context).size.height * 0.2,
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: TextField(
                        controller: emailCont,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            size: 20,
                          ),
                          hintText: 'И-Мэйл',
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: TextField(
                        controller: passwordCont,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_open_outlined,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: ispasswordev
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.ligthBlack,
                                    size: 20,
                                  )
                                // ignore: dead_code
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.ligthBlack,
                                    size: 20,
                                  ),
                            onPressed: () =>
                                setState(() => ispasswordev = !ispasswordev),
                          ),
                          hintText: 'Нууц үг',
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        obscureText: ispasswordev,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 252.0, top: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/loginParent");
                      },
                      child: const Text(
                        'Нууц үг сэргээх',
                        style: TextStyle(
                          color: Colors.brightOrange,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.28,
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
                        "Нэвтрэх",
                        style: TextStyle(color: Colors.ligthBlack),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/registerPage");
                      },
                      child: const Text(
                        'Бүртгүүлэх',
                        style: TextStyle(
                          color: Colors.brightOrange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
