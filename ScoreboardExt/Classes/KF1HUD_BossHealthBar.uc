class KF1HUD_BossHealthBar extends KFGFxWidget_BossHealthBar;

function TickHud(float DeltaTime)
{
    local ClassicKFHUD HUD;
    
    HUD = ClassicKFHUD(KFPC.MyHUD);
    if(KFPC.bHideBossHealthBar != bLastHideValue)
    {
        bLastHideValue = KFPC.bHideBossHealthBar;

        if(KFPC.bHideBossHealthBar && HUD.ScriptedPawn == none)
            HUD.bDisplayImportantHealthBar = false;
        else if(HUD.BossPawn != none || HUD.ScriptedPawn != none)
            HUD.bDisplayImportantHealthBar = true;
    }
}

function SetEscortPawn(KFPawn_Scripted NewPawn)
{
    local ClassicKFHUD HUD;
    
    HUD = ClassicKFHUD(KFPC.MyHUD);
	if (NewPawn == none)
		return;
        
    EscortPawn = NewPawn;
    
    HUD.bDisplayImportantHealthBar = true;
    HUD.BossInfoIcon = Texture2D(DynamicLoadObject(NewPawn.GetIconPath(),class'Texture2D'));
    HUD.ScriptedPawn = NewPawn;
}

function SetBossPawn(KFInterface_MonsterBoss NewBoss)
{
    BossPawn = NewBoss;
    if(NewBoss == None || KFPC.bHideBossHealthBar)
        return;

    ClassicKFHUD(KFPC.MyHUD).BossInfoIcon = Texture2D(DynamicLoadObject(NewBoss.GetIconPath(),class'Texture2D'));
    ClassicKFHUD(KFPC.MyHUD).BossPawn = NewBoss;
}

function UpdateBossShield(float NewShieldPercect)
{
    ClassicKFHUD(KFPC.MyHUD).BossShieldPct = NewShieldPercect;
}

function UpdateBossBattlePhase(int BattlePhase)
{
    ClassicKFHUD(KFPC.MyHUD).BossBattlePhaseColor = ClassicKFHUD(KFPC.MyHUD).BattlePhaseColors[Max(BattlePhase - 1, 0)];
}

function OnNamePlateHidden()
{
    local ClassicKFHUD HUD;
    
    HUD = ClassicKFHUD(KFPC.MyHUD);
    if(KFPC.bHideBossHealthBar && HUD.ScriptedPawn == none)
        return;

    if(HUD.BossPawn != None)
        HUD.bDisplayImportantHealthBar = true;
	else  HUD.bDisplayImportantHealthBar = false;
}

simulated function Deactivate()
{
    local ClassicKFHUD HUD;
    
    HUD = ClassicKFHUD(KFPC.MyHUD);
    
    HUD.BossInfoIcon = None;
    HUD.BossPawn = None;
    HUD.BossShieldPct = 0.f;
    HUD.BossBattlePhaseColor = HUD.default.BossBattlePhaseColor;
    HUD.ScriptedPawn = None;
    
	HUD.bDisplayImportantHealthBar = false;
}

DefaultProperties
{
}