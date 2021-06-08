class ScoreboardExtRepInfo extends ReplicationInfo;

var public array<UIDRankRelation> PlayerRankRelations;
var public array<RankInfo> CustomRanks;

var public string    SystemAdminRank;
var public ColorRGB  SystemAdminColor;
var public Fields    SystemAdminApplyColorToFields;

var public string    SystemPlayerRank;
var public ColorRGB  SystemPlayerColor;
var public Fields    SystemPlayerApplyColorToFields;

var private bool InitFinished, RanksFinished, InfosFinished;
var private int InfosReplicateProgress, RanksReplicateProgress;

var private KFScoreBoard SC;

public function ClientStartReplication()
{
	GetScoreboard();
	
	ClientInitSystem(
		SystemAdminRank,
		SystemAdminColor,
		SystemAdminApplyColorToFields,
		SystemPlayerRank,
		SystemPlayerColor,
		SystemPlayerApplyColorToFields);
		
	SetTimer(0.01f, true, nameof(ClientReplicateRanks));
	SetTimer(0.01f, true, nameof(ClientReplicateInfos));
}

public function ClientReplicateRanks()
{
	if (RanksReplicateProgress < CustomRanks.Length)
	{
		ClientAddPlayerRank(CustomRanks[RanksReplicateProgress]);
		++RanksReplicateProgress;
	}
	else
	{
		ClearTimer(nameof(ClientReplicateRanks));
		RankReplicationFinished();
	}
}

public function ClientReplicateInfos()
{
	if (InfosReplicateProgress < PlayerRankRelations.Length)
	{
		ClientAddPlayerInfo(PlayerRankRelations[InfosReplicateProgress]);
		++InfosReplicateProgress;
	}
	else
	{
		ClearTimer(nameof(ClientReplicateInfos));
		InfosReplicationFinished();
	}
}

private reliable client function GetScoreboard()
{
	if (SC != None)
	{
		ClearTimer(nameof(GetScoreboard));
		return;
	}
	
	SC = ScoreboardExtHUD(GetALocalPlayerController().myHUD).Scoreboard;
	SetTimer(0.1f, false, nameof(GetScoreboard));
}

private reliable client function ClientAddPlayerRank(RankInfo Rank)
{
	CustomRanks.AddItem(Rank);
}

private reliable client function ClientAddPlayerInfo(UIDRankRelation PlayerInfo)
{
	PlayerRankRelations.AddItem(PlayerInfo);
}

private reliable client function RankReplicationFinished()
{
	RanksFinished = true;
	ClientRanksApply();
}

private reliable client function InfosReplicationFinished()
{
	InfosFinished = true;
	ClientInfosApply();
}

private reliable client function ClientInitSystem(
	string                  _SystemAdminRank,
	ColorRGB                _SystemAdminColor,
	Fields                  _SystemAdminApplyColorToFields,
	string                  _SystemPlayerRank,
	ColorRGB                _SystemPlayerColor,
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

private reliable client function ClientSystemApply()
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
	
	InitFinished = true;
	Finished();
}

private reliable client function ClientRanksApply()
{
	if (SC == None)
	{
		SetTimer(0.1f, false, nameof(ClientRanksApply));
		return;
	}
	
	SC.CustomRanks = CustomRanks;
	RanksFinished  = true;
	Finished();
}

private reliable client function ClientInfosApply()
{
	if (SC == None)
	{
		SetTimer(0.1f, false, nameof(ClientInfosApply));
		return;
	}
	
	SC.PlayerRankRelations = PlayerRankRelations;
	RanksFinished = true;
	Finished();
}

private reliable client function Finished()
{
	if (InitFinished && RanksFinished && InfosFinished)
		Destroy();
}

defaultproperties
{
	InfosReplicateProgress=0
	RanksReplicateProgress=0
	
	InitFinished=false
	RanksFinished=false
	InfosFinished=false
}