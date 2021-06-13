class CustomRanks extends Object
	dependson(Types)
	config(ScoreboardExt);
	
`include(Build.uci)
`include(Logger.uci)

var config array < RankInfo> Rank;
