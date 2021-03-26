import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MetalAppCubit/model/metal_data.dart';

import '../repository/dio_helper.dart';
import 'metal_state.dart';

class MetalCubit extends Cubit<MetalState> {
	final DioHelper dioHelper;

	//Constructor dengan mengakses method parent class (MetalState)
	MetalCubit(this.dioHelper) : super(InitialMetalState());

	//Cubit method untuk mendapatkan data list metal (GET)
	void getAllData() async {
		emit(LoadingMetalState());
		var result = await dioHelper.getAllData();
		result.fold(
			(errorMessage) => emit(FailureLoadAllMetalState(errorMessage)),
			(listMetal) => emit(SuccessLoadAllMetalState(listMetal)),
		);
	}

	//Cubit method untuk menambahkan data list metal (POST)
	void addData(MetalData metalData) async{
		emit(LoadingMetalState());
		var result = await dioHelper.addData(metalData);
		result.fold(
			(errorMessage) => emit(FailureSubmitMetalState(errorMessage)),
			(_) => emit(SuccessSubmitMetalState()),
		);
	}

	//Cubit method untuk mengupdate data list metal (PUT)
	void editData(MetalData metalData) async {
		emit(LoadingMetalState());
		var result = await dioHelper.editData(metalData);
		result.fold(
			(errorMessage) => emit(FailureSubmitMetalState(errorMessage)),
			(_) => emit(SuccessSubmitMetalState()),
		);
	}

	//Cubit method untuk menghapus data list metal (DELETE)
	void deleteData(int id) async {
		emit(LoadingMetalState());

		var resultDelete = await dioHelper.deleteData(id);
		
	}
}
