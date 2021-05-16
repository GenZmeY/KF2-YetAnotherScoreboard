class ScoreboardExtHUD extends KFGFxHudWrapper
    config(ScoreboardExtMut);

const GFxListenerPriority = 80000;
    
const MAX_WEAPON_GROUPS = 4;
const HUDBorderSize = 3;

const PHASE_DONE = -1;
const PHASE_SHOWING = 0;
const PHASE_DELAYING = 1;
const PHASE_HIDING = 2;

enum EDamageTypes
{
    DMG_Fire,
    DMG_Toxic,
    DMG_Bleeding,
    DMG_EMP,
    DMG_Freeze,
    DMG_Flashbang,
    DMG_Generic,
    DMG_High,
    DMG_Medium,
    DMG_Unspecified
};

enum PopupPosition 
{
    PP_BOTTOM_CENTER,
    PP_BOTTOM_LEFT,
    PP_BOTTOM_RIGHT,
    PP_TOP_CENTER,
    PP_TOP_LEFT,
    PP_TOP_RIGHT
};

enum EJustificationType
{
    HUDA_None,
    HUDA_Right,
    HUDA_Left,
    HUDA_Top,
    HUDA_Bottom
};

enum EPriorityAlignment
{
    PR_TOP,
    PR_BOTTOM
};

enum EPriorityAnimStyle
{
    ANIM_SLIDE,
    ANIM_DROP
};

struct WeaponInfoS
{
    var Weapon Weapon;
    var string WeaponName;
};
var transient WeaponInfoS CachedWeaponInfo;

struct FKillMessageType
{
    var bool bDamage,bLocal,bPlayerDeath,bSuicide;
    var int Counter;
    var Class Type;
    var string Name, KillerName;
    var PlayerReplicationInfo OwnerPRI;
    var float MsgTime,XPosition,CurrentXPosition;
    var color MsgColor;
};
var transient array<FKillMessageType> KillMessages;

var Color DefaultHudMainColor, DefaultHudOutlineColor, DefaultFontColor;
var transient float LevelProgressBar, VisualProgressBar;
var transient bool bInterpolating, bDisplayingProgress;

var Texture HealthIcon, ArmorIcon, WeightIcon, GrenadesIcon, DoshIcon, ClipsIcon, BulletsIcon, BurstBulletIcon, AutoTargetIcon, ManualTargetIcon, ProgressBarTex, DoorWelderBG;
var Texture WaveCircle, BioCircle;
var Texture ArrowIcon, FlameIcon, FlameTankIcon, FlashlightIcon, FlashlightOffIcon, RocketIcon, BoltIcon, M79Icon, PipebombIcon, SingleBulletIcon, SyringIcon, SawbladeIcon, DoorWelderIcon;
var Texture TraderBox, TraderArrow, TraderArrowLight;
var Texture VoiceChatIcon;
var Texture2D PerkStarIcon, DoshEarnedIcon;

var KFDroppedPickup WeaponPickup;
var float MaxWeaponPickupDist;
var float WeaponPickupScanRadius;
var float ZedScanRadius;
var Texture2D WeaponAmmoIcon, WeaponWeightIcon;
var float WeaponIconSize;
var Color WeaponIconColor,WeaponOverweightIconColor;

var int MaxNonCriticalMessages;
var float NonCriticalMessageDisplayTime,NonCriticalMessageFadeInTime,NonCriticalMessageFadeOutTime;

struct PopupDamageInfo
{
    var int Damage;
    var float HitTime;
    var Vector HitLocation;
    var byte Type;
    var color FontColor;
    var vector RandVect;
};
const DAMAGEPOPUP_COUNT = 32;
var PopupDamageInfo DamagePopups[DAMAGEPOPUP_COUNT];
var int NextDamagePopupIndex;
var float DamagePopupFadeOutTime;

struct FCritialMessage
{
    var string Text, Delimiter;
    var float StartTime;
    var bool bHighlight,bUseAnimation;
    var int TextAnimAlpha;
};
var transient array<FCritialMessage> NonCriticalMessages;

struct FPriorityMessage
{
    var string PrimaryText, SecondaryText;
    var float StartTime, SecondaryStartTime, LifeTime, FadeInTime, FadeOutTime;
    var EPriorityAlignment SecondaryAlign;
    var EPriorityAnimStyle PrimaryAnim, SecondaryAnim;
    var Texture2D Icon,SecondaryIcon;
    var Color IconColor,SecondaryIconColor;
    var bool bSecondaryUsesFullLength;
    
    structdefaultproperties
    {
        FadeInTime=0.15f
        FadeOutTime=0.15f
        LifeTime=5.f
        IconColor=(R=255,G=255,B=255,A=255)
        SecondaryIconColor=(R=255,G=255,B=255,A=255)
    }
};
var transient FPriorityMessage PriorityMessage;
var int CurrentPriorityMessageA,CurrentSecondaryMessageA;

var transient vector PLCameraLoc,PLCameraDir;
var transient rotator PLCameraRot;

var int PlayerScore, OldPlayerScore, ScoreDelta;
var float TimeX, TimeXEnd;
var int PerkIconSize;
var int MaxPerkStars, MaxStarsPerRow;

var bool bDisplayQuickSyringe;
var float QuickSyringeStartTime, QuickSyringeDisplayTime, QuickSyringeFadeInTime, QuickSyringeFadeOutTime;

struct HUDBoxRenderInfo
{
    var int JustificationPadding;
    var Color TextColor, OutlineColor, BoxColor;
    var Texture IconTex;
    var float Alpha;
    var float IconScale;
    var array<String> StringArray;
    var bool bUseOutline, bUseRounded, bRoundedOutline, bHighlighted;
    var EJustificationType Justification;
    
    structdefaultproperties
    {
        TextColor=(R=255,B=255,G=255,A=255)
        Alpha=-1.f
        IconScale=1.f
    }
};

var Texture2D MedicLockOnIcon;
var float MedicLockOnIconSize, LockOnStartTime, LockOnEndTime;
var Color MedicLockOnColor, MedicPendingLockOnColor;
var KFPawn OldTarget;

var rotator MedicWeaponRot;
var float MedicWeaponHeight;
var Color MedicWeaponBGColor;
var Color MedicWeaponNotChargedColor, MedicWeaponChargedColor;

struct InventoryCategory
{
    var array<KFWeapon> Items;
    var int ItemCount;
};
var int MinWeaponIndex[MAX_WEAPON_GROUPS], MaxWeaponIndex[MAX_WEAPON_GROUPS];
var int MaxWeaponsPerCatagory;

var float ScaledBorderSize;

var const Color BlueColor;
var ObjectReferencer RepObject;
var transient KF2GUIController GUIController;
var transient GUIStyleBase GUIStyle;

var int FontBlurX,FontBlurX2,FontBlurY,FontBlurY2;

struct XPEarnedS
{
    var float StartTime,XPos,YPos,RandX,RandY;
    var bool bInit;
    var int XP;
    var Texture2D Icon;
    var Color IconColor;
};
var array<XPEarnedS> XPPopups;
var float XPFadeOutTime;

struct DoshEarnedS
{
    var float StartTime,XPos,YPos,RandX,RandY;
    var bool bInit;
    var int Dosh;
};
var array<DoshEarnedS> DoshPopups;
var float DoshFadeOutTime;

var array<KFPawn_Human> PawnList;

var bool bDisplayInventory;
var float InventoryFadeTime, InventoryFadeStartTime, InventoryFadeInTime, InventoryFadeOutTime, InventoryX, InventoryY, InventoryBoxWidth, InventoryBoxHeight, BorderSize;
var Texture InventoryBackgroundTexture, SelectedInventoryBackgroundTexture;
var int SelectedInventoryCategory, SelectedInventoryIndex;
var KFWeapon SelectedInventory;

struct PopupMessage 
{
    var string Body;
    var Texture2D Image;
    var PopupPosition MsgPosition;
};
var privatewrite int NotificationPhase;
var privatewrite array<PopupMessage> MessageQueue;
var privatewrite string NewLineSeparator;
var float NotificationPhaseStartTime, NotificationIconSpacing, NotificationShowTime, NotificationHideTime, NotificationHideDelay, NotificationBorderSize;
var Texture NotificationBackground;

var array<KFGUI_Base> HUDWidgets;

var class<KFScoreBoard> ScoreboardClass;
var KFScoreBoard Scoreboard;

struct FHealthBarInfo
{
    var float LastHealthUpdate,HealthUpdateEndTime;
    var int OldBarHealth,OldHealth;
    var bool bDrawingHistory;
};
var array<FHealthBarInfo> HealthBarDamageHistory;
var int DamageHistoryNum;

var KFPawn_Scripted ScriptedPawn;
var KFInterface_MonsterBoss BossPawn;
var float BossShieldPct;
var bool bDisplayImportantHealthBar;
var Color BossBattlePhaseColor;
var Texture2D BossInfoIcon;
var array<Color> BattlePhaseColors;

struct FNewItemEntry
{
    var Texture2D Icon;
    var string Item,IconURL;
    var float MsgTime;
};
var transient array<FNewItemEntry> NewItems;
var transient array<byte> WasNewlyAdded;
var transient OnlineSubsystem OnlineSub;
var transient bool bLoadedInitItems;
var array<Color> DamageMsgColors;

var transient GFxClikWidget HUDChatInputField, PartyChatInputField;
var transient bool bReplicatedColorTextures;

var config Color HudMainColor, HudOutlineColor, FontColor, CustomArmorColor, CustomHealthColor;
var config int HealthBarFullVisDist, HealthBarCutoffDist;
var config int iConfigVersion;

var config enum PlayerInfo
{
    INFO_CLASSIC,
    INFO_LEGACY,
    INFO_MODERN
} PlayerInfoType; 

