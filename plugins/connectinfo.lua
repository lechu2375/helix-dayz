PLUGIN.name = "Mat Spec"
PLUGIN.author = "Lechu2375"


if(CLIENT) then

    local convar = GetConVar("mat_specular")
    local tekst = "Wykryto włączoną opcję mat_specular!\n"..
    "Jeśli zauważysz zbyt jasne modele, problemy z oświetleniem możesz spróbować tego:\n"..
    "1.Wejdź w konsolę i wpisz: mat_specular 0 - Twoja gra może się zawiesić.\n"..
    "Jeśli powyżej minuty gra nie będzie dawała znaku życia to pomiń ten krok i przejdź do następnego\n"..
    "2.Dopisz na samym w dole autoconfigu mat_specular 0\n" ..
    "Ścieżka autoconfigu: garrysmod/cfg/autoexec.cfg]"
    function PLUGIN:InitPostEntity()
        if(convar:GetInt()==1) then


            local frame = vgui.Create("DFrame")
            frame:SetTitle("Warning")
            frame:SetSize(ScrW()*.5,ScrH()*.3)
            frame:DockMargin(20,0,20,0)
            frame:DockPadding(0,0,0,0)
            frame:Center()
            frame:MakePopup()
    
            local DLabel = vgui.Create( "DLabel", frame )
            DLabel:SetText( tekst)
            DLabel:SetFont("ixMediumLightFont")
            DLabel:Dock(FILL)
            DLabel:SetWrap( true )
    
    
        end
    end
end


