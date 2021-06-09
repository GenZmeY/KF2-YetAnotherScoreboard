class ScoreboardExtMut extends KFMutator
	dependson(Types)
	config(ScoreboardExt);

const SteamIDLen     = 17;
const UniqueIDLen    = 18;

const CurrentVersion = 1;

var config int ConfigVersion;

struct SClient
{
	var ScoreboardExtRepInfo RepInfo;
	var KFPlayerController KFPC;
};

var private array<SClient> RepClients;
var private array<UIDRankRelation> UIDRelations;
var private SCESettings Settings;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	WorldInfo.Game.HUDType = class'ScoreboardExtHUD';
	
	InitConfig();
	LoadPlayerRelations();
	
	Settings.Style  = class'ScoreboardStyle'.static.Settings();
	Settings.Admin  = class'SystemAdminRank'.static.Settings();
	Settings.Player = class'SystemPlayerRank'.static.Settings();
	Settings.HP     = class'ThresholdsHP'.static.Settings();
	Settings.Ping   = class'ThresholdsPing'.static.Settings();
	Settings.Level  = class'ThresholdsLevel'.static.Settings();
}

function NotifyLogin(Controller C)
{
	AddPlayer(C);
	Super.NotifyLogin(C);
}

function NotifyLogout(Controller C)
{
	RemovePlayer(C);
	Super.NotifyLogout(C);
}

private function InitConfig()
{
	local RankInfo ExampleRank;
	local PlayerRankRelation ExamplePlayer;
	local SteamGroupRankRelation ExampleSteamGroup;
	
	// Update from config version to current version if needed
	switch (ConfigVersion)
	{
		case 0: // which means there is no config right now
			SaveConfig(); // because I want the main settings to be at the beginning of the config :)
			
			class'SystemAdminRank'.static.WriteSettings(class'SystemAdminRank'.static.DefaultSettings());
			class'SystemPlayerRank'.static.WriteSettings(class'SystemPlayerRank'.static.DefaultSettings());
			class'ScoreboardStyle'.static.WriteSettings(class'ScoreboardStyle'.static.DefaultSettings());
			class'ThresholdsHP'.static.WriteSettings(class'ThresholdsHP'.static.DefaultSettings());
			class'ThresholdsPing'.static.WriteSettings(class'ThresholdsPing'.static.DefaultSettings());
			class'ThresholdsLevel'.static.WriteSettings(class'ThresholdsLevel'.static.DefaultSettings());
			
			// Example rank for player(s)
			ExampleRank.ID                              = 0;
			ExampleRank.Rank                            = "SCE Creator";
			ExampleRank.TextColor.R                     = 130;
			ExampleRank.TextColor.G                     = 250;
			ExampleRank.TextColor.B                     = 235;
			ExampleRank.OverrideAdminRank               = true;
			class'CustomRanks'.default.Rank.AddItem(ExampleRank);

			// Example player
			ExamplePlayer.PlayerID                      = "76561198001617867"; // GenZmeY SteamID64
			ExamplePlayer.RankID                        = ExampleRank.ID;
			class'PlayerRankRelations'.default.Relation.AddItem(ExamplePlayer);
			
			// Example rank for steam group members
			ExampleRank.ID                              = 1;
			ExampleRank.Rank                            = "[MSK-GS]";
			ExampleRank.TextColor.R                     = 130;
			ExampleRank.TextColor.G                     = 250;
			ExampleRank.TextColor.B                     = 130;
			ExampleRank.OverrideAdminRank               = false;
			class'CustomRanks'.default.Rank.AddItem(ExampleRank);
			
			// Example steam group
			ExampleSteamGroup.SteamGroupID              = "103582791465384046"; // MSK-GS SteamID64
			ExampleSteamGroup.RankID                    = ExampleRank.ID;
			class'SteamGroupRankRelations'.default.Relation.AddItem(ExampleSteamGroup);

			class'CustomRanks'.static.StaticSaveConfig();
			class'PlayerRankRelations'.static.StaticSaveConfig();
			class'SteamGroupRankRelations'.static.StaticSaveConfig();
		case 2147483647:
			`log("[ScoreboardExt] Config updated to version"@CurrentVersion);
			break;
		case CurrentVersion:
			`log("[ScoreboardExt] Config is up-to-date");
			break;
		default:
			`log("[ScoreboardExt] Warn: The config version is higher than the current version (are you using an old mutator?)");
			`log("[ScoreboardExt] Warn: Config version is"@ConfigVersion@"but current version is"@CurrentVersion);
			`log("[ScoreboardExt] Warn: The config version will be changed to "@CurrentVersion);
			break;
	}

	if (ConfigVersion != CurrentVersion)
	{
		ConfigVersion = CurrentVersion;
		SaveConfig();
	}
}

private function LoadPlayerRelations()
{
	local PlayerRankRelation Player;
	local OnlineSubsystem steamworks;
	local UIDRankRelation UIDInfo;
	
	steamworks = class'GameEngine'.static.GetOnlineSubsystem();
	
	foreach class'PlayerRankRelations'.default.Relation(Player)
	{
		UIDInfo.RankID = Player.RankID;
		if (Len(Player.PlayerID) == UniqueIDLen && steamworks.StringToUniqueNetId(Player.PlayerID, UIDInfo.UID))
		{
			if (UIDRelations.Find('Uid', UIDInfo.UID) == INDEX_NONE)
				UIDRelations.AddItem(UIDInfo);
		}
		else if (Len(Player.PlayerID) == SteamIDLen && steamworks.Int64ToUniqueNetId(Player.PlayerID, UIDInfo.UID))
		{
			if (UIDRelations.Find('Uid', UIDInfo.UID) == INDEX_NONE)
				UIDRelations.AddItem(UIDInfo);
		}
		else `Log("[ScoreboardExt] WARN: Can't add player:"@Player.PlayerID);
	}
}

function AddPlayer(Controller C)
{
	local KFPlayerController KFPC;
	local SClient RepClient;
	
	KFPC = KFPlayerController(C);
	if (KFPC == None)
		return;

	RepClient.RepInfo = Spawn(class'ScoreboardExtRepInfo', KFPC);
	RepClient.KFPC = KFPC;
	
	RepClients.AddItem(RepClient);
	
	RepClient.RepInfo.PlayerRankRelations = UIDRelations;
	RepClient.RepInfo.CustomRanks = class'CustomRanks'.default.Rank;
	RepClient.RepInfo.Settings = Settings;
	
	RepClient.RepInfo.ClientStartReplication();
}

function RemovePlayer(Controller C)
{
	local KFPlayerController KFPC;
	local int Index;

	KFPC = KFPlayerController(C);
	if (KFPC == None)
		return;

	Index = RepClients.Find('KFPC', KFPC);
	if (Index == INDEX_NONE)
		return;

	if (RepClients[Index].RepInfo != None)
		RepClients[Index].RepInfo.Destroy();
	
	RepClients.Remove(Index, 1);
}

DefaultProperties
{

}