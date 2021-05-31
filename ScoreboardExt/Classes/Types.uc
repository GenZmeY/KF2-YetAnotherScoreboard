class Types extends Object;

struct TextColor
{
	var byte R, G, B;
	
	StructDefaultProperties
	{
		R=250
		G=250
		B=250
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

struct PlayerGroupEntry
{
	var int       ID;
	var string    Rank;
	var TextColor Color;
	var bool      OverrideAdminRank;
	var Fields    ApplyColorToFields;
};

struct PlayerInfoEntry
{
	var string PlayerID;
	var int    GroupID;
};

struct UIDInfoEntry
{
	var UniqueNetId UID;
	var int GroupID;
};
