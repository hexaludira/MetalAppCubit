import	'package:json_annotation/json_annotation.dart';

part 'metal_data.g.dart';

@JsonSerializable()
class MetalData {
	@JsonKey(name: 'id')
	final int id;
	@JsonKey(name: 'date')
	final String date;
	@JsonKey(name: 'detail')
	final String detail;
	@JsonKey(name: 'location')
	final String location;
	@JsonKey(name: 'status')
	final String status;
	@JsonKey(name: 'remark')
	final String remark;

	//Constructor
	MetalData(
		this.id,
		this.date,
		this.detail,
		this.location,
		this.status,
		this.remark
	);

	factory MetalData.fromJson(Map<String, dynamic> json) => _$MetalDataFromJson(json);

	Map<String, dynamic> toJson() => _$MetalDataToJson(this);

	@override
	String toString() {
		return 'MetalData{id: $id, date: $date, detail: $detail, location: $location, status: $status, remark: $remark}';
	}
}
