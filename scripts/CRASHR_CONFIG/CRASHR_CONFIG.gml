#macro CRASHR_DATABASE_ADRESS ("https://gamemakercrashreportdemo-default-rtdb.europe-west1.firebasedatabase.app/")
#macro CRASHR_GAME_BUILD_ID ("1.0")
#macro CRASHR_REPORT_MESSAGE ("The game has run into an unexpected error and will now exit.\nCause of Crash: " + string(exception.message))
#macro CRASHR_REPORT_OFFLINE_MESSAGE ("The game has run into an unexpected error and will now exit. A crash has been saved to the local system")
#macro CRASHR_TARGET_DATABASE_DIRECTORY ( CRASHR_LOCAL_FILE_NAME  + ".json")
#macro CRASHR_LOCAL_FILE_NAME ( string(current_year) + "_" + string(current_month) + "_" + string(current_day) + "_" + string(current_hour) +"_"+ string(current_minute) +"_"+ string(current_second))
#macro CRASHR_LOCAL_DIRECTORY (working_directory + "/crash_reports/")
#macro CRASHR_LOCAL_TMP_DIR +  (working_directory + "/crash_reports_tmp/")

#macro CRASHR_MAX_CONNECT_ATTEMPT (5)


function crashr_generate_report(_exception){
#region Create sub structs

	var player_data_struct = {	
			"player_state" : crashr_get_instance_variable_safe(o_player, "state"),
			"player_health" : crashr_get_instance_variable_safe(o_player, "hp"),
		};
		
	var os_data_struct = {
			"os_version" : crashr_get_os_version_string(),
			"os_type" : crashr_get_os_type_string(),
			"os_language" : crashr_get_os_language_string()
	};
	
	var build_data_struct =  {
			"GM_build_date" : date_time_string(GM_build_date),
			"GM_runtime_version" : string(GM_runtime_version),
			"GM_version" : string(GM_version),
			"game_build" : CRASHR_GAME_BUILD_ID,
		};
		
	var game_data_struct = {
			"current_room" : room_get_name(room),
			"uptime" : current_time
	};
#endregion
	return  { // Return a Struct with the nested data
		"player_data" : player_data_struct,
		
		"os_data" : os_data_struct,
		
		"build_data": build_data_struct,
		
		"game_data" : game_data_struct,
		
		"crash_data": _exception
	}
}
