local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end

local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/zephhhhhhhh/NewVape2/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'newvape', 'newvape/games', 'newvape/profiles', 'newvape/assets', 'newvape/libraries', 'newvape/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not isfolder("newvape/assets/new") then
	makefolder("newvape/assets/new")
end

local _, subbed = pcall(function()
	return game:HttpGet('https://github.com/zephhhhhhhh/NewVape2')
end)
local commit = subbed:find('currentOid')
commit = commit and subbed:sub(commit + 13, commit + 52) or nil
commit = commit and #commit == 40 and commit or 'main'
if commit == 'main' or (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit then
	wipeFolder('newvape')
	wipeFolder('newvape/games')
	wipeFolder('newvape/guis')
	wipeFolder('newvape/libraries')
end
writefile('newvape/profiles/commit.txt', commit)


local fileNames = {
    "add.png", "alert.png", "allowedicon.png", "allowedtab.png", "arrowmodule.png",
    "back.png", "bind.png", "bindbkg.png", "blatanticon.png", "blockedicon.png",
    "blockedtab.png", "close.png", "closemini.png",
    "colorpreview.png", "combaticon.png", "customsettings.png", "dots.png", "edit.png",
    "expandright.png", "expandup.png", "friendstab.png", "guisettings.png", "guislider.png",
    "guisliderrain.png", "guiv4.png", "guivape.png", "info.png", "inventoryicon.png",
    "legit.png", "legittab.png", "miniicon.png", "notification.png", "overlaysicon.png",
    "overlaystab.png", "pin.png", "profilesicon.png", "radaricon.png",
    "rainbow_1.png", "rainbow_2.png", "rainbow_3.png", "rainbow_4.png",
    "range.png", "rangearrow.png", "rendericon.png", "rendertab.png", "search.png",
    "expandicon.png", "targetinfoicon.png", "targetnpc1.png", "targetnpc2.png",
    "targetplayers1.png", "targetplayers2.png", "targetstab.png", "textguiicon.png",
    "textv4.png", "textvape.png", "utilityicon.png", "vape.png", "warning.png", "worldicon.png"
}

local function downloadAsset(fileName)
    local assetPath = 'newvape/assets/new/' .. fileName
    if not isfile(assetPath) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/zephhhhhhhh/NewVape2/main/assets/new/' .. fileName, true)
        end)
        if suc and res ~= '404: Not Found' then
            writefile(assetPath, res)
        end
    end
end

local function downloadAllAssets()
    local threads = {}
    
    for _, fileName in ipairs(fileNames) do
        table.insert(threads, coroutine.create(function()
            downloadAsset(fileName)
        end))
    end
    
    for _, thread in ipairs(threads) do
        coroutine.resume(thread)
    end
end

local function skies(path)
    local url = 'https://raw.githubusercontent.com/zephhhhhhhh/NewVape2/main/assets/Sky/' .. path
    local suc, res = pcall(function()
        return game:HttpGet(url, true)
    end)
    return suc and res or nil
end


-- experimental 
local function skies(path)
    local url = 'https://raw.githubusercontent.com/zephhhhhhhh/NewVape2/main/assets/Sky/' .. path
    local suc, res = pcall(function()
        return game:HttpGet(url, true)
    end)
    if suc and res then
        local success, json = pcall(function() return game:GetService('HttpService'):JSONDecode(res) end)
        if success and type(json) == "table" then
            return json
        end
    end
    return nil
end

local function downloadsky(name, path)
    local assetPath = 'newvape/assets/Sky/' .. path .. '/' .. name
    if not isfile(assetPath) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/zephhhhhhhh/NewVape2/main/assets/Sky/' .. path .. '/' .. name, true)
        end)
        if suc and res ~= '404: Not Found' then
            writefile(assetPath, res)
        end
    end
end

local function downloadsky(path)
    local skypngs = skies(path)
    if skypngs then
        for _, name in ipairs(skypngs) do
            downloadsky(name, path)
        end
        for _, subFolder in ipairs(skypngs) do
            if subFolder:match('/$') then
                downloadsky(path .. '/' .. subFolder)
            end
        end
    end
end

downloadsky('Sky')
downloadAllAssets()


return loadstring(downloadFile('newvape/main.lua'), 'main')()
