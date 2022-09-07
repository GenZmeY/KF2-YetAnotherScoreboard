class YAS extends Info
	config(YAS);

const LatestVersion = 1;

const CfgRanks         = class'Ranks';
const CfgRankRelations = class'RankRelations';

const MatchUID             = "0x";
const MatchPlayerSteamID64 = "76561";
const MatchGroupSteamID64  = "10358279";

var private config int        Version;
var private config E_LogLevel LogLevel;
var private config int        UpdateInterval;

var private KFGameInfo            KFGI;
var private KFGameInfo_Survival   KFGIS;
var private KFGameInfo_Endless    KFGIE;
var private KFGameReplicationInfo KFGRI;
var private KFOnlineGameSettings  KFOGS;

var private OnlineSubsystemSteamworks OSS;

var private Array<YAS_RepInfo> RepInfos;

var private Array<CachedRankRelation> PlayerRelations;
var private Array<CachedRankRelation> GroupRelations;

public simulated function bool SafeDestroy()
{
	`Log_Trace();
	
	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	`Log_Trace();
	
	if (WorldInfo.NetMode == NM_Client)
	{
		`Log_Fatal("NetMode == NM_Client");
		SafeDestroy();
		return;
	}
	
	Super.PreBeginPlay();
	
	PreInit();
}

public event PostBeginPlay()
{
	`Log_Trace();
	
	if (bPendingDelete || bDeleteMe) return;
	
	Super.PostBeginPlay();
	
	PostInit();
}

private function PreInit()
{
	`Log_Trace();
	
	if (Version == `NO_CONFIG)
	{
		LogLevel = LL_Info;
		UpdateInterval = 1;
		SaveConfig();
	}
	
	CfgRanks.static.InitConfig(Version, LatestVersion);
	CfgRankRelations.static.InitConfig(Version, LatestVersion);
	
	switch (Version)
	{
		case `NO_CONFIG:
			`Log_Info("Config created");
			
		case MaxInt:
			`Log_Info("Config updated to version" @ LatestVersion);
			break;
			
		case LatestVersion:
			`Log_Info("Config is up-to-date");
			break;
			
		default:
			`Log_Warn("The config version is higher than the current version (are you using an old mutator?)");
			`Log_Warn("Config version is" @ Version @ "but current version is" @ LatestVersion);
			`Log_Warn("The config version will be changed to" @ LatestVersion);
			break;
	}
	
	if (LatestVersion != Version)
	{
		Version = LatestVersion;
		SaveConfig();
	}

	if (LogLevel == LL_WrongLevel)
	{
		LogLevel = LL_Info;
		`Log_Warn("Wrong 'LogLevel', return to default value");
		SaveConfig();
	}
	`Log_Base("LogLevel:" @ LogLevel);
	
	OSS = OnlineSubsystemSteamworks(class'GameEngine'.static.GetOnlineSubsystem());
	if (OSS != None)
	{
		InitRanks();
	}
	else
	{
		`Log_Error("Can't get online subsystem!");
	}
}

