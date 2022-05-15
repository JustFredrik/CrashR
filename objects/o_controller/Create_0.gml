/// @description Insert description here
// You can write your code in this editor

crashr_upload_reports() 

var _header = ds_map_create();
	ds_map_add(_header, "Content-Type", "application/json");
	
	//http_request(CRASHR_DATABASE_ADRESS + CRASHR_TARGET_DATABASE_DIRECTORY, "POST", _header, json_stringify(crashr_generate_report({})));
