class ScoreboardExtMut extends KFMutator
	dependson(PlayerGroups, PlayerInfos)
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

var private array<UIDInfoEntry> UIDInfos;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	WorldInfo.Game.HUDType = class'ScoreboardExtHUD';
	InitConfig();
	LoadGroupPlayers();
}

function NotifyLogin(Controller C)
{
	AddPlayerInfo(C);
	Super.NotifyLogin(C);
}

function NotifyLogout(Controller C)
{
	RemovePlayerInfo(C);
	Super.NotifyLogout(C);
}

private function InitConfig()
{
	local PlayerGroupEntry ExampleGroup;
	local PlayerInfoEntry  ExamplePlayer;
	local SteamGroupEntry  ExampleSteamGroup;
	
	// Update from config version to current version if needed
	switch (ConfigVersion)
	{
		case 0: // which means there is no config right now
			SaveConfig(); // because I want the main settings to be at the beginning of the config :)
			
			// Default admin rank
			class'SystemAdminGroup'.default.Rank         = "Admin";
			class'SystemAdminGroup'.default.TextColor.R  = 250;
			class'SystemAdminGroup'.default.TextColor.G  = 0;
			class'SystemAdminGroup'.default.TextColor.B  = 0;
	
			// Default player rank
			class'SystemPlayerGroup'.default.Rank        = "Player";
			class'SystemPlayerGroup'.default.TextColor.R = 250;
			class'SystemPlayerGroup'.default.TextColor.G = 250;
			class'SystemPlayerGroup'.default.TextColor.B = 250;
			
			// Example rank for player(s)
			ExampleGroup.ID                              = 0;
			ExampleGroup.Rank                            = "SCE Creator";
			ExampleGroup.TextColor.R                     = 130;
			ExampleGroup.TextColor.G                     = 250;
			ExampleGroup.TextColor.B                     = 235;
			ExampleGroup.OverrideAdminRank               = true;
			class'PlayerGroups'.default.PlayerGroup.AddItem(ExampleGroup);

			// Example player
			ExamplePlayer.PlayerID                       = "76561198001617867"; // GenZmeY SteamID64
			ExamplePlayer.GroupID                        = ExampleGroup.ID;
			class'PlayerInfos'.default.PlayerInfo.AddItem(ExamplePlayer);
			
			// Example rank for steam group members
			ExampleGroup.ID                              = 1;
			ExampleGroup.Rank                            = "[MSK-GS]";
			ExampleGroup.TextColor.R                     = 130;
			ExampleGroup.TextColor.G                     = 250;
			ExampleGroup.TextColor.B                     = 130;
			ExampleGroup.OverrideAdminRank               = false;
			class'PlayerGroups'.default.PlayerGroup.AddItem(ExampleGroup);
			
			// Example steam group
			ExampleSteamGroup.SteamGroupID               = "103582791465384046"; // MSK-GS SteamID64
			ExampleSteamGroup.GroupID                    = ExampleGroup.ID;
			class'SteamGroups'.default.SteamGroup.AddItem(ExampleSteamGroup);

			class'SystemAdminGroup'.static.StaticSaveConfig();
			class'SystemPlayerGroup'.static.StaticSaveConfig();
			class'PlayerGroups'.static.StaticSaveConfig();
			class'PlayerInfos'.static.StaticSaveConfig();
			class'SteamGroups'.static.StaticSaveConfig();

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

private function LoadGroupPlayers()
{
	local PlayerInfoEntry Player;
	local OnlineSubsystem steamworks;
	local UIDInfoEntry UIDInfo;
	
	steamworks = class'GameEngine'.static.GetOnlineSubsystem();
	
	foreach class'PlayerInfos'.default.PlayerInfo(Player)
	{
		UIDInfo.GroupID = Player.GroupID;
		if (Len(Player.PlayerID) == UniqueIDLen && steamworks.StringToUniqueNetId(Player.PlayerID, UIDInfo.UID))
		{
			if (UIDInfos.Find('Uid', UIDInfo.UID) == INDEX_NONE)
				UIDInfos.AddItem(UIDInfo);
		}
		else if (Len(Player.PlayerID) == SteamIDLen && steamworks.Int64ToUniqueNetId(Player.PlayerID, UIDInfo.UID))
		{
			if (UIDInfos.Find('Uid', UIDInfo.UID) == INDEX_NONE)
				UIDInfos.AddItem(UIDInfo);
		}
		else `Log("[ScoreboardExt] WARN: Can't add player:"@Player.PlayerID);
	}
}

function AddPlayerInfo(Controller C)
{
	local KFPlayerController KFPC;
	local SClient RepClient;
	
	KFPC = KFPlayerController(C);
	if (KFPC == None)
		return;

	RepClient.RepInfo = Spawn(class'ScoreboardExtRepInfo', KFPC);
	RepClient.KFPC = KFPC;
	
	RepClients.AddItem(RepClient);
	
	RepClient.RepInfo.PlayerInfos = UIDInfos;
	RepClient.RepInfo.PlayerGroups = class'PlayerGroups'.default.PlayerGroup;
	RepClient.RepInfo.SystemAdminRank = class'SystemAdminGroup'.default.Rank;
	RepClient.RepInfo.SystemAdminColor = class'SystemAdminGroup'.default.TextColor;
	RepClient.RepInfo.SystemAdminApplyColorToFields = class'SystemAdminGroup'.default.ApplyColorToFields;
	RepClient.RepInfo.SystemPlayerRank = class'SystemPlayerGroup'.default.Rank;
	RepClient.RepInfo.SystemPlayerColor = class'SystemPlayerGroup'.default.TextColor;
	RepClient.RepInfo.SystemPlayerApplyColorToFields = class'SystemPlayerGroup'.default.ApplyColorToFields;
	
	RepClient.RepInfo.ClientStartReplication();
}

function RemovePlayerInfo(Controller C)
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