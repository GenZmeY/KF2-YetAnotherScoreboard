class YAS_RepInfo extends ReplicationInfo;

// Server
var public YASMut Mut;
var public E_LogLevel LogLevel;

// Client
var private YAS_ScoreBoard            SC;
var private OnlineSubsystemSteamworks SW;

public simulated function bool SafeDestroy()
{
	`Log_Trace();
	
	return (bPendingDelete || bDeleteMe || Destroy());
}

public simulated event PreBeginPlay()
{
	if (bPendingDelete || bDeleteMe) return;
	
	Super.PreBeginPlay();
	
	if (Role < ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
	{
		GetScoreboard();
		GetOnlineSubsystem();
	}
}

public simulated event PostBeginPlay()
{
	if (bPendingDelete || bDeleteMe) return;
	
	Super.PostBeginPlay();
}

private reliable client function GetScoreboard() // TODO: !
{
	if (SC == None)
	{
		SC = YAS_HUD(GetALocalPlayerController().myHUD).Scoreboard; // GetKFPC?
	}
	
	if (SC == None)
	{
		SetTimer(0.1f, false, nameof(GetScoreboard));
	}
	else
	{
		ClearTimer(nameof(GetScoreboard));
	}
}

private reliable client function GetOnlineSubsystem()
{
	// TODO: !
}

defaultproperties
{
	Role       = ROLE_Authority
	RemoteRole = ROLE_SimulatedProxy
	
	bAlwaysRelevant               = false
	bOnlyRelevantToOwner          = true
	bSkipActorPropertyReplication = false
}