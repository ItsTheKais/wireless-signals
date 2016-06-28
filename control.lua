require "util"

local mod_version = "0.1.0"

local broadcast_signals = -- these are all the signals a receiver can use
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
    "signal-red",
    "signal-green",
    "signal-blue",
    "signal-yellow",
    "signal-pink",
    "signal-cyan",
    "signal-black",
    "signal-grey",
    "signal-white"
}

local wire_colors = 
{
    defines.wire_type.red,
    defines.wire_type.green
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

local function concatenateSignals(unsorted_signals)
-- combines duplicate signals in a passed table of signal tables
    local sorted_signals = broadcastTable() -- make an empty base table - we'll add the other tables to this
    for tk, transmitter_signals in pairs(unsorted_signals) do -- for each sub-table of signals
        for k, v in pairs(transmitter_signals.parameters) do -- for each signal in the sub-table
            for k1, v1 in pairs(sorted_signals.parameters) do -- check each valid signal type to see if it matches
                if v.signal.name == v1.signal.name then -- it matches, so add it to the base table
                    v1.count = v1.count + v.count
                end
            end
        end
    end
    return sorted_signals
end

local function findTransmittersInRange(receiver)
-- returns a list of transmitters that the receiver is in range of
    local in_range = {}
    for k, v in pairs(global.wireless_signals.transmitters) do
        if v.transmitter.valid and math.sqrt((receiver.position.x - v.transmitter.position.x)^2 + (receiver.position.y - v.transmitter.position.y)^2) <= v.range then -- range is circular, not square
            table.insert(in_range, v)
        end
    end
    return in_range
end

local function onInit()
    if not global.wireless_signals then
        global.wireless_signals = {transmitters = {}, receivers = {}} -- set the new save up with empty global lists
    end
end

local function onConfigChange(data)
    if data.mod_changes and data.mod_changes["wireless-signals"] then
        if not data.mod_changes["wireless-signals"].old_version then -- mod added to existing save
            global.wireless_signals = {transmitters = {}, receivers = {}} -- set up empty global lists
        end
    end
end

local function debugPrint(string)
    local p = game.players[1]
    p.print(string)
end

local function onTick(event)
    for k, v in pairs(global.wireless_signals.transmitters) do -- update transmitters
        if v.transmitter.valid then 
            if v.transmitter.energy > 0 then -- transmitters only work when powered
                v.signals = {parameters = {}} -- this will record all the signals from both wire colors
                for i = 1, #wire_colors do -- check both red and green wires
                    local c = v.transmitter.get_circuit_network(wire_colors[i]) -- read the circuit network
                    if c then
                        for j = 1, #v.broadcasting do -- only check the signals the transmitter is able to broadcast
                            local s = c.get_signal({type = "virtual", name=v.broadcasting[j]}) -- check that signal
                            if s > 0 then
                                table.insert(v.signals.parameters, -- the signal is being sent in, so add it to the global signal table
                                {
                                    count = s,
                                    signal = {type = "virtual", name = v.broadcasting[j]}
                                })
                            end
                        end
                    end
                end
            elseif v.position ~= nil then -- workaround for game incorrectly thinking devices are invalid on load
                rtest = game.surfaces["nauvis"].find_entity("ws-radio-transmitter-1", v.position)
                if rtest and rtest.valid then
                    v.transmitter = rtest
                    -- debugPrint("invalid transmitter 1 found")
                else -- must do this for both types of transmitters
                    rtest = game.surfaces["nauvis"].find_entity("ws-radio-transmitter-2", v.position)
                    if rtest and rtest.valid then
                        v.transmitter = rtest
                        -- debugPrint("invalid transmitter 2 found")
                    end
                end
            end
        end
     end
     for k, v in pairs(global.wireless_signals.receivers) do -- update receivers
        if v.receiver.valid then
            local unsorted_signals = {} 
            local nearby_transmitters = findTransmittersInRange(v.receiver) -- find which transmitters are in range
            for k1, v1 in pairs(nearby_transmitters) do -- get global signal tables from those transmitters
                if #v1.signals.parameters > 0 then -- that transmitter is broadcasting something
                    table.insert(unsorted_signals, v1.signals)
                end
            end
            if #unsorted_signals > 0 then
                local sorted_signals = concatenateSignals(unsorted_signals) -- merge any duplicates in the list of signals
                v.receiver.get_control_behavior().parameters = sorted_signals -- output the merged signals to circuit network
            else
                v.receiver.get_control_behavior().parameters = nil -- there are no incoming signals, so zero out the output
            end
         elseif v.position ~= nil then -- workaround for game sometimes losing track of devices on load
            rtest = game.surfaces["nauvis"].find_entity("ws-radio-receiver", v.position)
            if rtest and rtest.valid then
                v.receiver = rtest
                -- debugPrint("invalid reciever found")
            end
        end
    end
end

local function onPlaceEntity(event)
    local entity = event.created_entity
    if entity.name == "ws-radio-transmitter-1" then
        entity.operable = false -- disable the UI
        entity.get_or_create_control_behavior().connect_to_logistic_network = false -- keep it separate from the logistic network
        entity.get_control_behavior().circuit_condition = -- set the circuit condition to an almost-always true outcome, so that it will always consume power
        {
            condition = {
                comparator = ">",
                first_signal = {type = "virtual", name = "signal-everything"},
                constant = 0
            }
        }
        table.insert(global.wireless_signals.transmitters, -- add the transmitter to the global list
        {
            transmitter = entity,
            range = 600, -- how far the transmitter can broadcast
            broadcasting = -- the list of signals the transmitter can use
            { -- (only abstract signals allowed - no items or fluids)
                "signal-red",
                "signal-green",
                "signal-blue",
                "signal-yellow",
                "signal-pink",
                "signal-cyan",
                "signal-black",
                "signal-grey",
                "signal-white"
            },
            signals = {parameters = {}}, -- the actual signals, will be dynamically updated in OnTick
            position = entity.position -- part of workaround for game thinking devices are invalid on load, may become unnecessary in the future??
        })
    elseif entity.name == "ws-radio-transmitter-2" then
        entity.operable = false
        entity.get_or_create_control_behavior().connect_to_logistic_network = false
        entity.get_control_behavior().circuit_condition =
        {
            condition = {
                comparator = ">",
                first_signal = {type = "virtual", name = "signal-everything"},
                constant = 0
            }
        }
        table.insert(global.wireless_signals.transmitters, 
        {
            transmitter = entity,
            range = 1500,
            broadcasting = broadcast_signals,
            signals = {parameters = {}},
            position = entity.position
        })
    elseif entity.name == "ws-radio-receiver" then
        entity.operable = false
        table.insert(global.wireless_signals.receivers, -- add the receiver to the global list
        {
            receiver = entity,
            position = entity.position
        })
    end
end

local function onRemoveEntity(event) -- the removed device needs to be removed from the global list(s)
    local entity = event.entity
    if entity.name == "ws-radio-transmitter-1" or entity.name == "ws-radio-transmitter-2" then
        for i = 1, #global.wireless_signals.transmitters do
            if entity == global.wireless_signals.transmitters[i].transmitter then
                table.remove(global.wireless_signals.transmitters, i)
                return
            end
        end
    elseif entity.name == "ws-radio-receiver" then
        for i = 1, #global.wireless_signals.receivers do
            if entity == global.wireless_signals.receivers[i].receiver then
                table.remove(global.wireless_signals.receivers, i)
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