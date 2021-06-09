class SystemAdminRank extends Object
	dependson(Types)
	config(ScoreboardExt);

var config string    Rank;
var config ColorRGBA TextColor;
var config Fields    ApplyColorToFields;

public static function SCESettingsAdmin DefaultSettings()
{
	local SCESettingsAdmin Settings;
	return Settings;
}

public static function SCESettingsAdmin Settings()
{
	local SCESettingsAdmin Settings;
	
	Settings.Rank = default.Rank;
	Settings.TextColor = default.TextColor;
	Settings.ApplyColorToFields = default.ApplyColorToFields;
	
	return Settings;
}

public static function WriteSettings(SCESettingsAdmin Settings)
{
	default.Rank = Settings.Rank;
	default.TextColor = Settings.TextColor;
	default.ApplyColorToFields = Settings.ApplyColorToFields;
	
	StaticSaveConfig();
}

DefaultProperties
{

}