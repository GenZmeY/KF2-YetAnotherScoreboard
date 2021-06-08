class Types extends Object;

struct SCESettings
{
	string    SystemAdminRank;
	ColorRGBA SystemAdminColor;
	Fields    SystemAdminApplyColorToFields;

	string    SystemPlayerRank;
	ColorRGBA SystemPlayerColor;
	Fields    SystemPlayerApplyColorToFields;
	
	int HP_Low;
	int HP_High;

	int Ping_Low;
	int Ping_High;

	int Normal_Low;
	int Normal_High;
	int Hard_Low;
	int Hard_High;
	int Suicide_Low;
	int Suicide_High;
	int HellOnEarth_Low;
	int HellOnEarth_High;
	
	StructDefaultProperties
	{
		SystemAdminRank="Admin"
		SystemAdminColor=(R=250,G=0,B=0)
		SystemAdminApplyColorToFields=(Rank=True,Player=True,Perk=False,Dosh=False,Kills=False,Assists=False,Health=False,Ping=False)

		SystemPlayerRank="Player"
		SystemPlayerColor=(R=250,G=250,B=250)
		SystemPlayerApplyColorToFields=(Rank=True,Player=True,Perk=False,Dosh=False,Kills=False,Assists=False,Health=False,Ping=False)
		
		HP_Low=40
		HP_High=80

		Ping_Low=60
		Ping_High=120;

		Normal_Low=0;
		Normal_High=0;
		Hard_Low=5;
		Hard_High=15;
		Suicide_Low=15;
		Suicide_High=20;
		HellOnEarth_Low=20;
		HellOnEarth_High=25;
	}
};

struct SCEStyle
{
	ColorRGBA ServerNameBoxColor;
	ColorRGBA ServerNameTextColor
	
	ColorRGBA GameInfoBoxColor;
	ColorRGBA GameInfoTextColor;
	
	ColorRGBA WaveBoxColor;
	ColorRGBA WaveTextColor;
	
	ColorRGBA PlayerCountBoxColor;
	ColorRGBA PlayerCountTextColor;
	
	ColorRGBA ListHeaderBoxColor;
	ColorRGBA ListHeaderTextColor;
	
	ColorRGBA LeftHPBoxColorNone;
	ColorRGBA LeftHPBoxColorDead;
	ColorRGBA LeftHPBoxColorLow;
	ColorRGBA LeftHPBoxColorMid;
	ColorRGBA LeftHPBoxColorHigh;
	
	ColorRGBA PlayerOwnerBoxColor;
	ColorRGBA PlayerBoxColor;
	ColorRGBA StatsBoxColor;
	
	ColorRGBA RankTextColor;
	ColorRGBA ZedTextColor;
	ColorRGBA PerkTextColor;
	ColorRGBA LevelTextColor;
	ColorRGBA AvatarBorderColor;
	ColorRGBA PlayerNameTextColor;
	ColorRGBA KillsTextColor;
	ColorRGBA AssistsTextColor;
	ColorRGBA DoshTextColor;
	
	ColorRGBA StateTextColorLobby;
	ColorRGBA StateTextColorReady;
	ColorRGBA StateTextColorNotReady;
	ColorRGBA StateTextColorNone;
	ColorRGBA StateTextColorSpectator;
	ColorRGBA StateTextColorDead;
	ColorRGBA StateTextColorLowHP;
	ColorRGBA StateTextColorMidHP;
	ColorRGBA StateTextColorHighHP;
	
	ColorRGBA PingTextColorNone;
	ColorRGBA PingTextColorLow;
	ColorRGBA PingTextColorMid
	ColorRGBA PingTextColorHigh;
	
