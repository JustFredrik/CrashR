/// @description Insert description here
// You can write your code in this editor

atempts = 0
max_atempts = CRASHR_MAX_CONNECT_ATTEMPT;

logs = [];
var _file_name = "";
if directory_exists(CRASHR_LOCAL_TMP_DIR ){
	_file_name = file_find_first(CRASHR_LOCAL_TMP_DIR + "*.json", 0);
			
	while _file_name != "" {
		array_push(logs, _file_name);
		_file_name = file_find_next();
	}
			
	file_find_close();
	logs_length = array_length(logs);
	i = 0
	
	http_response = "First";

if !os_is_network_connected(){
	show_debug_message("CrashR :: Tried uploading crash reports but could not connect to the internet.")
	instance_destroy();
}
