/* 
CrashR functions
*/


// This function is what overrides the default GameMaker unhandled exception handler.
exception_unhandled_handler( function (exception) {
	
    var crash_report = crashr_generate_report(exception);
	show_message(CRASHR_REPORT_MESSAGE);
	var crash_string = json_stringify(crash_report);
    
	date_set_timezone(timezone_utc);
	var file_name = CRASHR_LOCAL_FILE_NAME + ".json";
	var file;

	file = file_text_open_write(CRASHR_LOCAL_DIRECTORY + file_name);
	file_text_write_string(file, crash_string);
	file_text_close(file);
	
	file = file_text_open_write(CRASHR_LOCAL_TMP_DIR+ file_name);
	file_text_write_string(file, crash_string);
	file_text_close(file);
});

#region -- CrashR functions ---------------------------------------
function crashr_get_os_version_string(){
	
	switch(os_version){
		case 24:
		case 25:
			return "Android - Nougat (7.0 - 7.11)";
			break;
		
		case 26:
		case 27:
			return "Android - Oreo (8.0 - 8.11)";
			break;
				
		case 28:
			return "Android - Pie (9.0)";
			break;
	
		case 29:
			return "Android X (10.0)";
			break
			
	default:
		
	}
}

function crashr_get_os_type_string(){
	switch(os_type){
		case os_windows:
			return "Windows OS";
			break;
			
		case os_uwp:
			return "Windows 10 Universal Windows Platform";
			break;
		
		case os_operagx:
			return "Opera GX";
			break;
		
		case os_linux:
			return "Linux";
			break;
		
		case os_macosx:
			return "macOS X";
			break;
			
		case os_ios:
			return "iOS (iPhone, iPad, iPod Touch)";
			break;
		
		case os_tvos:
			return "Apple tvOS";
			break;
		
		case os_ps4:
			return "Sony PlayStation 4";
			break;
			
		case os_ps5:
			return "Sony PlayStation 5";
			break;
		
		case os_xboxone:
			return "Microsoft Xbox One";
			break;
			
		case os_xboxseriesxs:
			return "Microsoft Xbox Series X/S";
			break;
			
		case os_switch:
			return "Nintendo Switch";
			break;
		
		default:
			return "Unknown OS";
			break;
	}
}
	
function crashr_get_os_language_string(){
	return string(os_get_language());	
}

function crashr_get_instance_variable_safe(_instance, _variable_name){
	if instance_exists(_instance){
		if variable_instance_exists(_instance, _variable_name){
		return variable_instance_get(_instance, _variable_name);	
		}
		return "VARIABLE DOES NOT EXISTS"
	}
	return "INSTANCE DOES NOT EXISTS"
}

function crashr_has_files_to_upload(){
	return true;
}

function crashr_send_error_report(database_path, _report_string){
	var _header = ds_map_create();
	ds_map_add(_header, "Content-Type", "application/json");
	return http_request(CRASHR_DATABASE_ADRESS + database_path, "POST", _header, _report_string );
}

function crashr_upload_reports(){
	instance_create_depth(0,0,0,o_crashr);	
}

function crashr_unsafe_upload_reports() {
	if os_is_network_connected() {
		var _logs = [];
		var _file_name = "";
		if directory_exists(CRASHR_LOCAL_TMP_DIR ){
			_file_name = file_find_first(CRASHR_LOCAL_TMP_DIR + "*.json", 0);
			
			while _file_name != "" {
				array_push(_logs, _file_name);
				_file_name = file_find_next();
			}
			
			file_find_close();
			
			var _logs_length = array_length(_logs);
			var _file, _data;
			
			for(var _i = 0; _i < _logs_length; _i ++){
				_file = file_text_open_read(CRASHR_LOCAL_TMP_DIR + _logs[_i])
				_data = file_text_read_string(_file);
				file_text_close(_file);
				file_delete(CRASHR_LOCAL_TMP_DIR+ _logs[_i])
				crashr_send_error_report(_logs[_i], _data);
			}
		}
	}
	show_debug_message("Tried to Upload CrashR Reports. But could not connect to the internet.");
}
	
function crashr_delete_all_files(_only_temp = false) {
	return true;	
}
	
#endregion

#region -- CrashR version info -----------------------------------
#macro CRASHR_VERSION ("0.1")
show_debug_message("CRASHR :: Currently using CrashR version " + string(CRASHR_VERSION) + "!");
#endregion
