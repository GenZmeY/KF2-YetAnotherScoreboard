class YAS_RepInfoPlayer extends ReplicationInfo;

var public  UniqueNetID UID;
var public  Rank        Rank;
var public  int         DamageDealt;

replication
{
	if (bNetInitial)
		UID;

	if (bNetDirty)
		Rank, DamageDealt;
}

public simulated function bool SafeDestroy()
{
	return (bPendingDelete || bDeleteMe || Destroy());
}

public simulated event PreBeginPlay()
{
	if (bPendingDelete || bDeleteMe) return;

	Super.PreBeginPlay();

	if (Role == ROLE_Authority || WorldInfo.NetMode == NM_StandAlone)
	{
		if (Controller(Owner) != None && Controller(Owner).PlayerReplicationInfo != None)
		{
			UID = Controller(Owner).PlayerReplicationInfo.UniqueID;
		}
	}
}

defaultproperties
{
	Role       = ROLE_Authority
	RemoteRole = ROLE_SimulatedProxy

	bAlwaysRelevant               = true
	bSkipActorPropertyReplication = false
}