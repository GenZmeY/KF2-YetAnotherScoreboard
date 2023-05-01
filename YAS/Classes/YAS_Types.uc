class YAS_Types extends Object;

struct YAS_SettingsHealth
{
	var int Low;
	var int High;

	Structdefaultproperties
	{
		Low  = 40
		High = 80
	}
};

struct YAS_SettingsPing
{
	var int Low;
	var int High;

	Structdefaultproperties
	{
		Low  = 60
		High = 120
	}
};

struct YAS_SettingsLevel
{
	var int Low [4];
	var int High[4];

	Structdefaultproperties
	{
		Low [0] = 0
		High[0] = 0
		Low [1] = 5
		High[1] = 15
		Low [2] = 15
		High[2] = 20
		Low [3] = 20
		High[3] = 25
	}
};

struct YAS_Style
{
	// Box shapes
	var int       ShapeServerNameBox;
	var int       ShapeGameInfoBox;
	var int       ShapeWaveInfoBox;
	var int       ShapePlayersCountBox;
	var int       ShapeHeaderBox;
	var int       ShapeStateHealthBoxTopPlayer;
	var int       ShapeStateHealthBoxMidPlayer;
	var int       ShapeStateHealthBoxBottomPlayer;
	var int       ShapePlayerBoxTopPlayer;
	var int       ShapePlayerBoxMidPlayer;
	var int       ShapePlayerBoxBottomPlayer;
	var int       ShapeStatsBoxTopPlayer;
	var int       ShapeStatsBoxMidPlayer;
	var int       ShapeStatsBoxBottomPlayer;

	// Server box
	var Color ServerNameBoxColor;
	var Color ServerNameTextColor;

	// Game info box
	var Color GameInfoBoxColor;
	var Color GameInfoTextColor;

	// Wave info box
	var Color WaveBoxColor;
	var Color WaveTextColor;

	// Player count box
	var Color PlayerCountBoxColor;
	var Color PlayerCountTextColor;

	// Header box
	var Color ListHeaderBoxColor;
	var Color ListHeaderTextColor;

	// State box
	var Color StateBoxColorLobby;
	var Color StateBoxColorReady;
	var Color StateBoxColorNotReady;
	var Color StateBoxColorSpectator;
	var Color StateBoxColorDead;
	var Color StateBoxColorNone;
	var Color StateBoxColorHealthLow;
	var Color StateBoxColorHealthMid;
	var Color StateBoxColorHealthHigh;

	// Player box
	var Color PlayerOwnerBoxColor;
	var Color PlayerBoxColor;

	// Stats box
	var Color StatsOwnerBoxColor;
	var Color StatsBoxColor;

	// State text
	var Color StateTextColorLobby;
	var Color StateTextColorReady;
	var Color StateTextColorNotReady;
	var Color StateTextColorSpectator;
	var Color StateTextColorDead;
	var Color StateTextColorNone;
	var Color StateTextColorHealthLow;
	var Color StateTextColorHealthMid;
	var Color StateTextColorHealthHigh;

	// Rank text
	var Color RankTextColor;

	// Player text
	var Color PlayerNameTextColor;

	// Level text
	var Color LevelTextColorLow;
	var Color LevelTextColorMid;
	var Color LevelTextColorHigh;

	// Perk text
	var Color ZedTextColor;
	var Color PerkNoneTextColor;
	var Color PerkBerserkerTextColor;
	var Color PerkCommandoTextColor;
	var Color PerkSupportTextColor;
	var Color PerkFieldMedicTextColor;
	var Color PerkDemolitionistTextColor;
	var Color PerkFirebugTextColor;
	var Color PerkGunslingerTextColor;
	var Color PerkSharpshooterTextColor;
	var Color PerkSwatTextColor;
	var Color PerkSurvivalistTextColor;

	// Dosh text
	var Color DoshTextColorLow;
	var Color DoshTextColorMid;
	var Color DoshTextColorHigh;

	// Kills text
	var Color KillsTextColorLow;
	var Color KillsTextColorMid;
	var Color KillsTextColorHigh;

