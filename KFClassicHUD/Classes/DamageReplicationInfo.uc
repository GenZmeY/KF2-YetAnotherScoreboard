class DamageReplicationInfo extends ReplicationInfo;

var KFPlayerController KFPC;

unreliable client function ClientNumberMsg( int Count, vector Pos, class<KFDamageType> Type )
{
    ClassicKFHUD(KFPC.MyHUD).AddNumberMsg(Count,Pos,Type);
}

defaultproperties
{
	bOnlyRelevantToOwner=True
}