simulated function PostBeginPlay()
{
    local bool bSaveConfig;
    
    Super.PostBeginPlay();
    
    if( iConfigVersion <= 0 )
    {
        HudMainColor = DefaultHudMainColor;
        HudOutlineColor = DefaultHudOutlineColor;
        FontColor = DefaultFontColor;
        
        PlayerInfoType = ClassicPlayerInfo ? INFO_LEGACY : INFO_MODERN;
        HealthBarFullVisDist = 350.f;
        HealthBarCutoffDist = 3500.f;
        
        iConfigVersion++;
        bSaveConfig = true;
    }
    
    if( iConfigVersion <= 1 )
    {
        switch(PlayerInfoType)
        {
            case INFO_CLASSIC:
                CustomArmorColor = BlueColor;
                CustomHealthColor = RedColor;
                break;
            case INFO_LEGACY:
                CustomArmorColor = ClassicArmorColor;
                CustomHealthColor = ClassicHealthColor;
                break;
            case INFO_MODERN:
                CustomArmorColor = ArmorColor;
                CustomHealthColor = HealthColor;
                break;    
        }
        
        iConfigVersion++;
        bSaveConfig = true;
    }
    
    if( bSaveConfig )
        SaveConfig();
    
    SetupHUDTextures();
    
    SetTimer(0.1, true, 'SetupFontBlur');
    SetTimer(0.1f, true, 'CheckForWeaponPickup');
    SetTimer(0.1f, true, 'BuildCacheItems');
    
    PlayerOwner.PlayerInput.OnReceivedNativeInputKey = NotifyInputKey;
    PlayerOwner.PlayerInput.OnReceivedNativeInputAxis = NotifyInputAxis;
    PlayerOwner.PlayerInput.OnReceivedNativeInputChar = NotifyInputChar;
    
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
    if( OnlineSub!=None )
    {
        OnlineSub.AddOnInventoryReadCompleteDelegate(SearchInventoryForNewItem);
        SetTimer(60,false,'SearchInventoryForNewItem');
    }

    SetTimer(300 + FRand()*120.f, false, 'CheckForItems');
    
    if( true ) // ???
    {
        RemoveMovies();
        CreateHUDMovie();
    }
}

function ResetHUDColors()
{
    HudMainColor = DefaultHudMainColor;
    HudOutlineColor = DefaultHudOutlineColor;
    FontColor = DefaultFontColor;
    SaveConfig();
    SetupHUDTextures();
}

function BuildCacheItems()
{
    local KFPawn_Human KFPH;
    
    foreach WorldInfo.AllPawns( class'KFPawn_Human', KFPH )
    {
        if( PawnList.Find(KFPH) == INDEX_NONE )
            PawnList.AddItem(KFPH);
    }
}

simulated function CheckForWeaponPickup()
{
    WeaponPickup = GetWeaponPickup();
}

simulated function KFDroppedPickup GetWeaponPickup()
{
    local KFDroppedPickup KFDP, BestKFDP;
    local int KFDPCount, ZedCount;
    local vector EndTrace, HitLocation, HitNormal;
    local Actor HitActor;
    local float DistSq, BestDistSq;
    local KFPawn_Monster KFPM;

    if (KFPlayerOwner == None || !KFPlayerOwner.WorldInfo.GRI.bMatchHasBegun)
        return None;

    EndTrace = PLCameraLoc + PLCameraDir * MaxWeaponPickupDist;
    HitActor = KFPlayerOwner.Trace(HitLocation, HitNormal, EndTrace, PLCameraLoc);
    
    if (HitActor == None)
        return None;
        
    foreach KFPlayerOwner.CollidingActors(class'KFPawn_Monster', KFPM, ZedScanRadius, HitLocation)
    {
        if (KFPM.IsAliveAndWell())
            return None;
        
        ZedCount++;
        if (ZedCount > 20)
            return None;
    }
        
    BestDistSq = WeaponPickupScanRadius * WeaponPickupScanRadius;

    foreach KFPlayerOwner.CollidingActors(class'KFDroppedPickup', KFDP, WeaponPickupScanRadius, HitLocation)
    {
        if (KFDP.Velocity.Z == 0 && ClassIsChildOf(KFDP.InventoryClass, class'KFWeapon'))
        {
            DistSq = VSizeSq(KFDP.Location - HitLocation);
            if (DistSq < BestDistSq)
            {
                BestKFDP = KFDP;
                BestDistSq = DistSq;
            }
        }

        KFDPCount++;
        if (KFDPCount > 2)
            break;
    }

    return BestKFDP;
}

simulated function SetupFontBlur()
{
    FontBlurX = RandRange(-8, 8);
    FontBlurX2 = RandRange(-8, 8);
    FontBlurY = RandRange(-8, 8);
    FontBlurY2 = RandRange(-8, 8);
}

function SetupHUDTextures(optional bool bUseColorIcons)
{
    ProgressBarTex = Texture2D(RepObject.ReferencedObjects[85]);
    
    HealthIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[146]) : Texture2D(RepObject.ReferencedObjects[27]);
    ArmorIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[149]) : Texture2D(RepObject.ReferencedObjects[31]);
    WeightIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[152]) : Texture2D(RepObject.ReferencedObjects[34]);
    GrenadesIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[142]) : Texture2D(RepObject.ReferencedObjects[23]);
    DoshIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[148]) : Texture2D(RepObject.ReferencedObjects[30]);
    BulletsIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[136]) : Texture2D(RepObject.ReferencedObjects[17]);
    ClipsIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[131]) : Texture2D(RepObject.ReferencedObjects[11]);
    BurstBulletIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[137]) : Texture2D(RepObject.ReferencedObjects[18]);
    AutoTargetIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[133]) : Texture2D(RepObject.ReferencedObjects[13]);
    
    ArrowIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[132]) : Texture2D(RepObject.ReferencedObjects[12]);
    FlameIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[139]) : Texture2D(RepObject.ReferencedObjects[19]);
    FlameTankIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[138]) : Texture2D(RepObject.ReferencedObjects[20]);
    FlashlightIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[141]) : Texture2D(RepObject.ReferencedObjects[21]);
    FlashlightOffIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[140]) : Texture2D(RepObject.ReferencedObjects[22]);
    RocketIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[143]) : Texture2D(RepObject.ReferencedObjects[24]);
    BoltIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[144]) : Texture2D(RepObject.ReferencedObjects[25]);
    M79Icon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[145]) : Texture2D(RepObject.ReferencedObjects[26]);
    PipebombIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[147]) : Texture2D(RepObject.ReferencedObjects[29]);
    SingleBulletIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[150]) : Texture2D(RepObject.ReferencedObjects[32]);
    SyringIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[151]) : Texture2D(RepObject.ReferencedObjects[33]);
    SawbladeIcon = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[153]) : Texture2D(RepObject.ReferencedObjects[78]);
    ManualTargetIcon = bUseColorIcons ? Texture2D'KFClassicMode_Assets.HUD_Color.Hud_ManualTarget_White' : Texture2D'KFClassicMode_Assets.HUD.Hud_ManualTarget';
    
    TraderBox = Texture2D(RepObject.ReferencedObjects[16]);
    
    InventoryBackgroundTexture = Texture2D(RepObject.ReferencedObjects[113]);
    SelectedInventoryBackgroundTexture = Texture2D(RepObject.ReferencedObjects[114]);
    
    WaveCircle = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[134]) : Texture2D(RepObject.ReferencedObjects[15]);
    BioCircle = bUseColorIcons ? Texture2D(RepObject.ReferencedObjects[135]) : Texture2D(RepObject.ReferencedObjects[14]);
}

function PostRender()
{
    if( !bReplicatedColorTextures && HudOutlineColor != DefaultHudOutlineColor )
    {
        bReplicatedColorTextures = true;
        SetupHUDTextures(true);
    }
    else if( bReplicatedColorTextures && HudOutlineColor == DefaultHudOutlineColor )
    {
        bReplicatedColorTextures = false;
        SetupHUDTextures();
    }
    
    if( KFGRI == None )
        KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
    
    if( GUIController!=None && PlayerOwner.PlayerInput==None )
        GUIController.NotifyLevelChange();
        
    if( GUIController==None || GUIController.bIsInvalid )
    {
        GUIController = Class'ScoreboardExt.KF2GUIController'.Static.GetGUIController(PlayerOwner);
        if( GUIController!=None )
        {
            GUIStyle = GUIController.CurrentStyle;
            GUIStyle.HUDOwner = self;
            LaunchHUDMenus();
        }
    }
    GUIStyle.Canvas = Canvas;
    GUIStyle.PickDefaultFontSize(Canvas.ClipY);
    
    if( !GUIController.bIsInMenuState )
        GUIController.HandleDrawMenu();
    
    ScaledBorderSize = FMax(GUIStyle.ScreenScale(HUDBorderSize), 1.f);
    
    Super.PostRender();
    
    PlayerOwner.GetPlayerViewPoint(PLCameraLoc,PLCameraRot);
    PLCameraDir = vector(PLCameraRot);
        
    DamageHistoryNum = 0;
}

function LaunchHUDMenus()
{
    Scoreboard = KFScoreBoard(GUIController.InitializeHUDWidget(ScoreboardClass));
    Scoreboard.SetVisibility(false);
}

function bool NotifyInputKey(int ControllerId, Name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
    local int i;
    
    for( i=(HUDWidgets.Length-1); i>=0; --i )
    {
        if( HUDWidgets[i].bVisible && HUDWidgets[i].NotifyInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad) )
            return true;
    }
    
    return false;
}

function bool NotifyInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad)
{
    local int i;
    
    for( i=(HUDWidgets.Length-1); i>=0; --i )
    {
        if( HUDWidgets[i].bVisible && HUDWidgets[i].NotifyInputAxis(ControllerId, Key, Delta, DeltaTime, bGamepad) )
            return true;
    }
    
    return false;
}

function bool NotifyInputChar(int ControllerId, string Unicode)
{
    local int i;
    
    for( i=(HUDWidgets.Length-1); i>=0; --i )
    {
        if( HUDWidgets[i].bVisible && HUDWidgets[i].NotifyInputChar(ControllerId, Unicode) )
            return true;
    }
    
    return false;
}

