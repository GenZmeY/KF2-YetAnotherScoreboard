class YAS_RepInfo extends ReplicationInfo;

var public YAS YAS;

var public repnotify E_LogLevel LogLevel;
var public repnotify SystemRank RankPlayer, RankAdmin;
var public repnotify String DynamicServerName;
var public repnotify bool UsesStats, Custom, PasswordRequired;

var public CachedRankRelation ActiveRankRelation;

var private KFPlayerController        KFPC;
var private YAS_ScoreBoard            SC;
var private OnlineSubsystemSteamworks OSS;

var private Array<UniqueNetID>        PendingGroupIDs;
var private Array<CachedRankRelation> PendingAddRankRelations;
var private Array<CachedRankRelation> PendingRemoveRankRelations;

const CheckGroupTimer = 0.2f;
const MaxRetries      = 3;
var private int Retries;

replication
{
	if (bNetInitial)
		LogLevel, RankPlayer, RankAdmin;
	
	if (bNetDirty)
		DynamicServerName, UsesStats, Custom, PasswordRequired;
}

public simulated event ReplicatedEvent(name VarName)
{
	`Log_Trace();
	
	switch (VarName)
	{
		case 'LogLevel':
			if (SC != None) SC.LogLevel = LogLevel;
			break;
		
		case 'RankPlayer':
			if (SC != None) SC.RankPlayer = RankPlayer;
			break;
			
		case 'RankAdmin':
			if (SC != None) SC.RankAdmin = RankAdmin;
			break;
			
		case 'DynamicServerName':
			if (SC != None) SC.DynamicServerName = DynamicServerName;
			break;
			
		case 'UsesStats':
			if (SC != None) SC.UsesStats = UsesStats;
			break;
			
		case 'Custom':
			if (SC != None) SC.Custom = Custom;
			break;
			
		case 'PasswordRequired':
			if (SC != None) SC.PasswordRequired = PasswordRequired;
			break;
		
		default:
			super.ReplicatedEvent(VarName);
			break;
	}
}

public simulated function bool SafeDestroy()
{
	`Log_Trace();
	
	return (bPendingDelete || bDeleteMe || Destroy());
}

public simulated event PreBeginPlay()
{
	`Log_Trace();
	
	if (bPendingDelete || bDeleteMe) return;
	
	Super.PreBeginPlay();
	
	if (Role < ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
	{
		GetScoreboard();
	}
	
	GetOnlineSubsystem();
}

public simulated event PostBeginPlay()
{
	if (bPendingDelete || bDeleteMe) return;
	
	Super.PostBeginPlay();
}

public reliable client function AddRankRelation(CachedRankRelation RR)
{
	local int Index;
	
	`Log_Trace();
	
	if (SC == None)
	{
		PendingAddRankRelations.AddItem(RR);
		return;
	}
	
	Index = SC.RankRelations.Find('UID', RR.UID);
	if (Index != INDEX_NONE)
	{
		SC.RankRelations[Index] = RR;
	}
	else
	{
		SC.RankRelations.AddItem(RR);
	}
}

public reliable client function RemoveRankRelation(CachedRankRelation RR)
{
	`Log_Trace();
	
	if (SC == None)
	{
		PendingRemoveRankRelations.AddItem(RR);
		return;
	}
	
	SC.RankRelations.RemoveItem(RR);
}

public reliable client function CheckGroupRanks(String JoinedGroupIDs)
{
	local Array<String> StringGroupIDs;
	local String StringGroupID;
	local UniqueNetId GroupUID;
	
	`Log_Trace();
	
	StringGroupIDs = SplitString(JoinedGroupIDs);
	
	if (GetOnlineSubsystem() == None)
	{
		`Log_Error("Can't get online subsystem");
		return;
	}
		
	foreach StringGroupIDs(StringGroupID)
	{
		if (OSS.Int64ToUniqueNetId(StringGroupID, GroupUID))
		{
			PendingGroupIDs.AddItem(GroupUID);
		}
	}
	
	Retries = 0;
	CheckGroupsCycle();
}

private simulated function CheckGroupsCycle()
{
	local UniqueNetId GroupUID;
	
	`Log_Trace();
	
	if (Retries++ >= MaxRetries) return;
	
	// CheckPlayerGroup doesn't return real values right away,
	// so we do a dry run and a few checks just in case
	foreach PendingGroupIDs(GroupUID) OSS.CheckPlayerGroup(GroupUID);
	
	foreach PendingGroupIDs(GroupUID)
	{
		if (OSS.CheckPlayerGroup(GroupUID))
		{
			PendingGroupIDs.Length = 0;
			ServerApplyMembership(GroupUID);
			return;
		}
	}
	
	SetTimer(0.2f, false, nameof(CheckGroupsCycle));
}

private reliable server function ServerApplyMembership(UniqueNetId GroupUID)
{
	`Log_Trace();
	
	if (GetKFPC() != None && KFPC.PlayerReplicationInfo != None)
	{
		YAS.ApplyMembership(GroupUID, KFPC.PlayerReplicationInfo.UniqueID);
	}
	else
	{
		`Log_Error("Can't apply membership for:" @ Self @ GetKFPC());
	}
}

public simulated function KFPlayerController GetKFPC()
{
	`Log_Trace();
	
	if (KFPC != None) return KFPC;
	
	KFPC = KFPlayerController(Owner);
	
	if (KFPC == None && ROLE < ROLE_Authority)
	{
		KFPC = KFPlayerController(GetALocalPlayerController());
	}
	
	return KFPC;
}

private simulated function OnlineSubsystemSteamworks GetOnlineSubsystem()
{
	`Log_Trace();
	
	if (OSS == None)
	{
		OSS = OnlineSubsystemSteamworks(class'GameEngine'.static.GetOnlineSubsystem());
	}
	
	return OSS;
}

private reliable client function GetScoreboard()
{
	`Log_Trace();
	
	if (SC == None)
	{
		if (GetKFPC() != None && KFPC.myHUD != None)
		{
			SC = YAS_HUD(KFPC.myHUD).Scoreboard;
		}
	}
	
	if (SC == None)
	{
		SetTimer(0.2f, false, nameof(GetScoreboard));
		return;
	}
	
	InitScoreboard();
}

private simulated function InitScoreboard()
{
	local CachedRankRelation RR;
	
	`Log_Trace();
	
	if (SC == None) return;
	
	SC.LogLevel          = LogLevel;
	SC.RankPlayer        = RankPlayer;
	SC.RankAdmin         = RankAdmin;
	SC.DynamicServerName = DynamicServerName;
	SC.UsesStats         = UsesStats;
	SC.Custom            = Custom;
	SC.PasswordRequired  = PasswordRequired;
	
	foreach PendingRemoveRankRelations(RR)
	{
		RemoveRankRelation(RR);
	}
	PendingRemoveRankRelations.Length = 0;
	
	foreach PendingAddRankRelations(RR)
	{
		AddRankRelation(RR);
	}
	PendingAddRankRelations.Length = 0;
}

defaultproperties
{
	Role       = ROLE_Authority
	RemoteRole = ROLE_SimulatedProxy
	
	bAlwaysRelevant               = false
	bOnlyRelevantToOwner          = true
	bSkipActorPropertyReplication = false
	
	Retries = 0
}