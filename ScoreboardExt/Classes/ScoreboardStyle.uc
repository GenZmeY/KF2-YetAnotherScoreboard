class ScoreboardStyle extends Object
	dependson(Types)
	config(ScoreboardExt);

var config ColorRGBA ServerNameBoxColor;
var config ColorRGBA ServerNameTextColor;
var config ColorRGBA GameInfoBoxColor;
var config ColorRGBA GameInfoTextColor;
var config ColorRGBA WaveBoxColor;
var config ColorRGBA WaveTextColor;
var config ColorRGBA PlayerCountBoxColor;
var config ColorRGBA PlayerCountTextColor;
var config ColorRGBA ListHeaderBoxColor;
var config ColorRGBA ListHeaderTextColor;
var config ColorRGBA LeftHPBoxColorNone;
var config ColorRGBA LeftHPBoxColorDead;
var config ColorRGBA LeftHPBoxColorLow;
var config ColorRGBA LeftHPBoxColorMid;
var config ColorRGBA LeftHPBoxColorHigh;
var config ColorRGBA PlayerOwnerBoxColor;
var config ColorRGBA PlayerBoxColor;
var config ColorRGBA StatsBoxColor;
var config ColorRGBA RankTextColor;
var config ColorRGBA ZedTextColor;
var config ColorRGBA PerkTextColor;
var config ColorRGBA LevelTextColor;
var config ColorRGBA PlayerNameTextColor;
var config ColorRGBA KillsTextColor;
var config ColorRGBA AssistsTextColor;
var config ColorRGBA DoshTextColor;
var config ColorRGBA StateTextColorLobby;
var config ColorRGBA StateTextColorReady;
var config ColorRGBA StateTextColorNotReady;
var config ColorRGBA StateTextColorNone;
var config ColorRGBA StateTextColorSpectator;
var config ColorRGBA StateTextColorDead;
var config ColorRGBA StateTextColorLowHP;
var config ColorRGBA StateTextColorMidHP;
var config ColorRGBA StateTextColorHighHP;
var config ColorRGBA PingTextColorNone;
var config ColorRGBA PingTextColorLow;
var config ColorRGBA PingTextColorMid;
var config ColorRGBA PingTextColorHigh;

public static function SCEStyle defaultSettings()
{
	local SCEStyle Settings;
	return Settings;
}

public static function SCEStyle Settings()
{
	local SCEStyle Settings;
	
	Settings.ServerNameBoxColor = default.ServerNameBoxColor;
	Settings.ServerNameTextColor = default.ServerNameTextColor;
	Settings.GameInfoBoxColor = default.GameInfoBoxColor;
	Settings.GameInfoTextColor = default.GameInfoTextColor;
	Settings.WaveBoxColor = default.WaveBoxColor;
	Settings.WaveTextColor = default.WaveTextColor;
	Settings.PlayerCountBoxColor = default.PlayerCountBoxColor;
	Settings.PlayerCountTextColor = default.PlayerCountTextColor;
	Settings.ListHeaderBoxColor = default.ListHeaderBoxColor;
	Settings.ListHeaderTextColor = default.ListHeaderTextColor;
	Settings.LeftHPBoxColorNone = default.LeftHPBoxColorNone;
	Settings.LeftHPBoxColorDead = default.LeftHPBoxColorDead;
	Settings.LeftHPBoxColorLow = default.LeftHPBoxColorLow;
	Settings.LeftHPBoxColorMid = default.LeftHPBoxColorMid;
	Settings.LeftHPBoxColorHigh = default.LeftHPBoxColorHigh;
	Settings.PlayerOwnerBoxColor = default.PlayerOwnerBoxColor;
	Settings.PlayerBoxColor = default.PlayerBoxColor;
	Settings.StatsBoxColor = default.StatsBoxColor;
	Settings.RankTextColor = default.RankTextColor;
	Settings.ZedTextColor = default.ZedTextColor;
	Settings.PerkTextColor = default.PerkTextColor;
	Settings.LevelTextColor = default.LevelTextColor;
	Settings.PlayerNameTextColor = default.PlayerNameTextColor;
	Settings.KillsTextColor = default.KillsTextColor;
	Settings.AssistsTextColor = default.AssistsTextColor;
	Settings.DoshTextColor = default.DoshTextColor;
	Settings.StateTextColorLobby = default.StateTextColorLobby;
	Settings.StateTextColorReady = default.StateTextColorReady;
	Settings.StateTextColorNotReady = default.StateTextColorNotReady;
	Settings.StateTextColorNone = default.StateTextColorNone;
	Settings.StateTextColorSpectator = default.StateTextColorSpectator;
	Settings.StateTextColorDead = default.StateTextColorDead;
	Settings.StateTextColorLowHP = default.StateTextColorLowHP;
	Settings.StateTextColorMidHP = default.StateTextColorMidHP;
	Settings.StateTextColorHighHP = default.StateTextColorHighHP;
	Settings.PingTextColorNone = default.PingTextColorNone;
	Settings.PingTextColorLow = default.PingTextColorLow;
	Settings.PingTextColorMid = default.PingTextColorMid;
	Settings.PingTextColorHigh = default.PingTextColorHigh;

	return Settings;
}

