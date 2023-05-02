class YASMut extends KFMutator;

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

public function AddMutator(Mutator Mut)
{
	if (Mut == Self) return;

	if (Mut.Class == Class)
		Mut.Destroy();
	else
		Super.AddMutator(Mut);
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

}