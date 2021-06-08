class Types extends Object;

struct ColorRGB
{
	var byte R, G, B;
	
	StructDefaultProperties
	{
		R=250
		G=250
		B=250
	}
};

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
