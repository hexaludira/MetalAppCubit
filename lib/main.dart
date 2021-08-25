import 'dart:io';

import 'package:cubit_metal/model/metal_data.dart';
import 'package:cubit_metal/view/input_problem.dart';
import 'package:cubit_metal/view/splash_screen.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Metal System',
      theme: ThemeData(
        primaryColor: Colors.grey[600],
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => SplashScreenPage(),
        '/list_problem' : (context) => ListMetalPage(),
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

  //text editing controller untuk filter text search
  final TextEditingController _filter = TextEditingController();
  Icon _searchIcon = Icon(Icons.search);
  String _searchText = "";
  Widget _appBarTitle = Text("List Metal Problem", style: TextStyle(color: Colors.white),);
  List<MetalData> problemList = [];
  List<MetalData> filteredData = [];

  //constructor _ListMetalPageState
  _ListMetalPageState() {
    _filter.addListener(() {
      if(_filter.text.isEmpty){
        setState(() {
                  _searchText = "";
                  filteredData = problemList;
                });
      } else {
        setState(() {
                  _searchText = _filter.text;
                });
      }
    });
  }
  

  @override
  void initState(){
    super.initState();
    metalCubit = MetalCubit(DioHelper());
    metalCubit.getAllData();
    
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: scaffoldState,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: _appBarTitle,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            tooltip: 'Cari data',
            onPressed: () {
              _cariData();
            })
        ],
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
                //var listMetal = state.listMetal;
                filteredData = state.listMetal;

                return _buildListView(filteredData); 
                
              } else {
                return Container();
              }
              
            }
          )
               
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InputProblem()));
        }
      ),
    );
  }

  Widget _buildListView(List<MetalData> metalData){
    if(_searchText.isNotEmpty){
      List<MetalData> tempList = [];
      metalData.forEach((element) {
        if(element.location.toLowerCase().contains(_searchText.toLowerCase()) || element.detail.toLowerCase().contains(_searchText.toLowerCase()) || element.date.toLowerCase().contains(_searchText.toLowerCase()) || element.remark.toLowerCase().contains(_searchText.toLowerCase()) || element.status.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(element);
        }
      });
      filteredData = tempList;
    }

    return RefreshIndicator(
      onRefresh: refreshData,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount : filteredData.length,
          itemBuilder : (_, index) {
            var listMetalData = filteredData[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //detail lokasi dan masalah 
                      Text(
                        listMetalData.location + ' \u25BA ' + listMetalData.detail,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      //Tanggal
                      Text(
                        listMetalData.date,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, color: Colors.grey[700],
                        ),
                      ),
                      //Status
                      Text(
                        'Status: ' + listMetalData.status,
                      ),
                      //Keterangan
                      Text(
                        'Ket: ' + listMetalData.remark,
                      ),
                      //Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            );
          }
        ), 
      ),
    );
    
  }

  //fungsi refreshData
  Future refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    metalCubit.getAllData();
    setState(() {
          
        });
  }

  void _cariData() {
    setState(() {
          if (this._searchIcon.icon == Icons.search){
            this._searchIcon = Icon(Icons.close);
            this._appBarTitle = TextField(
              controller: _filter,
              autofocus: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white,),
                hintText: 'Cari...',
                hintStyle: TextStyle(color: Colors.white),
              ),
            );
          } else {
            this._searchIcon = Icon(Icons.search);
            this._appBarTitle = Text("List Metal Problem", style: TextStyle(color: Colors.white),);
            filteredData = problemList;
            _filter.clear();
          }
        });
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
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/list_problem');
            },
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: Text('Web Metal'),
            onTap: () {
              Navigator.pop(context);
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





