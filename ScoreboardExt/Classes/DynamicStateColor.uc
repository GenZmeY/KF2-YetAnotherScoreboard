class DynamicStateColor extends Object
	dependson(Types)
	config(ScoreboardExt);

`include(Build.uci)
`include(Logger.uci)

var config bool bEnabled;
var config int Low;
var config int High;

public static function SCESettingsState DefaultSettings()
{
	local SCESettingsState Settings;
	
	`callstack_static("DefaultSettings");
	
	return Settings;
}

public static function SCESettingsState Settings()
{
	local SCESettingsState Settings;
	
	`callstack_static("Settings");
	
	Settings.Dynamic = default.bEnabled;
	Settings.Low = default.Low;
	Settings.High = default.High;
	
	return Settings;
}

public static function WriteSettings(SCESettingsState Settings)
{
	`callstack_static("WriteSettings");
	
	default.bEnabled = Settings.Dynamic;
	default.Low = Settings.Low;
	default.High = Settings.High;
	
	StaticSaveConfig();
}

DefaultProperties
{

}