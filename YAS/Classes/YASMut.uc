class YASMut extends KFMutator
	dependson(Types)
	config(YAS);

`include(Build.uci)
`include(Logger.uci)

const CurrentVersion = 1;

var config int ConfigVersion;

var private OnlineSubsystem Steamworks;

struct SClient
{
	var YASRepInfo RepInfo;
	var KFPlayerController KFPC;
};

var private array<SClient> RepClients;
var private array<UIDRankRelation> UIDRankRelationsPlayers;
var private array<UIDRankRelation> UIDRankRelationsSteamGroups;
var private array<UIDRankRelation> UIDRankRelationsActive;
var private YASSettings Settings;

function PostBeginPlay()
{
	`callstack();
	
	Super.PostBeginPlay();
	
	WorldInfo.Game.HUDType = class'YASHUD';
	Steamworks = class'GameEngine'.static.GetOnlineSubsystem();
	
	InitConfig();
	
	LoadRelations();
	
	Settings.Style  = class'ScoreboardStyle'.static.Settings();
	Settings.Admin  = class'SystemAdminRank'.static.Settings();
	Settings.Player = class'SystemPlayerRank'.static.Settings();
	Settings.State  = class'DynamicStateColor'.static.Settings();
	Settings.Ping   = class'DynamicPingColor'.static.Settings();
	Settings.Level  = class'DynamicLevelColor'.static.Settings();
}

function NotifyLogin(Controller C)
{
	`callstack();
	
	AddPlayer(C);
	Super.NotifyLogin(C);
}

function NotifyLogout(Controller C)
{
	`callstack();
	
	RemovePlayer(C);
	Super.NotifyLogout(C);
}

private function bool IsUID(String ID)
{
	`callstack();
	
	return (Left(ID, 2) ~= "0x");
}

private function InitConfig()
{
	local RankInfo ExampleRank;
	local RankRelation ExamplePlayer;
	local RankRelation ExampleSteamGroup;
	
	`callstack();
	
	// Update from config version to current version if needed
	switch (ConfigVersion)
	{
		case 0: // which means there is no config right now
			SaveConfig(); // because I want the main settings to be at the beginning of the config :)
			
			class'SystemAdminRank'.static.WriteSettings(class'SystemAdminRank'.static.DefaultSettings());
			class'SystemPlayerRank'.static.WriteSettings(class'SystemPlayerRank'.static.DefaultSettings());
			class'ScoreboardStyle'.static.WriteSettings(class'ScoreboardStyle'.static.DefaultSettings());
			class'DynamicStateColor'.static.WriteSettings(class'DynamicStateColor'.static.DefaultSettings());
			class'DynamicPingColor'.static.WriteSettings(class'DynamicPingColor'.static.DefaultSettings());
			class'DynamicLevelColor'.static.WriteSettings(class'DynamicLevelColor'.static.DefaultSettings());
			
			// Example rank for player(s)
			ExampleRank.ID                              = 0;
			ExampleRank.Rank                            = "YAS Creator";
			ExampleRank.TextColor.R                     = 130;
			ExampleRank.TextColor.G                     = 250;
			ExampleRank.TextColor.B                     = 235;
			ExampleRank.OverrideAdminRank               = true;
			class'CustomRanks'.default.Rank.AddItem(ExampleRank);

			// Example player
			ExamplePlayer.ObjectID                      = "76561198001617867"; // GenZmeY SteamID64
			ExamplePlayer.RankID                        = ExampleRank.ID;
			class'PlayerRankRelations'.default.Relation.AddItem(ExamplePlayer);
			
			// Example rank for steam group members
			ExampleRank.ID                              = 1;
			ExampleRank.Rank                            = "MSK-GS";
			ExampleRank.TextColor.R                     = 130;
			ExampleRank.TextColor.G                     = 250;
			ExampleRank.TextColor.B                     = 130;
			ExampleRank.OverrideAdminRank               = false;
			class'CustomRanks'.default.Rank.AddItem(ExampleRank);
			
			// Example steam group
			ExampleSteamGroup.ObjectID                  = "103582791465384046"; // MSK-GS SteamID64
			ExampleSteamGroup.RankID                    = ExampleRank.ID;
			class'SteamGroupRankRelations'.default.Relation.AddItem(ExampleSteamGroup);

			class'CustomRanks'.static.StaticSaveConfig();
			class'PlayerRankRelations'.static.StaticSaveConfig();
			class'SteamGroupRankRelations'.static.StaticSaveConfig();
			
		case 2147483647:
			`info("Config updated to version"@CurrentVersion);
			break;
			
		case CurrentVersion:
			`info("Config is up-to-date");
			break;
			
		default:
			`warning("The config version is higher than the current version (are you using an old mutator?)");
			`warning("Config version is"@ConfigVersion@"but current version is"@CurrentVersion);
			`warning("The config version will be changed to "@CurrentVersion);
			break;
	}

	if (ConfigVersion != CurrentVersion)
	{
		ConfigVersion = CurrentVersion;
		SaveConfig();
	}
}

