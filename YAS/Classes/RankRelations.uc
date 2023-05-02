class RankRelations extends Object
	dependson(YAS_Types)
	config(YAS);

var public config Array<RankRelation> Relation;

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
	local RankRelation NewRankRelation;

	default.Relation.Length = 0;

	// Example relation:
	NewRankRelation.RankID   = 1; // "Man of culture" ID
	NewRankRelation.ObjectID = "103582791429670253"; // HENTAI Group SteamID64

	default.Relation.AddItem(NewRankRelation);
}

defaultproperties
{

}