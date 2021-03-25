import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MetalAppCubit/model/metal_data.dart';

import '../repository/dio_helper.dart';
import 'metal_state.dart';

class MetalCubit extends Cubit<MetalState> {
	final DioHelper dioHelper;

	//Constructor dengan mengakses method parent class (MetalState)
	MetalCubit(this.dioHelper) : super(InitialMetalState());

	//Cubit method untuk mendapatkan data list metal (GET)
	void getAllProfiles() async {
		emit(LoadingMetalState());
		var result = await dioHelper.getAllData();
		result.fold()
	}


}
