class SystemPlayerRank extends Object
	dependson(Types)
	config(YAS);

`include(Build.uci)
`include(Logger.uci)

var config string    Rank;
var config ColorRGBA TextColor;
var config Fields    ApplyColorToFields;

public static function SCESettingsPlayer DefaultSettings()
{
	local SCESettingsPlayer Settings;
	
	`callstack_static("DefaultSettings");
	
	return Settings;
}

public static function SCESettingsPlayer Settings()
{
	local SCESettingsPlayer Settings;
	
	`callstack_static("Settings");
	
	Settings.Rank = default.Rank;
	Settings.TextColor = default.TextColor;
	Settings.ApplyColorToFields = default.ApplyColorToFields;
	
	return Settings;
}

public static function WriteSettings(SCESettingsPlayer Settings)
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