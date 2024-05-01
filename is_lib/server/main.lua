Lib = {}

exports('GetLibObject', function()
    while not Core do
        Wait(5)
    end

    return Lib
end)

Lib.checkVersion = function()
    local resource = GetInvokingResource() or GetCurrentResourceName()

	local currentVersion = GetResourceMetadata(resource, 'version')

	PerformHttpRequest("https://api.github.com/repos/inside-scripts/is_lib/releases/latest", function(status, response)
            if status ~= 200 then return end

            local data = json.decode(response)

            if currentVersion ~= data.tag_name then
                print("^2[UPDATE] ^7An update for ^2is_lib ^7is available. Download the latest version from ^2GitHub^7: ^5https://github.com/inside-scripts/is_lib/releases/tag/"..data.tag_name)
            else
                print("^2[INFORMATION] ^7Resource ^2is_lib ("..currentVersion..") ^7has been started successfully.")
                print("^7Store: ^5https://inside-scripts.tebex.io")
                print("^7Documentation: ^5https://inside-scripts.gitbook.io/documentation")
                print("^7Discord: ^5https://discord.gg/URKNMSwx5W")
            end
	end, 'GET')

end

Lib.checkVersion()
