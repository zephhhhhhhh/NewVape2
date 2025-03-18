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

local skyFolders = {"1", "2", "3"}
local skies = {"Sky_Back.png", "Sky_Bottom.png", "Sky_Front.png", "Sky_Left.png", "Sky_Right.png", "Sky_Top.png"}

local function downloadAsset(fileName, path)
    local assetPath = path .. fileName
    if not isfile(assetPath) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/zephhhhhhhh/NewVape2/main/' .. assetPath, true)
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
            downloadAsset(fileName, 'newvape/assets/new/')
        end))
    end
    
    for _, folder in ipairs(skyFolders) do
        for _, fileName in ipairs(skies) do
            table.insert(threads, coroutine.create(function()
                downloadAsset(fileName, 'newvape/assets/Sky/' .. folder .. '/')
            end))
        end
    end
    
    for _, thread in ipairs(threads) do
        coroutine.resume(thread)
    end
end

downloadAllAssets()

return loadstring(downloadFile('newvape/main.lua'), 'main')()
