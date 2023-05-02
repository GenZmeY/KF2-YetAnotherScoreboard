class Ranks extends Object
	dependson(YAS_Types)
	config(YAS);

var public config SystemRank  Player;
var public config SystemRank  Admin;
var public config Array<Rank> Rank;

public static function InitConfig(int Version, int LatestVersion)
{
	switch (Version)
	{
		case `NO_CONFIG:
			ApplyDefault();

		default: break;
	}

	if (LatestVersion != Version)
	{
		StaticSaveConfig();
	}
}

private static function ApplyDefault()
{
	local Rank NewRank;

	// System ranks:
	default.Player.RankName    = "";
	default.Player.RankColor   = MakeColor(250, 250, 250, 250);
	default.Player.PlayerColor = MakeColor(250, 250, 250, 250);

	default.Admin.RankName    = "Admin";
	default.Admin.RankColor   = MakeColor(250, 0, 0, 250);
	default.Admin.PlayerColor = MakeColor(250, 0, 0, 250);

	default.Rank.Length = 0;

	// Example custom rank:
	NewRank.RankID      = 1;
	NewRank.RankName    = "Man of culture";
	NewRank.RankColor   = MakeColor(0, 250, 0, 250);
	NewRank.PlayerColor = MakeColor(250, 250, 250, 250);

	default.Rank.AddItem(NewRank);
}

defaultproperties
{

}