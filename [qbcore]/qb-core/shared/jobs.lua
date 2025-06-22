QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved

QBShared.Jobs = {
	unemployed = {
		label = 'Zivilist',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = {
				name = 'Arbeitslos',
				payment = 10
			}
		}
	}
}

-- Jobs Creator integration (jobs_creator)
RegisterNetEvent("jobs_creator:injectJobs", function(jobs)
	if IsDuplicityVersion() and type(source) == "number" and source > 0 then return end
	QBShared.Jobs = jobs
end)
