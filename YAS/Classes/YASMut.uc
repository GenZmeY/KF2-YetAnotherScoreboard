class YASMut extends KFMutator
	dependson(Types)
	config(YAS);

`include(Build.uci)
`include(Logger.uci)

const CurrentVersion = 2;

var config int ConfigVersion;

var private OnlineSubsystem Steamworks;

var private array<YASRepInfo> RepInfos;
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
	
	CreateRepInfo(C);
	
	Super.NotifyLogin(C);
}

function NotifyLogout(Controller C)
{
	`callstack();
	
	DestroyRepInfo(C);
	
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

private function CreateRepInfo(Controller C)
{
	local YASRepInfo RepInfo;
	
	`callstack();
	
	if (C == None) return;
	
	RepInfo = Spawn(class'YASRepInfo', C);
	
	RepInfo.Mut = Self;
	RepInfo.Settings = Settings;

	RepInfos.AddItem(RepInfo);
}

private function DestroyRepInfo(Controller C)
{
	local YASRepInfo RepInfo;

	`callstack();

	if (C == None) return;

	foreach RepInfos(RepInfo)
	{
		if (RepInfo.Owner == C)
		{
			RepInfos.RemoveItem(RepInfo);
			RepInfo.Destroy();
		}
	}
}

public function UpdatePlayerRank(UIDRankRelation Rel)
{
	local YASRepInfo RepInfo;
	local int Index;
	
	`callstack();
	
	Index = UIDRankRelationsActive.Find('UID', Rel.UID);
	if (Index != INDEX_NONE)
		UIDRankRelationsActive[Index] = Rel;
	else
		UIDRankRelationsActive.AddItem(Rel);
	
	foreach RepInfos(RepInfo)
		RepInfo.UpdateRankRelation(Rel);
}

public function AddPlayerRank(UIDRankRelation Rel)
{
	local YASRepInfo RepInfo;
	
	`callstack();
	
	foreach RepInfos(RepInfo)
		RepInfo.AddRankRelation(Rel);
}

defaultproperties
{

}