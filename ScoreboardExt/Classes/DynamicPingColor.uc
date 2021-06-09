class DynamicPingColor extends Object
	dependson(Types)
	config(ScoreboardExt);

var config bool bEnabled;
var config int Low;
var config int High;
var config bool bShowPingBars;

public static function SCESettingsPing DefaultSettings()
{
	local SCESettingsPing Settings;
	return Settings;
}

public static function SCESettingsPing Settings()
{
	local SCESettingsPing Settings;
	
	Settings.Dynamic = default.bEnabled;
	Settings.Low = default.Low;
	Settings.High = default.High;
	Settings.ShowPingBars = default.bShowPingBars;
	
	return Settings;
}

public static function WriteSettings(SCESettingsPing Settings)
{
	default.bEnabled = Settings.Dynamic;
	default.Low = Settings.Low;
	default.High = Settings.High;
	default.bShowPingBars = Settings.ShowPingBars;
	
	StaticSaveConfig();
}

DefaultProperties
{

}