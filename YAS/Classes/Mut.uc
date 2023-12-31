class Mut extends KFMutator;

var private YAS YAS;

public simulated function bool SafeDestroy()
{
	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	Super.PreBeginPlay();

	if (WorldInfo.NetMode == NM_Client) return;

	foreach WorldInfo.DynamicActors(class'YAS', YAS)
	{
		break;
	}

	if (YAS == None)
	{
		YAS = WorldInfo.Spawn(class'YAS');
	}

	if (YAS == None)
	{
		`Log_Base("FATAL: Can't Spawn 'YAS'");
		SafeDestroy();
	}
}

public function AddMutator(Mutator M)
{
	if (M == Self) return;

	if (M.Class == Class)
		Mut(M).SafeDestroy();
	else
		Super.AddMutator(M);
}

public function NotifyLogin(Controller C)
{
	YAS.NotifyLogin(C);

	Super.NotifyLogin(C);
}

public function NotifyLogout(Controller C)
{
	YAS.NotifyLogout(C);

	Super.NotifyLogout(C);
}

DefaultProperties
{
	GroupNames.Add("Scoreboard")
}