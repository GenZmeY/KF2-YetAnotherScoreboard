class CustomRanks extends Object
	dependson(Types)
	config(YAS);
	
`include(Build.uci)
`include(Logger.uci)

var config array<RankInfo> Rank;

public static function InitConfig(int ConfigVersion)
{
	local RankInfo ExampleRank;
	
	`callstack_static("InitConfig");
	
	switch (ConfigVersion)
	{
		case 0:
			// Example rank for player(s)
			ExampleRank.ID                              = 0;
			ExampleRank.Rank                            = "YAS Creator";
			ExampleRank.TextColor.R                     = 130;
			ExampleRank.TextColor.G                     = 250;
			ExampleRank.TextColor.B                     = 235;
			ExampleRank.OverrideAdminRank               = false;
			default.Rank.AddItem(ExampleRank);
			
			// Example rank for steam group members
			ExampleRank.ID                              = 1;
			ExampleRank.Rank                            = "MSK-GS";
			ExampleRank.TextColor.R                     = 130;
			ExampleRank.TextColor.G                     = 250;
			ExampleRank.TextColor.B                     = 130;
			ExampleRank.OverrideAdminRank               = false;
			default.Rank.AddItem(ExampleRank);
				
		case 2147483647:
			StaticSaveConfig();
	}
}

DefaultProperties
{

}