	// Assists text
	var Color AssistsTextColorLow;
	var Color AssistsTextColorMid;
	var Color AssistsTextColorHigh;

	// Ping text
	var Color PingTextColorNone;
	var Color PingTextColorLow;
	var Color PingTextColorMid;
	var Color PingTextColorHigh;

	// Other settings
	var bool      ShowPingBars;
	var bool      HealthBoxSmoothColorChange;
	var bool      HealthTextSmoothColorChange;
	var bool      LevelTextSmoothColorChange;
	var bool      DoshTextSmoothColorChange;
	var bool      KillsTextSmoothColorChange;
	var bool      AssistsTextSmoothColorChange;
	var bool      PingTextSmoothColorChange;

	Structdefaultproperties
	{
		// Box shapes
		ShapeServerNameBox              = 150
		ShapeGameInfoBox                = 151
		ShapeWaveInfoBox                = 0
		ShapePlayersCountBox            = 152
		ShapeHeaderBox                  = 150
		ShapeStateHealthBoxTopPlayer    = 0
		ShapeStateHealthBoxMidPlayer    = 0
		ShapeStateHealthBoxBottomPlayer = 0
		ShapePlayerBoxTopPlayer         = 121
		ShapePlayerBoxMidPlayer         = 121
		ShapePlayerBoxBottomPlayer      = 121
		ShapeStatsBoxTopPlayer          = 0
		ShapeStatsBoxMidPlayer          = 0
		ShapeStatsBoxBottomPlayer       = 0

		// Server box
		ServerNameBoxColor              = (R=75,  G=0,   B=0,   A=200)
		ServerNameTextColor             = (R=250, G=250, B=250, A=255)

		// Game info box
		GameInfoBoxColor                = (R=30,  G=30,  B=30,  A=200)
		GameInfoTextColor               = (R=250, G=250, B=250, A=255)

		// Wave info box
		WaveBoxColor                    = (R=10,  G=10,  B=10,  A=200)
		WaveTextColor                   = (R=250, G=250, B=250, A=255)

		// Player count box
		PlayerCountBoxColor             = (R=75,  G=0,   B=0,   A=200)
		PlayerCountTextColor            = (R=250, G=250, B=250, A=255)

		// Header box
		ListHeaderBoxColor              = (R=10,  G=10,  B=10,  A=200)
		ListHeaderTextColor             = (R=250, G=250, B=250, A=255)

		// State box
		StateBoxColorLobby              = (R=150, G=150, B=150, A=150)
		StateBoxColorReady              = (R=150, G=150, B=150, A=150)
		StateBoxColorNotReady           = (R=150, G=150, B=150, A=150)
		StateBoxColorSpectator          = (R=150, G=150, B=150, A=150)
		StateBoxColorDead               = (R=200, G=0,   B=0,   A=150)
		StateBoxColorNone               = (R=150, G=150, B=150, A=150)
		StateBoxColorHealthLow          = (R=200, G=50,  B=50,  A=150)
		StateBoxColorHealthMid          = (R=200, G=200, B=0,   A=150)
		StateBoxColorHealthHigh         = (R=0,   G=200, B=0,   A=150)

		// Player box
		PlayerOwnerBoxColor             = (R=100, G=10,  B=10,  A=150)
		PlayerBoxColor                  = (R=30,  G=30,  B=30,  A=150)

		// Stats box
		StatsOwnerBoxColor              = (R=10,  G=10,  B=10,  A=150)
		StatsBoxColor                   = (R=10,  G=10,  B=10,  A=150)

		// State text
		StateTextColorLobby             = (R=150, G=150, B=150, A=150)
		StateTextColorReady             = (R=150, G=150, B=150, A=150)
		StateTextColorNotReady          = (R=150, G=150, B=150, A=150)
		StateTextColorSpectator         = (R=150, G=150, B=150, A=150)
		StateTextColorDead              = (R=250, G=0,   B=0,   A=255)
		StateTextColorNone              = (R=250, G=250, B=250, A=255)
		StateTextColorHealthLow         = (R=250, G=250, B=250, A=255)
		StateTextColorHealthMid         = (R=250, G=250, B=250, A=255)
		StateTextColorHealthHigh        = (R=250, G=250, B=250, A=255)

		// Rank text
		RankTextColor                   = (R=250, G=250, B=250, A=255)

		// Player text
		PlayerNameTextColor             = (R=250, G=250, B=250, A=255)

		// Level text
		LevelTextColorLow               = (R=250, G=100, B=100, A=255)
		LevelTextColorMid               = (R=250, G=250, B=0,   A=255)
		LevelTextColorHigh              = (R=0,   G=250, B=0,   A=255)

		// Perk text
		ZedTextColor                    = (R=255, G=0,   B=0,   A=255)
		PerkNoneTextColor               = (R=250, G=250, B=250, A=255)
		PerkBerserkerTextColor          = (R=250, G=250, B=250, A=255)
		PerkCommandoTextColor           = (R=250, G=250, B=250, A=255)
		PerkSupportTextColor            = (R=250, G=250, B=250, A=255)
		PerkFieldMedicTextColor         = (R=250, G=250, B=250, A=255)
		PerkDemolitionistTextColor      = (R=250, G=250, B=250, A=255)
		PerkFirebugTextColor            = (R=250, G=250, B=250, A=255)
		PerkGunslingerTextColor         = (R=250, G=250, B=250, A=255)
		PerkSharpshooterTextColor       = (R=250, G=250, B=250, A=255)
		PerkSwatTextColor               = (R=250, G=250, B=250, A=255)
		PerkSurvivalistTextColor        = (R=250, G=250, B=250, A=255)

		// Dosh text
		DoshTextColorLow                = (R=250, G=250, B=100, A=255)
		DoshTextColorMid                = (R=250, G=250, B=100, A=255)
		DoshTextColorHigh               = (R=250, G=250, B=100, A=255)

		// Kills text
		KillsTextColorLow               = (R=250, G=250, B=250, A=255)
		KillsTextColorMid               = (R=250, G=250, B=250, A=255)
		KillsTextColorHigh              = (R=250, G=250, B=250, A=255)

		// Assists text
		AssistsTextColorLow             = (R=250, G=250, B=250, A=255)
		AssistsTextColorMid             = (R=250, G=250, B=250, A=255)
		AssistsTextColorHigh            = (R=250, G=250, B=250, A=255)

		// Ping text
		PingTextColorNone               = (R=250, G=250, B=250, A=255)
		PingTextColorLow                = (R=0,   G=250, B=0,   A=255)
		PingTextColorMid                = (R=250, G=250, B=0,   A=255)
		PingTextColorHigh               = (R=250, G=0,   B=0,   A=255)

		// Other settings
		ShowPingBars                    = true
	}
};

