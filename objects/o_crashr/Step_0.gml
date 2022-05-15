/// @description Insert description here
// You can write your code in this editor

if ( !os_is_network_connected()){

}


if (http_response = "First"){
		var _data;
		try {
			var _file = file_text_open_read(CRASHR_LOCAL_TMP_DIR + logs[_i])
			_data = file_text_read_string(_file);
			file_text_close()
		}
}

	var _file, _data;
	for(var _i = 0; _i < _logs_length; _i ++){
		_file = file_text_open_read(CRASHR_LOCAL_TMP_DIR + logs[_i])
		_data = file_text_read_string(_file);
		file_text_close(_file);
		file_delete(CRASHR_LOCAL_TMP_DIR+ logs[_i])
		crashr_send_error_report(logs[_i], _data);
	}
