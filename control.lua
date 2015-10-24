require "defines"
require "util"
require "config"

local mod_version = "0.0.2"

local refresh_rate = math.floor(60 / math.min(math.max(signal_refresh_rate, 1), 60))

local broadcast_signals =
{
    "signal-0",
    "signal-1",
    "signal-2",
    "signal-3",
    "signal-4",
    "signal-5",
    "signal-6",
    "signal-7",
    "signal-8",
    "signal-9",
    "signal-A",
    "signal-B",
    "signal-C",
    "signal-D",
    "signal-E",
    "signal-F",
    "signal-blue",
    "signal-green",
    "signal-yellow",
    "signal-red"
}

local function broadcastTable()
    -- returns a fresh table of signals
    local table = {parameters = {}}
    for i = 1, #broadcast_signals do
        table.parameters[i] =
        {
            index = i,
            count = 0,
            signal = {type = "virtual", name = broadcast_signals[i]}
        }
    end
    return table
end

local function deduceSignalValue(entity, signal, condNum)
-- courtesy of GopherATL
    local t=2^31
    local v=0
    condNum=condNum or 1
    local condition=entity.get_circuit_condition(condNum)
    condition.condition.first_signal.name=signal
    -- BEGIN MODIFICATION (check "_ = 0" first)
    condition.condition.first_signal.type="virtual"
    local c = condition.condition.count
    condition.condition.count = 0
    condition.condition.comparator="="
    entity.set_circuit_condition(condNum,condition)
    if entity.get_circuit_condition(condNum).fulfilled==true then
        return 0
    end
    condition.condition.count = c
    -- END MODIFICATION
    condition.condition.comparator="<"
    while t~=1 do
        condition.condition.constant=v
        entity.set_circuit_condition(condNum,condition)
        t=t/2
        if entity.get_circuit_condition(condNum).fulfilled==true then
            v=v-t
        else
            v=v+t
        end
    end
    condition.condition.constant=v
    entity.set_circuit_condition(condNum,condition)
    if entity.get_circuit_condition(condNum).fulfilled then
        v=v-1
    end
    entity.set_circuit_condition(condNum, {condition={operator = ">", count = 0, first_signal={type = "virtual", name="signal-everything"}}}) -- MODIFICATION (reset the entity to an almost-always-true state)
    return v
end

local function concatenateSignals(unsorted_signals)
-- combines duplicate signals in a passed table of signal tables
    local sorted_signals = broadcastTable()
    for tk, transmitter_signals in pairs(unsorted_signals) do
        for k, v in pairs(transmitter_signals.parameters) do
            for k1, v1 in pairs(sorted_signals.parameters) do
                if v.signal.name == v1.signal.name then
                    v1.count = v1.count + v.count
                end
            end
        end
    end
    return sorted_signals
end

local function findTransmittersInRange(reciever)
-- returns a list of transmitters that the reciever is in range of
    local in_range = {}
    for k, v in pairs(global.wireless_signals.transmitters) do
        if v.transmitter.valid and math.sqrt((reciever.position.x - v.transmitter.position.x)^2 + (reciever.position.y - v.transmitter.position.y)^2) <= v.range then
            table.insert(in_range, v)
        end
    end
    return in_range
end

local function onInit()
    if not global.wireless_signals then
        global.wireless_signals = {transmitters = {}, recievers = {}}
    end
end

local function onConfigChange(data)
    if data.mod_changes and data.mod_changes["wireless-signals"] then
        if not data.mod_changes["wireless-signals"].old_version then -- mod added to existing save
            global.wireless_signals = {transmitters = {}, recievers = {}}
        end
    end
end

