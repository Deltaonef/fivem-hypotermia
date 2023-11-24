local isInWater = false
local timeInWater = 0
local hypothermiaThreshold = 240 -- 4 minutes in seconds
local warning1Time = 30
local warning2Time = 60
local damageInterval = 10 -- Damage every 10 seconds
local damageAmount = 5 -- Dama / Interval
local maxTimeInWater = 120 -- 2 minaa tajuttomuuteen 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 

        local playerPed = PlayerId()
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false)) 

        if IsEntityInWater(playerPed) then
            if not isInWater then
                isInWater = true
                TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Hyppäsit kylmään veteen!')
            end 

            timeInWater = timeInWater + 1 

            if timeInWater == hypothermiaThreshold then
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Alkaa tulla todella kylmä..', length = 6000, style = { ['background-color'] = '#007bff', ['color'] = '#ffffff' } })
            elseif timeInWater == (hypothermiaThreshold + warning1Time) then
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Alkaa voimat loppua', length = 6000, style = { ['background-color'] = '#ffc107', ['color'] = '#000000' } })
            elseif timeInWater == (hypothermiaThreshold + warning1Time + warning2Time) then
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Voi helvetti, nyt se hypotermia iski..', length = 6000, style = { ['background-color'] = '#ff0000', ['color'] = '#ffffff' } })
            end 

            if timeInWater % damageInterval == 0 then
                ApplyDamageToPed(playerPed, damageAmount, false)
            end 

            if timeInWater >= maxTimeInWater then
                TriggerEvent('chatMessage', 'SYSTEM', {55, 0, 200}, 'Taju läks! Tais tulla liian kylmä!')
                break
            end
        else
            if isInWater then
                isInWater = false
                timeInWater = 0
                TriggerEvent('chatMessage', 'SYSTEM', {0, 255, 0}, 'Lähdit vedestä, muista että sulla on märät vaatteet..')
            end
        end
    end
end)
