if (!(Get-Process whkd -ErrorAction SilentlyContinue)) {
  Start-Process whkd -WindowStyle hidden
}

komorebic watch-configuration enable
komorebic focus-follows-mouse enable

komorebic active-window-border-colour 142 140 216
komorebic active-window-border enable
komorebic toggle-cross-monitor-move-behaviour

# rules
komorebic float-rule class TaskManagerWindow
komorebic float-rule title "Microsoft Teams Notification"

# Visual studio
komorebic identify-object-name-change-application exe "devenv.exe"
komorebic float-rule title "WindowsFormsParkingWindow"

# preview teams
komorebic identify-object-name-change-application exe "ms-teams.exe"

# If my particular ultrawide monitor prefer columns
if (((Get-WmiObject WmiMonitorID -namespace root\wmi).InstanceName) -like "*VTK*") {
   # try ultrawide-vertical-stack
   komorebic workspace-layout 0 0 columns
}

komorebic complete-configuration
