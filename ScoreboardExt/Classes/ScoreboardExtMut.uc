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
	
	// Update from config version to current version if needed
	switch (ConfigVersion)
	{
		case 0: // which means there is no config right now
			// Default admin
			class'SystemAdminGroup'.default.Rank     = "Admin";
			class'SystemAdminGroup'.default.Color.R  = 250;
			class'SystemAdminGroup'.default.Color.G  = 0;
			class'SystemAdminGroup'.default.Color.B  = 0;
			class'SystemAdminGroup'.static.StaticSaveConfig();
	
			// Default player
			class'SystemPlayerGroup'.default.Rank    = "Player";
			class'SystemPlayerGroup'.default.Color.R = 250;
			class'SystemPlayerGroup'.default.Color.G = 250;
			class'SystemPlayerGroup'.default.Color.B = 250;
			class'SystemPlayerGroup'.static.StaticSaveConfig();
			
			// Example group
			ExampleGroup.ID                          = 0;
			ExampleGroup.Rank                        = "Scoreboard Creator";
			ExampleGroup.Color.R                     = 130;
			ExampleGroup.Color.G                     = 250;
			ExampleGroup.Color.B                     = 235;
			ExampleGroup.OverrideAdminRank           = true;
			class'PlayerGroups'.default.PlayerGroup.AddItem(ExampleGroup);
			class'PlayerGroups'.static.StaticSaveConfig();

			// Example player
			ExamplePlayer.PlayerID                   = "76561198001617867"; // GenZmeY SteamID64
			ExamplePlayer.GroupID                    = ExampleGroup.ID;
			class'PlayerInfos'.default.PlayerInfo.AddItem(ExamplePlayer);
			class'PlayerInfos'.static.StaticSaveConfig();

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

	ConfigVersion = CurrentVersion;
	SaveConfig();
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
	if (KFPC == None || !KFPC.bIsPlayer)
		return;

	RepClient.RepInfo = Spawn(class'ScoreboardExtRepInfo', KFPC);
	RepClient.KFPC = KFPC;
	
	RepClients.AddItem(RepClient);
	
	RepClient.RepInfo.ClientInit(
		class'PlayerGroups'.default.PlayerGroup,
		UIDInfos,
		class'SystemAdminGroup'.default.Rank,
		class'SystemAdminGroup'.default.Color,
		class'SystemAdminGroup'.default.ApplyColorToFields,
		class'SystemPlayerGroup'.default.Rank,
		class'SystemPlayerGroup'.default.Color,
		class'SystemPlayerGroup'.default.ApplyColorToFields);
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