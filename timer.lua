local _, ns = ...

-- create a new timer
-- parent and fontname must be defined, all others get default values if not specified
-- @parent The parent frame
-- @font a list of fontname, fontsize, fontflag
-- @size a list of width, height
-- @position a list of own anchor, parent anchor, x offset, y offset
-- @updatefreq a float value
-- @treshhold a list of remaining duration to show the timer, remaining duration to color it red
local newTimer = function(self, parent, font, size, position, updatefreq, treshhold)
	local new = { timerFrame = nil }
	
	new.parent = parent
	new.font = font
	new.width, new.height = unpack(size or {14, 14})
	new.selfanchor, new.parentanchor, new.x, new.y = unpack(position or { "CENTER", "BOTTOMRIGHT", 0, 0})
	new.updatefreq = updatefreq or 0.3
	new.treshhold_show, new.treshhold_red = unpack(treshhold or {10, 4})
	
	-- provides access to the current timer frame
	new.getFrame = function(self)
		if not self.timerFrame then
			local newTimerFrame = CreateFrame("Frame", nil, self.parent)
			newTimerFrame:SetWidth(self.width)
			newTimerFrame:SetHeight(self.height)
			newTimerFrame:SetPoint(self.selfanchor, self.parent, self.parentanchor, self.x, self.y)
			newTimerFrame.nextUpdate = 0
			newTimerFrame.updatefreq = self.updatefreq
			newTimerFrame.treshhold_show = self.treshhold_show
			newTimerFrame.treshhold_red = self.treshhold_red
			
			
			local timerText = newTimerFrame:CreateFontString(nil, "OVERLAY")
			timerText:SetFontObject(self.font)
			timerText:SetFont(timerText:GetFont(), 12, "THINOUTLINE")
			timerText:SetAllPoints(newTimerFrame)
			newTimerFrame.timerText = timerText
			
			newTimerFrame.update = function(self, elapsed)
				if self.nextUpdate > 0 then
					self.nextUpdate = self.nextUpdate - elapsed
				else
					self.nextUpdate = self.updatefreq or 0.5
					local remaining = self.expiryTime - GetTime()
					if remaining < self.treshhold_red then -- red color for timer < treshhold_red s
						self.timerText:SetFormattedText("|cffff0000%d|r", remaining)
					elseif remaining < self.treshhold_show then -- default color 
						self.timerText:SetFormattedText("%d", remaining)
					else -- dont show timer > treshhold_show s
						self.timerText:SetText("")
					end
				end
			end
			
			self.timerFrame = newTimerFrame
		end
		
		return self.timerFrame
	end
	
	return {
		-- set the expiry time for this timer
		setExpiryTime = function(self, expiryTime) new:getFrame().expiryTime = expiryTime end,
		
		-- Frame functions
		Show = function(self) 
            local timer = new:getFrame()
            timer:Show() 
            timer:SetScript("OnUpdate", timer.update)
        end,
		Hide = function(self) 
            local timer = new:getFrame()
            timer:Hide()
            timer:SetScript("OnUpdate", nil); 
            timer.timerText:SetText("")
        end,
	}
end

ns.newTimer = newTimer