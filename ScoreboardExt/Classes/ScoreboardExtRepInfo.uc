class ScoreboardExtRepInfo extends ReplicationInfo;

var public array<UIDInfoEntry>     PlayerInfos;
var public array<PlayerGroupEntry> PlayerGroups;

var public string    SystemAdminRank;
var public TextColor SystemAdminColor;
var public Fields    SystemAdminApplyColorToFields;

var public string    SystemPlayerRank;
var public TextColor SystemPlayerColor;
var public Fields    SystemPlayerApplyColorToFields;

var private bool SystemFinished, GroupsFinished, InfosFinished;
var private int InfosReplicateProgress, GroupsReplicateProgress;

var private KFScoreBoard SC;

public final function ClientStartReplication()
{
	GetScoreboard();
	
	ClientInitSystem(
		SystemAdminRank,
		SystemAdminColor,
		SystemAdminApplyColorToFields,
		SystemPlayerRank,
		SystemPlayerColor,
		SystemPlayerApplyColorToFields);
		
	SetTimer(0.01f, true, nameof(ClientReplicateGroups));
	SetTimer(0.01f, true, nameof(ClientReplicateInfos));
}

public final function ClientReplicateGroups()
{
	if (GroupsReplicateProgress < PlayerGroups.Length)
	{
		ClientAddPlayerGroup(PlayerGroups[GroupsReplicateProgress]);
		++GroupsReplicateProgress;
	}
	else
	{
		ClearTimer(nameof(ClientReplicateGroups));
		GroupReplicationFinished();
	}
}

public final function ClientReplicateInfos()
{
	if (InfosReplicateProgress < PlayerInfos.Length)
	{
		ClientAddPlayerInfo(PlayerInfos[InfosReplicateProgress]);
		++InfosReplicateProgress;
	}
	else
	{
		ClearTimer(nameof(ClientReplicateInfos));
		InfosReplicationFinished();
	}
}

private reliable client final function GetScoreboard()
{
	if (SC != None)
	{
		ClearTimer(nameof(GetScoreboard));
		return;
	}
	
	SC = ScoreboardExtHUD(GetALocalPlayerController().myHUD).Scoreboard;
	SetTimer(0.1f, false, nameof(GetScoreboard));
}

private reliable client final function ClientAddPlayerGroup(PlayerGroupEntry Group)
{
	PlayerGroups.AddItem(Group);
}

private reliable client final function ClientAddPlayerInfo(UIDInfoEntry PlayerInfo)
{
	PlayerInfos.AddItem(PlayerInfo);
}

private reliable client final function GroupReplicationFinished()
{
	GroupsFinished = true;
	ClientGroupsApply();
}

private reliable client final function InfosReplicationFinished()
{
	InfosFinished = true;
	ClientInfosApply();
}

private reliable client final function ClientInitSystem(
	string                  _SystemAdminRank,
	TextColor               _SystemAdminColor,
	Fields                  _SystemAdminApplyColorToFields,
	string                  _SystemPlayerRank,
	TextColor               _SystemPlayerColor,
	Fields                  _SystemPlayerApplyColorToFields)
{
	SystemAdminRank                = _SystemAdminRank;
	SystemAdminColor               = _SystemAdminColor;
	SystemAdminApplyColorToFields  = _SystemAdminApplyColorToFields;
	SystemPlayerRank               = _SystemPlayerRank;
	SystemPlayerColor              = _SystemPlayerColor;
	SystemPlayerApplyColorToFields = _SystemPlayerApplyColorToFields;

	ClientSystemApply();
}

private reliable client final function ClientSystemApply()
{
	if (SC == None)
	{
		SetTimer(0.1f, false, nameof(ClientSystemApply));
		return;
	}
	
	SC.SystemAdminRank                = SystemAdminRank;
	SC.SystemAdminColor               = SystemAdminColor;
	SC.SystemAdminApplyColorToFields  = SystemAdminApplyColorToFields;
	SC.SystemPlayerRank               = SystemPlayerRank;
	SC.SystemPlayerColor              = SystemPlayerColor;
	SC.SystemPlayerApplyColorToFields = SystemPlayerApplyColorToFields;
	
	SystemFinished = true;
	Finished();
}

private reliable client final function ClientGroupsApply()
{
	if (SC == None)
	{
		SetTimer(0.1f, false, nameof(ClientGroupsApply));
		return;
	}
	
	SC.PlayerGroups = PlayerGroups;
	GroupsFinished  = true;
	Finished();
}

private reliable client final function ClientInfosApply()
{
	if (SC == None)
	{
		SetTimer(0.1f, false, nameof(ClientInfosApply));
		return;
	}
	
	SC.PlayerInfos = PlayerInfos;
	GroupsFinished = true;
	Finished();
}

private reliable client final function Finished()
{
	if (SystemFinished && GroupsFinished && InfosFinished)
		Destroy();
}

defaultproperties
{
	InfosReplicateProgress=0
	GroupsReplicateProgress=0
	
	SystemFinished=false
	GroupsFinished=false
	InfosFinished=false
}