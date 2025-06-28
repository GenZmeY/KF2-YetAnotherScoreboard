// This file is part of Yet Another Scoreboard.
// Yet Another Scoreboard - a mutator for Killing Floor 2.
//
// Copyright (C) 201?      Marco
// Copyright (C) 2020      ForrestMarkX
// Copyright (C) 2021-2024 GenZmeY (mailto: genzmey@gmail.com)
//
// Yet Another Scoreboard is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Yet Another Scoreboard is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with Yet Another Scoreboard. If not, see <https://www.gnu.org/licenses/>.

class KFGUI_Slider extends KFGUI_MultiComponent;

var KFGUI_ScrollBarH ScrollBar;

var int MinValue, MaxValue;
var transient int CurrentValue;

delegate OnValueChanged(KFGUI_Slider Sender, int Value);

function InitMenu()
{
	Super.InitMenu();
	ScrollBar = KFGUI_ScrollBarH(FindComponentID('Scrollbar'));
	ScrollBar.OnScrollChange = ValueChanged;
}

function int GetValue()
{
	return CurrentValue;
}

function SetValue(int Value)
{
	CurrentValue = Clamp(Value, MinValue, MaxValue);
	OnValueChanged(self, CurrentValue);
}

function ValueChanged(KFGUI_ScrollBarBase Sender, int Value)
{
	SetValue(Value);
}

function UpdateListVis()
{
	ScrollBar.UpdateScrollSize(CurrentValue, MaxValue, 1,1, MinValue);
}

function ScrollMouseWheel(bool bUp)
{
	if (!ScrollBar.bDisabled)
		ScrollBar.ScrollMouseWheel(bUp);
}

defaultproperties
{
	Begin Object Class=KFGUI_ScrollBarH Name=SliderScroll
		XSize=1
		YSize=0.5
		ID="Scrollbar"
	End Object
	Components.Add(SliderScroll)
}