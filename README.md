# CrashR
 A lightweight GameMaker Library for saving and uploading crash reports to RestAPI Databases
___
CrashR is a lightweight GameMaker library designed to override the default uncaught exception handler for GameMaker. CrashR will save and store customizable crash reports as JSON files both locally and to a developer specified remote database. 

**Disclaimer:** most coutries have laws regarding user data collection and CrashR does not provide any buildt in legal user disclaimers or notifications to  allow developers to be compliant with data collection laws. Any developer using this are themselves responsible that their use of this tool is compliant with laws and regulations regarding user data collection.

# Quick Setup
**Step 1:** Download the `crashr.yymps` file from this reposetory.

**Step 2:** In your GameMaker project of choice go to the top dropdown menu and go to `Tools` > `Import Local Package`.

**Step 3:** Select the `crashr.yymps` file that you just downloaded.

**Step 4:** In this new view select **Add All** And then **OK**, you should now have a new directory in your GameMaker project called 'CrashR'.

**Step 5:** Go into the file `CrashR/CRSAHR_CONFIG` in your project directory and in this config file change the `CRASHR_DATABASE_ADRESS` macro to the address of your own database. (Note that the default configuration of CrashR requires that the database allows for anyone to POST without authentication, if you wish to add support for authentication you will have to do so yourself.)

**Step 6:** Done! Crasher will now store crash reports to players local systems! (by default under %localappdata&/GAME_NAME/crash_reports) If you wish to upload files to your remote database see Step 7.

**Step 7 (optional):** by calling the function `crashr_upload_reports()` at any point from anywhere during runtime, CrashR will try to upload any and all crash reports to the remote database that has not been uploaded yet.

# Overview

## Whats Included
When adding CrashR to your GameMaker project you will recieve a new folder called `CrashR`
In this folder you will find: a script file titled `CRASHR_CONFIG` where you will be able to configure CrashR.
And a folder called `CrashR Internals`, in this folder you can find the upload worker object `o_crashr` which is in charge of uploading crash reports and a scipt file called `scr_crashr` which contains all crashr functions. If you wish to extend- and or change the functionality of CrashR, then this is where you should look.

## How it works
CrashR overrides the default uncaught exception handler by calling the buildt in function `exception_unhandled_handler()` and passing in it's own handler code. When the game crashes the user will be presented with a message that can be specified and changed in `CRASHR_CONFIG` and two files will be saved to the local machine, one in the crash report directory and one in a temporary directory. The temporary directory is so CrashR can keep track of which files that have been successfully uploaded and which files that have not. Files will be deleted from the temporary directory once the files have been successfully uploaded to the remote database. Crash reports in the standard directory will stay there until either the user manually deletes them or the function `crashr_delete_all_files()` is called.

GameMaker can't spin up a HTTP connection when an uncaught error occurs so once the game crashes all CrashR will do is to save the crash report locally to upload it later. It is therefore recommended to check if there are any files ready to be uploaded on game start so crash report files that was generated during the previous game run is uploaded as soon as possible.

## Config File
| Macro | Type | Description |
|-------|------|-------------|
| CRASHR_DATABASE_ADRESS | String | Base address to post crash reports to. |
| CRASHR_REPORT_MESSAGE | String | Formatting for the Crash Message shown to Players when the game crashes. |
| CRASHR_TARGET_DATABASE_DIRECTORY | String | Formatting for the database subdirectory path to POST the reports to. |
| CRASHR_LOCAL_FILE_NAME | String | Crash report file naming convention. |
| CRASHR_LOCAL_DIRECTORY | String | Local directory path to save crash reports to. |
| CRASHR_LOCAL_TMP_DIR | String | Local directory path to temporarily save crash reports that have not yet been uploaded to. |
| CRASHR_MAX_CONNECT_ATTEMPT | Real | The maximum amount of attempts that CrashR will try to upload files before giving up. |

In addition to thsee macros the config file also contains a function called `crashr_generate_report()`. By changing the contents of the struct that this function returns you can customize the structure and contents of your crash reports to suit your own needs (comes pre-configured with generic useful data).

## Functions
### crashr_upload_reports()
Spawns an instance of `o_crashr` to upload all crash reports in the temporary report directory.<br />
**Returns:**	`N/A`
***


### crashr_get_os_version_string()
Returns a string representation of the player's OS version (currently only supports Android). <br />
**Returns:**	`String`<br />
*** 


### crashr_get_os_type_string()
Returns a string representation of the player's OS. <br />
**Returns:**	`String`<br />
*** 

	
### crashr_get_os_language_string()
Returns a string representation of the player's OS.<br />
**Returns:**	`String` 
*** 



### crashr_has_files_to_upload()
Checks if there are any files to upload, if so returns true otherwise it will return false. <br />
**Returns:**	`bool`<br />
*** 



### crashr_send_error_reports(*database_sub_directory, report_json_string*)
Sends off an HTTP POST request to the remote database with specified report data. The address that the post will be sent to will be `CRASHR_DATABASE_ADRESS` + `database_sub_directory`. For example if `CRASHR_DATABASE_ADRESS` is 'www.myaddress.com' and `database_sub_directory` is '/test.json' then the POST request will be sent to www.myaddress.com/test.json. The data passed into report_json_string should be a string representation of a JSON object.<br />
| Argument | Type | Description |
|----------|------|-------------|
|database_sub_directory|String|The sub directory path to where the POST request will be sent to on the remote database.|
| report_json_string | String | A string representation of the JSON object that you wish to POST to the database.|

**Returns:**	`Real`  The HTTP request id of the POST request which can be used to link it to it's correlating server response.<br />
*** 



### crashr_unsafe_upload_reports()
Sends off all crash reports all at once and deletes them locally without checking if it was successful or not.
**Returns:**	`N/A`
*** 



###	crashr_delete_all_files(only_temp)
Deletes all locally stored crash reports, Deletes only temp files if only_temp is set to true.
| Argument | Type | Description |
|----------|------|-------------|
|only_temp (*optional*)| Bool | Specify if you only wish to delete the temp files (true) or not (false). set to false by default. |

**Returns:**	`N/A`
*** 



### crashr_generate_report(*exception*)
This function unlike all other functions is located in the `CRASHR_CONFIG` file. This function determines the contents of the crash report. By changing the contents of the struct that this function returns you can customize the structure and contents of your crash reports to suit your own needs.
| Argument | Type | Description |
|----------|------|-------------|
| exception |Struct | The exception that you wish to include inside the crash report. |

**Returns:**	`Struct` A struct containing all crash report data which can later be stringified and uploaded as JSON. <br />

