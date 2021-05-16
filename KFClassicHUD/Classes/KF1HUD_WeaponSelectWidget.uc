class KF1HUD_WeaponSelectWidget extends KFGFxHUD_WeaponSelectWidget;

function SetSelectedWeapon(int GroupIndex, int SelectedIndex)
{
    local ClassicKFHUD HUD;
    
    HUD = ClassicKFHUD(GetPC().MyHUD);
    if( !HUD.bDisplayInventory )
    {
        HUD.bDisplayInventory = true;
        HUD.InventoryFadeStartTime = GetPC().WorldInfo.TimeSeconds;
    }
    else HUD.RefreshInventory();
    
    HUD.SelectedInventoryCategory = GroupIndex;
    HUD.SelectedInventoryIndex = SelectedIndex;
}

function InitializeObject();
function SetThowButton();
simulated function RefreshWeaponSelect();
simulated function UpdateWeaponGroupOnHUD( byte GroupIndex );
simulated function SetWeaponGroupList(out array<KFWeapon> WeaponList, byte GroupIndex);
simulated function SetWeaponList( GFxObject WeaponList, int GroupIndex );
function Weapon GetSelectedWeapon();
function UpdateIndex();
function Hide();
function SetWeaponCategories();
function SendWeaponIndex( int GroupIndex, int SelectedIndex );
function ShowOnlyHUDGroup( byte GroupIndex );
function ShowAllHUDGroups();
function FadeOut();
function RefreshTimer();
function SetWeaponSwitchStayOpen(bool bStayOpen);

DefaultProperties
{
}
