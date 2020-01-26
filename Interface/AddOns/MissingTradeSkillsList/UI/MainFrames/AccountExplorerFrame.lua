---------------------------------------------------------
-- Name: Database Explorer Frame	                   --
-- Description: The main frame to explore the database --
---------------------------------------------------------
MTSLUI_ACCOUNT_EXPLORER_FRAME = MTSL_TOOLS:CopyObject(MTSLUI_BASE_FRAME)

MTSLUI_ACCOUNT_EXPLORER_FRAME.FRAME_WIDTH_VERTICAL_SPLIT = 1253
MTSLUI_ACCOUNT_EXPLORER_FRAME.FRAME_HEIGHT_VERTICAL_SPLIT = 470

MTSLUI_ACCOUNT_EXPLORER_FRAME.FRAME_WIDTH_HORIZONTAL_SPLIT = 868
MTSLUI_ACCOUNT_EXPLORER_FRAME.FRAME_HEIGHT_HORIZONTAL_SPLIT = 738

---------------------------------------------------------------------------------------
-- Shows the frame
----------------------------------------------------------------------------------------
function MTSLUI_ACCOUNT_EXPLORER_FRAME:Show()
    -- only show if not options menu open
    if MTSLUI_OPTIONS_MENU_FRAME:IsShown() then
        print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: " .. MTSLUI_TOOLS:GetLocalisedLabel("close options menu"))
    else
        -- hide database viewer
        MTSLUI_DATABASE_EXPLORER_FRAME:Hide()
        self.ui_frame:Show()
        -- update the UI of the screen
        self:RefreshUI()
    end
end

----------------------------------------------------------------------------------------------------------
-- Intialises the MissingTradeSkillFrame
--
-- @parent_frame		Frame		The parent frame
----------------------------------------------------------------------------------------------------------
function MTSLUI_ACCOUNT_EXPLORER_FRAME:Initialise()
    self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLUI_AccountFrame", nil, nil, self.FRAME_WIDTH_VERTICAL_SPLIT, self.FRAME_HEIGHT_VERTICAL_SPLIT, true)
        self.ui_frame:SetFrameLevel(10)
        self.ui_frame:SetToplevel(true)
    -- Set Position to center of screen
    self.ui_frame:SetPoint("CENTER", nil, "CENTER", 0, 0)
    -- Dummy operation to do nothing, discarding the zooming in/out
    self.ui_frame:SetScript("OnMouseWheel", function() end)
    -- Make the screen dragable/movable
    MTSLUI_TOOLS:AddDragToFrame(self.ui_frame)
    -- close/hide window on esc
    tinsert(UISpecialFrames, "MTSLUI_AccountFrame")

    -- add the close button
    self.ui_frame.close_button = MTSLUI_TOOLS:CreateBaseFrame("Button", "", self.ui_frame, "UIPanelButtonTemplate", 24, 24)
    self.ui_frame.close_button:SetText("X")
    -- Set Position to top right of databaseframe
    self.ui_frame.close_button:SetPoint("TOPRIGHT", self.ui_frame, "TOPRIGHT", -2, -2)
    self.ui_frame.close_button:SetScript("OnClick", function()
        MTSLUI_ACCOUNT_EXPLORER_FRAME:Hide()
    end)
    -- Hide oncreation
    self.ui_frame:Hide()

    -- Create the frames inside this frame
    self:CreateCompontentFrames()
    self:LinkFrames()
    -- select the first player
    self.player_list_frame:HandleSelectedListItem(1)
end