private function InitRanks() // TODO: Ref
{
	local Array<RankRelation> Relations;
	local Array<Rank> Ranks;
	local RankRelation Relation;
	local Rank Rank;
	local CachedRankRelation CachedRankRelation;
	
	Ranks     = CfgRanks.default.Ranks;
	Relations = CfgRankRelations.default.Relations;
	
	foreach Relations(Relation)
	{
		if (IsUID(Relation.ObjectID) || IsPlayerSteamID64(Relation.ObjectID))
		{
			if (AnyToUID(Relation.ObjectID, CachedRankRelation.UID))
			{
				CachedRankRelation.RawID = Relation.ObjectID;
				
				foreach Ranks(Rank)
				{
					if (Rank.RankID == Relation.RankID)
					{
						CachedRankRelation.Rank = Rank;
						break;
					}
				}
				
				if (CachedRankRelation.Rank.RankID > 0)
				{
					PlayerRelations.AddItem(CachedRankRelation);
				}
				else
				{
					`Log_Warn("Rank with ID" @ Relation.RankID @ "not found");
				}
			}
			else
			{
				`Log_Warn("Can't convert to UniqueNetID:" @ Relation.ObjectID);
			}
		}
		else if (IsGroupSteamID64(Relation.ObjectID))
		{
			if (AnyToUID(Relation.ObjectID, CachedRankRelation.UID))
			{
				CachedRankRelation.RawID = Relation.ObjectID;
				
				foreach Ranks(Rank)
				{
					if (Rank.RankID == Relation.RankID)
					{
						CachedRankRelation.Rank = Rank;
						break;
					}
				}
				
				if (CachedRankRelation.Rank.RankID > 0)
				{
					GroupRelations.AddItem(CachedRankRelation);
				}
				else
				{
					`Log_Warn("Rank with ID" @ Relation.RankID @ "not found");
				}
			}
			else
			{
				`Log_Warn("Can't convert to UniqueNetID:" @ Relation.ObjectID);
			}
		}
		else
		{
			`Log_Warn("Can't parse ID:" @ Relation.ObjectID);
		}
	}
}

private static function bool IsUID(String ID)
{
	return (Left(ID, Len(MatchUID)) ~= MatchUID);
}

private static function bool IsPlayerSteamID64(String ID)
{
	return (Left(ID, Len(MatchPlayerSteamID64)) ~= MatchPlayerSteamID64);
}

private static function bool IsGroupSteamID64(String ID)
{
	return (Left(ID, Len(MatchGroupSteamID64)) ~= MatchGroupSteamID64);
}

private function bool AnyToUID(String ID, out UniqueNetId UID)
{
	return IsUID(ID) ? OSS.StringToUniqueNetId(ID, UID) : OSS.Int64ToUniqueNetId(ID, UID);
}

private function PostInit()
{
	`Log_Trace();
	
	if (WorldInfo == None || WorldInfo.Game == None)
	{
		SetTimer(1.0f, false, nameof(PostInit));
		return;
	}
	
	KFGI = KFGameInfo(WorldInfo.Game);
	if (KFGI == None)
	{
		`Log_Fatal("Incompatible gamemode:" @ WorldInfo.Game);
		SafeDestroy();
		return;
	}
	
	KFGI.HUDType = class'YAS_HUD';
	
	if (KFGI.GameReplicationInfo == None)
	{
		SetTimer(1.0f, false, nameof(PostInit));
		return;
	}
	
	KFGRI = KFGameReplicationInfo(KFGI.GameReplicationInfo);
	if (KFGRI == None)
	{
		`Log_Fatal("Incompatible Replication info:" @ KFGI.GameReplicationInfo);
		SafeDestroy();
		return;
	}
	
	if (KFGI.PlayfabInter != None && KFGI.PlayfabInter.GetGameSettings() != None)
	{
		KFOGS = KFOnlineGameSettings(KFGI.PlayfabInter.GetGameSettings());
	}
	else if (KFGI.GameInterface != None)
	{
		KFOGS = KFOnlineGameSettings(
			KFGI.GameInterface.GetGameSettings(
				KFGI.PlayerReplicationInfoClass.default.SessionName));
	}
	
	if (KFOGS == None)
	{
		SetTimer(1.0f, false, nameof(PostInit));
		return;
	}
	
	KFGIS = KFGameInfo_Survival(KFGI);
	KFGIE = KFGameInfo_Endless(KFGI);
	
	SetTimer(UpdateInterval, true, nameof(UpdateTimer));
}

private function UpdateTimer()
{
	// TODO: Server params monitor
}

public function NotifyLogin(Controller C)
{
	local YAS_RepInfo RepInfo;
	
	`Log_Trace();

	RepInfo = CreateRepInfo(C);
	if (RepInfo == None)
	{
		`Log_Error("Can't create RepInfo for:" @ C);
		return;
	}
	
	ApplyCurrentRankRelations(RepInfo);
	InitRank(RepInfo);
}

public function NotifyLogout(Controller C)
{
	local YAS_RepInfo RepInfo;
	
	`Log_Trace();
	
	RepInfo = FindRepInfo(C);
	if (RepInfo == None)
	{
		`Log_Error("Can't find repinfo for:" @ C);
		return;
	}
	
	BroadcastRemoveRankRelation(RepInfo.ActiveRankRelation, C);
	
	if (!DestroyRepInfo(RepInfo))
	{
		`Log_Error("Can't destroy RepInfo of:" @ C);
	}
}

public function YAS_RepInfo CreateRepInfo(Controller C)
{
	local YAS_RepInfo RepInfo;
	
	`Log_Trace();
	
	RepInfo = Spawn(class'YAS_RepInfo', C);
	
	if (RepInfo != None)
	{
		RepInfos.AddItem(RepInfo);
		
		RepInfo.YAS        = Self;
		RepInfo.LogLevel   = LogLevel;
		RepInfo.RankPlayer = CfgRanks.default.Player;
		RepInfo.RankAdmin  = CfgRanks.default.Admin;
	}
	
	return RepInfo;
}

private function YAS_RepInfo FindRepInfo(Controller C)
{
	local YAS_RepInfo RepInfo;
	
	if (C == None) return None;
	
	foreach RepInfos(RepInfo)
	{
		if (RepInfo.Owner == C)
		{
			return RepInfo;
		}
	}
	
	return None;
}

public function bool DestroyRepInfo(YAS_RepInfo RepInfo)
{
	`Log_Trace();
	
	if (RepInfo == None) return false;
	
	RepInfos.RemoveItem(RepInfo);
	RepInfo.SafeDestroy();
	
	return true;
}

private function ApplyCurrentRankRelations(YAS_RepInfo RepInfo)
{
	
}

private function InitRank(YAS_RepInfo RepInfo)
{
	local CachedRankRelation Rel;
	local String JoinedGroupIDs;
	local PlayerReplicationInfo PRI;
	local KFPlayerController KFPC;
	local bool HasPlayerRank;
	local Array<String> StringGroupIDs;
	
	`Log_Trace();
	
	KFPC = RepInfo.GetKFPC();
	
	if (KFPC == None) return;
	
	PRI = KFPC.PlayerReplicationInfo;
	if (PRI == None) return;
	
	HasPlayerRank = false;
	foreach PlayerRelations(Rel)
	{
		if (Rel.UID.Uid == PRI.UniqueID.Uid)
		{
			HasPlayerRank = true;
			RepInfo.ActiveRankRelation = Rel;
			break;
		}
	}
	
	if (HasPlayerRank)
	{
		BroadcastAddRankRelation(RepInfo.ActiveRankRelation);
	}
	else if (!KFPC.bIsEosPlayer)
	{
		foreach GroupRelations(Rel)
		{
			StringGroupIDs.AddItem(Rel.RawID);
		}
		JoinArray(StringGroupIDs, JoinedGroupIDs);
		RepInfo.CheckGroupRanks(JoinedGroupIDs);
	}
}

public function ApplyMembership(UniqueNetId GroupUID, UniqueNetId PlayerUID)
{
	local CachedRankRelation RR;
	local int Index;
	
	`Log_Trace();
	
	Index = GroupRelations.Find('UID', GroupUID);
	if (Index != INDEX_NONE)
	{
		RR.UID = PlayerUID;
		RR.Rank = GroupRelations[Index].Rank;
		BroadcastAddRankRelation(RR);
	}
	else
	{
		`Log_Error("Can't find related GroupID rank");
	}
}

public function BroadcastAddRankRelation(CachedRankRelation RR)
{
	local YAS_RepInfo RepInfo;
	
	`Log_Trace();
	
	foreach RepInfos(RepInfo)
	{
		RepInfo.AddRankRelation(RR);
	}
}

public function BroadcastRemoveRankRelation(CachedRankRelation RR, optional Controller Except)
{
	local YAS_RepInfo RepInfo;
	
	foreach RepInfos(RepInfo)
	{
		if (RepInfo.Owner != Except)
		{
			RepInfo.RemoveRankRelation(RR);
		}
	}
}

DefaultProperties
{
	
}