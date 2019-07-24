local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale or "enUS")
local AB = E:GetModule("ActionBars")

local function ColorizeSettingName(settingName)
	return format("|cff1784d1%s|r", settingName)
end

function AB:GetOptions()
	local ACD = E.Libs.AceConfigDialog

	if not E.Options.args.elvuiPlugins then
		E.Options.args.elvuiPlugins = {
			order = 50,
			type = "group",
			name = "|cffff7000E|r|cffe5e3e3lvUI |r|cff00b30bP|r|cffe5e3e3lugins|r",
			args = {
				header = {
					order = 0,
					type = "header",
					name = "|cffff7000E|r|cffe5e3e3lvUI |r|cff00b30bP|r|cffe5e3e3lugins|r"
				},
				microbarEnhancedShortcut = {
					type = "execute",
					name = ColorizeSettingName("Microbar Enhancement"),
					func = function()
						if IsAddOnLoaded("ElvUI_OptionsUI") then
							ACD:SelectGroup("ElvUI", "elvuiPlugins", "microbarEnhanced")
						end
					end
				}
			}
		}
	elseif not E.Options.args.elvuiPlugins.args.microbarEnhancedShortcut then
		E.Options.args.elvuiPlugins.args.microbarEnhancedShortcut = {
			type = "execute",
			name = ColorizeSettingName("Microbar Enhancement"),
			func = function()
				if IsAddOnLoaded("ElvUI_OptionsUI") then
					ACD:SelectGroup("ElvUI", "elvuiPlugins", "microbarEnhanced")
				end
			end
		}
	end

	E.Options.args.elvuiPlugins.args.microbarEnhanced = {
		type = "group",
		name = ColorizeSettingName(L["Microbar Enhancement"]),
		get = function(info) return E.db.actionbar.microbar[info[#info]] end,
		set = function(info, value) E.db.actionbar.microbar[info[#info]] = value AB:UpdateMicroPositionDimensions() end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Microbar Enhancement"]
			},
			backdrop = {
				order = 2,
				type = "toggle",
				name = L["Backdrop"],
				disabled = function() return not AB.db.microbar.enabled end
			},
			transparentBackdrop = {
				order = 3,
				type = "toggle",
				name = L["Transparent Backdrop"],
				disabled = function() return not AB.db.microbar.enabled or not AB.db.microbar.backdrop end
			},
			spacer = {
				order = 4,
				type = "description",
				name = " "
			},
			symbolic = {
				order = 5,
				type = "toggle",
				name = L["As Letters"],
				desc = L["Replace icons with letters"],
				disabled = function() return not AB.db.microbar.enabled end
			},
			classColor = {
				order = 6,
				type = "toggle",
				name = L["Use Class Color"],
				get = function(info) return AB.db.microbar.classColor end,
				set = function(info, value) AB.db.microbar.classColor = value AB:SetSymbloColor() end,
				disabled = function() return not AB.db.microbar.enabled or not AB.db.microbar.symbolic end,
			},
			color = {
				order = 7,
				type = "color",
				name = L["COLOR"],
				get = function(info)
					local t = AB.db.microbar.colorS
					local d = P.actionbar.microbar.colorS
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b
				end,
				set = function(info, r, g, b)
					local t = AB.db.microbar.colorS
					t.r, t.g, t.b = r, g, b
					AB:SetSymbloColor()
				end,
				disabled = function() return not AB.db.microbar.enabled or AB.db.microbar.classColor or not AB.db.microbar.symbolic end
			}
		}
	}
end