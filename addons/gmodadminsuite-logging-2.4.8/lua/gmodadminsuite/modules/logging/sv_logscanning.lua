GAS.Logging.LogScanning = {}
GAS.Logging.LogScanning.LogRegistry = {}
GAS.Logging.LogScanning.CurrentLogEntities = {}

function GAS.Logging.LogScanning:CommitToRegistry(log_id)
    for ent in pairs(GAS.Logging.LogScanning.CurrentLogEntities) do
        if (not IsValid(ent)) then continue end
        if (GAS.Logging.LogScanning.LogRegistry[ent] == nil) then
            GAS.Logging.LogScanning.LogRegistry[ent] = {}
        end
        GAS.Logging.LogScanning.LogRegistry[ent][#GAS.Logging.LogScanning.LogRegistry[ent] + 1] = log_id
    end
    GAS.Logging.LogScanning.CurrentLogEntities = {}
end