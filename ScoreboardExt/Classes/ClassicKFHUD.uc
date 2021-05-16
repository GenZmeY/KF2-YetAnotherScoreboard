class ClassicKFHUD extends KFGFxHudWrapper
    config(ClassicHUD);

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

var UIP_ColorSettings ColorSettingMenu;
var transient GFxClikWidget HUDChatInputField, PartyChatInputField;
var transient bool bReplicatedColorTextures;

var config Color HudMainColor, HudOutlineColor, FontColor, CustomArmorColor, CustomHealthColor;
var config bool bEnableDamagePopups, bLightHUD, bHideWeaponInfo, bHidePlayerInfo, bHideDosh, bDisableHiddenPlayers, bShowSpeed, bDisableLastZEDIcons, bDisablePickupInfo, bDisableLockOnUI, bDisableRechargeUI, bShowXPEarned, bShowDoshEarned, bNewScoreboard, bDisableHUD;
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
        
        bLightHUD = false;
        bHideWeaponInfo = false;
        bHidePlayerInfo = false;
        bHideDosh = false;
        bDisableHiddenPlayers = false;
        bEnableDamagePopups = true;
        bShowSpeed = false;
        bDisableLastZEDIcons = false;
        bDisablePickupInfo = false;
        bDisableLockOnUI = false;
        bDisableRechargeUI = false;
        bShowXPEarned = true;
        bShowDoshEarned = true;
        bNewScoreboard = true;
        bDisableHUD = false;
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
    
    if( bDisableHUD )
    {
        RemoveMovies();
        HUDClass = class'KFGFxHudWrapper'.default.HUDClass;
        CreateHUDMovie();
    }
    
    SetTimer(0.25f, false, nameof(InitializeHUD));
    
    InitializePartyChatHook();
    InitializeHUDChatHook();
}

function InitializeHUD()
{
    WriteToChat("<Classic HUD> Initialized!", "FFFF00");
    WriteToChat("<Classic HUD> Type !settings or use OpenSettingsMenu in console to configure!", "00FF00");
}

delegate OnPartyChatInputKeyDown(GFxClikWidget.EventData Data)
{
    OnChatKeyDown(PartyChatInputField, Data);
}

delegate OnHUDChatInputKeyDown(GFxClikWidget.EventData Data)
{
    if (OnChatKeyDown(HUDChatInputField, Data))
        HUDMovie.HudChatBox.ClearAndCloseChat();
}

function bool OnChatKeyDown(GFxClikWidget InputField, GFxClikWidget.EventData Data)
{
    local GFXObject InputDetails;
    local int KeyCode;
    local string EventType;
    local string KeyEvent;
    local string Text;

    InputDetails = Data._this.GetObject("details");
    KeyCode = InputDetails.GetInt("code");
    EventType = InputDetails.GetString("type");
    KeyEvent = InputDetails.GetString("value");

    if (EventType != "key") return false;

    if (KeyCode == 13 && (KeyEvent == "keyHold" || KeyEvent == "keyDown"))
    {
        Text = InputField.GetText();
        switch (Locs(Text))
        {
            case "!settings":
                OpenSettingsMenu();
                break;
            default:
                return false;
        }

        InputField.SetText("");

        return true;
    }

    return false;
}

function InitializePartyChatHook()
{
    if (KFPlayerOwner.MyGFxManager == None || KFPlayerOwner.MyGFxManager.PartyWidget == None || KFPlayerOwner.MYGFxManager.PartyWidget.PartyChatWidget == None)
    {
        SetTimer(1.f, false, nameof(InitializePartyChatHook));
        return;
    }

    KFPlayerOwner.MyGFxManager.PartyWidget.PartyChatWidget.SetVisible(true);
    PartyChatInputField = GFxClikWidget(KFPlayerOwner.MyGFxManager.PartyWidget.PartyChatWidget.GetObject("ChatInputField", class'GFxClikWidget'));
    PartyChatInputField.AddEventListener('CLIK_input', OnPartyChatInputKeyDown, false, GFxListenerPriority, false);
}

function InitializeHUDChatHook()
{
    if( HUDMovie == None || HUDMovie.HudChatBox == None )
    {
        SetTimer(1.f, false, nameof(InitializeHUDChatHook));
        return;
    }

    HUDChatInputField = GFxClikWidget(HUDMovie.HudChatBox.GetObject("ChatInputField", class'GFxClikWidget'));
    HUDChatInputField.AddEventListener('CLIK_input', OnHUDChatInputKeyDown, false, GFxListenerPriority, false);;
}

