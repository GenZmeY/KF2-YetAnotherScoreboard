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

class KFGUI_Image extends KFGUI_Base;

var enum eImageStyle
{
	ISTY_Normal,
	ISTY_Stretched
} ImageStyle;

var enum eScaleStyle
{
	ISTY_Height,
	ISTY_Width
} ScaleStyle;

var Color ImageColor;
var Texture Image;
var bool bAlignCenter, bForceUniformSize;
var int X1, Y1, X2, Y2;
var float ImageScale;

function DrawMenu()
{
	local float X, Y, XL, YL;

	if (Image == None)
		return;

	DrawBackground(Canvas, CompPos[2], CompPos[3]);

	Canvas.DrawColor = ImageColor;

	switch (ImageStyle)
	{
		case ISTY_Normal:
			if (X1 != -1)
				X = X1;
			else X = 0;

			if (Y1 != -1)
				Y = Y1;
			else Y = 0;

			if (bForceUniformSize)
			{
				if (ScaleStyle == ISTY_Height)
				{
					YL = CompPos[3];
					XL = YL;
				}
				else
				{
					XL = CompPos[2];
					YL = XL;
				}
			}
			else
			{
				if (Y2 == -1)
					YL = FMin(CompPos[3], Image.GetSurfaceHeight());
				else YL = (Y2-Y1);

				if (X2 == -1)
					XL = FMin(CompPos[2], Image.GetSurfaceWidth());
				else XL = (X2-X1);
			}

			if (bAlignCenter)
			{
				Canvas.SetPos((CompPos[2]/2) - (XL/2), (CompPos[3]/2) - (YL/2));
				Canvas.DrawTile(Image, XL, YL, X, Y, Image.GetSurfaceWidth(), Image.GetSurfaceHeight());
			}
			else
			{
				Canvas.SetPos(0.f, 0.f);
				Canvas.DrawTile(Image, XL, YL, X, Y, Image.GetSurfaceWidth(), Image.GetSurfaceHeight());
			}

			break;
		case ISTY_Stretched:
			if (X1 < 0 && X2 < 0 && Y1 < 0 && Y2 < 0 )
				Owner.CurrentStyle.DrawTileStretched(Image, 0.f, 0.f, CompPos[2], CompPos[3]);
			else
			{
				if (X1 != -1)
					X = X1;
				else X = 0;

				if (Y1 != -1)
					Y = Y1;
				else Y = 0;

				if (bForceUniformSize)
				{
					if (ScaleStyle == ISTY_Height)
					{
						YL = CompPos[3];
						XL = YL;
					}
					else
					{
						XL = CompPos[2];
						YL = XL;
					}
				}
				else
				{
					if (Y2 == -1)
						YL = FMin(CompPos[3], Image.GetSurfaceHeight());
					else YL = (Y2-Y1);

					if (X2 == -1)
						XL = FMin(CompPos[2], Image.GetSurfaceWidth());
					else XL = (X2-X1);
				}

				if (bAlignCenter)
				{
					Canvas.SetPos((CompPos[2]/2) - (XL/2), (CompPos[3]/2) - (YL/2));
					Canvas.DrawTile(Image, CompPos[2], CompPos[3], X, Y, Image.GetSurfaceWidth(), Image.GetSurfaceHeight());
				}
				else
				{
					Canvas.SetPos(0.f, 0.f);
					Canvas.DrawTile(Image, CompPos[2], CompPos[3], X, Y, Image.GetSurfaceWidth(), Image.GetSurfaceHeight());
				}

				break;
			}
			break;
	}
}

delegate DrawBackground(Canvas C, float W, Float H);

defaultproperties
{
	ImageColor=(R=255, G=255, B=255, A=255)
	ImageStyle=ISTY_Normal
	X1=-1
	X2=-1
	Y1=-1
	Y2=-1
}