	StructDefaultProperties
	{
		ServerNameBoxColor=(R=75,G=0,B=0,A=200)
		ServerNameTextColor=(R=250,G=250,B=250,A=255)
		
		GameInfoBoxColor=(R=30,G=30,B=30,A=200)
		GameInfoTextColor=(R=250,G=250,B=250,A=255)
		
		WaveBoxColor=(R=10,G=10,B=10,A=200)
		WaveTextColor=(R=250,G=250,B=250,A=255)
		
		PlayerCountBoxColor=(R=75,G=0,B=0,A=200)
		PlayerCountTextColor=(R=250,G=250,B=250,A=255)
		
		ListHeaderBoxColor=(R=10,G=10,B=10,A=200)
		ListHeaderTextColor=(R=250,G=250,B=250,A=255)
		
		LeftHPBoxColorNone=(R=150,G=150,B=150,A=150)
		LeftHPBoxColorDead=(R=200,G=0,B=0,A=150)
		LeftHPBoxColorLow=(R=200,G=50,B=50,A=150)
		LeftHPBoxColorMid=(R=200,G=200,B=0,A=150)
		LeftHPBoxColorHigh=(R=0,G=200,B=0,A=150)
		
		PlayerOwnerBoxColor=(R=100,G=10,B=10,A=150)
		PlayerBoxColor=(R=30,G=30,B=30,A=150)
		StatsBoxColor=(R=10,G=10,B=10,A=150)
		
		RankTextColor=(R=250,G=250,B=250,A=255)
		ZedTextColor=(R=255,G=0,B=0,A=255)
		PerkTextColor=(R=250,G=250,B=250,A=255)
		LevelTextColor=(R=250,G=250,B=250,A=255)
		AvatarBorderColor=(R=255,G=255,B=255,A=255)
		PlayerNameColor=(R=250,G=250,B=250,A=255)
		KillsTextColor=(R=250,G=250,B=250,A=255)
		AssistsTextColor=(R=250,G=250,B=250,A=255)
		DoshTextColor=(R=250,G=250,B=100,A=255)
		
		StateTextColorLobby=(R=150,G=150,B=150,A=150)
		StateTextColorReady=(R=150,G=150,B=150,A=150)
		StateTextColorNotReady=(R=150,G=150,B=150,A=150)
		StateTextColorNone=(R=150,G=150,B=150,A=150)
		StateTextColorSpectator=(R=150,G=150,B=150,A=150)
		StateTextColorDead=(R=250,G=0,B=0,A=255)
		StateTextColorLowHP=(R=250,G=100,B=100,A=255)
		StateTextColorMidHP=(R=250,G=250,B=0,A=255)
		StateTextColorHighHP=(R=0,G=250,B=0,A=255)
		
		PingTextColorNone=(R=250,G=250,B=250,A=255)
		PingTextColorLow=(R=0,G=250,B=0,A=255)
		PingTextColorMid=(R=250,G=250,B=0,A=255)
		PingTextColorHigh=(R=250,G=0,B=0,A=255)
	}
}

struct ColorRGBA
{
	var byte R, G, B, A;
	
	StructDefaultProperties
	{
		R=250
		G=250
		B=250
		A=255
	}
};

struct Fields
{
	var bool Rank;
	var bool Player;
	var bool Perk;
	var bool Dosh;
	var bool Kills;
	var bool Assists;
	var bool Health;
	var bool Ping;
	
	StructDefaultProperties
	{
		Rank    = true;
		Player  = true;
		Perk    = false;
		Dosh    = false;
		Kills   = false;
		Assists = false;
		Health  = false;
		Ping    = false;
	}
};

struct RankInfo
{
	var int       ID;
	var string    Rank;
	var ColorRGB  TextColor;
	var bool      OverrideAdminRank;
	var Fields    ApplyColorToFields;
};

struct SteamGroupRankRelation
{
	var string SteamGroupID;
	var int    RankID;
};

struct PlayerRankRelation
{
	var string PlayerID;
	var int    RankID;
};

struct UIDRankRelation
{
	var UniqueNetId UID;
	var int RankID;
};
