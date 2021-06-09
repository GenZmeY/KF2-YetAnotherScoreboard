class ThresholdsLevel extends Object
	dependson(Types)
	config(ScoreboardExt);

var config int Normal_Low;
var config int Normal_High;
var config int Hard_Low;
var config int Hard_High;
var config int Suicide_Low;
var config int Suicide_High;
var config int HellOnEarth_Low;
var config int HellOnEarth_High;

public static function SCESettingsLevel DefaultSettings()
{
	local SCESettingsLevel Settings;
	return Settings;
}

public static function SCESettingsLevel Settings()
{
	local SCESettingsLevel Settings;
	
	Settings.Normal_Low = default.Normal_Low;
	Settings.Normal_High = default.Normal_High;
	Settings.Hard_Low = default.Hard_Low;
	Settings.Hard_High = default.Hard_High;
	Settings.Suicide_Low = default.Suicide_Low;
	Settings.Suicide_High = default.Suicide_High;
	Settings.HellOnEarth_Low = default.HellOnEarth_Low;
	Settings.HellOnEarth_High = default.HellOnEarth_High;

	return Settings;
}

public static function WriteSettings(SCESettingsLevel Settings)
{
	default.Normal_Low = Settings.Normal_Low;
	default.Normal_High = Settings.Normal_High;
	default.Hard_Low = Settings.Hard_Low;
	default.Hard_High = Settings.Hard_High;
	default.Suicide_Low = Settings.Suicide_Low;
	default.Suicide_High = Settings.Suicide_High;
	default.HellOnEarth_Low = Settings.HellOnEarth_Low;
	default.HellOnEarth_High = Settings.HellOnEarth_High;
	
	StaticSaveConfig();
}

DefaultProperties
{

}