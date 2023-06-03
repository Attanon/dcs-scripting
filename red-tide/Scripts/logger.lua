--[[

@script logger

@description

@features
- 6 levels of logging
- custom log files
- optional format of date and time for custom log files

@examples

@created May 9, 2022

@version 0.0.9

]]

if utils and utils.logger then
    env.info("Script was loaded via loader. Skipping..")
    return
end

utils = {}

local osdate = nil
if not os then
    osdate = function(v)
        return v
    end
else
    osdate = os.date
end
local format = string.format

local levels = {
    { ["callback"] = "alert", ["enum"] = "ALERT" },
    { ["callback"] = "error", ["enum"] = "ERROR" },
    { ["callback"] = "warning", ["enum"] = "WARNING" },
    { ["callback"] = "info", ["enum"] = "INFO" },
    { ["callback"] = "debug", ["enum"] = "DEBUG" },
    { ["callback"] = "trace", ["enum"] = "TRACE" },
}

utils.logger = {
    ["openmode"] = "a",
    ["date"] = "%Y-%m-%d",
    ["time"] = "%H:%M:%S",
    ["level"] = 6,
}

utils.logger.version = "0.0.9"

utils.logger.enums = {
    ["alert"] = 1,
    ["error"] = 2,
    ["warning"] = 3,
    ["info"] = 4,
    ["debug"] = 5,
    ["trace"] = 6
}

for i, level in ipairs(levels) do
    utils.logger[level.callback] = function(self, message, ...)
        if self.level < i then
            return
        end

        local fName = nil
        local cLine = nil

        if debug then
            local dInfo = debug.getinfo(2)
            fName = dInfo.name
            cLine = dInfo.currentline
        end

        local logMessage = format(message, ...)
        local source = self.source
        if fName then
            source = format("%s|%s", source, fName)
        end

        if cLine then
            source = format("%s:%s", source, cLine)
        end

        if self.file then
            local fullMessage = format("%s %s\t%s: %s\n", osdate(self.datetime), level.enum, source, logMessage)
            self.file:write(fullMessage)
            return
        end
        if i == 2 then
            env.error(format("%s\t%s: %s", level.enum, source, logMessage))
            return
        end

        env.info(format("%s\t%s: %s", level.enum, source, logMessage))
    end
end

--[[ create a new instance of logger
- @param #logger self
- @param #enum level [the level of logging, eg; logger.enums.info]
- @param #string file [the external file to write to]
- @param #string mode [the mode in which the above file is opened, eg; "a" to append new lines]
- @param #string date [the format in which the date will be written in the external file, eg; "%Y-%m-%d" : 2022-05-09]
- @param #string time [the format in which the time will be written in the external file, eg; "%H:%M:%S" : 13:30:05]
- @return #logger self
]]
function utils.logger:new(level, source, file, mode, date, time)
    local self = setmetatable({}, { __index = utils.logger })
    self.level = level
    self.source = source

    if not source then
        local cSourceFile = nil
        if debug then
            local dInfo = debug.getinfo(2)
            fName = dInfo.name
            cLine = dInfo.currentline
            sourceFile = dInfo.source:sub(2)
            cSourceFile = sourceFile:match("^.*\\(.*.lua)$") or sourceFile
            self.source = cSourceFile
        end
    end

    if self.file then
        self.file:close()
    end
    if file then
        if not mode then
            mode = utils.logger.openmode
        end
        self.file = assert(io.open(file, mode))
    end
    date = date or utils.logger.date
    time = time or utils.logger.time
    self.datetime = date .. " " .. time
    return self
end

--[[ set the level of the logger
- @param #logger self
- @param #enum level [the level of logging, eg; logger.enums.info]
- @return #logger self
]]
function utils.logger:setLevel(level)
    self.level = level
    return self
end

--[[ set the external log file for the logger
- @param #logger self
- @param #string file [the external file to write to]
- @param #string mode [the mode in which the above file is opened, eg; "a" to append new lines]
- @return #logger self
]]
function utils.logger:setFile(file, mode)
    if self.file then
        self.file:close()
    end
    if not mode then
        mode = utils.logger.openmode
    end
    self.file = assert(io.open(file, mode))
    return self
end

--[[ set the format for the date and time for an external log file
- @param #logger self
- @param #string date [the format in which the date will be written in the external file, eg; "%Y-%m-%d" : 2022-05-09]
- @param #string time [the format in which the time will be written in the external file, eg; "%H:%M:%S" : 13:30:05]
- @return #logger self
]]
function utils.logger:setDateTime(date, time)
    date = date or utils.logger.date
    time = time or utils.logger.time
    self.datetime = date .. " " .. time
    return self
end

logger = utils.logger:new(6)
logger:info("successfully loaded version %s", logger.version)