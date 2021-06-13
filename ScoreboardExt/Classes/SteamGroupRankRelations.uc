class SteamGroupRankRelations extends Object
	dependson(Types)
	config(ScoreboardExt);

`include(Build.uci)
`include(Logger.uci)

var config array < RankRelation> Relation;

DefaultProperties
{

}