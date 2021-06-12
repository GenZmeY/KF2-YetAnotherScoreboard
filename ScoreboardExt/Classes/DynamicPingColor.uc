class DynamicPingColor extends Object
	dependson(Types)
	config(ScoreboardExt);

`include(Build.uci)
`include(Logger.uci)

var config bool bEnabled;
var config int Low;
var config int High;
var config bool bShowPingBars;

public static function SCESettingsPing DefaultSettings()
{
	local SCESettingsPing Settings;
	
	`callstack_static("DefaultSettings");
	
	return Settings;
}

public static function SCESettingsPing Settings()
{
	local SCESettingsPing Settings;
	
	`callstack_static("Settings");
	
	Settings.Dynamic = default.bEnabled;
	Settings.Low = default.Low;
	Settings.High = default.High;
	Settings.ShowPingBars = default.bShowPingBars;
	
	return Settings;
}

public static function WriteSettings(SCESettingsPing Settings)
{
	`callstack_static("WriteSettings");
	
	default.bEnabled = Settings.Dynamic;
	default.Low = Settings.Low;
	default.High = Settings.High;
	default.bShowPingBars = Settings.ShowPingBars;
	
	StaticSaveConfig();
}

DefaultProperties
{

}