function WriteToChat(string Message, string HexColor)
{
    if (KFPlayerOwner.MyGFxManager.PartyWidget != None && KFPlayerOwner.MyGFxManager.PartyWidget.PartyChatWidget != None)
        KFPlayerOwner.MyGFxManager.PartyWidget.PartyChatWidget.AddChatMessage(Message, HexColor);

    if (HUDMovie != None && HUDMovie.HudChatBox != None)
        HUDMovie.HudChatBox.AddChatMessage(Message, HexColor);
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
        GUIController = Class'KFClassicHUD.KF2GUIController'.Static.GetGUIController(PlayerOwner);
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
    
    Canvas.EnableStencilTest(true);
    
    if( !bDisablePickupInfo && WeaponPickup != None )
    {
        DrawWeaponPickupInfo();
    }
    
    if( bEnableDamagePopups )
        DrawDamage();
    
    if( KFPlayerOwner != None && KFPlayerOwner.Pawn != None )
    {
        if( !bDisableLockOnUI && KFWeap_MedicBase(KFPlayerOwner.Pawn.Weapon) != None )
        {
            DrawMedicWeaponLockOn(KFWeap_MedicBase(KFPlayerOwner.Pawn.Weapon));
        }
        
        if( !bDisableRechargeUI && !KFPlayerOwner.bCinematicMode )
            DrawMedicWeaponRecharge();
    }

    Canvas.EnableStencilTest(false);
    
    if( !bDisableHUD )
        DrawTraderIndicator();

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
    
    if( bDisableHUD )
        return;
    
    if( KillMessages.Length > 0 )
    {
        RenderKillMsg();
    }
    
    if( NonCriticalMessages.Length > 0 )
    {
        for( i=0; i<NonCriticalMessages.Length; ++i )
        {
            DrawNonCritialMessage(i, NonCriticalMessages[i], Canvas.ClipX * 0.5, Canvas.ClipY * 0.9);
        }
    }
    
    if( PriorityMessage != default.PriorityMessage )
    {
        DrawPriorityMessage();
    }
    
    if ( NotificationPhase != PHASE_DONE ) 
    {
        DrawPopupInfo();
    }
    
    if( BossPawn != None && BossPawn.GetMonsterPawn().IsAliveAndWell() )
    {
        DrawBossHealthBars();
    }
    else if( ScriptedPawn != None )
    {
        DrawEscortHealthBars();
    }
    
    if( NewItems.Length > 0 )
    {
        DrawItemsList();
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

simulated final function DrawItemsList()
{
    local int i;
    local float T,FontScale,XS,YS,YSize,XPos,YPos,BT,OT;
    local Color BackgroundColor,OutlineColor,TextColor;
    
    FontScale = Canvas.ClipY / 660.f;
    Canvas.Font = GUIStyle.PickFont(FontScale);
    Canvas.TextSize("ABC",XS,YSize,FontScale,FontScale);
    YSize*=2.f;
    YPos = Canvas.ClipY*0.7 - YSize;
    XPos = Canvas.ClipX - YSize*0.15;
    
    for( i=0; i<NewItems.Length; ++i )
    {
        T = WorldInfo.TimeSeconds-NewItems[i].MsgTime;
        BT = T;
        OT = T;
        
        if( T>=10.f )
        {
            NewItems.Remove(i--,1);
            continue;
        }
        if( T>9.f )
        {
            T = 255.f * (10.f-T);
            TextColor = MakeColor(255,255,255,T);
            
            BT = HudMainColor.A * (10.f-BT);
            BackgroundColor = MakeColor(HudMainColor.R, HudMainColor.G, HudMainColor.B, BT);
            
            OT = HudOutlineColor.A * (10.f-OT);
            OutlineColor = MakeColor(HudOutlineColor.R, HudOutlineColor.G, HudOutlineColor.B, OT);
        }
        else 
        {
            TextColor = MakeColor(255,255,255,255);
            BackgroundColor = HudMainColor;
            OutlineColor = HudOutlineColor;
        }
        
        Canvas.TextSize(NewItems[i].Item,XS,YS,FontScale,FontScale);
        GUIStyle.DrawOutlinedBox(XPos-(XS+(ScaledBorderSize*2)), YPos-(ScaledBorderSize*0.5), XS+(ScaledBorderSize*4), YSize+(ScaledBorderSize*2), 1, BackgroundColor, OutlineColor);
        
        XS = XPos-XS;
        
        Canvas.DrawColor = TextColor;
        Canvas.SetPos(XS, YPos);
        Canvas.DrawText("New Item:",, FontScale, FontScale);
        Canvas.SetPos(XS, YPos+(YSize*0.5));
        Canvas.DrawText(NewItems[i].Item,, FontScale, FontScale);

        YPos-=YSize;
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

function DrawPopupInfo()
{
    local float IconSize, TempX, TempY, DrawHeight, TimeElapsed, TempWidth, TempHeight, FontScalar, NotificationHeight, NotificationWidth;
    
    Canvas.Font = GUIStyle.PickFont(FontScalar);
    NotificationHeight = GUIStyle.DefaultHeight * 1.5f;
        
    Canvas.TextSize(MessageQueue[0].Body, TempWidth, TempHeight, FontScalar, FontScalar);
    NotificationWidth = TempWidth + (NotificationHeight*2) + (ScaledBorderSize*4);
    
    TimeElapsed = `TimeSince(NotificationPhaseStartTime);
    switch( NotificationPhase )
    {
        case PHASE_SHOWING:
            if (TimeElapsed < NotificationShowTime) 
            {
                DrawHeight = (TimeElapsed / NotificationShowTime) * NotificationHeight;
            } 
            else 
            {
                NotificationPhase = PHASE_DELAYING;
                NotificationPhaseStartTime = `TimeSince(TimeElapsed - NotificationShowTime);
                DrawHeight = NotificationHeight;
            }
            break;
        case PHASE_DELAYING:
            if (TimeElapsed < NotificationHideDelay ) 
            {
                DrawHeight = NotificationHeight;
            } 
            else 
            {
                NotificationPhase = PHASE_HIDING; // Hiding Phase
                TimeElapsed -= NotificationHideDelay;
                NotificationPhaseStartTime = `TimeSince(TimeElapsed);
                DrawHeight = (1.0 - (TimeElapsed / NotificationHideTime)) * NotificationHeight;
            }
            break;
        case PHASE_HIDING:
            if (TimeElapsed < NotificationHideTime) 
            {
                DrawHeight = (1.0 - (TimeElapsed / NotificationHideTime)) * NotificationHeight;
            } 
            else 
            {
                // We're done
                MessageQueue.Remove(0, 1);
                if( MessageQueue.Length != 0 ) 
                {
                    NotificationPhaseStartTime = WorldInfo.TimeSeconds;
                    NotificationPhase = PHASE_SHOWING;
                } 
                else 
                {
                    NotificationPhase = PHASE_DONE;
                }
                return;
            }
            break;
    }

    switch( MessageQueue[0].MsgPosition ) 
    {
        case PP_TOP_LEFT:
        case PP_BOTTOM_LEFT:
            TempX = 0;
            break;
        case PP_TOP_CENTER:
        case PP_BOTTOM_CENTER:
            TempX = (Canvas.ClipX * 0.5f) - (NotificationWidth * 0.5f);
            break;
        case PP_TOP_RIGHT:
        case PP_BOTTOM_RIGHT:
            TempX = Canvas.ClipX - NotificationWidth;
            break;
        default:
            `Warn("Unrecognized position:" @ MessageQueue[0].MsgPosition);
            break;
    }

    switch( MessageQueue[0].MsgPosition ) 
    {
        case PP_BOTTOM_CENTER:
        case PP_BOTTOM_LEFT:
        case PP_BOTTOM_RIGHT:
            TempY = Canvas.ClipY - DrawHeight - (ScaledBorderSize*2);
            break;
        case PP_TOP_CENTER:
        case PP_TOP_LEFT:
        case PP_TOP_RIGHT:
            TempY = DrawHeight - NotificationHeight + (ScaledBorderSize*2);
            break;
        default:
            `Warn("Unrecognized position:" @ MessageQueue[0].MsgPosition);
            break;
    }

    // Draw the Background
    GUIStyle.DrawRoundedBox(ScaledBorderSize*2, TempX, TempY, NotificationWidth, NotificationHeight, HudMainColor);
    GUIStyle.DrawRoundedBoxEx(ScaledBorderSize*2, TempX, TempY, NotificationHeight, NotificationHeight, HudOutlineColor, true, false, true, false);

    IconSize = NotificationHeight - (NotificationBorderSize * 2.0);
    
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.SetPos(TempX + ((NotificationHeight-IconSize)*0.5f), TempY + ((NotificationHeight-IconSize)*0.5f));
    Canvas.DrawTile(MessageQueue[0].Image, IconSize, IconSize, 1, 0, 256, 256);
    
    Canvas.SetPos(TempX + (NotificationHeight*0.5f) + ((NotificationWidth-TempWidth)*0.5f), TempY + ((NotificationHeight-TempHeight)*0.5f));
    Canvas.DrawText(MessageQueue[0].Body,, FontScalar, FontScalar);
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
    
    if( !bLightHUD )
    {
        if( HBRI.bUseRounded )
        {
            if( HBRI.bHighlighted )
            {
                if( HBRI.bRoundedOutline )
                    GUIStyle.DrawOutlinedBox(X+(ScaledBorderSize*2), Y, Width-(ScaledBorderSize*4), Height, ScaledBorderSize, BoxColor, OutlineColor);
                else
                {
                    Canvas.DrawColor = BoxColor;
                    Canvas.SetPos(X+(ScaledBorderSize*2), Y);
                    GUIStyle.DrawWhiteBox(Width-(ScaledBorderSize*4), Height);
                }
                
                GUIStyle.DrawRoundedBoxEx(ScaledBorderSize*2, X, Y, ScaledBorderSize*2, Height, OutlineColor, true, false, true, false);
                GUIStyle.DrawRoundedBoxEx(ScaledBorderSize*2, X+Width-(ScaledBorderSize*2), Y, ScaledBorderSize*2, Height, OutlineColor, false, true, false, true);
            }
            else
            {
                if( HBRI.bRoundedOutline )
                    GUIStyle.DrawRoundedBoxOutlined(ScaledBorderSize, X, Y, Width, Height, BoxColor, OutlineColor);
                else GUIStyle.DrawRoundedBox(ScaledBorderSize*2, X, Y, Width, Height, BoxColor);
            }
        }
        else GUIStyle.DrawOutlinedBox(X, Y, Width, Height, ScaledBorderSize, BoxColor, OutlineColor);
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

function RenderKFHUD(KFPawn_Human KFPH)
{
    local float scale_w, scale_w2, FontScalar, OriginalFontScalar, XL, YL, ObjYL, BoxXL, BoxYL, BoxSW, BoxSH, DoshXL, DoshYL, PerkXL, PerkYL, StarXL, StarYL, ObjectiveH, SecondaryXL, SecondaryYL, PerkLevelXL, PerkLevelYL, PerkIconY;
    local float PerkProgressSize, PerkProgressX, PerkProgressY;
    local byte PerkLevel;
    local int i, XPos, YPos, DrawCircleSize, FlashlightCharge, AmmoCount, MagCount, CurrentScore, Index, ObjectiveSize, ObjectivePadding, ObjX, ObjY, bStatusWarning, bStatusNotification, PrestigeLevel;
    local string CircleText, SubCircleText, WeaponName, TraderDistanceText, ObjectiveTitle, ObjectiveDesc, ObjectiveProgress, ObjectiveReward, ObjectiveStatusMessage;
    local bool bSingleFire, bHasSecondaryAmmo;
    local Texture2D PerkIcon;
    local KFInventoryManager Inv;
    local KFPlayerReplicationInfo MyKFPRI;
    local KFWeapon CurrentWeapon;
    local KFTraderTrigger T;
    local KFGFxObject_TraderItems TraderItems;
    local FontRenderInfo FRI;
    local Color HealthFontColor, PerkStarColor;
    local HUDBoxRenderInfo HBRI;
    local KFInterface_MapObjective MapObjective;
    
    if( bDisableHUD || KFPlayerOwner.bCinematicMode )
        return;
    
    FRI.bClipText = true;
    FRI.bEnableShadow = true;
    
    Canvas.Font = GUIStyle.PickFont(OriginalFontScalar);
    
    scale_w = GUIStyle.ScreenScale(64);
    scale_w2 = GUIStyle.ScreenScale(32);
    
    BoxXL = SizeX * 0.015;
    BoxYL = SizeY * 0.935;
    
    BoxSW = SizeX * 0.0625;
    BoxSH = SizeY * 0.0425;
    
    // Trader/Wave info
    if( KFGRI != None )
    {
        CircleText = GetGameInfoText();
        SubCircleText = GetGameInfoSubText();
        
        if( CircleText != "" )
        {
            Canvas.Font = GUIStyle.PickFont(OriginalFontScalar, false, KFGRI.IsEndlessWave());
            
            FontScalar = OriginalFontScalar + GUIStyle.ScreenScale(KFGRI.IsEndlessWave() ? 0.75 : 0.3);
            DrawCircleSize = GUIStyle.ScreenScale(128);
            
            if( !bLightHUD )
            {
                if( HudOutlineColor != DefaultHudOutlineColor )
                    Canvas.SetDrawColor(HudOutlineColor.R, HudOutlineColor.G, HudOutlineColor.B, 255);
                else Canvas.SetDrawColor(255, 255, 255, 255);
                
                Canvas.SetPos(Canvas.ClipX - DrawCircleSize, 2);
                Canvas.DrawRect(DrawCircleSize, DrawCircleSize, (KFGRI != None && KFGRI.bWaveIsActive) ? BioCircle : WaveCircle);
            }
            
            Canvas.TextSize(CircleText, XL, YL, FontScalar, FontScalar);
            
            XPos = Canvas.ClipX - DrawCircleSize*0.5f - (XL * 0.5f);
            YPos = SubCircleText != "" ? DrawCircleSize*0.5f - (YL / 1.5) : DrawCircleSize*0.5f - YL * 0.5f;
            
            Canvas.DrawColor = FontColor;
            if( bLightHUD )
                GUIStyle.DrawTextShadow(CircleText, XPos, YPos, 1, FontScalar);
            else
            {
                Canvas.SetPos(XPos, YPos);
                Canvas.DrawText(CircleText, , FontScalar, FontScalar, FRI);
            }
            
            if( SubCircleText != "" )
            {
                Canvas.Font = GUIStyle.PickFont(OriginalFontScalar);
                FontScalar = OriginalFontScalar;
                
                Canvas.TextSize(SubCircleText, XL, YL, FontScalar, FontScalar);
                
                XPos = Canvas.ClipX - DrawCircleSize*0.5f - (XL * 0.5f);
                YPos = DrawCircleSize*0.5f + (YL / 2.5f);
                
                if( bLightHUD )
                    GUIStyle.DrawTextShadow(SubCircleText, XPos, YPos, 1, FontScalar);
                else
                {
                    Canvas.SetPos(XPos, YPos);
                    Canvas.DrawText(SubCircleText, , FontScalar, FontScalar, FRI);
                }
            }
        }
    }

    if( !bShowHUD || KFPH == None )
        return;
        
    Inv = KFInventoryManager(KFPH.InvManager);
        
    Canvas.Font = GUIStyle.PickFont(OriginalFontScalar, true);
    FontScalar = OriginalFontScalar + GUIStyle.ScreenScale(0.3);
    
    HBRI.IconScale = scale_w2;
    HBRI.Justification = HUDA_Right;
    HBRI.TextColor = FontColor;
    HBRI.bUseOutline = bLightHUD;
        
    if( !bHidePlayerInfo )
    {
        // Health
        HealthFontColor = FontColor;
        if ( KFPH.Health < 50 )
        {
            HealthFontColor.R = 255;
            HealthFontColor.G = Clamp(Sin(WorldInfo.TimeSeconds * 12) * 200 + 200, 0, 200);
            HealthFontColor.B = 0;
        }

        HBRI.TextColor = HealthFontColor;
        HBRI.IconTex = HealthIcon;
        DrawHUDBox(BoxXL, BoxYL, BoxSW, BoxSH, string(KFPH.Health), FontScalar, HBRI);
        
        HBRI.TextColor = FontColor;

        // Armor
        HBRI.IconTex = ArmorIcon;
        DrawHUDBox(BoxXL, BoxYL, BoxSW, BoxSH, string(KFPH.Armor), FontScalar, HBRI);
        
        if( Inv != None )
        {
            HBRI.IconTex = WeightIcon;
            
            // Weight
            BoxSW = SizeX * 0.082;
            DrawHUDBox(BoxXL, BoxYL, BoxSW, BoxSH, Inv.CurrentCarryBlocks$"/"$Inv.MaxCarryBlocks, FontScalar, HBRI);
        }
        
        BoxSW = SizeX * 0.0625;
    }
    
    MyKFPRI = KFPlayerReplicationInfo(KFPlayerOwner.PlayerReplicationInfo);
    if( MyKFPRI != None )
    {
        if( !bHideDosh )
        {
            FontScalar = OriginalFontScalar + GUIStyle.ScreenScale(0.625);
            
            // Dosh
            DoshXL = SizeX * 0.85;
            DoshYL = SizeY * 0.835;
            
            Canvas.DrawColor = PlayerBarShadowColor;
            Canvas.SetPos(DoshXL+1, DoshYL+1);
            Canvas.DrawRect(scale_w, scale_w, DoshIcon);
            
            if( HudOutlineColor != DefaultHudOutlineColor )
                Canvas.SetDrawColor(HudOutlineColor.R, HudOutlineColor.G, HudOutlineColor.B, 255);
            else Canvas.SetDrawColor(255, 255, 255, 255);

            Canvas.SetPos(DoshXL, DoshYL);
            Canvas.DrawRect(scale_w, scale_w, DoshIcon);
            
            CurrentScore = int(MyKFPRI.Score);
            if( OldPlayerScore != CurrentScore )
            {
                NotifyDoshEarned(CurrentScore - OldPlayerScore);
                OldPlayerScore = CurrentScore;
            }
            
            if( ScoreDelta != CurrentScore )
            {
                if( !bInterpolating )
                {
                    bInterpolating = true;
                    TimeX = WorldInfo.RealTimeSeconds;
                    TimeXEnd = TimeX + 1.f;
                }
                
                PlayerScore = Clamp(FInterpEaseInOut(PlayerScore, CurrentScore, GUIStyle.TimeFraction(TimeX, TimeXEnd, WorldInfo.RealTimeSeconds), 1.5f), 0, CurrentScore);
                if( PlayerScore == CurrentScore )
                {
                    bInterpolating = false;
                    ScoreDelta = CurrentScore;
                }
            }
            
            Canvas.TextSize(PlayerScore, XL, YL, FontScalar, FontScalar);
            Canvas.DrawColor = FontColor;
            GUIStyle.DrawTextShadow(PlayerScore, DoshXL + (DoshXL * 0.035), DoshYL + (scale_w * 0.5f) - (YL * 0.5f), 1, FontScalar);
            
            if( bShowDoshEarned && DoshPopups.Length > 0 )
                DrawDoshEarned((DoshXL + (DoshXL * 0.035)) + ((scale_w-XL) * 0.5f), DoshYL);
        }
        
        // Draw Perk Info
        if( MyKFPRI.CurrentPerkClass != None )
        {
            FontScalar = OriginalFontScalar;
            
            PrestigeLevel = MyKFPRI.GetActivePerkPrestigeLevel();
            PerkLevel = MyKFPRI.GetActivePerkLevel();
            PerkIcon = MyKFPRI.CurrentPerkClass.default.PerkIcon;
            
            //Perk Icon
            PerkXL = SizeX - (SizeX - 12);
            PerkYL = SizeY * 0.8625;
            
            Canvas.Font = GUIStyle.PickFont(OriginalFontScalar);
            Canvas.TextSize(PerkLevel@MyKFPRI.CurrentPerkClass.default.PerkName, XL, YL, FontScalar, FontScalar);
            
            PerkLevelXL = PerkXL + scale_w + (ScaledBorderSize*2);
            PerkLevelYL = PerkYL + (scale_w - YL) + (ScaledBorderSize*2);
            PerkIconY = PerkYL;
            
            Canvas.DrawColor = FontColor;
            GUIStyle.DrawTextShadow(PerkLevel@MyKFPRI.CurrentPerkClass.default.PerkName, PerkLevelXL, PerkLevelYL, 1, FontScalar);
            
            Canvas.Font = GUIStyle.PickFont(OriginalFontScalar, true);
            
            if( PrestigeLevel > 0 )
            {
                Canvas.DrawColor = PlayerBarShadowColor;
                Canvas.SetPos(PerkXL+1, PerkIconY+1);
                Canvas.DrawTile(MyKFPRI.CurrentPerkClass.default.PrestigeIcons[PrestigeLevel - 1], scale_w, scale_w, 0, 3, 256, 256);
                
                Canvas.DrawColor = WhiteColor;
                Canvas.SetPos(PerkXL, PerkIconY);
                Canvas.DrawTile(MyKFPRI.CurrentPerkClass.default.PrestigeIcons[PrestigeLevel - 1], scale_w, scale_w, 0, 3, 256, 256);
            }
            
            if (PrestigeLevel > 0)
            {
                Canvas.DrawColor = WhiteColor;
                Canvas.SetPos(PerkXL + ((scale_w*0.5f) - ((scale_w*PrestigeIconScale)*0.5f)), PerkIconY + ((scale_w*0.5f) - ((scale_w*PrestigeIconScale)*0.5f)) - 4);
                Canvas.DrawRect(scale_w*PrestigeIconScale, scale_w*PrestigeIconScale, PerkIcon);
            }
            else
            {
                Canvas.DrawColor = PlayerBarShadowColor;
                Canvas.SetPos(PerkXL+1, PerkIconY+1);
                Canvas.DrawRect(scale_w, scale_w, PerkIcon);
                
                Canvas.DrawColor = WhiteColor;
                Canvas.SetPos(PerkXL, PerkIconY);
                Canvas.DrawRect(scale_w, scale_w, PerkIcon);
            }
            
            //Perk Stars
            if( PrestigeLevel > 0 )
            {
                PerkIconSize = GUIStyle.ScreenScale(default.PerkIconSize);
                StarXL = PerkLevelXL + PerkIconSize;
                StarYL = PerkLevelYL - PerkIconSize;
                
                PerkStarColor = MakeColor(255, 200 * (PrestigeLevel/`MAX_PRESTIGE_LEVEL), 15, 255);
                for ( i = 0; i < PrestigeLevel; i++ )
                {
                    Canvas.DrawColor = PlayerBarShadowColor;
                    Canvas.SetPos(StarXL+1, StarYL+1);
                    Canvas.DrawRect(PerkIconSize, PerkIconSize, PerkStarIcon);
                            
                    Canvas.DrawColor = PerkStarColor;
                    Canvas.SetPos(StarXL, StarYL);
                    Canvas.DrawRect(PerkIconSize, PerkIconSize, PerkStarIcon);
                    
                    StarXL += PerkIconSize;
                }
            }
            
            // Progress Bar
            PerkProgressSize = GUIStyle.ScreenScale(76);
            PerkProgressX = Canvas.ClipX * 0.007;
            PerkProgressY = PerkIconY - (PerkProgressSize*0.125f) - ScaledBorderSize;
            Canvas.DrawColor = WhiteColor;
            
            bDisplayingProgress = true;
            LevelProgressBar = KFPlayerOwner.GetPerkLevelProgressPercentage(KFPlayerOwner.CurrentPerk.Class) / 100.f;
            DrawProgressBar(PerkProgressX,PerkProgressY-PerkProgressSize*0.12f,PerkProgressSize*2.f,PerkProgressSize*0.125f,VisualProgressBar);
            if( bShowXPEarned && XPPopups.Length > 0 )
                DrawXPEarned(PerkProgressX + (PerkProgressSize*0.5f), PerkProgressY-(PerkProgressSize*0.125f)-(ScaledBorderSize*2));
        }
    }
    
    // Trader Distance/Objective Container
    if( KFGRI != None )
    {
        if( KFGRI.OpenedTrader != None || KFGRI.NextTrader != None )
        {
            T = KFGRI.OpenedTrader != None ? KFGRI.OpenedTrader : KFGRI.NextTrader;
            if( T != None )
            {
                Canvas.Font = GUIStyle.PickFont(OriginalFontScalar);
                
                FontScalar = OriginalFontScalar + GUIStyle.ScreenScale(0.3);
                
                TraderDistanceText = "Trader"$": "$int(VSize(T.Location - KFPH.Location) / 100.f)$"m";
                Canvas.TextSize(TraderDistanceText, XL, YL, FontScalar, FontScalar);
                
                Canvas.DrawColor = FontColor;
                GUIStyle.DrawTextShadow(TraderDistanceText, Canvas.ClipX*0.015, YL, 1, FontScalar);
                
                Canvas.Font = GUIStyle.PickFont(OriginalFontScalar, true);
            }
        }
        
        //Map Objectives
        MapObjective = KFInterface_MapObjective(KFGRI.CurrentObjective);
        if( MapObjective == None )
            MapObjective = KFInterface_MapObjective(KFGRI.PreviousObjective);
            
        if( MapObjective != None && (MapObjective.IsActive() || ((MapObjective.IsComplete() || MapObjective.HasFailedObjective()) && KFGRI.bWaveIsActive)) )
        {
            Canvas.Font = GUIStyle.PickFont(OriginalFontScalar);
            FontScalar = OriginalFontScalar + GUIStyle.ScreenScale(0.155);
            
            ObjectivePadding = GUIStyle.ScreenScale(8);
            ObjectiveH = GUIStyle.ScreenScale(142);
            ObjectiveSize = ObjectiveH * 2.25;
            
            ObjX = Canvas.ClipX*0.015;
            ObjY = T != None ? (YL * 2) + ObjectivePadding : ObjectiveH;
            
            ObjectiveTitle = Localize("Objectives", "ObjectiveTitle", "KFGame");
            Canvas.TextSize(ObjectiveTitle, XL, ObjYL, FontScalar, FontScalar);

            if( !bLightHUD )
                GUIStyle.DrawRoundedBoxOutlined(ScaledBorderSize, ObjX, ObjY, ObjectiveSize, ObjectiveH, HudMainColor, HudOutlineColor);
        
            // Objective Title
            XPos = ObjX + ObjectivePadding;
            YPos = ObjY + ((ObjectivePadding-ScaledBorderSize) * 0.5f);
        
            if( MapObjective.GetIcon() != None )
            {
                Canvas.DrawColor = FontColor;
                Canvas.SetPos(XPos + ScaledBorderSize, YPos + (ScaledBorderSize*2.5) + 0.5);
                Canvas.DrawTile(MapObjective.GetIcon(), ObjYL - (ScaledBorderSize*4), ObjYL - (ScaledBorderSize*4), 0, 0, 256, 256);
                
                XPos += (ObjYL - (ScaledBorderSize*2)) + ObjectivePadding;
            }
            
            Canvas.DrawColor = FontColor;    
            if( bLightHUD )
                GUIStyle.DrawTextShadow(ObjectiveTitle, XPos, YPos, 1, FontScalar);
            else
            {
                Canvas.SetPos(XPos, YPos);
                Canvas.DrawText(ObjectiveTitle,, FontScalar, FontScalar, FRI);
            }
            
            // Objective Progress
            if( MapObjective.IsComplete() )
            {
                ObjectiveProgress = Localize("Objectives", "SuccessString", "KFGame");
                Canvas.SetDrawColor(0, 255, 0, 255);
            }
            else if( MapObjective.HasFailedObjective() )
            {
                ObjectiveProgress = Localize("Objectives", "FailedString", "KFGame");
                Canvas.SetDrawColor(255, 0, 0, 255);
            }
            else
            {
                ObjectiveProgress = MapObjective.GetProgressText();
                Canvas.DrawColor = FontColor;
            }
            Canvas.TextSize(ObjectiveProgress, XL, YL, FontScalar, FontScalar);
            
            XPos = ObjX + (ObjectiveSize - XL - ObjectivePadding);
            
            if( bLightHUD )
                GUIStyle.DrawTextShadow(ObjectiveProgress, XPos, YPos, 1, FontScalar);
            else
            {
                Canvas.SetPos(XPos, YPos);
                Canvas.DrawText(ObjectiveProgress,, FontScalar, FontScalar, FRI);
            }
            
            // Objective Reward
            Canvas.SetDrawColor(0, 255, 0, 255);
            FontScalar = OriginalFontScalar + GUIStyle.ScreenScale(0.1);
        
            ObjectiveReward = "£" $ (MapObjective.HasFailedObjective() ? 0 : MapObjective.GetDoshReward());
            Canvas.TextSize(ObjectiveReward, XL, YL, FontScalar, FontScalar);
            
            XPos = ObjX + (ObjectiveSize - XL - ObjectivePadding);
            YPos = ObjY + ((ObjectiveH-ObjYL)*0.5f) + (YL*0.5f);
            
            if( bLightHUD )
                GUIStyle.DrawTextShadow(ObjectiveReward, XPos, YPos, 1, FontScalar);
            else
            {
                Canvas.SetPos(XPos, YPos);
                Canvas.DrawText(ObjectiveReward,, FontScalar, FontScalar, FRI);
            }
            
            // Objective Description
            ObjectiveDesc = MapObjective.GetLocalizedShortDescription();
            if( MapObjective.IsComplete() || MapObjective.HasFailedObjective() )
                Canvas.DrawColor = FontColor * 0.5f;
            else Canvas.DrawColor = FontColor;
            
            YPos = ObjY + ((ObjectiveH-ObjYL)/1.5f) - (YL/1.5f) - (ScaledBorderSize*2);
            XPos = ObjX + ObjectivePadding;
            
            if( bLightHUD )
                GUIStyle.DrawTextShadow(ObjectiveDesc, XPos, YPos, 1, FontScalar);
            else
            {
                Canvas.SetPos(XPos, YPos);
                Canvas.DrawText(ObjectiveDesc,, FontScalar, FontScalar, FRI);
            }
            
            // Status Message for the Objective
            MapObjective.GetLocalizedStatus(ObjectiveStatusMessage, bStatusWarning, bStatusNotification);
            if( ObjectiveStatusMessage != "" )
            { 
                if( bool(bStatusWarning) )
                    Canvas.SetDrawColor(255, Clamp(Sin(WorldInfo.TimeSeconds * 12) * 200 + 200, 0, 200), 0, 255);
                else Canvas.DrawColor = FontColor;
                
                Canvas.TextSize(ObjectiveStatusMessage, XL, YL, FontScalar, FontScalar);
                
                XPos = ObjX + ObjectivePadding;
                YPos += YL;
                
                if( bLightHUD )
                    GUIStyle.DrawTextShadow(ObjectiveStatusMessage, XPos, YPos, 1, FontScalar);
                else
                {
                    Canvas.SetPos(XPos, YPos);
                    Canvas.DrawText(ObjectiveStatusMessage,, FontScalar, FontScalar, FRI);
                }
            }
            Canvas.Font = GUIStyle.PickFont(OriginalFontScalar, true);
        }
    }
    
    CurrentWeapon = KFWeapon(KFPH.Weapon);
    if( CurrentWeapon != None )
    {
        if( !bHideWeaponInfo )
        {
            FontScalar = OriginalFontScalar + GUIStyle.ScreenScale(0.1);
            
            // Weapon Name
            if( CachedWeaponInfo.Weapon != CurrentWeapon )
            {
                if( KFGRI != None )
                {
                    TraderItems = KFGRI.TraderItems;
                    if( TraderItems != None )
                    {
                        Index = TraderItems.SaleItems.Find('ClassName', CurrentWeapon.Class.Name);
                        if( Index != INDEX_NONE )
                        {
                            WeaponName = TraderItems.SaleItems[Index].WeaponDef.static.GetItemName();
                        }
                    }
                }
                
                if( WeaponName == "" )
                    WeaponName = CurrentWeapon.ItemName;
                    
                CachedWeaponInfo.Weapon = CurrentWeapon;
                CachedWeaponInfo.WeaponName = WeaponName;
            }
            else WeaponName = CachedWeaponInfo.WeaponName;
            
            Canvas.TextSize(WeaponName, XL, YL, FontScalar, FontScalar);
            Canvas.DrawColor = FontColor;
            GUIStyle.DrawTextShadow(WeaponName, (SizeX * 0.95f) - XL, SizeY * 0.892f, 1, FontScalar);
            
            BoxXL = SizeX * 0.915;
            FontScalar = OriginalFontScalar + GUIStyle.ScreenScale(0.3);
            
            HBRI.Justification = HUDA_Left;
            
            if( Inv != None )
            {
                // Grenades
                HBRI.IconTex = GrenadesIcon;
                DrawHUDBox(BoxXL, BoxYL, BoxSW, BoxSH, string(Inv.GrenadeCount), FontScalar, HBRI);
            }
            
            // ToDo - Find better way to check for weapons like the Welder and Med Syringe
            if( CurrentWeapon.UsesAmmo() || CurrentWeapon.GetSpecialAmmoForHUD() != "" || CurrentWeapon.IsA('KFWeap_Welder') || CurrentWeapon.IsA('KFWeap_Healer_Syringe') )
            {
                bSingleFire = CurrentWeapon.MagazineCapacity[0] <= 1;
                bHasSecondaryAmmo = CurrentWeapon.UsesSecondaryAmmo();
                
                AmmoCount = CurrentWeapon.AmmoCount[0];
                MagCount = bSingleFire ? CurrentWeapon.GetSpareAmmoForHUD() : FCeil(float(CurrentWeapon.GetSpareAmmoForHUD()) / float(CurrentWeapon.MagazineCapacity[0]));
                
                if( CurrentWeapon.IsA('KFWeap_Welder') || CurrentWeapon.IsA('KFWeap_Healer_Syringe') || CurrentWeapon.GetSpecialAmmoForHUD() != "" )
                {
                    bSingleFire = true;
                    MagCount = AmmoCount;
                }
                
                // Clips
                HBRI.IconTex = GetClipIcon(CurrentWeapon, bSingleFire);
                DrawHUDBox(BoxXL, BoxYL, BoxSW, BoxSH, CurrentWeapon.GetSpecialAmmoForHUD() != "" ? CurrentWeapon.GetSpecialAmmoForHUD() : string(MagCount), FontScalar, HBRI);
                
                // Bullets
                if( !bSingleFire )
                {
                    HBRI.IconTex = GetBulletIcon(CurrentWeapon);
                    DrawHUDBox(BoxXL, BoxYL, BoxSW, BoxSH, AmmoCount, FontScalar, HBRI);
                }
                
                // Secondary Ammo
                if( bHasSecondaryAmmo )
                {
                    if( CurrentWeapon.AmmoCount[class'KFWeapon'.const.ALTFIRE_FIREMODE] <= 0 )
                    {
                        SecondaryXL = BoxXL;
                        SecondaryYL = BoxYL - BoxSH;

                        HBRI.IconTex = None;
                        HBRI.TextColor = MakeColor(255, Clamp(Sin(WorldInfo.TimeSeconds * 12) * 200 + 200, 0, 200), 0, 255);
                        
                        DrawHUDBox(SecondaryXL, SecondaryYL, BoxSW, BoxSH, "RELOAD", FontScalar * 0.75, HBRI);
                        
                        HBRI.TextColor = FontColor;
                    }
                    
                    HBRI.IconTex = GetSecondaryAmmoIcon(CurrentWeapon);
                    DrawHUDBox(BoxXL, BoxYL, BoxSW, BoxSH, CurrentWeapon.GetSecondaryAmmoForHUD(), FontScalar, HBRI);
                }
            }
            
            // Flashlight
            FlashlightCharge = KFPH.BatteryCharge;
            if( FlashlightCharge != KFPH.default.BatteryCharge || KFPH.bFlashlightOn )
            {
                HBRI.IconTex = KFPH.bFlashlightOn ? FlashlightIcon : FlashlightOffIcon;
                DrawHUDBox(BoxXL, BoxYL, BoxSW, BoxSH, string(int(KFPH.BatteryCharge)), FontScalar, HBRI);
            }
        }
    }
    
    // Speed
    if( bShowSpeed )
        DrawSpeedMeter();
    
    // Inventory
    if ( bDisplayInventory )
        DrawInventory();
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