delegate int SortRenderDistance(KFPawn_Human PawnA, KFPawn_Human PawnB)
{
    return VSizeSq(PawnA.Location - PlayerOwner.Location) < VSizeSq(PawnB.Location - PlayerOwner.Location) ? -1 : 0;
}

function DrawHUD()
{
    local KFPawn_Human KFPH;
    local vector PlayerPartyInfoLocation;
    local array<PlayerReplicationInfo> VisibleHumanPlayers;
    local array<sHiddenHumanPawnInfo> HiddenHumanPlayers;
    local float ThisDot;
    local vector TargetLocation;
    local Actor LocActor;
    local int i;
    
    if( KFPlayerOwner != none && KFPlayerOwner.Pawn != None && KFPlayerOwner.Pawn.Weapon != None )
    {
        KFPlayerOwner.Pawn.Weapon.DrawHUD( self, Canvas );
    }

    Super(HUD).DrawHUD();
    
    Canvas.EnableStencilTest(false);

    if( KFGRI == None )
    {
        KFGRI = KFGameReplicationInfo( WorldInfo.GRI );
    }

    if( KFPlayerOwner == None )
    {
        return;
    }
    
    if( !KFPlayerOwner.bCinematicMode )
    {
        LocActor = KFPlayerOwner.ViewTarget != none ? KFPlayerOwner.ViewTarget : KFPlayerOwner;

        if( KFPlayerOwner != none && (bDrawCrosshair || bForceDrawCrosshair || KFPlayerOwner.GetTeamNum() == 255) )
        {
            DrawCrosshair();
        }

        if( PlayerOwner.GetTeamNum() == 0 )
        {
            Canvas.EnableStencilTest(true);
            
            // Probably slow but needed to properly sort the rendering so farther elements don't overlap closer ones.
            PawnList.Sort(SortRenderDistance);
            foreach PawnList( KFPH )
            {
                if( KFPH != None && KFPH.IsAliveAndWell() && KFPH != KFPlayerOwner.Pawn && KFPH.Mesh.SkeletalMesh != none && KFPH.Mesh.bAnimTreeInitialised )
                {
                    PlayerPartyInfoLocation = KFPH.Mesh.GetPosition() + ( KFPH.CylinderComponent.CollisionHeight * vect(0,0,1) );
                    if(`TimeSince(KFPH.Mesh.LastRenderTime) < 0.2f && Normal(PlayerPartyInfoLocation - PLCameraLoc) dot PLCameraDir > 0.f )
                    {
                        if( DrawFriendlyHumanPlayerInfo(KFPH) )
                        {
                            VisibleHumanPlayers.AddItem( KFPH.PlayerReplicationInfo );
                        }
                        else
                        {
                            HiddenHumanPlayers.Insert( 0, 1 );
                            HiddenHumanPlayers[0].HumanPawn = KFPH;
                            HiddenHumanPlayers[0].HumanPRI = KFPH.PlayerReplicationInfo;
                        }
                    }
                    else
                    {
                        HiddenHumanPlayers.Insert( 0, 1 );
                        HiddenHumanPlayers[0].HumanPawn = KFPH;
                        HiddenHumanPlayers[0].HumanPRI = KFPH.PlayerReplicationInfo;
                    }
                }
            }

            if( !KFGRI.bHidePawnIcons )
            {
                CheckAndDrawHiddenPlayerIcons( VisibleHumanPlayers, HiddenHumanPlayers );
                CheckAndDrawRemainingZedIcons();

                if(KFGRI.CurrentObjective != none && KFGRI.ObjectiveInterface != none)
                {
                    KFGRI.ObjectiveInterface.DrawHUD(self, Canvas);

                    TargetLocation = KFGRI.ObjectiveInterface.GetIconLocation();
                    ThisDot = Normal((TargetLocation + (class'KFPawn_Human'.default.CylinderComponent.CollisionHeight * vect(0, 0, 1))) - PLCameraLoc) dot PLCameraDir;
                
                    if (ThisDot > 0 &&  
                        KFGRI.ObjectiveInterface.ShouldShowObjectiveHUD() &&
                        (!KFGRI.ObjectiveInterFace.HasObjectiveDrawDistance() || VSizeSq(TargetLocation - LocActor.Location) < MaxDrawDistanceObjective))
                    {
                        DrawObjectiveHUD();
                    }
                }
            }

            Canvas.EnableStencilTest(false);
        }
    }
}

simulated function SearchInventoryForNewItem()
{
    local int i,j;

    if( WasNewlyAdded.Length!=OnlineSub.CurrentInventory.Length )
        WasNewlyAdded.Length = OnlineSub.CurrentInventory.Length;
    for( i=0; i<OnlineSub.CurrentInventory.Length; ++i )
    {
        if( OnlineSub.CurrentInventory[i].NewlyAdded==1 && WasNewlyAdded[i]==0 )
        {
            WasNewlyAdded[i] = 1;
            if( WorldInfo.TimeSeconds<80.f || !bLoadedInitItems ) // Skip initial inventory.
                continue;
            
            j = OnlineSub.ItemPropertiesList.Find('Definition', OnlineSub.CurrentInventory[i].Definition);
            if(j != INDEX_NONE)
            {
                NewItems.Insert(0,1);
                NewItems[0].Item = OnlineSub.ItemPropertiesList[j].Name$" ["$RarityStr(OnlineSub.ItemPropertiesList[j].Rarity)$"]";
                NewItems[0].MsgTime = WorldInfo.TimeSeconds;
                
                PlayerOwner.PlayAKEvent(AkEvent'WW_UI_Menu.Play_UI_Drop');
            }
        }
    }
    bLoadedInitItems = true;
}

simulated final function string RarityStr( byte R )
{
    switch( R )
    {
    case ITR_Common:                return "Common";
    case ITR_Uncommon:              return "Uncommon";
    case ITR_Rare:                  return "Rare";
    case ITR_Legendary:             return "Legendary";
    case ITR_ExceedinglyRare:       return "Exceedingly Rare";
    case ITR_Mythical:              return "Mythical";
    default:                        return "Very Common";
    }
}

simulated function CheckForItems()
{
    if( KFGRI!=none )
        KFGRI.ProcessChanceDrop();
    SetTimer(260+FRand()*220.f,false,'CheckForItems');
}

function AddPopupMessage(const out PopupMessage NewMessage) 
{
    MessageQueue.AddItem(NewMessage);

    if( MessageQueue.Length == 1 ) 
    {
        NotificationPhaseStartTime = WorldInfo.TimeSeconds;
        NotificationPhase = PHASE_SHOWING;
    }
}

function string GetGameInfoText()
{
    if( KFGRI != None )
    {
        if( KFGRI.bTraderIsOpen )
            return GUIStyle.GetTimeString(KFGRI.GetTraderTimeRemaining());
        else if( KFGRI.bWaveIsActive )
        {
            if( KFGRI.IsBossWave() )
                return class'KFGFxHUD_WaveInfo'.default.BossWaveString;
            else if( KFGRI.IsEndlessWave() )
                return Chr(0x221E);
            else if( KFGRI.bMatchIsOver )
                return "---";
            
            return string(KFGRI.AIRemaining);
        }
    }
    
    return "";
}

function string GetGameInfoSubText()
{
    if( KFGRI != None && !KFGRI.IsBossWave() )
        return class'KFGFxHUD_WaveInfo'.default.WaveString @ KFGameReplicationInfo_Endless(KFGRI) != None ? string(KFGRI.WaveNum) : string(KFGRI.WaveNum) $ "/" $ string(KFGRI.WaveMax-1);
    return "";
}

function DrawHUDBox
    (
    out float X, 
    out float Y, 
    float Width, 
    float Height, 
    coerce string Text, 
    float TextScale=1.f,
    optional HUDBoxRenderInfo HBRI
    )
{
    local float XL, YL, IconXL, IconYL, IconW, TextX, TextY;
    local bool bUseAlpha;
    local int i;
    local FontRenderInfo FRI;
    local Color BoxColor, OutlineColor, TextColor, BlankColor;
    
    FRI.bClipText = true;
    FRI.bEnableShadow = true;
    
    bUseAlpha = HBRI.Alpha != -1.f;
    BoxColor = HBRI.BoxColor == BlankColor ? HudMainColor : HBRI.BoxColor;
    OutlineColor = HBRI.OutlineColor == BlankColor ? HudOutlineColor : HBRI.OutlineColor;
    TextColor = HBRI.TextColor == BlankColor ? FontColor : HBRI.TextColor;
    
    if( bUseAlpha )
    {
        BoxColor.A = byte(Min(HBRI.Alpha, HudMainColor.A));
        OutlineColor.A = byte(Min(HBRI.Alpha, HudOutlineColor.A));
        TextColor.A = byte(HBRI.Alpha);
    }
    
    if( HBRI.IconTex != None )
    {
        if( HBRI.IconScale == 1.f )
            HBRI.IconScale = Height;
        
        IconW = HBRI.IconScale - (HBRI.bUseRounded ? 0.f : ScaledBorderSize);
        
        IconXL = X + (IconW*0.5f);
        IconYL = Y + (Height * 0.5f) - (IconW * 0.5f);
        
        if( HudOutlineColor != DefaultHudOutlineColor )
        {
            Canvas.DrawColor = HudOutlineColor;
            if( !bUseAlpha ) 
                Canvas.DrawColor.A = 255;
        }
        else Canvas.SetDrawColor(255, 255, 255, bUseAlpha ? byte(HBRI.Alpha) : 255);
        
        Canvas.SetPos(IconXL, IconYL);
        Canvas.DrawRect(IconW, IconW, HBRI.IconTex);
    }

    Canvas.DrawColor = TextColor;
    
    if( HBRI.StringArray.Length < 1 )
    {
        Canvas.TextSize(Text, XL, YL, TextScale, TextScale);
        
        if( HBRI.IconTex != None )
            TextX = IconXL + IconW + (ScaledBorderSize*4);
        else TextX = X + (Width * 0.5f) - (XL * 0.5f);
        
        TextY = Y + (Height * 0.5f) - (YL * 0.5f);
        if( !HBRI.bUseRounded )
        {
            TextY -= (ScaledBorderSize*0.5f);
            
            // Always one pixel off, could not find the source
            if( Canvas.SizeX != 1920 )
                TextY -= GUIStyle.ScreenScale(1.f);
        }
        
        if( HBRI.bUseOutline )
            GUIStyle.DrawTextShadow(Text, TextX, TextY, 1, TextScale);
        else
        {
            Canvas.SetPos(TextX, TextY);
            Canvas.DrawText(Text,, TextScale, TextScale, FRI);
        }
    }
    else
    {
        TextY = Y + ((Height*0.05)*0.5f);
        
        for( i=0; i<HBRI.StringArray.Length; ++i )
        {
            Canvas.TextSize(HBRI.StringArray[i], XL, YL, TextScale, TextScale);
            
            if( HBRI.IconTex != None )
                TextX = IconXL + IconW + (ScaledBorderSize*4);
            else TextX = X + (Width * 0.5f) - (XL * 0.5f);
            
            if( HBRI.bUseOutline )
                GUIStyle.DrawTextShadow(HBRI.StringArray[i], TextX, TextY, 1, TextScale);
            else
            {
                Canvas.SetPos(TextX, TextY);
                Canvas.DrawText(HBRI.StringArray[i],, TextScale, TextScale, FRI);
            }
            TextY+=YL-(ScaledBorderSize*0.5f);
        }
    }
    
    switch(HBRI.Justification)
    {
        case HUDA_Right:
            X += Width + GUIStyle.ScreenScale(HBRI.JustificationPadding) - ScaledBorderSize;
            break;
        case HUDA_Left:
            X -= Width + GUIStyle.ScreenScale(HBRI.JustificationPadding) - ScaledBorderSize;
            break;
        case HUDA_Top:
            Y += Height + GUIStyle.ScreenScale(HBRI.JustificationPadding) - ScaledBorderSize;
            break;
        case HUDA_Bottom:
            Y -= Height + GUIStyle.ScreenScale(HBRI.JustificationPadding) - ScaledBorderSize;
            break;
    }
}

function RefreshInventory()
{
    if ( `TimeSince(InventoryFadeStartTime) > InventoryFadeInTime )
    {
        if ( `TimeSince(InventoryFadeStartTime) > InventoryFadeTime - InventoryFadeOutTime )
            InventoryFadeStartTime = `TimeSince(InventoryFadeInTime + ((InventoryFadeTime - `TimeSince(InventoryFadeStartTime)) * InventoryFadeInTime));
        else InventoryFadeStartTime = `TimeSince(InventoryFadeInTime);
    }
}

final function bool GetItemIndicesFromArche( out byte ItemIndex, name WeaponClassName )
{
	local int Index;
    
    Index = KFGRI.TraderItems.SaleItems.Find('ClassName', WeaponClassName);
    if( Index != INDEX_NONE )
    {
        ItemIndex = Index;
        return true;
    }
    
    return false;
}

final function string GetWeaponCatagoryName(int Index)
{
    switch(Index)
    {
        case 0:
            return class'KFGFxHUD_WeaponSelectWidget'.default.PrimaryString;
        case 1:
            return class'KFGFxHUD_WeaponSelectWidget'.default.SecondaryString;
        case 2:
            return class'KFGFxHUD_WeaponSelectWidget'.default.MeleeString;
        case 3:
            return class'KFGFxHUD_WeaponSelectWidget'.default.EquiptmentString;
        default:
            return "ERROR!!";
    }
}

function ShowPriorityMessage(FPriorityMessage Msg)
{
    if( Msg.LifeTime <= 0.f )
        Msg.LifeTime = 15.f;
        
    Msg.LifeTime += 0.5f;
    Msg.StartTime = WorldInfo.TimeSeconds;
    PriorityMessage = Msg;
}

function ShowNonCriticalMessage( string Message, optional string Delimiter, optional bool bHighlight, optional bool bUseAnimation )
{    
    local FCritialMessage Messages;
    local int Index;
    local float DisplayTime;
    
    if( KFPlayerOwner.IsBossCameraMode() )
        return;
        
    Index = NonCriticalMessages.Find('Text', Message);
    if( Index != INDEX_NONE )
    {
        DisplayTime = bUseAnimation ? 1.775f : NonCriticalMessageDisplayTime;
        if ( `TimeSince(NonCriticalMessages[Index].StartTime) > NonCriticalMessageFadeInTime )
        {
            if ( `TimeSince(NonCriticalMessages[Index].StartTime) > DisplayTime - NonCriticalMessageFadeOutTime )
                NonCriticalMessages[Index].StartTime = `TimeSince(NonCriticalMessageFadeInTime + ((DisplayTime - `TimeSince(NonCriticalMessages[Index].StartTime)) * NonCriticalMessageFadeInTime));
            else NonCriticalMessages[Index].StartTime = `TimeSince(NonCriticalMessageFadeInTime);
        }
        
        return;
    }
    
    if( NonCriticalMessages.Length >= MaxNonCriticalMessages )
        return;
        
    Messages.Text = Message;
    Messages.Delimiter = Delimiter;
    Messages.StartTime = WorldInfo.TimeSeconds;
    Messages.bHighlight = bHighlight;
    Messages.bUseAnimation = bUseAnimation;
    
    NonCriticalMessages.AddItem(Messages);
}

function Texture GetClipIcon(KFWeapon Wep, bool bSingleFire)
{
    if( bSingleFire )
        return GetBulletIcon(Wep);
    else if( Wep.FireModeIconPaths[Wep.const.DEFAULT_FIREMODE] != None && Wep.FireModeIconPaths[Wep.const.DEFAULT_FIREMODE].Name == 'UI_FireModeSelect_Flamethrower' )
        return FlameTankIcon;
    
    return ClipsIcon;
}

function Texture GetBulletIcon(KFWeapon Wep)
{
    if( Wep.bUseAltFireMode )
        return GetSecondaryAmmoIcon(Wep);
    else if( Wep.IsA('KFWeap_Bow_Crossbow') )
        return ArrowIcon;
    else if( Wep.IsA('KFWeap_Edged_IonThruster') )
        return BoltIcon;
    else
    {
        if( KFWeap_ThrownBase(Wep) != None && Wep.FireModeIconPaths[class'KFWeap_ThrownBase'.const.THROW_FIREMODE] != None )
        {
            Switch(Wep.FireModeIconPaths[class'KFWeap_ThrownBase'.const.THROW_FIREMODE].Name)
            {       
                case 'UI_FireModeSelect_Grenade':
                    return PipebombIcon;
            }
        }
        else if( Wep.FireModeIconPaths[Wep.const.DEFAULT_FIREMODE] != None )
        {
            Switch(Wep.FireModeIconPaths[Wep.const.DEFAULT_FIREMODE].Name)
            {
                case 'UI_FireModeSelect_Flamethrower':
                    return FlameIcon;
                case 'UI_FireModeSelect_Sawblade':
                    return SawbladeIcon;
                case 'UI_FireModeSelect_BulletSingle':
                    if( Wep.MagazineCapacity[Wep.const.DEFAULT_FIREMODE] > 1 )
                        return BulletsIcon;
                    return SingleBulletIcon;
                case 'UI_FireModeSelect_Grenade':
                    return M79Icon;
                case 'UI_FireModeSelect_MedicDart':
                    return SyringIcon;
                case 'UI_FireModeSelect_Rocket':
                    return RocketIcon;
                case 'UI_FireModeSelect_Electricity':
                    return BoltIcon;
                case 'UI_FireModeSelect_BulletBurst':
                    return BurstBulletIcon;
            }
        }
    }
    
    return BulletsIcon;
}

function Texture GetSecondaryAmmoIcon(KFWeapon Wep)
{
    if( Wep.UsesSecondaryAmmo() && Wep.SecondaryAmmoTexture != None )
    {
        Switch(Wep.SecondaryAmmoTexture.Name)
        {
            case 'GasTank':
                return FlameTankIcon;
            case 'MedicDarts':
                return SyringIcon;
            case 'UI_FireModeSelect_Grenade':
                return M79Icon;
        }
    }
    else if( Wep.FireModeIconPaths[Wep.const.ALTFIRE_FIREMODE] != None )
    {
        Switch(Wep.FireModeIconPaths[Wep.const.ALTFIRE_FIREMODE].Name)
        {
            case 'UI_FireModeSelect_AutoTarget':
                return AutoTargetIcon;
            case 'UI_FireModeSelect_ManualTarget':
                return ManualTargetIcon;
            case 'UI_FireModeSelect_BulletBurst':
                return BurstBulletIcon;
            case 'UI_FireModeSelect_BulletSingle':
                if( Wep.MagazineCapacity[Wep.ALTFIRE_FIREMODE] > 1 )
                    return BulletsIcon;
                else return SingleBulletIcon;
            case 'UI_FireModeSelect_Electricity':
                return BoltIcon;
            case 'UI_FireModeSelect_MedicDart':
                return SyringIcon;
        }
    }
    
    return SingleBulletIcon;
}

function color GetMsgColor( bool bDamage, int Count )
{
    local float T;

    if( bDamage )
    {
        if( Count>1500 )
            return MakeColor(148,0,0,255);
        else if( Count>1000 )
        {
            T = (Count-1000) / 500.f;
            return MakeColor(148,0,0,255)*T + MakeColor(255,0,0,255)*(1.f-T);
        }
        else if( Count>500 )
        {
            T = (Count-500) / 500.f;
            return MakeColor(255,0,0,255)*T + MakeColor(255,255,0,255)*(1.f-T);
        }
        T = Count / 500.f;
        return MakeColor(255,255,0,255)*T + MakeColor(0,255,0,255)*(1.f-T);
    }
    if( Count>20 )
        return MakeColor(255,0,0,255);
    else if( Count>10 )
    {
        T = (Count-10) / 10.f;
        return MakeColor(148,0,0,255)*T + MakeColor(255,0,0,255)*(1.f-T);
    }
    else if( Count>5 )
    {
        T = (Count-5) / 5.f;
        return MakeColor(255,0,0,255)*T + MakeColor(255,255,0,255)*(1.f-T);
    }
    T = Count / 5.f;
    return MakeColor(255,255,0,255)*T + MakeColor(0,255,0,255)*(1.f-T);
}

static function string StripMsgColors( string S )
{
    local int i;
    
    while( true )
    {
        i = InStr(S,Chr(6));
        if( i==-1 )
            break;
        S = Left(S,i)$Mid(S,i+2);
    }
    return S;
}

static function string GetNameArticle( string S )
{
    switch( Caps(Left(S,1)) ) // Check if a vowel, then an.
    {
    case "A":
    case "E":
    case "I":
    case "O":
    case "U":
        return "an";
    }
    return "a";
}

static function string GetNameOf( class<Pawn> Other )
{
    local string S;
    local class<KFPawn_Monster> KFM;
        
    KFM = class<KFPawn_Monster>(Other);
    if( KFM!=None )
        return KFM.static.GetLocalizedName();
        
    if( Other.Default.MenuName!="" )
        return Other.Default.MenuName;
        
    S = string(Other.Name);
    if( Left(S,10)~="KFPawn_Zed" )
        S = Mid(S,10);
    else if( Left(S,7)~="KFPawn_" )
        S = Mid(S,7);
    S = Repl(S,"_"," ");
    
    return S;
}

function ShowKillMessage(PlayerReplicationInfo PRI1, PlayerReplicationInfo PRI2, optional bool bDeathMessage=false, optional string KilledName, optional string KillerName)
{
    local FKillMessageType Msg;
    local int i;
    
    if( bDeathMessage )
    {
        Msg.bPlayerDeath = true;
        Msg.KillerName = KillerName;
        Msg.MsgTime = WorldInfo.TimeSeconds;
        Msg.Name = KilledName;
        Msg.bSuicide = KillerName == KilledName;
        Msg.MsgColor = MakeColor(0, 162, 232, 255);
        Msg.XPosition = SizeX*0.015;
        
        KillMessages.AddItem(Msg);
        return;
    }

    for( i=0; i<KillMessages.Length; ++i )
    {
        if( KillMessages[i].Name==KilledName && KillMessages[i].OwnerPRI==PRI1 )
        {
            KillMessages[i].Counter+=1;
            KillMessages[i].MsgTime = WorldInfo.TimeSeconds;
            KillMessages[i].MsgColor = GetMsgColor(false,KillMessages[i].Counter);
            return;
        }
    }
    
    KillMessages.Length = i+1;
    KillMessages[i].bLocal = true;
    KillMessages[i].Counter = 1;
    KillMessages[i].OwnerPRI = PRI1;
    KillMessages[i].MsgTime = WorldInfo.TimeSeconds;
    KillMessages[i].Name = KilledName;
    KillMessages[i].MsgColor = GetMsgColor(false,1);
    KillMessages[i].XPosition = SizeX*0.015;
}

function AddNumberMsg( int Amount, vector Pos, class<KFDamageType> Type )
{
    local vector RandVect;
    local EDamageOverTimeGroup DotType;
    
    RandVect.X = RandRange(-64, 64);
    RandVect.Y = RandRange(-64, 64);
    RandVect.Z = RandRange(-64, 64);

    DamagePopups[NextDamagePopupIndex].Damage = Amount;
    DamagePopups[NextDamagePopupIndex].HitTime = WorldInfo.TimeSeconds;
    DamagePopups[NextDamagePopupIndex].HitLocation = Pos;
    DamagePopups[NextDamagePopupIndex].RandVect = RandVect;
    
    if( Type == None )
        DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_Unspecified];
    else
    {
        DotType = Type.default.DoT_Type;
        if( DotType == DOT_Fire )
            DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_Fire];
        else if( DotType == DOT_Toxic )
            DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_Toxic];
        else if( DotType == DOT_Bleeding )
            DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_Bleeding];
        else if( Type.default.EMPPower > 0.f )
            DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_EMP];
        else if( Type.default.FreezePower > 0.f )
            DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_Freeze];
        else if( class<KFDT_Explosive_FlashBangGrenade>(Type) != None )
            DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_Flashbang];
        else if ( Amount < 100 )
            DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_Generic];
        else if ( Amount >= 175 )
            DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_High];
        else DamagePopups[NextDamagePopupIndex].FontColor = DamageMsgColors[DMG_Medium];
    }
    
    if( ++NextDamagePopupIndex >= DAMAGEPOPUP_COUNT)
        NextDamagePopupIndex=0;
}

function string GetSpeedStr()
{
    local int Speed;
    local string S;
    local vector Velocity2D;

    if ( KFPawn(PlayerOwner.Pawn) == None )
        return S;

    Velocity2D = PlayerOwner.Pawn.Velocity;
    Velocity2D.Z = 0;
    Speed = VSize(Velocity2D);
    S = string(Speed) $ "/" $ int(PlayerOwner.Pawn.GroundSpeed);

    if ( Speed >= int(KFPawn(PlayerOwner.Pawn).SprintSpeed) ) 
        Canvas.SetDrawColor(0, 100, 255);
    else if ( Speed >= int(PlayerOwner.Pawn.GroundSpeed) )
        Canvas.SetDrawColor(0, 206, 0);
    else Canvas.SetDrawColor(255, 64, 64);

    return S;
}

function DrawImportantHealthBar(float X, float Y, float W, float H, string S, float HealthFrac, Color MainColor, Color BarColor, Texture2D Icon, optional float BorderScale, optional bool bDisabled, optional bool bTrackDamageHistory, optional int Health, optional int HealthMax, optional bool bEaseInOut)
{
    local float FontScalar,MainBoxH,XPos,YPos,IconBoxX,IconBoxY,IconXL,IconYL,XL,YL,HistoryX;
    local Color BoxColor,FadeColor;
    
    if( BorderScale == 0.f )
        BorderScale = ScaledBorderSize*2;
        
    if( bDisabled )
        MainColor.A = 95;
    
    MainBoxH = H * 2;
    IconBoxX = X;
    IconBoxY = Y;
    
    BoxColor = MakeColor(30, 30, 30, 255);
    GUIStyle.DrawRoundedBoxEx(BorderScale, IconBoxX, IconBoxY, MainBoxH, MainBoxH, BoxColor, true, false, true, false);
    
    X += MainBoxH;
    W -= MainBoxH;
    
    GUIStyle.DrawRoundedBoxEx(BorderScale, X, Y, W, H, MainColor, false, true, false, true);
    
    // ToDo - Make this code less ugly and more optimal. Moving the boss healthbar to a widget may help
    if( bTrackDamageHistory )
    {
        if( HealthBarDamageHistory.Length == 0 )
            HealthBarDamageHistory.Length = DamageHistoryNum+1;
            
        GUIStyle.DrawRoundedBoxEx(BorderScale, X, Y, W * HealthFrac, H, BarColor, false, !HealthBarDamageHistory[DamageHistoryNum].bDrawingHistory, false, !HealthBarDamageHistory[DamageHistoryNum].bDrawingHistory);
        
        if( DamageHistoryNum >= HealthBarDamageHistory.Length )
            HealthBarDamageHistory.Length = DamageHistoryNum+1;
            
        if( HealthBarDamageHistory[DamageHistoryNum].OldBarHealth != Health )
        {
            if( HealthBarDamageHistory[DamageHistoryNum].OldBarHealth > Health )
            {
                HealthBarDamageHistory[DamageHistoryNum].bDrawingHistory = true;
                
                if( HealthBarDamageHistory[DamageHistoryNum].OldHealth != Health )
                {
                    HealthBarDamageHistory[DamageHistoryNum].OldHealth = Health;
                    HealthBarDamageHistory[DamageHistoryNum].LastHealthUpdate = WorldInfo.RealTimeSeconds + 0.1f;
                    HealthBarDamageHistory[DamageHistoryNum].HealthUpdateEndTime = WorldInfo.RealTimeSeconds + 1.225f;
                }
                
                HistoryX = X + (W * HealthFrac);
                HealthFrac = FMin(float(HealthBarDamageHistory[DamageHistoryNum].OldBarHealth-Health) / float(HealthMax),1.f-HealthFrac);
                
                FadeColor = WhiteColor;
                FadeColor.A  = BarColor.A;
                if( HealthBarDamageHistory[DamageHistoryNum].LastHealthUpdate < WorldInfo.RealTimeSeconds )
                {
                    FadeColor.A = Clamp(Sin(WorldInfo.RealTimeSeconds * 12) * 200 + 255, 0, BarColor.A);
                    
                    if( HealthBarDamageHistory[DamageHistoryNum].HealthUpdateEndTime < WorldInfo.RealTimeSeconds )
                    {
                        HealthBarDamageHistory[DamageHistoryNum].OldBarHealth = Health;
                        HealthBarDamageHistory[DamageHistoryNum].bDrawingHistory = false;
                        HealthBarDamageHistory[DamageHistoryNum].LastHealthUpdate = 0.f;
                        HealthBarDamageHistory[DamageHistoryNum].HealthUpdateEndTime = 0.f;
                    }
                }
                
                GUIStyle.DrawRoundedBoxEx(ScaledBorderSize*2, HistoryX, Y, W * HealthFrac, H, FadeColor, false, true, false, true);
            }
            else
            {
                HealthBarDamageHistory[DamageHistoryNum].OldBarHealth = Health;
            }
        }
        
        DamageHistoryNum++;
    }
    else GUIStyle.DrawRoundedBoxEx(BorderScale, X, Y, W * HealthFrac, H, BarColor, false, true, false, true);
    
    if( BossShieldPct > 0.f )
        GUIStyle.DrawRoundedBoxEx(ScaledBorderSize, X, Y, W * BossShieldPct, H * 0.25, MakeColor(0, 162, 232, 255), false, true, false, false);

    Canvas.DrawColor = BoxColor;
    Canvas.SetPos(IconBoxX+MainBoxH,IconBoxY);
    GUIStyle.DrawCornerTex(BorderScale*2,3);
    
    IconXL = MainBoxH-BorderScale;
    IconYL = IconXL;
    
    XPos = IconBoxX + (MainBoxH*0.5f) - (IconXL*0.5f);
    YPos = IconBoxY + (MainBoxH*0.5f) - (IconYL*0.5f);
    
    Canvas.SetDrawColor(255, 255, 255, bDisabled ? 95 : 255);
    Canvas.SetPos(XPos, YPos);
    Canvas.DrawRect(IconXL, IconYL, Icon);
    
    if( S != "" )
    {
        Canvas.Font = GUIStyle.PickFont(FontScalar);
        Canvas.TextSize(S, XL, YL, FontScalar, FontScalar);

        XPos = X + BorderScale;
        YPos = (Y+H) + (H*0.5f) - (YL*0.5f);
        
        Canvas.DrawColor = class'HUD'.default.WhiteColor;
        GUIStyle.DrawTextShadow(S, XPos, YPos, 1, FontScalar);
    }
}

final function Vector DrawDirectionalIndicator(Vector Loc, Texture Mat, float IconSize, optional float FontMult=1.f, optional Color DrawColor=WhiteColor, optional string Text, optional bool bDrawBackground)
{
    local rotator R;
    local vector V,X;
    local float XS,YS,FontScalar,BoxW,BoxH,BoxX,BoxY;
    local Canvas.FontRenderInfo FI;
    local bool bWasStencilEnabled;

    FI.bClipText = true;
    Canvas.Font = GUIStyle.PickFont(FontScalar);
    FontScalar *= FontMult;
    
    X = PLCameraDir;
    
    // First see if on screen.
    V = Loc - PLCameraLoc;
    if( (V Dot X)>0.997 ) // Front of camera.
    {
        V = Canvas.Project(Loc+vect(0,0,1.055));
        if( V.X>0 && V.Y>0 && V.X<Canvas.ClipX && V.Y<Canvas.ClipY ) // Within screen bounds.
        {
            Canvas.EnableStencilTest(true);
            
            Canvas.DrawColor = PlayerBarShadowColor;
            Canvas.DrawColor.A = DrawColor.A;
            Canvas.SetPos(V.X-(IconSize*0.5)+1,V.Y-IconSize+1);
            Canvas.DrawRect(IconSize, IconSize, Mat);

            Canvas.DrawColor = DrawColor;
            Canvas.SetPos(V.X-(IconSize*0.5),V.Y-IconSize);
            Canvas.DrawRect(IconSize, IconSize, Mat);
            
            if( Text != "" )
            {
                Canvas.TextSize(Text,XS,YS,FontScalar,FontScalar);
                
                if( bDrawBackground )
                {
                    BoxW = XS+8.f;
                    BoxH = YS+8.f;
                    
                    BoxX = V.X - (BoxW*0.5);
                    BoxY = V.Y - IconSize - BoxH;
                    
                    GUIStyle.DrawOutlinedBox(BoxX, BoxY, BoxW, BoxH, FMax(ScaledBorderSize * 0.5, 1.f), HudMainColor, HudOutlineColor);
                   
                    Canvas.DrawColor = WhiteColor;
                    Canvas.SetPos(BoxX + (BoxW*0.5f) - (XS*0.5f), BoxY + (BoxH*0.5f) - (YS*0.5f));
                    Canvas.DrawText(Text,, FontScalar, FontScalar, FI);
                }
                else
                {
                    Canvas.DrawColor = WhiteColor;
                    GUIStyle.DrawTextShadow(Text, V.X-(XS*0.5), V.Y-IconSize-YS-4.f, 1, FontScalar);
                }
            }
            
            Canvas.EnableStencilTest(false);
            return V;
        }
    }
    
    bWasStencilEnabled = Canvas.bStencilEnabled;
    if( bWasStencilEnabled )
        Canvas.EnableStencilTest(false);
    
    // Draw the material towards the location.
    // First transform offset to local screen space.
    V = (Loc - PLCameraLoc) << PLCameraRot;
    V.X = 0;
    V = Normal(V);

    // Check pitch.
    R.Yaw = rotator(V).Pitch;
    if( V.Y>0 ) // Must flip pitch
        R.Yaw = 32768-R.Yaw;
    R.Yaw+=16384;

    // Check screen edge location.
    V = FindEdgeIntersection(V.Y,-V.Z,IconSize);
    
    // Draw material.
    Canvas.DrawColor = PlayerBarShadowColor;
    Canvas.DrawColor.A = DrawColor.A;
    Canvas.SetPos(V.X+1,V.Y+1);
    Canvas.DrawRotatedTile(Mat,R,IconSize,IconSize,0,0,Mat.GetSurfaceWidth(),Mat.GetSurfaceHeight());
            
    Canvas.DrawColor = DrawColor;
    Canvas.SetPos(V.X,V.Y);
    Canvas.DrawRotatedTile(Mat,R,IconSize,IconSize,0,0,Mat.GetSurfaceWidth(),Mat.GetSurfaceHeight());
    
    if( bWasStencilEnabled )
        Canvas.EnableStencilTest(true);
    
    return V;
}

final function vector FindEdgeIntersection( float XDir, float YDir, float ClampSize )
{
    local vector V;
    local float TimeXS,TimeYS,SX,SY;

    // First check for paralell lines.
    if( Abs(XDir)<0.001f )
    {
        V.X = Canvas.ClipX*0.5f;
        if( YDir>0.f )
            V.Y = Canvas.ClipY-ClampSize;
        else V.Y = ClampSize;
    }
    else if( Abs(YDir)<0.001f )
    {
        V.Y = Canvas.ClipY*0.5f;
        if( XDir>0.f )
            V.X = Canvas.ClipX-ClampSize;
        else V.X = ClampSize;
    }
    else
    {
        SX = Canvas.ClipX*0.5f;
        SY = Canvas.ClipY*0.5f;

        // Look for best intersection axis.
        TimeXS = Abs((SX-ClampSize) / XDir);
        TimeYS = Abs((SY-ClampSize) / YDir);
        
        if( TimeXS<TimeYS ) // X axis intersects first.
        {
            V.X = TimeXS*XDir;
            V.Y = TimeXS*YDir;
        }
        else
        {
            V.X = TimeYS*XDir;
            V.Y = TimeYS*YDir;
        }
        
        // Transform axis to screen center.
        V.X += SX;
        V.Y += SY;
    }
    return V;
}

function DrawProgressBar( float X, float Y, float XS, float YS, float Value )
{
    Canvas.DrawColor.A = 64;
    Canvas.SetPos(X, Y);
    Canvas.DrawTileStretched(ProgressBarTex,XS,YS,0,0,ProgressBarTex.GetSurfaceWidth(),ProgressBarTex.GetSurfaceHeight());
    if( Value>0.f )
    {
        Canvas.DrawColor.A = 150;
        Canvas.SetPos(X,Y);
        Canvas.DrawTileStretched(ProgressBarTex,XS*Value,YS,0,0,ProgressBarTex.GetSurfaceWidth(),ProgressBarTex.GetSurfaceHeight());
    }
}

function DrawXPEarned(float X, float Y)
{
    local int i;
    local float EndTime, TextWidth, TextHeight, Sc, FadeAlpha;
    local string S;

    Canvas.Font = GUIStyle.PickFont(Sc);
    
    for( i=0; i<XPPopups.Length; i++ ) 
    {
        EndTime = `RealTimeSince(XPPopups[i].StartTime);
        if( EndTime > XPFadeOutTime )
        {
            XPPopups.RemoveItem(XPPopups[i]);
            continue;
        }
            
        S = "+"$string(XPPopups[i].XP)@"XP";
        Canvas.TextSize(S,TextWidth,TextHeight,Sc,Sc);

        if( XPPopups[i].bInit )
        {
            XPPopups[i].XPos = X;
            XPPopups[i].YPos = Y-(TextHeight*0.5f);
            XPPopups[i].bInit = false;
        }
        
        if( XPPopups[i].XPos > 0.f && XPPopups[i].XPos < Canvas.ClipX )
            XPPopups[i].XPos += Asin(0.75f * Pi * EndTime/XPFadeOutTime) * (i % 2 == 0 ? -XPPopups[i].RandX : XPPopups[i].RandX);
        else XPPopups[i].XPos = FClamp(XPPopups[i].XPos, 0, Canvas.ClipX);
        
        XPPopups[i].YPos -= (RenderDelta*62.f) * XPPopups[i].RandY;

        FadeAlpha = 255 * Cos(0.5f * Pi * EndTime/XPFadeOutTime);
        if( XPPopups[i].Icon != None )
        {
            Canvas.DrawColor = PlayerBarShadowColor;
            Canvas.DrawColor.A = FadeAlpha;
            
            Canvas.SetPos(XPPopups[i].XPos+1, XPPopups[i].YPos+1);
            Canvas.DrawRect(TextHeight*1.25f, TextHeight*1.25f, XPPopups[i].Icon);
            
            Canvas.DrawColor = XPPopups[i].IconColor;
            Canvas.DrawColor.A = FadeAlpha;
            
            Canvas.SetPos(XPPopups[i].XPos, XPPopups[i].YPos);
            Canvas.DrawRect(TextHeight*1.25f, TextHeight*1.25f, XPPopups[i].Icon);
            
            Canvas.SetDrawColor(255, 255, 255, FadeAlpha);
            GUIStyle.DrawTextShadow(S, XPPopups[i].XPos+(TextHeight*1.25f)+(ScaledBorderSize*2), XPPopups[i].YPos, 1, Sc);
        }
        else
        {
            Canvas.SetDrawColor(255, 255, 255, FadeAlpha);
            GUIStyle.DrawTextShadow(S, XPPopups[i].XPos, XPPopups[i].YPos, 1, Sc);
        }
    }
}

function DrawDoshEarned(float X, float Y)
{
    local int i;
    local float EndTime, TextWidth, TextHeight, Sc, FadeAlpha;
    local string S;
    local Color DoshColor;

    Canvas.Font = GUIStyle.PickFont(Sc);
    
    for( i=0; i<DoshPopups.Length; i++ ) 
    {
        EndTime = `RealTimeSince(DoshPopups[i].StartTime);
        if( EndTime > DoshFadeOutTime )
        {
            DoshPopups.RemoveItem(DoshPopups[i]);
            continue;
        }
            
        S = (DoshPopups[i].Dosh > 0 ? "+" : "")$string(DoshPopups[i].Dosh);
        Canvas.TextSize(S,TextWidth,TextHeight,Sc,Sc);
        
        if( DoshPopups[i].Dosh > 0 )
            DoshColor = GreenColor;
        else DoshColor = RedColor;

        if( DoshPopups[i].bInit )
        {
            DoshPopups[i].XPos = X;
            DoshPopups[i].YPos = Y-(TextHeight*0.5f);
            DoshPopups[i].bInit = false;
        }
        
        if( DoshPopups[i].XPos > 0.f && DoshPopups[i].XPos > 0 )
            DoshPopups[i].XPos += Asin(0.25f * Pi * EndTime/DoshFadeOutTime) * (i % 2 == 0 ? -DoshPopups[i].RandX : DoshPopups[i].RandX);
        else DoshPopups[i].XPos = FClamp(DoshPopups[i].XPos, 0, Canvas.ClipX);
        
        DoshPopups[i].YPos -= (RenderDelta*72.f) * DoshPopups[i].RandY;

        FadeAlpha = 255 * Cos(0.5f * Pi * EndTime/DoshFadeOutTime);
        Canvas.DrawColor = PlayerBarShadowColor;
        Canvas.DrawColor.A = FadeAlpha;
        
        Canvas.SetPos(DoshPopups[i].XPos+1, DoshPopups[i].YPos+1);
        Canvas.DrawTile(DoshEarnedIcon, TextHeight*1.25f, TextHeight*1.25f, 0, 0, 256, 256);
        
        Canvas.DrawColor = DoshColor;
        Canvas.DrawColor.A = FadeAlpha;
        
        Canvas.SetPos(DoshPopups[i].XPos, DoshPopups[i].YPos);
        Canvas.DrawTile(DoshEarnedIcon, TextHeight*1.25f, TextHeight*1.25f, 0, 0, 256, 256);
        
        GUIStyle.DrawTextShadow(S, DoshPopups[i].XPos+(TextHeight*1.25f)+(ScaledBorderSize*2), DoshPopups[i].YPos, 1, Sc);
    }
}

function NotifyXPEarned( int XP, Texture2D Icon, Color IconColor )
{
    local XPEarnedS XPEarned;
    
    XPEarned.XP = XP;
    XPEarned.StartTime = WorldInfo.RealTimeSeconds;
    XPEarned.RandX = 2.f * FRand();
    XPEarned.RandY = 1.f + FRand();
    XPEarned.Icon = Icon;
    XPEarned.IconColor = IconColor;
    XPEarned.bInit = true;
    
    XPPopups.AddItem(XPEarned);
}

function NotifyDoshEarned( int Dosh )
{
    local DoshEarnedS DoshEarned;
   
    DoshEarned.Dosh = Dosh;
    DoshEarned.StartTime = WorldInfo.RealTimeSeconds;
    DoshEarned.RandX = 2.f * FRand();
    DoshEarned.RandY = 1.f + FRand();
    DoshEarned.bInit = true;
    
    DoshPopups.AddItem(DoshEarned);
}

function byte DrawToDistance(Actor A, optional float StartAlpha=255.f, optional float MinAlpha=90.f)
{
    local float Dist, fZoom;

    Dist = VSize(A.Location - PLCameraLoc);
    if ( Dist <= HealthBarFullVisDist || PlayerOwner.PlayerReplicationInfo.bOnlySpectator )
        fZoom = 1.0;
    else fZoom = FMax(1.0 - (Dist - HealthBarFullVisDist) / (HealthBarCutoffDist - HealthBarFullVisDist), 0.0);
    
    return Clamp(StartAlpha * fZoom, MinAlpha, StartAlpha);
}

simulated function bool DrawFriendlyHumanPlayerInfo( KFPawn_Human KFPH )
{
    local float Percentage;
    local float BarHeight, BarLength;
    local vector ScreenPos, TargetLocation;
    local KFPlayerReplicationInfo KFPRI;
    local float FontScale;
    local float ResModifier;
    local float PerkIconPosX, PerkIconPosY, SupplyIconPosX, SupplyIconPosY, PerkIconXL, BarY;
    local color CurrentArmorColor, CurrentHealthColor;
    local byte FadeAlpha, PerkLevel;

    ResModifier = WorldInfo.static.GetResolutionBasedHUDScale() * FriendlyHudScale;
    KFPRI = KFPlayerReplicationInfo(KFPH.PlayerReplicationInfo);

    if( KFPRI == None )
        return false;

    BarLength = FMin(PlayerStatusBarLengthMax * (Canvas.ClipX / 1024.f), PlayerStatusBarLengthMax) * ResModifier;
    BarHeight = FMin(8.f * (Canvas.ClipX / 1024.f), 8.f) * ResModifier;

    TargetLocation = KFPH.Mesh.GetPosition() + ( KFPH.CylinderComponent.CollisionHeight * vect(0,0,2.5f) );
    ScreenPos = Canvas.Project( TargetLocation );
    if( ScreenPos.X < 0 || ScreenPos.X > Canvas.ClipX || ScreenPos.Y < 0 || ScreenPos.Y > Canvas.ClipY )
        return false;
        
    FadeAlpha = DrawToDistance(KFPH);

    //Draw player name (Top)
    Canvas.Font = GUIStyle.PickFont(FontScale);
    FontScale *= FriendlyHudScale;

    //Player name text
    Canvas.DrawColor = WhiteColor;
    Canvas.DrawColor.A = FadeAlpha;
    GUIStyle.DrawTextShadow(KFPRI.PlayerName, ScreenPos.X - (BarLength * 0.5f), ScreenPos.Y - 3.5f, 1, FontScale);
    
    //Info Color
    CurrentArmorColor = CustomArmorColor;
    CurrentHealthColor = CustomHealthColor;
    CurrentArmorColor.A = FadeAlpha;
    CurrentHealthColor.A = FadeAlpha;
    
    BarY = ScreenPos.Y + BarHeight + (36 * FontScale * ResModifier);
        
    //Draw armor bar
    Percentage = FMin(float(KFPH.Armor) / float(KFPH.MaxArmor), 100);
    DrawPlayerInfo(KFPH, Percentage, BarLength, BarHeight, ScreenPos.X - (BarLength * 0.5f), BarY, CurrentArmorColor, PlayerInfoType == INFO_CLASSIC);

    BarY += BarHeight + 5;
    
    //Draw health bar
    Percentage = FMin(float(KFPH.Health) / float(KFPH.HealthMax), 100);
    DrawPlayerInfo(KFPH, Percentage, BarLength, BarHeight, ScreenPos.X - (BarLength * 0.5f), BarY, CurrentHealthColor, PlayerInfoType == INFO_CLASSIC, true);

    BarY += BarHeight;
    
	if( KFPRI.CurrentPerkClass == none )
		return false;
        
    PerkLevel = KFPRI.GetActivePerkLevel();

    //Draw perk level and name text
    Canvas.DrawColor = WhiteColor;
    Canvas.DrawColor.A = FadeAlpha;
    GUIStyle.DrawTextShadow(PerkLevel@KFPRI.CurrentPerkClass.default.PerkName, ScreenPos.X - (BarLength * 0.5f), BarY, 1, FontScale);

    // drop shadow for perk icon
    Canvas.DrawColor = PlayerBarShadowColor;
    Canvas.DrawColor.A = FadeAlpha;
    PerkIconXL = PlayerStatusIconSize * ResModifier;
    PerkIconPosX = ScreenPos.X - (BarLength * 0.5f) - PerkIconXL + 1;
    PerkIconPosY = ScreenPos.Y + (PerkIconXL*0.5f) - (BarHeight*0.5f) + 6;
    SupplyIconPosX = ScreenPos.X + (BarLength * 0.5f) + 1;
    SupplyIconPosY = PerkIconPosY + 4 * ResModifier;
    DrawPerkIcons(KFPH, PerkIconXL, PerkIconPosX - (ScaledBorderSize*2), PerkIconPosY, SupplyIconPosX + (ScaledBorderSize*2), SupplyIconPosY, true);

    //draw perk icon
    Canvas.DrawColor = WhiteColor;
    Canvas.DrawColor.A = FadeAlpha;
    PerkIconPosX = ScreenPos.X - (BarLength * 0.5f) - PerkIconXL;
    PerkIconPosY = ScreenPos.Y + (PerkIconXL*0.5f) - (BarHeight*0.5f) + 5;
    SupplyIconPosX = ScreenPos.X + (BarLength * 0.5f);
    SupplyIconPosY = PerkIconPosY + 4 * ResModifier;
    DrawPerkIcons(KFPH, PerkIconXL, PerkIconPosX - (ScaledBorderSize*2), PerkIconPosY, SupplyIconPosX + (ScaledBorderSize*2), SupplyIconPosY, false);

    return true;
}

simulated function DrawPerkIcons(KFPawn_Human KFPH, float PerkIconXL, float PerkIconPosX, float PerkIconPosY, float SupplyIconPosX, float SupplyIconPosY, bool bDropShadow)
{
    local byte PrestigeLevel;
    local KFPlayerReplicationInfo KFPRI;
    local color TempColor;
    local float ResModifier;
    local byte FadeAlpha;

    KFPRI = KFPlayerReplicationInfo(KFPH.PlayerReplicationInfo);
    if( KFPRI == None )
        return;
        
    PrestigeLevel = KFPRI.GetActivePerkPrestigeLevel();
    ResModifier = WorldInfo.static.GetResolutionBasedHUDScale() * FriendlyHudScale;
    FadeAlpha = Canvas.DrawColor.A;

    if (KFPRI.CurrentVoiceCommsRequest == VCT_NONE && KFPRI.CurrentPerkClass != none && PrestigeLevel > 0)
    {
        Canvas.SetPos(PerkIconPosX, PerkIconPosY);
        Canvas.DrawTile(KFPRI.CurrentPerkClass.default.PrestigeIcons[PrestigeLevel - 1], PerkIconXL, PerkIconXL, 0, 0, 256, 256);
    }

    if (PrestigeLevel > 0)
    {
        Canvas.SetPos(PerkIconPosX + (PerkIconXL * (1 - class'KFHUDBase'.default.PrestigeIconScale)) * 0.5f, PerkIconPosY + PerkIconXL * 0.05f);
        Canvas.DrawTile(KFPRI.GetCurrentIconToDisplay(), PerkIconXL * class'KFHUDBase'.default.PrestigeIconScale, PerkIconXL * class'KFHUDBase'.default.PrestigeIconScale, 0, 0, 256, 256);
    }
    else
    {
        Canvas.SetPos(PerkIconPosX, PerkIconPosY);
        Canvas.DrawTile(KFPRI.GetCurrentIconToDisplay(), PerkIconXL, PerkIconXL, 0, 0, 256, 256);
    }

    if (KFPRI.PerkSupplyLevel > 0 && KFPRI.CurrentPerkClass.static.GetInteractIcon() != none)
    {
        if (!bDropShadow)
        {
            if (KFPRI.PerkSupplyLevel == 2)
            {
                if (KFPRI.bPerkPrimarySupplyUsed && KFPRI.bPerkSecondarySupplyUsed)
                {
                    TempColor = SupplierActiveColor;
                }
                else if (KFPRI.bPerkPrimarySupplyUsed || KFPRI.bPerkSecondarySupplyUsed)
                {
                    TempColor = SupplierHalfUsableColor;
                }
                else
                {
                    TempColor = SupplierUsableColor;
                }
            }
            else if (KFPRI.PerkSupplyLevel == 1)
            {
                TempColor = KFPRI.bPerkPrimarySupplyUsed ? SupplierActiveColor : SupplierUsableColor;
            }

            Canvas.DrawColor = TempColor;
            Canvas.DrawColor.A = FadeAlpha;
        }

        Canvas.SetPos(SupplyIconPosX, SupplyIconPosY);
        Canvas.DrawTile(KFPRI.CurrentPerkClass.static.GetInteractIcon(), (PlayerStatusIconSize * 0.75) * ResModifier, (PlayerStatusIconSize * 0.75) * ResModifier, 0, 0, 256, 256);
    }
}

simulated function DrawPlayerInfo( KFPawn_Human P, float BarPercentage, float BarLength, float BarHeight, float XPos, float YPos, Color BarColor, optional bool bDrawOutline, optional bool bDrawingHealth )
{
    if( bDrawOutline )
    {
        Canvas.SetDrawColor(185, 185, 185, 255);
        GUIStyle.DrawBoxHollow(XPos - 2, YPos - 2, BarLength + 4, BarHeight + 4, 1);
        
        Canvas.SetPos(XPos, YPos);
        Canvas.DrawColor = PlayerBarBGColor;
        Canvas.DrawTileStretched(PlayerStatusBarBGTexture, BarLength, BarHeight, 0, 0, 32, 32);
        
        Canvas.SetPos(XPos, YPos);
        Canvas.DrawColor = BarColor;
        Canvas.DrawTileStretched(PlayerStatusBarBGTexture, BarLength * BarPercentage, BarHeight, 0, 0, 32, 32);
    }
    else DrawKFBar(BarPercentage, BarLength, BarHeight, XPos, YPos, BarColor);
}

function ShowQuickSyringe()
{
    if ( bDisplayQuickSyringe )
    {
        if ( `TimeSince(QuickSyringeStartTime) > QuickSyringeFadeInTime )
        {
            if ( `TimeSince(QuickSyringeStartTime) > QuickSyringeDisplayTime - QuickSyringeFadeOutTime )
                QuickSyringeStartTime = `TimeSince(QuickSyringeFadeInTime + ((QuickSyringeDisplayTime - `TimeSince(QuickSyringeStartTime)) * QuickSyringeFadeInTime));
            else QuickSyringeStartTime = `TimeSince(QuickSyringeFadeInTime);
        }
    }
    else
    {
        bDisplayQuickSyringe = true;
        QuickSyringeStartTime = WorldInfo.TimeSeconds;
    }
}

simulated function Tick( float Delta )
{
    if( bDisplayingProgress )
    {
        bDisplayingProgress = false;
        if( VisualProgressBar<LevelProgressBar )
            VisualProgressBar = FMin(VisualProgressBar+Delta,LevelProgressBar);
        else if( VisualProgressBar>LevelProgressBar )
            VisualProgressBar = FMax(VisualProgressBar-Delta,LevelProgressBar);
    }
    
    Super.Tick(Delta);
}

function DrawZedIcon( Pawn ZedPawn, vector PawnLocation, float NormalizedAngle )
{
    DrawDirectionalIndicator(PawnLocation + (ZedPawn.CylinderComponent.CollisionHeight * vect(0, 0, 1)), GenericZedIconTexture, PlayerStatusIconSize * (WorldInfo.static.GetResolutionBasedHUDScale() * FriendlyHudScale) * 0.5f,,, GetNameOf(ZedPawn.Class));
}

exec function SetShowScores(bool bNewValue)
{
    if (Scoreboard != None)
        Scoreboard.SetVisibility(bNewValue);
	else Super.SetShowScores(bNewValue);
}

defaultproperties
{
    DefaultHudMainColor=(R=0,B=0,G=0,A=195)
    DefaultHudOutlineColor=(R=200,B=15,G=15,A=195)
    DefaultFontColor=(R=255,B=50,G=50,A=255)
    
    BlueColor=(R=0,B=255,G=0,A=255)
    
    MedicLockOnIcon=Texture2D'UI_SecondaryAmmo_TEX.UI_FireModeSelect_ManualTarget'
    MedicLockOnIconSize=40
    MedicLockOnColor=(R=0,G=255,B=255,A=192)
    MedicPendingLockOnColor=(R=92,G=92,B=92,A=192)
    
    MedicWeaponRot=(Yaw=16384)
    MedicWeaponHeight=88
    MedicWeaponBGColor=(R=0,G=0,B=0,A=128)
    MedicWeaponNotChargedColor=(R=224,G=0,B=0,A=128)
    MedicWeaponChargedColor=(R=0,G=224,B=224,A=128)
    
    InventoryFadeTime=1.25
    InventoryFadeInTime=0.1
    InventoryFadeOutTime=0.15
    
    InventoryX=0.35
    InventoryY=0.025
    InventoryBoxWidth=0.1
    InventoryBoxHeight=0.075
    BorderSize=0.005
    
    TraderArrow=Texture2D'UI_LevelChevrons_TEX.UI_LevelChevron_Icon_03'
    TraderArrowLight=Texture2D'UI_Objective_Tex.UI_Obj_World_Loc'
    VoiceChatIcon=Texture2D'UI_HUD.voip_icon'
    DoshEarnedIcon=Texture2D'UI_Objective_Tex.UI_Obj_Dosh_Loc'
    
    PerkIconSize=16
    MaxPerkStars=5
    MaxStarsPerRow=5
    
    PrestigeIconScale=0.6625
    
    DamagePopupFadeOutTime=2.25
    XPFadeOutTime=1.0
    DoshFadeOutTime=2.0
    
    MaxWeaponPickupDist=700
    WeaponPickupScanRadius=75
    ZedScanRadius=200
    WeaponAmmoIcon=Texture2D'UI_Menus.TraderMenu_SWF_I10B'
    WeaponWeightIcon=Texture2D'UI_Menus.TraderMenu_SWF_I26'
    WeaponIconSize=32
    WeaponIconColor=(R=192,G=192,B=192,A=255)
    WeaponOverweightIconColor=(R=255,G=0,B=0,A=192)
    
    NonCriticalMessageDisplayTime=3.0
    NonCriticalMessageFadeInTime=0.65
    NonCriticalMessageFadeOutTime=0.5
    
    RepObject=ObjectReferencer'KFClassicMode_Assets.ObjectRef.MainObj_List'
    PerkStarIcon=Texture2D'KFClassicMode_Assets.HUD.Hud_Perk_Star'
    ScoreboardClass=class'KFScoreBoard'
    
    BossBattlePhaseColor=(R=0,B=0,G=150,A=175)
    
    BattlePhaseColors.Add((R=0,B=0,G=150,A=175))
    BattlePhaseColors.Add((R=255,B=18,G=176,A=175))
    BattlePhaseColors.Add((R=255,B=18,G=96,A=175))
    BattlePhaseColors.Add((R=173,B=17,G=22,A=175))
    BattlePhaseColors.Add((R=0,B=0,G=0,A=175))
    
    DamageMsgColors[DMG_Fire]=(R=206,G=103,B=0,A=255)
    DamageMsgColors[DMG_Toxic]=(R=58,G=232,B=0,A=255)
    DamageMsgColors[DMG_Bleeding]=(R=255,G=100,B=100,A=255)
    DamageMsgColors[DMG_EMP]=(R=32,G=138,B=255,A=255)
    DamageMsgColors[DMG_Freeze]=(R=0,G=183,B=236,A=255)
    DamageMsgColors[DMG_Flashbang]=(R=195,G=195,B=195,A=255)
    DamageMsgColors[DMG_Generic]=(R=206,G=64,B=64,A=255)
    DamageMsgColors[DMG_High]=(R=0,G=206,B=0,A=255)
    DamageMsgColors[DMG_Medium]=(R=206,G=206,B=0,A=255)
    DamageMsgColors[DMG_Unspecified]=(R=150,G=150,B=150,A=255)
    
    NewLineSeparator="|"
    
    NotificationBackground=Texture2D'KFClassicMode_Assets.HUD.Med_border_SlightTransparent'
    NotificationShowTime=0.3
    NotificationHideTime=0.5
    NotificationHideDelay=3.5
    NotificationBorderSize=7.0
    NotificationIconSpacing=10.0
    NotificationPhase=PHASE_DONE
}