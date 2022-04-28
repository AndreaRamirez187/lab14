import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab14/pages/page1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List _estudiantes = [];

   @override
   void initState(){
     super.initState();
     WidgetsBinding.instance!.addPostFrameCallback((_) => infoJson(context));
   }

   Future infoJson(BuildContext context) async {
     final String loading = await rootBundle.loadString('information/datastudents.json');
     final decoding = await json.decode(loading);
     setState(() {
       _estudiantes = decoding["estudiantes"];
     });
   }

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
       appBar: AppBar(
         centerTitle: true,
         backgroundColor: const Color.fromARGB(255, 243, 163, 255),
         title: const Text(" Lista de estudiantes ", style: TextStyle( color: Color.fromARGB(255, 29, 13, 175), fontSize: 20, fontWeight: FontWeight.bold),
       ),
     ),
     body: ListView.builder(
       itemCount: _estudiantes.length,
       itemBuilder: (context, index){
         return ListTile(
           onTap: () {
             Navigator.push(
                 context,
                 MaterialPageRoute(
                    builder:(context) => Page1(
                        matricula: _estudiantes[index]["matricula"],
                        nombrecompleto: _estudiantes[index]["nombre"],
                        carrera: _estudiantes[index]["carrera"],
                        semestre: _estudiantes[index]["semestre"],
                        telefono: _estudiantes[index]["telefono"],
                        correo: _estudiantes[index]["correo"])));
           },
           onLongPress:(){
             _eliminar(context, _estudiantes[index]);
           },
           title: Text(_estudiantes[index]["nombre"], style: const TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 29, 13, 175)),),
           subtitle: Text(_estudiantes[index]["correo"], style: const TextStyle(
                            color: Color.fromARGB(255, 221, 9, 147)),),
           leading: CircleAvatar(
             backgroundColor: const Color.fromARGB(204, 211, 113, 220),
             child: Text(_estudiantes[index]["nombre"].substring(0, 1),style: const TextStyle(
                            color: Color.fromARGB(255, 29, 13, 175))),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            );
          },
     ),
        ));
  }

  _eliminar(context, estudiante) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Eliminar estudiante"),
              content: Text("¿Está seguro de eliminar a " +
                  estudiante["nombre"] +
                  "?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar")),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _estudiantes.remove(estudiante);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Borrar",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }
}
