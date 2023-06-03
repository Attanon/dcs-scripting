local f=io.open(lfs.writedir() .. 'Missions\\Source\\red-tide\\Scripts\\frontline_manager.lua',"r")

local loaderLog = mist.Logger:new('LOADER_MANAGER', 'info')
loaderLog:msg('Trying to load dev version of frontline_manager.lua')

if f~=nil then
	f:close()

	loaderLog:msg('Dev version is exists, loading dev version..')
	dofile(lfs.writedir() .. 'Missions\\Source\\red-tide\\Scripts\\logger.lua')
	dofile(lfs.writedir() .. 'Missions\\Source\\red-tide\\Scripts\\frontline_manager.lua')
end