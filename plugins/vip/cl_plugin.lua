function PLUGIN:PopulateItemTooltip(tooltip, item) 
    if(item.vip and !LocalPlayer():IsVip()) then
        local warning = tooltip:AddRowAfter("name", "warning")
        warning:SetText("Czujesz, że coś blokuje Cię przed skorzystaniem z tego przedmiotu...")
        warning:SetBackgroundColor(derma.GetColor("Warning", tooltip))
        warning:SizeToContents()
    end
end