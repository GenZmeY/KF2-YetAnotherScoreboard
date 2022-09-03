class YAS extends Info
	config(YAS);

const LatestVersion = 1;

//const CfgExampleConfig = class'ExampleConfig';

var private config int        Version;
var private config E_LogLevel LogLevel;

var private KFGameInfo            KFGI;
var private KFGameInfo_Survival   KFGIS;
var private KFGameInfo_Endless    KFGIE;
var private KFGameReplicationInfo KFGRI;

var private Array<YAS_RepInfo> RepInfos;

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
		SaveConfig();
	}
	
	//CfgExampleConfig.static.InitConfig(Version, LatestVersion);
	
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
	
	//ExampleConfig = CfgExampleConfig.static.Load(LogLevel);
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
	
	KFGIS = KFGameInfo_Survival(KFGI);
	KFGIE = KFGameInfo_Endless(KFGI);
}

public function NotifyLogin(Controller C)
{
	`Log_Trace();

	if (!CreateRepInfo(C))
	{
		`Log_Error("Can't create RepInfo for:" @ C);
	}
}

public function NotifyLogout(Controller C)
{
	`Log_Trace();

	if (!DestroyRepInfo(C))
	{
		`Log_Error("Can't destroy RepInfo of:" @ C);
	}
}

public function bool CreateRepInfo(Controller C)
{
	local YAS_RepInfo RepInfo;
	
	`Log_Trace();
	
	if (C == None) return false;
	
	RepInfo = Spawn(class'YAS_RepInfo', C);
	
	if (RepInfo == None) return false;
	
	// Do something
	
	RepInfos.AddItem(RepInfo);
	
	return true;
}

public function bool DestroyRepInfo(Controller C)
{
	local YAS_RepInfo RepInfo;
	
	`Log_Trace();
	
	if (C == None) return false;
	
	foreach RepInfos(RepInfo)
	{
		if (RepInfo.Owner == C)
		{
			RepInfos.RemoveItem(RepInfo);
			RepInfo.SafeDestroy();
			return true;
		}
	}
	
	return false;
}

DefaultProperties
{
	
}