local function onTick(event)
    if event.tick % refresh_rate == 0 then
        for k, v in pairs(global.wireless_signals.transmitters) do
            if v.transmitter.valid then 
                if v.transmitter.energy > 0 then
                    v.signals = {parameters = {}} -- update the signals being broadcast
                    local wire_connected, x = pcall(v.transmitter.get_circuit_condition, 1) -- DEVS PLS
                    if wire_connected then
                        for i = 1, #v.broadcasting do -- only check the signals the transmitter is able to broadcast
                            local s = deduceSignalValue(v.transmitter, v.broadcasting[i], 1)
                            if s > 0 then
                                table.insert(v.signals.parameters, 
                                {
                                    count = s,
                                    signal = {type = "virtual", name = v.broadcasting[i]},
                                })
                            end
                        end
                    end
                elseif v.position ~= nil then -- workaround for game incorrectly thinking devices are invalid on load
                    rtest = game.surfaces["nauvis"].find_entity("ws-radio-transmitter", v.position)
                    if rtest and rtest.valid then
                        v.transmitter = rtest
                    else
                        rtest = game.surfaces["nauvis"].find_entity("ws-radio-transmitter", v.position)
                        if rtest and rtest.valid then
                            v.transmitter = rtest
                        end
                    end
                end
            end
        end
        for k, v in pairs(global.wireless_signals.recievers) do
            if v.reciever.valid then
                local unsorted_signals = {}
                local nearby_transmitters = findTransmittersInRange(v.reciever)
                for k1, v1 in pairs(nearby_transmitters) do -- get signal tables from nearby transmitters
                    if #v1.signals.parameters > 0 then
                        table.insert(unsorted_signals, v1.signals)
                    end
                end
                if #unsorted_signals > 0 then
                    local sorted_signals = concatenateSignals(unsorted_signals) -- merge any duplicates in the list of signals
                    v.reciever.set_circuit_condition(1, sorted_signals)
                else
                    v.reciever.set_circuit_condition(1, broadcastTable())
                end
            elseif v.position ~= nil then -- workaround for game thinking all recievers are invalid on load
                rtest = game.surfaces["nauvis"].find_entity("ws-radio-reciever", v.position)
                if rtest and rtest.valid then
                    v.reciever = rtest
                end
            end
        end
    end
end

local function onPlaceEntity(event)
    local entity = event.created_entity
    if entity.name == "ws-radio-transmitter-1" then
        entity.operable = false -- disable the UI
        table.insert(global.wireless_signals.transmitters, 
        {
            transmitter = entity,
            range = 600, -- how far the transmitter can broadcast
            broadcasting = -- the list of signals the transmitter can use
            { -- (only abstract signals allowed - no items)
                "signal-blue",
                "signal-green",
                "signal-yellow",
                "signal-red"
            },
            signals = {parameters = {}}, -- the actual signals, will be dynamically updated in OnTick
            position = entity.position -- part of workaround for game thinking devices are invalid on load, may become unnecessary in the future??
        })
    elseif entity.name == "ws-radio-transmitter-2" then
        entity.operable = false
        table.insert(global.wireless_signals.transmitters, 
        {
            transmitter = entity,
            range = 1500,
            broadcasting = broadcast_signals,
            signals = {parameters = {}},
            position = entity.position
        })
    elseif entity.name == "ws-radio-reciever" then
        entity.operable = false
        table.insert(global.wireless_signals.recievers,
        {
            reciever = entity,
            position = entity.position
        })
    end
end

local function onRemoveEntity(event)
    local entity = event.entity
    if entity.name == "ws-radio-transmitter-1" or entity.name == "ws-radio-transmitter-2" then
        for i = 1, #global.wireless_signals.transmitters do
            if entity == global.wireless_signals.transmitters[i].transmitter then
                table.remove(global.wireless_signals.transmitters, i)
                return
            end
        end
    elseif entity.name == "ws-radio-reciever" then
        for i = 1, #global.wireless_signals.recievers do
            if entity == global.wireless_signals.recievers[i].reciever then
                table.remove(global.wireless_signals.recievers, i)
                return
            end
        end
    end
end

script.on_init(onInit)

script.on_configuration_changed(onConfigChange)

script.on_event(defines.events.on_built_entity, onPlaceEntity)
script.on_event(defines.events.on_robot_built_entity, onPlaceEntity)

script.on_event(defines.events.on_preplayer_mined_item, onRemoveEntity)
script.on_event(defines.events.on_robot_pre_mined, onRemoveEntity)
script.on_event(defines.events.on_entity_died, onRemoveEntity)

script.on_event(defines.events.on_tick, onTick)