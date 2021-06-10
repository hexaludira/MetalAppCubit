import 'dart:io';

import 'package:cubit_metal/view/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/metal_cubit.dart';
import 'cubit/metal_state.dart';
import 'repository/dio_helper.dart';


void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      //home: ListMetalPage(),
      initialRoute: '/',
      routes: {
        '/' : (context) => ListMetalPage(),
        '/web_view' : (context) => WebView(),
      },
    );
  }
}

class ListMetalPage extends StatefulWidget {
  @override
  _ListMetalPageState createState() => _ListMetalPageState();
}

class _ListMetalPageState extends State<ListMetalPage> {
  //definisikan key untuk scaffold
  final scaffoldState = GlobalKey<ScaffoldState>();
  MetalCubit metalCubit;

  @override
  void initState(){
    metalCubit = MetalCubit(DioHelper());
    metalCubit.getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: scaffoldState,
      drawer: NavDrawer(),
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), onPressed: (){
          scaffoldState.currentState.openDrawer();
        }),
        title: Text('Metal Problem List'),
      ),
      body: BlocProvider<MetalCubit>(
        create: (_) => metalCubit,
        child: BlocListener<MetalCubit, MetalState>(
          listener: (_, state) {
            if (state is FailureLoadAllMetalState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),)
              );
              // scaffoldState.currentState(
              //   SnackBar(
              //     content: Text(state.errorMessage),
              //   ),
              // );
            } else if (state is FailureDeleteMetalState) {
              //Lakukan fungsi jika delete gagal
              
            }
          },
          child: BlocBuilder<MetalCubit, MetalState>(
            builder: (_, state) {
              if (state is LoadingMetalState) {
                return Center(
                  child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
                );
              } else if (state is FailureLoadAllMetalState) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is SuccessLoadAllMetalState) {
                var listMetal = state.listMetal;
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount : listMetal.length,
                  itemBuilder : (_, index) {
                    var metalData = listMetal[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //detail lokasi dan masalah 
                            Text(
                              metalData.location + ' \u25BA ' + metalData.detail,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            //Tanggal
                            Text(
                              metalData.date,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16, color: Colors.grey[700],
                              ),
                            ),
                            //Status
                            Text(
                              'Status: ' + metalData.status,
                            ),
                            //Keterangan
                            Text(
                              'Ket: ' + metalData.remark,
                            ),
                            //Button
                            Row(
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {}, 
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  )
                                ),
                                SizedBox(width: 7.0,),
                                TextButton(
                                  onPressed: () {}, 
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.teal),
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              } else {
                return Container();
              }
              
            }
          )
               
        )
      )
    );
  }
}

//Membuat Drawer Menu
class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Metal System Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
               
            ),
          ),
          ListTile(
            leading: Icon(Icons.microwave_outlined),
            title: Text('Data Metal Problem'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: Text('Web Metal'),
            onTap: () {
              Navigator.pushNamed(context, '/web_view');
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('FAQ'),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}





