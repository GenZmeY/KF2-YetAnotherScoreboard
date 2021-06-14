class SystemAdminRank extends Object
	dependson(Types)
	config(ScoreboardExt);

`include(Build.uci)
`include(Logger.uci)

var config string    Rank;
var config ColorRGBA TextColor;
var config Fields    ApplyColorToFields;

public static function SCESettingsAdmin DefaultSettings()
{
	local SCESettingsAdmin Settings;
	
	`callstack_static("DefaultSettings");
	
	return Settings;
}

public static function SCESettingsAdmin Settings()
{
	local SCESettingsAdmin Settings;
	
	`callstack_static("Settings");
	
	Settings.Rank = default.Rank;
	Settings.TextColor = default.TextColor;
	Settings.ApplyColorToFields = default.ApplyColorToFields;
	
	return Settings;
}

public static function WriteSettings(SCESettingsAdmin Settings)
{
	`callstack_static("WriteSettings");
	
	default.Rank = Settings.Rank;
	default.TextColor = Settings.TextColor;
	default.ApplyColorToFields = Settings.ApplyColorToFields;
	
	StaticSaveConfig();
}

DefaultProperties
{

}