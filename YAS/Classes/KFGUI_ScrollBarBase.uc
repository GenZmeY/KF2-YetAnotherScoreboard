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

class KFGUI_ScrollBarBase extends KFGUI_Clickable
	abstract;

var() int MinRange, MaxRange, ScrollStride, PageStep;
var() float ButtonScale; // Button width (scaled by default font height).
var int CurrentScroll;

// In-runtime values.
var transient float CalcButtonScale;
var transient int SliderScale, ButtonOffset, GrabbedOffset;
var transient bool bGrabbedScroller;

var bool bVertical, bHideScrollbar;

final function UpdateScrollSize(int Current, int MxRange, int Stride, int StepStride, optional int MnRange)
{
	MaxRange = MxRange;
	MinRange = MnRange;
	ScrollStride = Stride;
	PageStep = StepStride;
	SetValue(Current);
}
final function AddValue(int V)
{
	SetValue(CurrentScroll+V);
}
final function SetValue(int V)
{
	CurrentScroll = Clamp((V / ScrollStride) * ScrollStride, MinRange, MaxRange);
	OnScrollChange(Self, CurrentScroll);
}
final function int GetValue()
{
	return CurrentScroll;
}
Delegate OnScrollChange(KFGUI_ScrollBarBase Sender, int Value);

// Get UI width.
function float GetWidth()
{
	CalcButtonScale = ButtonScale*Owner.CurrentStyle.DefaultHeight;
	return CalcButtonScale / (bVertical ? InputPos[2] : InputPos[3]);
}
function PreDraw()
{
	// Auto scale to match width to screen size.
	if (bVertical)
		XSize = GetWidth();
	else YSize = GetWidth();
	Super.PreDraw();
}
function DrawMenu()
{
	if (!bHideScrollbar)
	{
		Owner.CurrentStyle.RenderScrollBar(Self);
	}
}
function MouseClick(bool bRight)
{
	if (bRight || bDisabled)
		return;
	bPressedDown = true;
	PlayMenuSound(MN_ClickButton);

	if (bVertical)
	{
		if (Owner.MousePosition.Y >= (CompPos[1]+ButtonOffset) && Owner.MousePosition.Y <= (CompPos[1]+ButtonOffset+SliderScale) ) // Grabbed scrollbar!
		{
			GrabbedOffset = Owner.MousePosition.Y - (CompPos[1]+ButtonOffset);
			bGrabbedScroller = true;
			GetInputFocus();
		}
		else if (Owner.MousePosition.Y < (CompPos[1]+ButtonOffset) ) // Page up.
			AddValue(-PageStep);
		else AddValue(PageStep);
	}
	else
	{
		if (Owner.MousePosition.X >= (CompPos[0]+ButtonOffset) && Owner.MousePosition.X <= (CompPos[0]+ButtonOffset+SliderScale) ) // Grabbed scrollbar!
		{
			GrabbedOffset = Owner.MousePosition.X - (CompPos[0]+ButtonOffset);
			bGrabbedScroller = true;
			GetInputFocus();
		}
		else if (Owner.MousePosition.X < (CompPos[0]+ButtonOffset) ) // Page left.
			AddValue(-PageStep);
		else AddValue(PageStep);
	}
}
function MouseRelease(bool bRight)
{
	if (!bRight)
		DropInputFocus();
}

function LostInputFocus()
{
	bGrabbedScroller = false;
	bPressedDown = false;
}

function ScrollMouseWheel(bool bUp)
{
	if (bDisabled)
		return;
	if (bUp)
		AddValue(-ScrollStride);
	else AddValue(ScrollStride);
}

function SetVisibility(bool Visible)
{
	bHideScrollbar = Visible;
}

defaultproperties
{
	MaxRange=100
	ScrollStride=1
	PageStep=10
	ButtonScale=1
}