local math = math
local table = table
local ipairs = ipairs

local SUI, NAME = CURRENT_SUI, CURRENT_SUI.name

local Panel = {}

AccessorFunc(Panel, "horizontalMargin", "HorizontalMargin", FORCE_NUMBER)
AccessorFunc(Panel, "verticalMargin", "VerticalMargin", FORCE_NUMBER)
AccessorFunc(Panel, "columns", "Columns", FORCE_NUMBER)
AccessorFunc(Panel, "Wide2", "Wide2", FORCE_NUMBER)

function Panel:Init()
	self:SetHorizontalMargin(0)
	self:SetVerticalMargin(0)
	self.Rows = {}
	self.Cells = {}
end

function Panel:AddCell(pnl)
	local cols = self:GetColumns()
	local idx = math.floor(#self.Cells / cols) + 1

	local rows = self.Rows[idx]
	if not rows then
		rows = self:CreateRow()
		self.Rows[idx] = rows
	end

	local margin = self:GetHorizontalMargin()

	local dockl, dockt, _, dockb = pnl:GetDockMargin()
	pnl:SetParent(rows)
	pnl:Dock(LEFT)
	pnl:DockMargin(dockl, dockt, #rows.Items + 1 < cols and self:GetHorizontalMargin() or 0, dockb)
	pnl:SetWide(((self:GetWide2() or self:GetWide()) - margin * (cols - 1)) / cols)

	table.insert(rows.Items, pnl)
	table.insert(self.Cells, pnl)

	self:CalculateRowHeight(rows)
end

function Panel:CreateRow()
	local row = self:Add("Panel")
	row:Dock(TOP)
	row:DockMargin(0, 0, 0, self:GetVerticalMargin())
	row.Items = {}

	return row
end

function Panel:CalculateRowHeight(row)
	local height = 0

	for k, v in ipairs(row.Items) do
		local _, t, _, b = v:GetDockMargin()
		height = math.max(height, v:GetTall() + t + b)
	end

	row:SetTall(height)
end

function Panel:Skip()
	local cell = vgui.Create("Panel")
	self:AddCell(cell)
end

function Panel:CalculateRowHeights()
	for _, row in ipairs(self.Rows) do
		self:CalculateRowHeight(row)
	end
end

function Panel:Clear()
	for _, row in ipairs(self.Rows) do
		for _, cell in ipairs(row.Items) do
			cell:Remove()
		end

		row:Remove()
	end

	self.Cells, self.Rows = {}, {}
end

Panel.OnRemove = Panel.Clear
sui.register("ThreeGrid", Panel, NAME .. ".ScrollPanel")