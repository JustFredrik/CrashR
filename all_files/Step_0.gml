/// @description Insert description here
// You can write your code in this editor

if ( !os_is_network_connected()){
	atempts += 1;
	exit
}

switch(http_response){

case "ready":
		var _data;
		try {
			var _file = file_text_open_read(CRASHR_LOCAL_TMP_DIR + logs[i])
			_data = file_text_read_string(_file);
			file_text_close(_file)
			http_request_id = crashr_send_error_report(logs[i], _data);
			show_debug_message(http_request_id);
			http_response = "waiting"
		}
		catch(_exception){
			atempts += 1;
			show_debug_message("CrashR :: ERROR! Something went wrong with uploading crash report.")
		}
		break

case "200": 
	file_delete(CRASHR_LOCAL_TMP_DIR + logs[i])
	i++
	http_response = "ready"
	break
	
case "waiting":
	break
	
default:
	atempts += 1;
	show_debug_message("CrashR :: ERROR! Unexpected HTTP resonse code:" + string(http_response));
	break
}
	
if (i >= logs_length){
	show_debug_message("CrashR :: Finished uploading " + string(logs_length) + " crash reports.")
	instance_destroy();	
}
