class ClassicHUD extends KFMutator;

var KFPawn LastHitZed;
var int LastHitHP;
var KFPlayerController LastDamageDealer;
var vector LastDamagePosition;
var class<KFDamageType> LastDamageDMGType;

struct RepInfoS
{
    var DamageReplicationInfo DRI;
    var KFPlayerController KFPC;
};
var array<RepInfoS> DamageReplicationInfos;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    WorldInfo.Game.HUDType = class'ClassicKFHUD'; 
}

function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    Super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);

    if( LastDamageDealer!=None )
    {
        ClearTimer('CheckDamageDone');
        CheckDamageDone();
    }
    
    if( Damage>0 && InstigatedBy != None )
    {
        if( KFPawn_Monster(Injured) != None && KFPlayerController(InstigatedBy) != None )
        {
            LastDamageDealer = KFPlayerController(InstigatedBy);

            LastHitZed = KFPawn(Injured);
            LastHitHP = LastHitZed.Health;
            LastDamagePosition = HitLocation;
            LastDamageDMGType = class<KFDamageType>(DamageType);
            SetTimer(0.1,false,'CheckDamageDone');
        }
    }
}

final function CheckDamageDone()
{
    local int Damage, i;

    if( LastDamageDealer!=None && LastHitZed!=None && LastHitHP!=LastHitZed.Health )
    {
        Damage = LastHitHP-Max(LastHitZed.Health,0);
        if( Damage>0 )
        {
            i = DamageReplicationInfos.Find('KFPC', LastDamageDealer);
            if( i != INDEX_NONE )
                DamageReplicationInfos[i].DRI.ClientNumberMsg(Damage,LastDamagePosition,LastDamageDMGType);
        }
    }
    LastDamageDealer = None;
}

function NotifyLogin(Controller C)
{
	if( KFPlayerController(C) != None )
		CreateReplicationInfo(KFPlayerController(C));
		
    Super.NotifyLogin(C);
}

function NotifyLogout(Controller C)
{
	if( KFPlayerController(C) != None )
		DestroyReplicationInfo(KFPlayerController(C));
	
    Super.NotifyLogout(C);
}

function CreateReplicationInfo(KFPlayerController C)
{
    local RepInfoS Info;
    
    Info.DRI = Spawn(class'DamageReplicationInfo', C);
    Info.KFPC = C;
    
    Info.DRI.KFPC = C;
    
    DamageReplicationInfos.AddItem(Info);
}

function DestroyReplicationInfo(KFPlayerController C)
{
    local int i;
    
    i = DamageReplicationInfos.Find('KFPC', C);
    if( i != INDEX_NONE )
    {
        DamageReplicationInfos[i].DRI.Destroy();
        DamageReplicationInfos.RemoveItem(DamageReplicationInfos[i]);
    }
}

defaultproperties
{
}