private function LoadRelations()
{
	local RankRelation Player, SteamGroup;
	local UIDRankRelation UIDInfo;
	
	`callstack();
	
	foreach class'PlayerRankRelations'.default.Relation(Player)
	{
		UIDInfo.RankID = Player.RankID;
		if (IsUID(Player.ObjectID) && Steamworks.StringToUniqueNetId(Player.ObjectID, UIDInfo.UID))
		{
			if (UIDRankRelationsPlayers.Find('Uid', UIDInfo.UID) == INDEX_NONE)
				UIDRankRelationsPlayers.AddItem(UIDInfo);
		}
		else if (Steamworks.Int64ToUniqueNetId(Player.ObjectID, UIDInfo.UID))
		{
			if (UIDRankRelationsPlayers.Find('Uid', UIDInfo.UID) == INDEX_NONE)
				UIDRankRelationsPlayers.AddItem(UIDInfo);
		}
		else `warning("Can't add player:"@Player.ObjectID);
	}
	
	foreach class'SteamGroupRankRelations'.default.Relation(SteamGroup)
	{
		UIDInfo.RankID = SteamGroup.RankID;
		if (IsUID(SteamGroup.ObjectID) && Steamworks.StringToUniqueNetId(SteamGroup.ObjectID, UIDInfo.UID))
		{
			if (UIDRankRelationsPlayers.Find('Uid', UIDInfo.UID) == INDEX_NONE)
				UIDRankRelationsPlayers.AddItem(UIDInfo);
		}
		else if (Steamworks.Int64ToUniqueNetId(SteamGroup.ObjectID, UIDInfo.UID))
		{
			if (UIDRankRelationsSteamGroups.Find('Uid', UIDInfo.UID) == INDEX_NONE)
				UIDRankRelationsSteamGroups.AddItem(UIDInfo);
		}
		else `warning("Can't add steamgroup:"@SteamGroup.ObjectID);
	}
}

private function AddPlayer(Controller C)
{
	local KFPlayerController KFPC;
	local UIDRankRelation Relation;
	local SClient RepClient, RepClientNew;
	
	`callstack();
	
	KFPC = KFPlayerController(C);
	if (KFPC == None)
		return;

	RepClientNew.KFPC = KFPC;
	RepClientNew.RepInfo = Spawn(class'YASRepInfo', KFPC);
	
	RepClientNew.RepInfo.Mut = Self;
	RepClientNew.RepInfo.CustomRanks = class'CustomRanks'.default.Rank;
	RepClientNew.RepInfo.SteamGroupRelations = UIDRankRelationsSteamGroups;
	RepClientNew.RepInfo.Settings = Settings;
	RepClientNew.RepInfo.RankRelation.UID = KFPC.PlayerReplicationInfo.UniqueId;
	RepClientNew.RepInfo.RankRelation.RankID = UIDRankRelationsPlayers.Find('UID', RepClientNew.RepInfo.RankRelation.UID);
	
	RepClients.AddItem(RepClientNew);
	
	foreach UIDRankRelationsActive(Relation)
		RepClientNew.RepInfo.AddRankRelation(Relation);
	
	RepClientNew.RepInfo.StartFirstTimeReplication();
	
	if (RepClientNew.RepInfo.RankRelation.RankID != INDEX_NONE)
	{
		UIDRankRelationsActive.AddItem(RepClientNew.RepInfo.RankRelation);
		foreach RepClients(RepClient)
			RepClient.RepInfo.AddRankRelation(RepClientNew.RepInfo.RankRelation);
	}
}

private function RemovePlayer(Controller C)
{
	local KFPlayerController KFPC;
	local int Index, i;
	local UniqueNetId UID;

	`callstack();

	KFPC = KFPlayerController(C);
	if (KFPC == None)
		return;

	UID = KFPC.PlayerReplicationInfo.UniqueId;
	Index = UIDRankRelationsActive.Find('UID', UID);
	if (Index != INDEX_NONE)
		for (i = 0; i < UIDRankRelationsActive.Length; ++i)
			if (Index != i)
				RepClients[i].RepInfo.RemoveRankRelation(UIDRankRelationsActive[Index]);

	Index = RepClients.Find('KFPC', KFPC);
	if (Index == INDEX_NONE)
		return;

	if (RepClients[Index].RepInfo != None)
		RepClients[Index].RepInfo.Destroy();
	
	RepClients.Remove(Index, 1);
}

public function UpdatePlayerRank(UIDRankRelation Rel)
{
	local SClient RepClient;
	local int Index;
	
	`callstack();
	
	Index = UIDRankRelationsActive.Find('UID', Rel.UID);
	if (Index != INDEX_NONE)
		UIDRankRelationsActive[Index] = Rel;
	else
		UIDRankRelationsActive.AddItem(Rel);
	
	foreach RepClients(RepClient)
		RepClient.RepInfo.UpdateRankRelation(Rel);
}

public function AddPlayerRank(UIDRankRelation Rel)
{
	local SClient RepClient;
	
	`callstack();
	
	foreach RepClients(RepClient)
		RepClient.RepInfo.AddRankRelation(Rel);
}

DefaultProperties
{

}