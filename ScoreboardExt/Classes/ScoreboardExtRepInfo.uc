class ScoreboardExtRepInfo extends ReplicationInfo;

var private array<UIDInfoEntry>     PlayerInfos;
var private array<PlayerGroupEntry> PlayerGroups;

var private string    SystemAdminRank;
var private TextColor SystemAdminColor;
var private Fields    SystemAdminApplyColorToFields;

var private string    SystemPlayerRank;
var private TextColor SystemPlayerColor;
var private Fields    SystemPlayerApplyColorToFields;

public reliable client final function ClientInit(
	array<PlayerGroupEntry> _PlayerGroups,
	array<UIDInfoEntry>     _PlayerInfos,
	string                  _SystemAdminRank,
	TextColor               _SystemAdminColor,
	Fields                  _SystemAdminApplyColorToFields,
	string                  _SystemPlayerRank,
	TextColor               _SystemPlayerColor,
	Fields                  _SystemPlayerApplyColorToFields)
{
	PlayerGroups                   = _PlayerGroups;
	PlayerInfos                    = _PlayerInfos;
	SystemAdminRank                = _SystemAdminRank;
	SystemAdminColor               = _SystemAdminColor;
	SystemAdminApplyColorToFields  = _SystemAdminApplyColorToFields;
	SystemPlayerRank               = _SystemPlayerRank;
	SystemPlayerColor              = _SystemPlayerColor;
	SystemPlayerApplyColorToFields = _SystemPlayerApplyColorToFields;

	ClientApply();
}

private reliable client final function ClientApply()
{
	local KFScoreBoard SC;
	
	SC = ScoreboardExtHUD(PlayerController(Owner).myHUD).Scoreboard;
	if (SC == None)
	{
		SetTimer(0.5f, false, nameof(ClientApply));
		return;
	}
	
	SC.PlayerGroups                   = PlayerGroups;
	SC.PlayerInfos                    = PlayerInfos;
	SC.SystemAdminRank                = SystemAdminRank;
	SC.SystemAdminColor               = SystemAdminColor;
	SC.SystemAdminApplyColorToFields  = SystemAdminApplyColorToFields;
	SC.SystemPlayerRank               = SystemPlayerRank;
	SC.SystemPlayerColor              = SystemPlayerColor;
	SC.SystemPlayerApplyColorToFields = SystemPlayerApplyColorToFields;
	
	Destroy();
}

defaultproperties
{
	
}