class ThresholdsPing extends Object
	dependson(Types)
	config(ScoreboardExt);

var config int Low;
var config int High;

public static function SCESettingsPing DefaultSettings()
{
	local SCESettingsPing Settings;
	return Settings;
}

public static function SCESettingsPing Settings()
{
	local SCESettingsPing Settings;
	
	Settings.Low = default.Low;
	Settings.High = default.High;
	
	return Settings;
}

public static function WriteSettings(SCESettingsPing Settings)
{
	default.Low = Settings.Low;
	default.High = Settings.High;
	
	StaticSaveConfig();
}

DefaultProperties
{

}