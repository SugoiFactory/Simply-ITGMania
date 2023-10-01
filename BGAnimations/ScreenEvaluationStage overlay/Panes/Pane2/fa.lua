local player, controller = unpack(...)

local pn = ToEnumShortString(player)
local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

local firstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

-- iterating through the TapNoteScore enum directly isn't helpful because the
-- sequencing is strange, so make our own data structures for this purpose
local TapNoteScores = {}
local TapNoteScores = {
	Types = { 'W0' },
	Names = {
		THEME:GetString("TapNoteScoreFA+", "W1"),
		THEME:GetString("TapNoteScoreFA+", "W2"),
		THEME:GetString("TapNoteScoreFA+", "W3"),
		THEME:GetString("TapNoteScoreFA+", "W4"),
		THEME:GetString("TapNoteScoreFA+", "W5"),
		THEME:GetString("TapNoteScore", "W5"), -- FA+ mode doesn't have a Way Off window. Extract name from the ITG mode.
		THEME:GetString("TapNoteScoreFA+", "Miss"),
	},
	Colors = {
		SL.JudgmentColors["FA+"][1],
		SL.JudgmentColors["FA+"][2],
		SL.JudgmentColors["FA+"][3],
		SL.JudgmentColors["FA+"][4],
		SL.JudgmentColors["FA+"][5],
		SL.JudgmentColors["ITG"][5], -- FA+ mode doesn't have a Way Off window. Extract color from the ITG mode.
		SL.JudgmentColors["FA+"][6],
	},
	-- x values for P1 and P2
	x = { P1=64, P2=94 }
}

local RadarCategories = {
	THEME:GetString("ScreenEvaluation", 'Holds'),
	THEME:GetString("ScreenEvaluation", 'Mines'),
	THEME:GetString("ScreenEvaluation", 'Rolls')
}

local EnglishRadarCategories = {
	[THEME:GetString("ScreenEvaluation", 'Holds')] = "Holds",
	[THEME:GetString("ScreenEvaluation", 'Mines')] = "Mines",
	[THEME:GetString("ScreenEvaluation", 'Rolls')] = "Rolls",
}

local t = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(50 * (controller==PLAYER_1 and 1 or -1), _screen.cy-24)
	end,
}

-- The FA+ window shares the status as the FA window.
-- If the FA window is disabled, then we consider the FA+ window disabled as well.
local windows = {SL[pn].ActiveModifiers.TimingWindows[1]}
for v in ivalues(SL[pn].ActiveModifiers.TimingWindows) do
	windows[#windows + 1] = v
end

--  labels: W1, W2, W3, W4, W5, Miss
for i=1, #TapNoteScores.Types do
	-- no need to add BitmapText actors for TimingWindows that were turned off
	if windows[i] or i==#TapNoteScores.Types then
		t[#t+1] = LoadFont("_eurostile normal")..{
			Text=TapNoteScores.Names[i],
			InitCommand=function(self) self:zoom(0.53):horizalign(right) end,
			BeginCommand=function(self)
				self:x( (controller == PLAYER_1 and -230) or -28 )
				self:y(94)
				-- diffuse the JudgmentLabels the appropriate colors for the current GameMode
				
			end
		}
	end
	
end

-- labels: hands/ex, holds, mines, rolls
for index, label in ipairs(RadarCategories) do
	if index == 1 then
		t[#t+1] = LoadFont("_eurostile normal")..{
			Text="EX",
			InitCommand=function(self) self:zoom(0.5):horizalign(right) end,
			BeginCommand=function(self)
				self:x(-137)
				self:y(94)
				
			end
		}
	end


end
return t