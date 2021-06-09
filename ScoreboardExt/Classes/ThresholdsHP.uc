class ThresholdsHP extends Object
	dependson(Types)
	config(ScoreboardExt);

var config int Low;
var config int High;

public static function SCESettingsHP DefaultSettings()
{
	local SCESettingsHP Settings;
	return Settings;
}

public static function SCESettingsHP Settings()
{
	local SCESettingsHP Settings;
	
	Settings.Low = default.Low;
	Settings.High = default.High;
	
	return Settings;
}

public static function WriteSettings(SCESettingsHP Settings)
{
	default.Low = Settings.Low;
	default.High = Settings.High;
	
	StaticSaveConfig();
}

DefaultProperties
{

}