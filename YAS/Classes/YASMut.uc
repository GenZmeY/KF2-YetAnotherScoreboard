class YASMut extends KFMutator
	dependson(Types)
	config(YAS);

`include(Build.uci)
`include(Logger.uci)

const CurrentVersion = 2;

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
	Settings.Health = class'SettingsHealth'.static.Settings();
	Settings.Armor  = class'SettingsArmor'.static.Settings();
	Settings.Ping   = class'SettingsPing'.static.Settings();
	Settings.Level  = class'SettingsLevel'.static.Settings();
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
	`callstack();
	
	if (ConfigVersion == 0) SaveConfig(); // because I want the main settings to be at the beginning of the config :)
	
	class'ScoreboardStyle'.static.InitConfig(ConfigVersion);
	class'SystemAdminRank'.static.InitConfig(ConfigVersion);
	class'SystemPlayerRank'.static.InitConfig(ConfigVersion);
	class'SettingsHealth'.static.InitConfig(ConfigVersion);
	class'SettingsArmor'.static.InitConfig(ConfigVersion);
	class'SettingsPing'.static.InitConfig(ConfigVersion);
	class'SettingsLevel'.static.InitConfig(ConfigVersion);
	class'CustomRanks'.static.InitConfig(ConfigVersion);
	class'PlayerRankRelations'.static.InitConfig(ConfigVersion);
	class'SteamGroupRankRelations'.static.InitConfig(ConfigVersion);

	switch (ConfigVersion)
	{
		case 0:
		case 1:
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