public static function WriteSettings(SCEStyle Settings)
{
	default.ServerNameBoxColor = Settings.ServerNameBoxColor;
	default.ServerNameTextColor = Settings.ServerNameTextColor;
	default.GameInfoBoxColor = Settings.GameInfoBoxColor;
	default.GameInfoTextColor = Settings.GameInfoTextColor;
	default.WaveBoxColor = Settings.WaveBoxColor;
	default.WaveTextColor = Settings.WaveTextColor;
	default.PlayerCountBoxColor = Settings.PlayerCountBoxColor;
	default.PlayerCountTextColor = Settings.PlayerCountTextColor;
	default.ListHeaderBoxColor = Settings.ListHeaderBoxColor;
	default.ListHeaderTextColor = Settings.ListHeaderTextColor;
	default.LeftHPBoxColorNone = Settings.LeftHPBoxColorNone;
	default.LeftHPBoxColorDead = Settings.LeftHPBoxColorDead;
	default.LeftHPBoxColorLow = Settings.LeftHPBoxColorLow;
	default.LeftHPBoxColorMid = Settings.LeftHPBoxColorMid;
	default.LeftHPBoxColorHigh = Settings.LeftHPBoxColorHigh;
	default.PlayerOwnerBoxColor = Settings.PlayerOwnerBoxColor;
	default.PlayerBoxColor = Settings.PlayerBoxColor;
	default.StatsBoxColor = Settings.StatsBoxColor;
	default.RankTextColor = Settings.RankTextColor;
	default.ZedTextColor = Settings.ZedTextColor;
	default.PerkTextColor = Settings.PerkTextColor;
	default.LevelTextColor = Settings.LevelTextColor;
	default.PlayerNameTextColor = Settings.PlayerNameTextColor;
	default.KillsTextColor = Settings.KillsTextColor;
	default.AssistsTextColor = Settings.AssistsTextColor;
	default.DoshTextColor = Settings.DoshTextColor;
	default.StateTextColorLobby = Settings.StateTextColorLobby;
	default.StateTextColorReady = Settings.StateTextColorReady;
	default.StateTextColorNotReady = Settings.StateTextColorNotReady;
	default.StateTextColorNone = Settings.StateTextColorNone;
	default.StateTextColorSpectator = Settings.StateTextColorSpectator;
	default.StateTextColorDead = Settings.StateTextColorDead;
	default.StateTextColorLowHP = Settings.StateTextColorLowHP;
	default.StateTextColorMidHP = Settings.StateTextColorMidHP;
	default.StateTextColorHighHP = Settings.StateTextColorHighHP;
	default.PingTextColorNone = Settings.PingTextColorNone;
	default.PingTextColorLow = Settings.PingTextColorLow;
	default.PingTextColorMid = Settings.PingTextColorMid;
	default.PingTextColorHigh = Settings.PingTextColorHigh;
	
	StaticSaveConfig();
}

defaultProperties
{

}