function DrawInventory()
{
    local InventoryCategory Categorized[MAX_WEAPON_GROUPS];
    local int i, j;
    local byte FadeAlpha, OrgFadeAlpha, ItemIndex;
    local float TempSize, TempX, TempY, TempWidth, TempHeight, TempBorder, OriginalFontScalar, FontScalar, AmmoFontScalar, CatagoryFontScalar, UpgradeX, UpgradeY, UpgradeW, UpgradeH, EmptyW, EmptyH, EmptyX, EmptyY;
    local float XL, YL, XS, YS;
    local string WeaponName, S;
    local bool bHasAmmo;
    local KFWeapon KFW;
    local Color MainColor, OutlineColor;
    local HUDBoxRenderInfo HBRI;

    if( PlayerOwner.Pawn == None || PlayerOwner.Pawn.InvManager == None )
    {
        return;
    }

    TempSize = `TimeSince(InventoryFadeStartTime);
    if ( TempSize > InventoryFadeTime )
    {
        bDisplayInventory = false;
        return;
    }
    
    if ( TempSize < InventoryFadeInTime )
    {
        FadeAlpha = int((TempSize / InventoryFadeInTime) * 255.0);
    }
    else if ( TempSize > InventoryFadeTime - InventoryFadeOutTime )
    {
        FadeAlpha = int((1.0 - ((TempSize - (InventoryFadeTime - InventoryFadeOutTime)) / InventoryFadeOutTime)) * 255.0);
    }
    else
    {
        FadeAlpha = 255;
    }

    foreach PlayerOwner.Pawn.InvManager.InventoryActors( class'KFWeapon', KFW )
    {
        if ( KFW.InventoryGroup < MAX_WEAPON_GROUPS )
        {
            Categorized[KFW.InventoryGroup].Items[Categorized[KFW.InventoryGroup].ItemCount++] = KFW;
        }
    }
    
    Canvas.Font = GUIStyle.PickFont(OriginalFontScalar);
    FontScalar = OriginalFontScalar;
    AmmoFontScalar = OriginalFontScalar;
    CatagoryFontScalar = OriginalFontScalar;

    TempWidth = InventoryBoxWidth * Canvas.ClipX;
    TempHeight = InventoryBoxHeight * Canvas.ClipX;
    TempBorder = BorderSize * Canvas.ClipX;

    TempX = (Canvas.ClipX*0.5f) - (((TempWidth + TempBorder) * MAX_WEAPON_GROUPS)*0.5f);

    OrgFadeAlpha = FadeAlpha;
    
    for ( i = 0; i < MAX_WEAPON_GROUPS; i++ )
    {
        if( SelectedInventoryCategory == i && MaxWeaponIndex[i] != 0 )
        {
            if( SelectedInventoryIndex == 0 && MinWeaponIndex[i] != 0 )
            {
                MinWeaponIndex[i] = 0;
            }
            
            if( SelectedInventoryIndex > MaxWeaponIndex[i] )
                MinWeaponIndex[i] = SelectedInventoryIndex - MaxWeaponsPerCatagory;
            else if( SelectedInventoryIndex < MinWeaponIndex[i] )
                MinWeaponIndex[i]--;
        }
        else if( MinWeaponIndex[i] != 0 )
        {
            MinWeaponIndex[i] = 0;
        }
    
        TempY = InventoryY * Canvas.ClipY;
        
        HBRI.Justification = HUDA_Top;
        HBRI.JustificationPadding = 24;
        HBRI.TextColor = FontColor;
        HBRI.Alpha = OrgFadeAlpha;
        HBRI.bUseOutline = bLightHUD;
        
        DrawHUDBox(TempX, TempY, TempWidth, TempHeight * 0.25, GetWeaponCatagoryName(i), CatagoryFontScalar, HBRI);
        
        if ( Categorized[i].ItemCount != 0 )
        {
            for ( j = 0; j < Categorized[i].ItemCount; j++ )
            {
                if( j < MinWeaponIndex[i] )
                    continue;
                    
                KFW = Categorized[i].Items[j];
                bHasAmmo = KFW.HasAnyAmmo();
                if( !bHasAmmo )
                    FadeAlpha *= 0.5;
                else if( FadeAlpha != OrgFadeAlpha )
                    FadeAlpha = OrgFadeAlpha;
                
                OutlineColor = KFW.CurrentWeaponUpgradeIndex > 0 ? MakeColor(255, 255, 0) : HudOutlineColor;
                OutlineColor.A = Min(OrgFadeAlpha, default.DefaultHudOutlineColor.A);
                
                if ( i == SelectedInventoryCategory && j == SelectedInventoryIndex )
                {
                    MainColor = HudOutlineColor * 0.5;
                    MainColor.A = Min(FadeAlpha, DefaultHudOutlineColor.A);
                
                    if( KFW.CurrentWeaponUpgradeIndex > 0 )
                        GUIStyle.DrawRoundedBoxOutlined(ScaledBorderSize, TempX, TempY, TempWidth, TempHeight, MainColor, OutlineColor);
                    else GUIStyle.DrawRoundedBox(ScaledBorderSize*2, TempX, TempY, TempWidth, TempHeight, MainColor);
                    
                    if( KFGRI != None && GetItemIndicesFromArche(ItemIndex, KFW.Class.Name) )
                        WeaponName = KFGRI.TraderItems.SaleItems[ItemIndex].WeaponDef.static.GetItemName();
                    else WeaponName = KFW.ItemName;
                        
                    Canvas.DrawColor = WhiteColor;
                    Canvas.DrawColor.A = FadeAlpha;
                    Canvas.TextSize(WeaponName, XS, YS, FontScalar, FontScalar);
                    
                    while( XS > TempWidth )
                    {
                        FontScalar -= 0.1;
                        Canvas.TextSize(WeaponName, XS, YS, FontScalar, FontScalar);
                    }
                    
                    Canvas.SetPos(TempX + ((TempWidth*0.5f) - (XS*0.5f)), TempY + (YS/4));
                    Canvas.DrawText(WeaponName,, FontScalar, FontScalar);
                }
                else 
                {
                    MainColor = HudMainColor;
                    MainColor.A = Min(FadeAlpha, default.DefaultHudMainColor.A);
                    
                    GUIStyle.DrawRoundedBox(ScaledBorderSize*2, TempX, TempY, TempWidth, TempHeight, MainColor);
                }
                
                if( KFW.CurrentWeaponUpgradeIndex > 0 )
                {
                    S = "*"$KFW.CurrentWeaponUpgradeIndex;
                    Canvas.TextSize(S, XS, YS, OriginalFontScalar, OriginalFontScalar);
                    
                    UpgradeW = XS + (ScaledBorderSize*4);
                    UpgradeH = YS + (ScaledBorderSize*4);
                    UpgradeX = TempX + ScaledBorderSize;
                    UpgradeY = TempY + (TempHeight*0.5f) - (UpgradeH*0.5f);
                    
                    GUIStyle.DrawRoundedBoxEx(ScaledBorderSize*2, UpgradeX, UpgradeY, UpgradeW, UpgradeH, OutlineColor, false, true, false, true);
                    
                    Canvas.DrawColor = WhiteColor;
                    Canvas.DrawColor.A = FadeAlpha;
                    
                    GUIStyle.DrawTextShadow(S, UpgradeX + ((UpgradeW*0.5f) - (XS*0.5f)), UpgradeY + (UpgradeH*0.5f) - (YS*0.5f), 2, OriginalFontScalar);
                }
                
                Canvas.DrawColor = WhiteColor;
                Canvas.DrawColor.A = FadeAlpha;
                
                XL = TempWidth * 0.75;
                YL = TempHeight * 0.5;
 
                Canvas.SetPos(TempX + ((TempWidth*0.5f) - (XL*0.5f)), TempY + ((TempHeight*0.5f) - (YL*0.5f)));
                Canvas.DrawRect(XL, YL, KFW.WeaponSelectTexture);
                
                if( KFW.static.UsesAmmo() )
                {
                    S = KFW.AmmoCount[class'KFWeapon'.const.DEFAULT_FIREMODE]$"/"$KFW.SpareAmmoCount[class'KFWeapon'.const.DEFAULT_FIREMODE];
                    Canvas.TextSize(S, XS, YS, AmmoFontScalar, AmmoFontScalar);
                    Canvas.SetPos(TempX + (TempWidth - XS) - (ScaledBorderSize*2), TempY + (TempHeight - YS) - (ScaledBorderSize*2));
                    Canvas.DrawText(S,, AmmoFontScalar, AmmoFontScalar);
                }
                
                if( KFW.UsesSecondaryAmmo() && KFW.bCanRefillSecondaryAmmo )
                {
                    if( KFW.SpareAmmoCount[class'KFWeapon'.const.ALTFIRE_FIREMODE] <= 0 )
                        S = "[" @ string(KFW.AmmoCount[class'KFWeapon'.const.ALTFIRE_FIREMODE]) @ "]";
                    else S = "[" @ KFW.AmmoCount[class'KFWeapon'.const.ALTFIRE_FIREMODE]$"/"$KFW.SpareAmmoCount[class'KFWeapon'.const.ALTFIRE_FIREMODE] @ "]";
                    
                    Canvas.TextSize(S, XS, YS, AmmoFontScalar, AmmoFontScalar);
                    Canvas.SetPos(TempX + (ScaledBorderSize*2), TempY + (TempHeight - YS) - (ScaledBorderSize*2));
                    Canvas.DrawText(S,, AmmoFontScalar, AmmoFontScalar);
                }
                
                if( !bHasAmmo )
                {
                    S = "EMPTY";
                    Canvas.TextSize(S, XS, YS, OriginalFontScalar, OriginalFontScalar);
                    
                    EmptyW = XS * 1.25f;
                    EmptyH = YS * 1.25f;
                    EmptyX = TempX + ((TempWidth*0.5f) - (EmptyW*0.5f));
                    EmptyY = TempY + ((TempHeight*0.5f) - (EmptyH*0.5f));
                    
                    MainColor = DefaultHudMainColor;
                    MainColor.A = Min(FadeAlpha, default.DefaultHudMainColor.A);
                    
                    GUIStyle.DrawRoundedBox(ScaledBorderSize*2, EmptyX, EmptyY, EmptyW, EmptyH, MainColor);
                    
                    Canvas.DrawColor = WhiteColor;
                    Canvas.DrawColor.A = FadeAlpha;
                    Canvas.SetPos(EmptyX + (EmptyW*0.5f) - (XS*0.5f), EmptyY + (EmptyH*0.5f) - (YS*0.5f));
                    Canvas.DrawText(S,, OriginalFontScalar, OriginalFontScalar);
                }
                
                if( (TempY + TempHeight) > (Canvas.ClipY * 0.75) )
                {
                    if( MaxWeaponsPerCatagory == 0 )
                    {
                        MaxWeaponsPerCatagory = j;
                    }
                    
                    MaxWeaponIndex[i] = j;
                    break;
                }

                TempY += TempHeight;
            }
        }

        TempX += TempWidth + TempBorder;
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

function DrawPriorityMessage()
{
    local float XS, YS, TextX, TextY, IconX, IconY, BoxW, OrgBoxW, BoxH, OrgBoxH, BoxX, BoxY, OrignalFontScalar, FontScalar, Box2W, OrgBox2W, Box2H, OrgBox2H, Box2X, Box2Y, Box3W, Box3X, SecondaryXS, SecondaryYS, SecondaryScaler;
    local float TempSize, BoxAlpha, SecondaryBoxAlpha;
    local bool bHasIcon, bHasSecondaryIcon, bHasSecondary, bAlignTop, bAlignBottom, bAnimFinished;
    
    TempSize = `TimeSince(PriorityMessage.StartTime);
    
    Canvas.Font = GUIStyle.PickFont(OrignalFontScalar);
    
    bHasIcon = PriorityMessage.Icon != None;
    bHasSecondaryIcon = PriorityMessage.SecondaryIcon != None;
    bHasSecondary = PriorityMessage.SecondaryText != "";
    
    FontScalar = OrignalFontScalar + GUIStyle.ScreenScale(0.85f);
    Canvas.TextSize(PriorityMessage.PrimaryText, XS, YS, FontScalar, FontScalar);
    
    if( bHasSecondary )
    {
        SecondaryScaler = OrignalFontScalar + GUIStyle.ScreenScale(0.3f);
        Canvas.TextSize(PriorityMessage.SecondaryText, SecondaryXS, SecondaryYS, SecondaryScaler, SecondaryScaler);
        BoxW = FMax(XS,SecondaryXS + (SecondaryXS*0.5f))+(YS*2)*2;
    }
    else BoxW = XS+(YS*2)*2;
    BoxH = YS;
   
    OrgBoxW = BoxW;
    OrgBoxH = BoxH;
   
    if( PriorityMessage.FadeInTime - TempSize > 0 )
    {
        BoxAlpha = (PriorityMessage.FadeInTime - TempSize) / PriorityMessage.FadeInTime;
        BoxAlpha = 1.f - BoxAlpha;
    }
    else if( (PriorityMessage.LifeTime - TempSize) < PriorityMessage.FadeOutTime )
    {
        BoxAlpha = (PriorityMessage.LifeTime - TempSize) / PriorityMessage.FadeOutTime;
    }
    else
    {
        BoxAlpha = 1.f;
    }
    
    if( PriorityMessage.PrimaryAnim == ANIM_SLIDE )
        BoxW = Lerp(BoxH, BoxW, BoxAlpha);
    else BoxH = Lerp(0, BoxH, BoxAlpha);

    if( TempSize > PriorityMessage.LifeTime )
    {
        PriorityMessage = default.PriorityMessage;
        CurrentPriorityMessageA = 0;
        CurrentSecondaryMessageA = 0;
        return;
    }
    
    BoxX = CenterX - (BoxW*0.5f);
    BoxY = (CenterY*0.5) - (BoxH*0.5f);
    
    TextX = BoxX + (BoxW*0.5f) - (XS*0.5f);
    TextY = BoxY + (BoxH*0.5f) - (YS*0.5f);
    
    if( bHasIcon )
        GUIStyle.DrawOutlinedBox(BoxX+BoxH, BoxY, BoxW-(BoxH*2), BoxH, ScaledBorderSize, HudMainColor, HudOutlineColor);
    else GUIStyle.DrawRoundedBoxOutlined(ScaledBorderSize, BoxX, BoxY, BoxW, BoxH, HudMainColor, HudOutlineColor);
    
    bAnimFinished = (PriorityMessage.PrimaryAnim == ANIM_SLIDE ? BoxW >= OrgBoxW : BoxH >= OrgBoxH) && (TempSize+PriorityMessage.FadeInTime+0.5f) > 1.f;
    if( bAnimFinished ) 
    {
        if( CurrentPriorityMessageA != 255 )
        {
            CurrentPriorityMessageA += RandRange(3,10);
            if( CurrentPriorityMessageA > 255 )
                CurrentPriorityMessageA = 255;
        }
            
        Canvas.DrawColor = FontColor;
        Canvas.DrawColor.A = CurrentPriorityMessageA;
        GUIStyle.DrawTextBlurry(PriorityMessage.PrimaryText, TextX, TextY, FontScalar);
    }
    
    if( bHasIcon )
    {
        IconX = BoxX;
        
        GUIStyle.DrawRoundedBoxEx(ScaledBorderSize*2, IconX, BoxY, BoxH, BoxH, HudOutlineColor, true, false, true, false);

        Canvas.DrawColor = PriorityMessage.IconColor;
        Canvas.SetPos(IconX, TextY);
        Canvas.DrawRect(BoxH, BoxH, PriorityMessage.Icon);
        
        IconX = BoxX+(BoxW-BoxH);
        
        GUIStyle.DrawRoundedBoxEx(ScaledBorderSize*2, IconX, BoxY, BoxH, BoxH, HudOutlineColor, false, true, false, true);
        
        Canvas.DrawColor = PriorityMessage.IconColor;
        Canvas.SetPos(IconX, TextY);
        Canvas.DrawRect(BoxH, BoxH, PriorityMessage.Icon);
    }
    
    if( bHasSecondary && bAnimFinished && CurrentPriorityMessageA >= 255 )
    {
        Box2H = SecondaryYS;
        
        if( PriorityMessage.SecondaryStartTime <= 0.f )
            PriorityMessage.SecondaryStartTime = WorldInfo.TimeSeconds;
            
        if( PriorityMessage.bSecondaryUsesFullLength )
            Box2W = BoxW - (BoxH * 2) + (ScaledBorderSize*2);
        else
        {
            Box2W = FMin(SecondaryXS + (SecondaryXS*0.5f), BoxW - (BoxH * 2));
            if( bHasSecondaryIcon )
                Box2W += Box2H*2;
        }
        
        OrgBox2W = Box2W;
        OrgBox2H = Box2H;

        SecondaryBoxAlpha = GUIStyle.TimeFraction(PriorityMessage.SecondaryStartTime, PriorityMessage.SecondaryStartTime+PriorityMessage.FadeInTime, WorldInfo.TimeSeconds);
        if( PriorityMessage.SecondaryAnim == ANIM_SLIDE )
            Box2W = Lerp(0, Box2W, SecondaryBoxAlpha);
        else Box2H = Lerp(0, Box2H, SecondaryBoxAlpha);
            
        Box2X = BoxX + (BoxW*0.5f) - (Box2W*0.5f);
        
        bAlignTop = PriorityMessage.SecondaryAlign == PR_TOP;
        bAlignBottom = PriorityMessage.SecondaryAlign == PR_BOTTOM;
        
        if( bAlignTop )
            Box2Y = BoxY - Box2H;
        else Box2Y = BoxY + BoxH;
        
        Box3X = Box2X+ScaledBorderSize;
        Box3W = Box2W-(ScaledBorderSize*2);
        
        Canvas.DrawColor = HudMainColor;
        Canvas.SetPos(Box3X, Box2Y);
        GUIStyle.DrawWhiteBox(Box3W, Box2H);
       
        GUIStyle.DrawRoundedBoxEx(ScaledBorderSize*4, Box2X, Box2Y, ScaledBorderSize*2, Box2H, HudOutlineColor, bAlignTop, false, bAlignBottom, false);
        GUIStyle.DrawRoundedBoxEx(ScaledBorderSize*4, Box2X+(Box2W-(ScaledBorderSize*2)), Box2Y, ScaledBorderSize*2, Box2H, HudOutlineColor, false, bAlignTop, false, bAlignBottom);

        TextX = Box3X + ((Box3W-SecondaryXS)*0.5f);
        TextY = Box2Y + ((Box2H-SecondaryYS)*0.5f);
        
        if( PriorityMessage.SecondaryAnim == ANIM_SLIDE ? Box2W >= OrgBox2W : Box2H >= OrgBox2H )
        {
            if( CurrentSecondaryMessageA != 255 )
            {
                CurrentSecondaryMessageA += RandRange(3,10);
                if( CurrentSecondaryMessageA > 255 )
                    CurrentSecondaryMessageA = 255;
            }
                
            Canvas.DrawColor = FontColor;
            Canvas.DrawColor.A = CurrentSecondaryMessageA;
            Canvas.SetPos(TextX, TextY);
            Canvas.DrawText(PriorityMessage.SecondaryText,,SecondaryScaler,SecondaryScaler);
        }
        
        if( bHasSecondaryIcon )
        {
            IconX = Box3X+(ScaledBorderSize*4);
            IconY = TextY+(ScaledBorderSize*2);
            
            Canvas.DrawColor = PriorityMessage.SecondaryIconColor;
            Canvas.SetPos(IconX, IconY);
            Canvas.DrawRect(Box2H-(ScaledBorderSize*4), Box2H-(ScaledBorderSize*4), PriorityMessage.SecondaryIcon);
            
            IconX = Box3X+Box3W-Box2H;

            Canvas.DrawColor = PriorityMessage.SecondaryIconColor;
            Canvas.SetPos(IconX, IconY);
            Canvas.DrawRect(Box2H-(ScaledBorderSize*4), Box2H-(ScaledBorderSize*4), PriorityMessage.SecondaryIcon);
        }
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

function DrawNonCritialMessage( int Index, FCritialMessage Message, float X, float Y )
{
    local float XS, YS, XL, YL, TX, BoxXS, BoxYS, FontScalar, TempSize, TY, OrgXL, BoxAlpha, AnimFadeIn, AnimFadeOut, DisplayTime;
    local int i, FadeAlpha;
    local array<string> SArray;
    local HUDBoxRenderInfo HBRI;
    local bool bAnimFinished, bTextAnimFinished;
    local string S;
    local Color TextColor;
    
    Canvas.Font = GUIStyle.PickFont(FontScalar);
    FontScalar += GUIStyle.ScreenScale(0.1);
    TextColor = FontColor;
    DisplayTime = Message.bUseAnimation ? 1.775f : NonCriticalMessageDisplayTime;
    
    TempSize = `TimeSince(Message.StartTime);
    if ( TempSize > DisplayTime )
    {
        NonCriticalMessages.RemoveItem(Message);
        return;
    }
    
    if( Message.Delimiter != "" )
    {
        SArray = SplitString(Message.Text, Message.Delimiter);
        if( SArray.Length > 0 )
        {    
            for( i=0; i<SArray.Length; ++i )
            {
                if( SArray[i]!="" )
                {
                    Canvas.TextSize(GUIStyle.StripTextureFromString(SArray[i]),XS,YS,FontScalar,FontScalar);
                    TX = FMax(XS,TX);
                    TY += YS;
                }
            }
            
            XL = TX * 1.2;
            YL = TY * 1.05;
        }
    }
    else
    {
        Canvas.TextSize(GUIStyle.StripTextureFromString(Message.Text), XS, YS, FontScalar, FontScalar);
        
        XL = XS * 1.2;
        YL = YS * 1.05;
    }
    
    if( Message.bHighlight )
        XL += ScaledBorderSize*4;
        
    if( Message.bUseAnimation )
    {
        FadeAlpha = -1.f;
        OrgXL = XL;
        
        AnimFadeIn = NonCriticalMessageFadeInTime * 0.25;
        AnimFadeOut = NonCriticalMessageFadeOutTime * 0.25;
        
        if( AnimFadeIn - TempSize > 0 )
        {
            BoxAlpha = (AnimFadeIn - TempSize) / AnimFadeIn;
            BoxAlpha = 1.f - BoxAlpha;
        }
        else if( (DisplayTime - TempSize) < AnimFadeOut )
        {
            BoxAlpha = (DisplayTime - TempSize) / AnimFadeOut;
        }
        else
        {
            BoxAlpha = 1.f;
        }
        
        BoxAlpha = FClamp(BoxAlpha, 0.f, 1.f);
        XL = Lerp(ScaledBorderSize*2, XL, BoxAlpha);
        
        bAnimFinished = XL >= OrgXL && (TempSize+AnimFadeIn+0.5f) > 1.f;
        if( bAnimFinished )
        {
            HBRI.StringArray = SArray;
            S = Message.Text;
            
            bTextAnimFinished = NonCriticalMessages[Index].TextAnimAlpha >= 255;
            if( !bTextAnimFinished )
            {
                NonCriticalMessages[Index].TextAnimAlpha += RandRange(3,10);
                if( NonCriticalMessages[Index].TextAnimAlpha > 255 )
                    NonCriticalMessages[Index].TextAnimAlpha =  255;
            }
                
            TextColor.A = NonCriticalMessages[Index].TextAnimAlpha;
        }
    }
    else
    {
        if ( TempSize < NonCriticalMessageFadeInTime )
        {
            FadeAlpha = int((TempSize / NonCriticalMessageFadeInTime) * 255.0);
        }
        else if ( TempSize > DisplayTime - NonCriticalMessageFadeOutTime )
        {
            FadeAlpha = int((1.0 - ((TempSize - (DisplayTime - NonCriticalMessageFadeOutTime)) / NonCriticalMessageFadeOutTime)) * 255.0);
        }
        else
        {
            FadeAlpha = 255;
        }
        
        HBRI.StringArray = SArray;
        S = Message.Text;
    }
    
    BoxXS = X - (XL * 0.5f);
    BoxYS = Y - ((YL + (ScaledBorderSize * 2)) * Index);
    
    if( (BoxYS + YL) > Canvas.ClipY )
        BoxYS = Canvas.ClipY - YL - (ScaledBorderSize * 2);
        
    HBRI.TextColor = TextColor;
    HBRI.Alpha = FadeAlpha;
    HBRI.bUseOutline = bLightHUD;
    HBRI.bUseRounded = true;
    HBRI.bHighlighted = Message.bHighlight;
    
    DrawHUDBox(BoxXS, BoxYS, XL, YL, S, FontScalar, HBRI);
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

function RenderKillMsg()
{
    local float Sc,PDSc,CurrentSc,XL,YL,TextXL,TextYL,PDYL,T,Y;
    local string S;
    local int i;
    local KFInterface_MapObjective MapObjective;
    
    Canvas.Font = GUIStyle.PickFont(Sc);
    Canvas.TextSize("A",XL,YL,Sc,Sc);
    
    PDSc = Sc*1.375f;
    Canvas.TextSize("A",XL,PDYL,PDSc,PDSc);

    MapObjective = KFInterface_MapObjective(KFGRI.CurrentObjective);
    if( MapObjective == None )
        MapObjective = KFInterface_MapObjective(KFGRI.PreviousObjective);
        
    if( MapObjective != None && (MapObjective.IsActive() || ((MapObjective.IsComplete() || MapObjective.HasFailedObjective()) && KFGRI.bWaveIsActive)) )
        Y = Canvas.ClipY*0.235;
    else Y = Canvas.ClipY*0.15;
    
    for( i=0; i<KillMessages.Length; ++i )
    {
        T = WorldInfo.TimeSeconds-KillMessages[i].MsgTime;

        if( KillMessages[i].bDamage )
            S = "-"$KillMessages[i].Counter$" HP "$KillMessages[i].Name;
        else if( KillMessages[i].bLocal )
            S = "+"$KillMessages[i].Counter@KillMessages[i].Name$(KillMessages[i].Counter>1 ? " kills" : " kill");
        else if( KillMessages[i].bPlayerDeath )
            S = (KillMessages[i].bSuicide ? "" : KillMessages[i].Name)$" <Icon>UI_PerkIcons_TEX.UI_PerkIcon_ZED</Icon> "$(KillMessages[i].OwnerPRI!=None ? KillMessages[i].OwnerPRI.GetHumanReadableName() : KillMessages[i].KillerName);
        else S = (KillMessages[i].OwnerPRI!=None ? KillMessages[i].OwnerPRI.GetHumanReadableName() : KillMessages[i].KillerName)$" +"$KillMessages[i].Counter@KillMessages[i].Name$(KillMessages[i].Counter>1 ? " kills" : " kill");
        
        CurrentSc = KillMessages[i].bPlayerDeath ? PDSc : Sc;
        
        if( T>6.f )
        {
            KillMessages[i].CurrentXPosition -= RenderDelta*400.f;
            
            Canvas.TextSize(GUIStyle.StripTextureFromString(S),TextXL,TextYL,CurrentSc,CurrentSc);
            if( (KillMessages[i].CurrentXPosition+TextXL) <= 0.f )
            {
                KillMessages.Remove(i--,1);
                continue;
            }
        }
        else
        {
            KillMessages[i].CurrentXPosition += RenderDelta*200.f;
            KillMessages[i].CurrentXPosition = FMin(KillMessages[i].CurrentXPosition, KillMessages[i].XPosition);
        }
        
        Canvas.DrawColor = KillMessages[i].MsgColor;
        GUIStyle.DrawTexturedString(S, KillMessages[i].CurrentXPosition, Y, CurrentSc,, true);
        Y+=KillMessages[i].bPlayerDeath ? PDYL : YL;
    }
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

function DrawDamage()
{
    local int i, Vel;
    local float TimeSinceHit, TextWidth, TextHeight, Sc, TextX, TextY;
    local vector HBScreenPos;
    local string S;

    Canvas.Font = GUIStyle.PickFont(Sc);
    
    for( i=0; i < DAMAGEPOPUP_COUNT ; i++ ) 
    {
        TimeSinceHit = `TimeSince(DamagePopups[i].HitTime);
        if( TimeSinceHit > DamagePopupFadeOutTime || ( Normal(DamagePopups[i].HitLocation - PLCameraLoc) dot Normal(PLCameraDir) < 0.1 ) ) //don't draw if player faced back to the hit location
            continue;
            
        S = string(DamagePopups[i].Damage);
            
        Canvas.TextSize(S,TextWidth,TextHeight,Sc,Sc);
        Vel = RenderDelta*900.f;

        if ( i % 2 == 0 )
            DamagePopups[i].RandVect.X *= -1.f;
        
        DamagePopups[i].HitLocation += DamagePopups[i].RandVect*RenderDelta;
        if( (TimeSinceHit/DamagePopupFadeOutTime) < 0.035f )
            DamagePopups[i].RandVect.Z += Vel*2;
        else DamagePopups[i].RandVect.Z -= Vel;
        
        HBScreenPos = Canvas.Project(DamagePopups[i].HitLocation);
        
        TextX = HBScreenPos.X-(TextWidth*0.5f);
        TextY = HBScreenPos.Y-(TextHeight*0.5f);
        if( TextX < 0 || TextX > Canvas.ClipX || TextY < 0 || TextY > Canvas.ClipY )
            continue;

        Canvas.DrawColor = DamagePopups[i].FontColor;
        Canvas.DrawColor.A = 255 * Cos(0.5f * Pi * TimeSinceHit/DamagePopupFadeOutTime);
        
        GUIStyle.DrawTextShadow(S, TextX, TextY, 1, Sc);
    }
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

function DrawSpeedMeter()
{
    local float FontScalar, XL, YL;
    local string S;
    
    S = GetSpeedStr() $ " ups";
    
    Canvas.Font = GUIStyle.PickFont(FontScalar);
    Canvas.TextSize(S,XL,YL,FontScalar,FontScalar);
    
    GUIStyle.DrawTextShadow(S, Canvas.ClipX - XL + (ScaledBorderSize*2), Canvas.ClipY * 0.80, 1, FontScalar);
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

function DrawBossHealthBars()
{
    local int i;
    local float BarH, BarW, MainBarX, MainBarY, MainBoxW, ArmorW, ArmorH;
    local float ArmorPct;
    local ArmorZoneInfo ArmorZone;
    local KFPawn_Monster Pawn;
    
    if( bDisplayInventory || Scoreboard.bVisible || !bDisplayImportantHealthBar )
        return;
    
    Pawn = BossRef.GetMonsterPawn();
    
    BarH = GUIStyle.DefaultHeight;
    BarW = Canvas.ClipX * 0.45;
    
    MainBoxW = BarW * 0.125;
    
    MainBarX = (Canvas.ClipX*0.5f) - (BarW*0.5f) + (MainBoxW*0.5f);
    MainBarY = BarH;
    
    DrawImportantHealthBar(MainBarX, MainBarY, BarW, BarH, Pawn.static.GetLocalizedName(), FClamp(BossRef.GetHealthPercent(), 0.f, 1.f), HudMainColor, BossBattlePhaseColor, BossInfoIcon,,,true,Pawn.Health,Pawn.HealthMax,true);
    
    if( Pawn.ArmorInfo != None )
    {
        ArmorW = BarW * 0.2;
        ArmorH = BarH * 0.45;
        
        MainBarX = MainBarX + (BarW - ArmorW - ScaledBorderSize);
        MainBarY += (BarH*0.5f) + ArmorH + (ScaledBorderSize*2);
            
        for(i=0; i<Pawn.ArmorInfo.ArmorZones.Length; i++)
        {
            ArmorZone = Pawn.ArmorInfo.ArmorZones[i];
            ArmorPct = FClamp(ByteToFloat(Pawn.RepArmorPct[i]), 0.f, 1.f);
            
            DrawImportantHealthBar(MainBarX, MainBarY, ArmorW, ArmorH, "", ArmorPct, HudMainColor, MakeColor(0, 162, 232, 255), ArmorZone.ZoneIcon, ScaledBorderSize, ArmorPct <= 0.f);
            MainBarX -= ArmorW + (ScaledBorderSize*2);
        }
    }
}

function DrawEscortHealthBars()
{
    local int BarH, BarW, MainBarX, MainBarY, MainBoxW;
    local float HealthFrac;
    local Color PawnHealthColor;
    
    if( bDisplayInventory || Scoreboard.bVisible || !bDisplayImportantHealthBar )
        return;
    
    BarH = GUIStyle.DefaultHeight;
    BarW = Canvas.ClipX * 0.45;
    
    MainBoxW = BarW * 0.125;
    
    MainBarX = (Canvas.ClipX*0.5f) - (BarW*0.5f) + (MainBoxW*0.5f);
    MainBarY = BarH;
    
    HealthFrac = FClamp(float(ScriptedPawn.Health)/float(ScriptedPawn.HealthMax), 0.f, 1.f);
    
    PawnHealthColor = MakeColor(0, 150, 0, 175);
    PawnHealthColor.g = 150 * HealthFrac;
    PawnHealthColor.r = 150 - PawnHealthColor.g;
    
    DrawImportantHealthBar(MainBarX, MainBarY, BarW, BarH, ScriptedPawn.GetLocalizedName(), HealthFrac, HudMainColor, PawnHealthColor, BossInfoIcon,,, true, ScriptedPawn.Health, ScriptedPawn.HealthMax, true);
}

function DrawMedicWeaponRecharge()
{
    local KFWeapon KFWMB;
    local float IconBaseX, IconBaseY, IconHeight, IconWidth;
    local float IconRatioX, IconRatioY, ChargePct, ChargeBaseY, WeaponBaseX;
    local color ChargeColor;
    
    if (PlayerOwner.Pawn.InvManager == None)
        return;

    IconRatioX = Canvas.ClipX / 1920.0;
    IconRatioY = Canvas.ClipY / 1080.0;
    IconHeight = MedicWeaponHeight * IconRatioY;
    IconWidth = IconHeight * 0.5f;

    IconBaseX = bDisableHUD ? 300 * IconRatioX : (Canvas.ClipX * 0.85) - IconWidth;
    IconBaseY = Canvas.ClipY * 0.8125;
    
    WeaponBaseX = IconBaseX;

    Canvas.EnableStencilTest(false);
    foreach PlayerOwner.Pawn.InvManager.InventoryActors(class'KFWeapon', KFWMB)
    {
        if ((bDisableHUD && KFWeap_HealerBase(KFWMB) != None) || (KFWeap_HealerBase(KFWMB) == None && KFWeap_MedicBase(KFWMB) == None) || KFWMB == PlayerOwner.Pawn.Weapon || (KFWeap_MedicBase(KFWMB) != None && !KFWeap_MedicBase(KFWMB).bRechargeHealAmmo) || (KFWeap_HealerBase(KFWMB) != None && float(KFWMB.AmmoCount[0]) == float(KFWMB.MagazineCapacity[0])))
            continue;
            
        GUIStyle.DrawRoundedBox(ScaledBorderSize*2, WeaponBaseX, IconBaseY, IconWidth, IconHeight, MedicWeaponBGColor);
        
        if( KFWeap_HealerBase(KFWMB) != None )
            ChargePct = FClamp(float(KFWMB.AmmoCount[0]) / float(KFWMB.MagazineCapacity[0]),0.f,1.f);
        else ChargePct = FClamp(float(KFWMB.AmmoCount[1]) / float(KFWMB.MagazineCapacity[1]),0.f,1.f);
        
        ChargeBaseY = IconBaseY + IconHeight * (1.0 - ChargePct);
        ChargeColor = (KFWMB.HasAmmo(1) ? MedicWeaponChargedColor : MedicWeaponNotChargedColor);
        GUIStyle.DrawRoundedBox(ScaledBorderSize*2, WeaponBaseX, ChargeBaseY, IconWidth, IconHeight * ChargePct, ChargeColor);
        
        Canvas.DrawColor = WhiteColor;
        Canvas.SetPos(WeaponBaseX + IconWidth, IconBaseY);
        Canvas.DrawRotatedTile(KFWMB.WeaponSelectTexture, MedicWeaponRot, IconHeight, IconWidth, 0, 0, KFWMB.WeaponSelectTexture.GetSurfaceWidth(), KFWMB.WeaponSelectTexture.GetSurfaceHeight(), 0, 0);
        
        if( bDisableHUD )
            WeaponBaseX += IconWidth * 1.2;
        else WeaponBaseX -= IconWidth * 1.2;
    }
    Canvas.EnableStencilTest(true);
}

function DrawMedicWeaponLockOn(KFWeap_MedicBase KFW)
{
    local KFPawn CurrentActor;
    local color IconColor;
    local vector ScreenPos;
    local float IconSize, RealIconSize;

    if (KFW.LockedTarget != None)
    {
        CurrentActor = KFPawn(KFW.LockedTarget);
        IconColor = MedicLockOnColor;
    }
    else if (KFW.PendingLockedTarget != None)
    {
        CurrentActor = KFPawn(KFW.PendingLockedTarget);
        IconColor = MedicPendingLockOnColor;
    }

    if (CurrentActor == None)
    {
        OldTarget = None;
        return;
    }
        
    if (CurrentActor != OldTarget)
    {
        LockOnStartTime = WorldInfo.RealTimeSeconds;
        LockOnEndTime = WorldInfo.RealTimeSeconds+0.15;
        OldTarget = CurrentActor;
    }

    ScreenPos = Canvas.Project(CurrentActor.Mesh.GetPosition() + (CurrentActor.CylinderComponent.CollisionHeight * vect(0,0,1.25)));
    if (ScreenPos.X < 0 || ScreenPos.X > Canvas.ClipX || ScreenPos.Y < 0 || ScreenPos.Y > Canvas.ClipY)
        return;

    IconSize = WorldInfo.static.GetResolutionBasedHUDScale() * MedicLockOnIconSize;
    RealIconSize = FInterpEaseInOut(IconSize*2, IconSize, GUIStyle.TimeFraction(LockOnStartTime, LockOnEndTime, WorldInfo.RealTimeSeconds), 2.5);
    
    Canvas.DrawColor = IconColor;
    Canvas.SetPos(ScreenPos.X - (RealIconSize * 0.5f), ScreenPos.Y - (RealIconSize * 0.5f));
    Canvas.DrawRect(RealIconSize, RealIconSize, MedicLockOnIcon);
}

function DrawTraderIndicator()
{
    local KFTraderTrigger T;
    
    if( KFGRI == None || (KFGRI.OpenedTrader == None && KFGRI.NextTrader == None) )
        return;
    
    T = KFGRI.OpenedTrader != None ? KFGRI.OpenedTrader : KFGRI.NextTrader;
    if( T != None )
        DrawDirectionalIndicator(T.Location, bLightHUD ? TraderArrowLight : TraderArrow, Canvas.ClipY/33.f,, HudOutlineColor, class'KFGFxHUD_TraderCompass'.default.TraderString, !bLightHUD);
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

function DrawWeaponPickupInfo()
{
    local vector ScreenPos;
    local bool bHasSingleForDual, bCanCarry;
    local Inventory Inv;
    local KFInventoryManager KFIM;
    local string WeightText, S;
    local class<KFWeapon> KFWC;
    local int Weight;
    local color CanCarryColor;
    local FontRenderInfo FRI;
    local float FontScale, ResModifier, IconSize;
    local float TextWidth, TextHeight, TextYOffset, SecondaryBGWidth, SecondaryBGHeight;
    local float InfoBaseX, InfoBaseY;
    local float BGX, BGY, BGWidth, BGHeight;

    ScreenPos = Canvas.Project(WeaponPickup.Location + vect(0,0,25));
    if (ScreenPos.X < 0 || ScreenPos.X > Canvas.ClipX || ScreenPos.Y < 0 || ScreenPos.Y > Canvas.ClipY)
        return;

    KFWC = class<KFWeapon>(WeaponPickup.InventoryClass);
    if (KFWC.default.DualClass != None && PlayerOwner.Pawn != None && PlayerOwner.Pawn.InvManager != None)
    {
        Inv = PlayerOwner.Pawn.InvManager.FindInventoryType(KFWC);
        if (KFWeapon(Inv) != None)
            bHasSingleForDual = true;
    }

    if (bHasSingleForDual)
    {
        Weight = KFWC.default.DualClass.default.InventorySize - KFWeapon(Inv).GetModifiedWeightValue();
    }
    else Weight = KFWC.default.InventorySize;

    WeightText = string(Weight);
    if (PlayerOwner.Pawn != None && KFInventoryManager(PlayerOwner.Pawn.InvManager) != None)
    {
        KFIM = KFInventoryManager(PlayerOwner.Pawn.InvManager);
        if (KFIM.CanCarryWeapon(KFWC))
        {
            if (KFWC.default.DualClass != None)
                bCanCarry = !KFIM.ClassIsInInventory(KFWC.default.DualClass, Inv);
            else bCanCarry = !KFIM.ClassIsInInventory(KFWC, Inv);
        }
    }
    else bCanCarry = true;

    CanCarryColor = (bCanCarry ? WeaponIconColor : WeaponOverweightIconColor);

    FRI = Canvas.CreateFontRenderInfo(true);

    ResModifier = WorldInfo.static.GetResolutionBasedHUDScale();
    Canvas.Font = GUIStyle.PickFont(FontScale);
    Canvas.TextSize(WeightText, TextWidth, TextHeight, FontScale, FontScale);

    IconSize = WeaponIconSize * ResModifier;
    InfoBaseX = ScreenPos.X - ((IconSize * 1.5 + TextWidth) * 0.5);
    InfoBaseY = ScreenPos.Y;
    TextYOffset = (IconSize - TextHeight) * 0.5;

    BGWidth = IconSize * 2.0 + TextWidth;
    BGX = InfoBaseX - (IconSize * 0.25);
    BGHeight = IconSize * 1.5;
    BGY = InfoBaseY + IconSize * 1.5 - (BGHeight * 0.125);

    GUIStyle.DrawRoundedBox(ScaledBorderSize*2, BGX, BGY, BGWidth, BGHeight, HudMainColor);

    Canvas.DrawColor = CanCarryColor;
    Canvas.SetPos(InfoBaseX, InfoBaseY + IconSize * 1.5);
    Canvas.DrawTile(WeaponWeightIcon, IconSize, IconSize, 0, 0, 256, 256);

    Canvas.DrawColor = WhiteColor;
    Canvas.SetPos(InfoBaseX + IconSize * 1.5, InfoBaseY + IconSize * 1.5 + TextYOffset);
    Canvas.DrawText(WeightText, , FontScale, FontScale, FRI);
    
    if( WeaponPickup.GetDisplayName() != "" )
    {
        S = WeaponPickup.GetDisplayName();
        Canvas.TextSize(S, TextWidth, TextHeight, FontScale, FontScale);
        
        SecondaryBGWidth = TextWidth * 1.125;
        SecondaryBGHeight = TextHeight * 1.125;
        
        BGY += BGHeight + (TextHeight*0.5f);
        BGX += (BGWidth*0.5f) - (SecondaryBGWidth*0.5f);
        
        GUIStyle.DrawRoundedBox(ScaledBorderSize*2, BGX, BGY, SecondaryBGWidth, SecondaryBGHeight, HudMainColor);
        
        Canvas.DrawColor = WhiteColor;
        Canvas.SetPos(BGX + (SecondaryBGWidth*0.5f) - (TextWidth*0.5f), BGY + (SecondaryBGHeight*0.5f) - (TextHeight*0.5f));
        Canvas.DrawText(S, , FontScale, FontScale, FRI);
    }
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

function CheckAndDrawRemainingZedIcons()
{
    if( !bDisableLastZEDIcons )
        Super.CheckAndDrawRemainingZedIcons();
}

simulated function CheckAndDrawHiddenPlayerIcons( array<PlayerReplicationInfo> VisibleHumanPlayers, array<sHiddenHumanPawnInfo> HiddenHumanPlayers )
{
    if( !bDisableHiddenPlayers )
        Super.CheckAndDrawHiddenPlayerIcons(VisibleHumanPlayers, HiddenHumanPlayers);
}

exec function OpenSettingsMenu()
{
    GUIController.OpenMenu(class'KFClassicHUD.UI_MidGameMenu');
}

exec function SetShowScores(bool bNewValue)
{
    if( bNewScoreboard && Scoreboard != None )
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
    HUDClass=class'KF1_HUDWrapper'
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