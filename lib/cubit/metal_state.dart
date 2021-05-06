import 'package:cubit_metal/model/metal_data.dart';

abstract class MetalState {}

class InitialMetalState extends MetalState {}

class LoadingMetalState extends MetalState {}

class FailureLoadAllMetalState extends MetalState {
	final String errorMessage;

	FailureLoadAllMetalState(this.errorMessage);

	@override
	String toString() {
		return 'FailureLoadAllMetalState{errorMessage: $errorMessage}';
	}

}

class SuccessLoadAllMetalState extends MetalState {
	final List<MetalData> listMetal;
	final String message;

	SuccessLoadAllMetalState(this.listMetal, {this.message});

	@override
	String toString(){
		return 'SuccessLoadAllMetalState(listMetal: $listMetal, message: $message)';
	}
}

class FailureSubmitMetalState extends MetalState {
	final String errorMessage;

	FailureSubmitMetalState(this.errorMessage);

	@override
	String toString() {
		return 'FailureSubmitMetalState(errorMessage: $errorMessage)';
	}
}

class SuccessSubmitMetalState extends MetalState {}

class FailureDeleteMetalState extends MetalState {
	final String errorMessage;

	FailureDeleteMetalState(this.errorMessage);

	@override
	String toString() {
		return 'FailureDeleteMetalState(errorMessage: $errorMessage)';
	}
} 