function MTSLUI_ACCOUNT_EXPLORER_FRAME:CreateCompontentFrames()
    -- Copy & init the title frame
    self.title_frame = MTSL_TOOLS:CopyObject(MTSLUI_TITLE_FRAME)
    self.title_frame:Initialise(self.ui_frame, "Account Explorer", 1165, 810)
    -- position in left top corner of main frame
    self.title_frame.ui_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", 0, 0)
    -- Copy & init the player filter frames
    self.player_filter_frame = MTSL_TOOLS:CopyObject(MTSLUI_PLAYER_FILTER_FRAME)
    self.player_filter_frame:Initialise(self.title_frame.ui_frame, "MTSLACCUI_PLAYER_FILTER_FRAME")
    -- position next of the detail frame (in vertical mode)
    self.player_filter_frame.ui_frame:SetPoint("TOPLEFT", self.title_frame.ui_frame, "BOTTOMLEFT", 4, -5)
    -- Copy & init the player list frames
    self.player_list_frame = MTSL_TOOLS:CopyObject(MTSLUI_PLAYER_LIST_FRAME)
    self.player_list_frame:Initialise(self.player_filter_frame.ui_frame, "MTSLACCUI_PLAYER_LIST_FRAME")
    -- position under the filter frame
    self.player_list_frame.ui_frame:SetPoint("TOPLEFT", self.player_filter_frame.ui_frame, "BOTTOMLEFT", 0, -6)
    -- Copy & init the profession list frame
    self.profession_list_frame = MTSL_TOOLS:CopyObject(MTSLUI_PROFESSION_LIST_FRAME)
    self.profession_list_frame:Initialise(self.player_list_frame.ui_frame, "MTSLACCUI_PROFESSION_LIST_FRAME")
    -- position next to player_list_frame
    self.profession_list_frame.ui_frame:SetPoint("TOPLEFT", self.player_filter_frame.ui_frame, "TOPRIGHT", -6, 11)
    -- Copy & init the filter frame
    self.skill_list_filter_frame = MTSL_TOOLS:CopyObject(MTSLUI_FILTER_FRAME)
    self.skill_list_filter_frame:Initialise(self.profession_list_frame.ui_frame, "MTSLACCUI_SKILL_LIST_FILTER_FRAME")
    -- position under TitleFrame and right of ProfessionListFrame
    self.skill_list_filter_frame.ui_frame:SetPoint("TOPLEFT", self.profession_list_frame.ui_frame, "TOPRIGHT", 1, -8)
    -- Copy & init the list frame
    self.skill_list_frame = MTSL_TOOLS:CopyObject(MTSLUI_LIST_FRAME)
    self.skill_list_frame:Initialise(self.skill_list_filter_frame.ui_frame, "MTSLACCUI_SKILL_LIST_FRAME")
    -- position under the filter frame
    self.skill_list_frame.ui_frame:SetPoint("TOPLEFT", self.skill_list_filter_frame.ui_frame, "BOTTOMLEFT", 0, -5)
    -- Copy & init the skill detail frame
    self.skill_detail_frame = MTSL_TOOLS:CopyObject(MTSLUI_SKILL_DETAIL_FRAME)
    self.skill_detail_frame:Initialise(self.skill_list_frame.ui_frame, "MTSLACCUI_SKILL_DETAIL_FRAME")
    self.skill_detail_frame.ui_frame:SetPoint("BOTTOMLEFT", self.skill_list_frame.ui_frame, "BOTTOMRIGHT", 0, 0)
    -- limit to tcurrent phase only (no point in know skills to filter for all)
    self.skill_list_filter_frame:UseOnlyCurrentPhase()
end

function MTSLUI_ACCOUNT_EXPLORER_FRAME:LinkFrames()
    self.player_filter_frame:SetListFrame(self.player_list_frame)
    self.player_list_frame:SetProfessionListFrame(self.profession_list_frame)
    self.profession_list_frame:SetFilterFrame(self.skill_list_filter_frame)
    self.profession_list_frame:SetListFrame(self.skill_list_frame)
    self.skill_list_filter_frame:SetListFrame(self.skill_list_frame)
    self.skill_list_frame:SetDetailSelectedItemFrame(self.skill_detail_frame)
end

----------------------------------------------------------------------------------------------------------
-- Refresh the ui of the addon
----------------------------------------------------------------------------------------------------------
function MTSLUI_ACCOUNT_EXPLORER_FRAME:RefreshUI()
    -- auto select the first player
    self.player_list_frame:UpdateList()
    self.player_list_frame:HandleSelectedListItem(1)
end
----------------------------------------------------------------------------------------------------------
-- Swap to Vertical Mode (Default mode, means list left & details right)
----------------------------------------------------------------------------------------------------------
function MTSLUI_ACCOUNT_EXPLORER_FRAME:SwapToVerticalMode()
    -- resize the frames
    self.ui_frame:SetWidth(self.FRAME_WIDTH_VERTICAL_SPLIT)
    self.ui_frame:SetHeight(self.FRAME_HEIGHT_VERTICAL_SPLIT)
    self.title_frame:ResizeToVerticalMode()

    self.player_list_frame:ResizeToVerticalMode()

    self.skill_list_filter_frame:ResizeToVerticalMode()
    self.skill_list_frame:ResizeToVerticalMode()
    -- no need to resize detail frame, always same size, just rehook it
    self.skill_detail_frame.ui_frame:ClearAllPoints()
    self.skill_detail_frame.ui_frame:SetPoint("BOTTOMLEFT", self.skill_list_frame.ui_frame, "BOTTOMRIGHT", 0, 0)
end

----------------------------------------------------------------------------------------------------------
-- Swap to Horizontal Mode (means list on top & details below)
----------------------------------------------------------------------------------------------------------
function MTSLUI_ACCOUNT_EXPLORER_FRAME:SwapToHorizontalMode()
    -- resize the frames where needed
    self.ui_frame:SetWidth(self.FRAME_WIDTH_HORIZONTAL_SPLIT)
    self.ui_frame:SetHeight(self.FRAME_HEIGHT_HORIZONTAL_SPLIT)
    self.title_frame:ResizeToHorizontalMode()

    self.player_list_frame:ResizeToHorizontalMode()

    self.skill_list_filter_frame:ResizeToHorizontalMode()
    self.skill_list_frame:ResizeToHorizontalMode()
    -- no need to resize detail frame, always same size, just rehook it
    self.skill_detail_frame.ui_frame:ClearAllPoints()
    self.skill_detail_frame.ui_frame:SetPoint("TOPLEFT", self.skill_list_frame.ui_frame, "BOTTOMLEFT", 0, 0)
end

function MTSLUI_ACCOUNT_EXPLORER_FRAME:ChangeToPlayer(realm_name, player_name)
    local known_professions = MTSL_LOGIC_PLAYER_NPC:GetKnownProfessionsForPlayer(realm_name, player_name)
    self.profession_list_frame:UpdateProfessions(known_professions)
end