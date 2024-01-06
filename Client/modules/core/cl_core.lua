Input.Register("Admin Panel", "K")

local admin_panel = WebUI("Admin Panel", "file://ui/panel/index.html", WidgetVisibility.Hidden)
local is_open = false

Input.Bind("Admin Panel", InputEvent.Released, function()
    if (is_open) then -- Panel is open, close
        admin_panel:SetVisibility(WidgetVisibility.Hidden)
        Input.SetMouseEnabled(false)
        is_open = false
    else -- Panel is closed, open
        admin_panel:SetVisibility(WidgetVisibility.Visible)
        Input.SetMouseEnabled(true)
        is_open = true
    end
end)