struct SystemRank
{
	var String RankName;
	var Color  RankColor;
	var Color  PlayerColor;

	structdefaultproperties
	{
		RankName      = ""
		RankColor     = (R=250, G=250, B=250, A=255)
		PlayerColor   = (R=250, G=250, B=250, A=255)
	}
};

struct Rank
{
	var int    RankID;
	var String RankName;
	var Color  RankColor;
	var Color  PlayerColor;
	var bool   OverrideAdmin;

	structdefaultproperties
	{
		RankID        = 0
		RankName      = ""
		RankColor     = (R=250, G=250, B=250, A=255)
		PlayerColor   = (R=250, G=250, B=250, A=255)
		OverrideAdmin = false
	}
};

struct RankRelation
{
	var int    RankID;
	var String ObjectID;
};

struct CachedRankRelation
{
	var String      RawID;
	var UniqueNetId UID;
	var Rank        Rank;
};

struct YAS_Settings
{
	var YAS_Style          Style;
	var YAS_SettingsPing   Ping;
	var YAS_SettingsLevel  Level;
	var YAS_SettingsHealth Health;
};

public static function Rank FromSystemRank(SystemRank SysRank)
{
	local Rank RV;

	RV.RankID        = 0;
	RV.RankName      = SysRank.RankName;
	RV.RankColor     = SysRank.RankColor;
	RV.PlayerColor   = SysRank.PlayerColor;
	RV.OverrideAdmin = false;

	return RV;
}

defaultproperties
{

}
