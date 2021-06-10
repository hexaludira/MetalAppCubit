import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:cubit_metal/model/metal_data.dart';

class DioHelper {
	Dio _dio;

	//Define base option as constructor
	DioHelper(){
		_dio = Dio(
			BaseOptions(
					//baseUrl: 'http://10.10.41.246/rest_ci',
          baseUrl: 'http://10.0.2.2/rest_ci',
          //baseUrl: 'http://localhost/rest_ci',
				),
			);
		_dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
	}

	//Get All data metal (GET)
	Future<Either<String, List<MetalData>>> getAllData() async {
		try {
			var response = await _dio.get('/index.php/List_Problem');
			var listMetalData = List<MetalData>.from(response.data.map((e) => MetalData.fromJson(e)));
			return Right(listMetalData);
		} on DioError catch (error) {
			return Left('$error');
		}
	}

	//Add data to DB (POST)
	Future<Either<String, bool>> addData(MetalData metalData) async {
		try {
			await _dio.post(
				'/index.php/List_Problem',
				data: metalData.toJson(),
			);
			return Right(true);
		} on DioError catch (error) {
			return Left('$error');
		}
	}

	//Edit data (PUT)
	Future<Either<String, bool>> editData(MetalData metalData) async {
		try {
				await _dio.put(
					'/index.php/List_Problem/${metalData.id}',
					data: metalData.toJson(),
				);
				return Right(true);
			} on DioError catch (error) {
				return Left('$error');
			}
	}

	//Delete data (DELETE)
	Future<Either<String, bool>> deleteData(int id) async {
		try {
			await _dio.delete(
				'index.php/List_Problem/$id',
			);
			return Right(true);
		} on DioError catch (error) {
			return Left('$error');
		}
	}

}


