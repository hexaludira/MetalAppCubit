import 'package:flutter/material.dart';
import 'package:cubit_metal/main.dart';
import 'package:cubit_metal/model/metal_data.dart';
import 'package:cubit_metal/repository/dio_helper.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class InputProblem extends StatefulWidget {
  //const InputProblem({ Key? key }) : super(key: key);
  MetalData metalData;

  InputProblem({this.metalData});

  @override
  _InputProblemState createState() => _InputProblemState();
}

class _InputProblemState extends State<InputProblem> {
  var _valPerbaikan;
  //daftar status perbaikan
  var _listStatus = ["LP diambil IT", "Lapor QIP", "LP Kirim vendor", "LP selesai service", "LP dipasang kembali", "Sensor datang", "Pasang Sensor Baru"];

  bool _isLoading = false;
  DioHelper _dioHelper = DioHelper();
  bool _isFieldDateValid;
  bool _isFieldDetailValid;
  bool _isFieldLocationValid;
  bool _isFieldStatusValid;
  //bool _isFieldRemarkValid;

  TextEditingController _controllerDate = TextEditingController();
  TextEditingController _controllerDetail = TextEditingController();
  TextEditingController _controllerLocation = TextEditingController();
  TextEditingController _controllerRemark = TextEditingController();
  
  final FocusNode _remarkFocus = FocusNode();

  @override
  void initState() {
    if (widget.metalData != null) {
      _isFieldDateValid = true;
      _controllerDate.text = widget.metalData.date;
      _isFieldDetailValid = true;
      _controllerDetail.text = widget.metalData.detail;
      _isFieldLocationValid = true;
      _controllerLocation.text = widget.metalData.location;
      _isFieldStatusValid = true;
      //_controllerStatus.text = widget.metalData.status;
      _controllerRemark.text = widget.metalData.remark;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.metalData == null ? "Tambah Data" : "Ubah Data",
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),

      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Stack(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildTextFieldDate(),
                      _buildTextFieldDetail(),
                      _buildTextFieldLocation(),
                      _buildTextFieldStatus(),
                      _buildTextFieldRemark(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ButtonTheme(
                          minWidth: 100.0,
                          height: 60.0,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_isFieldDateValid == null || _isFieldDetailValid == null || _isFieldLocationValid == null || _isFieldStatusValid == null || !_isFieldDateValid || !_isFieldDetailValid || !_isFieldLocationValid || !_isFieldStatusValid) 
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Tolong isi semua data")),
                                );
                                return;
                              }
                              setState(() => _isLoading = true);
                              String date = _controllerDate.text.toString();
                              String detail = _controllerDetail.text.toString();
                              String location = _controllerLocation.text.toString();
                              String status = _valPerbaikan.toString();
                              String remark = _controllerRemark.text.toString();

                              MetalData metalData = MetalData(date: date, detail: detail, location: location, status: status, remark: remark);

                              if (widget.metalData == null) {
                                //Input new data
                                _dioHelper.addData(metalData).then((isSuccess) {
                                setState(() => _isLoading = false);
                                if(isSuccess != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Data berhasil disimpan"))
                                  );
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => ListMetalPage()), (route) => false);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Submit data gagal"))
                                  );
                                }
                                });
                              } else {
                                //Update data
                                metalData.id = widget.metalData.id;
                                _dioHelper.editData(metalData).then((isSuccess) {
                                  setState(() => _isLoading = false);
                                  if(isSuccess != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Data berhasil diupdate"))
                                    );
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => ListMetalPage()), (route) => false);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Update data gagal"))
                                    );
                                  }

                                });
                              }
                              
                            }, 
                            child: Text(
                              widget.metalData == null ? "Submit".toUpperCase() : "Update Data".toUpperCase(),
                              style: TextStyle(color: Colors.white, fontSize: 21.0),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[600],
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ), 
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              )
            ])
          ),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
              ),
            ),
          )
        ],
      ),
    );
  }

  //DateTime Field
  Widget _buildTextFieldDate() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),            
      child: DateTimeField(
        format: DateFormat('dd MMMM yyyy'), 
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context, 
            initialDate: DateTime.now(), 
            firstDate: DateTime(2019), 
            lastDate: DateTime(2030)
          );
        },
        controller: _controllerDate,
        decoration: InputDecoration(
          labelText: "Tanggal",
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorText: _isFieldDateValid == null || _isFieldDateValid ? null : "Tanggal harus diisi"
        ),
        onChanged: (value) {
          bool isFieldValid = value.toString().trim().isNotEmpty;
          if(isFieldValid != _isFieldDateValid) {
            setState(() => _isFieldDateValid = isFieldValid);
          } 
        },
      ),
    );
  }

  //Detail Field
  Widget _buildTextFieldDetail(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: _controllerDetail,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "Detail",
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          errorText: _isFieldDetailValid == null || _isFieldDetailValid ? null : "Detail harus diisi",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _isFieldDetailValid) {
            setState(() => _isFieldDetailValid = isFieldValid);
          }
        },
      ),
    );
  }


  //Location Field
  Widget _buildTextFieldLocation() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: _controllerLocation,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "Location",
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          errorText: _isFieldLocationValid == null || _isFieldLocationValid ? null : "Lokasi harus diisi",
        ),
        onChanged: (value) {
          bool isFieldValid = value.trim().isNotEmpty;
          if (isFieldValid != _isFieldLocationValid) {
            setState(() => _isFieldLocationValid = isFieldValid);
          }
        },
      ),
    );
  }


  //Status Field
  Widget _buildTextFieldStatus() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorText: _isFieldStatusValid == null || _isFieldStatusValid ? null : "Status harus diisi"
            ),
            isEmpty: _valPerbaikan == "",
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text("Status Perbaikan"),
                value: _valPerbaikan,
                isDense: true,

                items: _listStatus.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),

                onChanged: (String newValue) {
                  setState(() {
                    _valPerbaikan = newValue;
                    state.didChange(newValue);
                    _isFieldStatusValid = true;                    
                  });
                },
                
              ),
            ),
          );
        }
      ),
    );
  }

  //Remark Field
  Widget _buildTextFieldRemark() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: _controllerRemark,
        focusNode: _remarkFocus,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "Keterangan",
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );

  }

}