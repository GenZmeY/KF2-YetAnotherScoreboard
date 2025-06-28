// This file is part of Yet Another Scoreboard.
// Yet Another Scoreboard - a mutator for Killing Floor 2.
//
// Copyright (C) 201?      Mr Evil
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

class KFColorHelper extends Object
	transient;

struct HSVColour
{
	var() float H, S, V, A;

	structdefaultproperties
	{
		A=1.0
	}
};

static final function HSVColour RGBToHSV(const LinearColor RGB)
{
	local float Max;
	local float Min;
	local float Chroma;
	local HSVColour HSV;

	Min = FMin(FMin(RGB.R, RGB.G), RGB.B);
	Max = FMax(FMax(RGB.R, RGB.G), RGB.B);
	Chroma = Max - Min;

	//If Chroma is 0, then S is 0 by definition, and H is undefined but 0 by convention.
	if (Chroma != 0)
	{
		if (RGB.R == Max)
		{
			HSV.H = (RGB.G - RGB.B) / Chroma;

			if (HSV.H < 0.0)
			{
				HSV.H += 6.0;
			}
		}
		else if (RGB.G == Max)
		{
			HSV.H = ((RGB.B - RGB.R) / Chroma) + 2.0;
		}
		else //RGB.B == Max
		{
			HSV.H = ((RGB.R - RGB.G) / Chroma) + 4.0;
		}

		HSV.H *= 60.0;
		HSV.S = Chroma / Max;
	}

	HSV.V = Max;
	HSV.A = RGB.A;

	return HSV;
}

static final function LinearColor HSVToRGB(const HSVColour HSV)
{
	local float Min;
	local float Chroma;
	local float Hdash;
	local float X;
	local LinearColor RGB;

	Chroma = HSV.S * HSV.V;
	Hdash = HSV.H / 60.0;
	X = Chroma * (1.0 - Abs((Hdash % 2.0) - 1.0));

	if (Hdash < 1.0)
	{
		RGB.R = Chroma;
		RGB.G = X;
	}
	else if (Hdash < 2.0)
	{
		RGB.R = X;
		RGB.G = Chroma;
	}
	else if (Hdash < 3.0)
	{
		RGB.G = Chroma;
		RGB.B = X;
	}
	else if (Hdash < 4.0)
	{
		RGB.G= X;
		RGB.B = Chroma;
	}
	else if (Hdash < 5.0)
	{
		RGB.R = X;
		RGB.B = Chroma;
	}
	else if (Hdash < 6.0)
	{
		RGB.R = Chroma;
		RGB.B = X;
	}

	Min = HSV.V - Chroma;

	RGB.R += Min;
	RGB.G += Min;
	RGB.B += Min;
	RGB.A = HSV.A;

	return RGB;
}

static final function Color LinearColorToColor(const LinearColor RGB)
{
	local Color TrueRGB;

	TrueRGB.R = RGB.R * 255;
	TrueRGB.G = RGB.G * 255;
	TrueRGB.B = RGB.B * 255;
	TrueRGB.A = RGB.A * 255;

	return TrueRGB;
}