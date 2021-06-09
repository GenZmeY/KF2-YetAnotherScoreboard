class SystemPlayerRank extends Object
	dependson(Types)
	config(ScoreboardExt);

var config string    Rank;
var config ColorRGBA TextColor;
var config Fields    ApplyColorToFields;

public static function SCESettingsPlayer DefaultSettings()
{
	local SCESettingsPlayer Settings;
	return Settings;
}

public static function SCESettingsPlayer Settings()
{
	local SCESettingsPlayer Settings;
	
	Settings.Rank = default.Rank;
	Settings.TextColor = default.TextColor;
	Settings.ApplyColorToFields = default.ApplyColorToFields;
	
	return Settings;
}

public static function WriteSettings(SCESettingsPlayer Settings)
{
	default.Rank = Settings.Rank;
	default.TextColor = Settings.TextColor;
	default.ApplyColorToFields = Settings.ApplyColorToFields;
	
	StaticSaveConfig();
}

DefaultProperties
{

}