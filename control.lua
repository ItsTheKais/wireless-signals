require "defines"
require "config"

local transmitters = {}
local recievers = {}

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
    "signal-red",
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
    -- BEGIN MODIFICATION (check "_ = 0" first)
    local c = condition.condition.count
    condition.condition.count = 0
    condition.condition.comparator="="
    entity.set_circuit_condition(condNum,condition)
    if entity.get_circuit_condition(condNum).fulfilled==true then
        return 0
    end
    condition.condition.count = c
    -- END MODIFICATION
    condition.condition.first_signal.name=signal
    condition.condition.first_signal.type="virtual" -- MODIFICATION (I don't know why I need this, but I do?)
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

local function concantenateSignals(unsorted_signals)
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
    for k, v in pairs(transmitters) do
        if v.transmitter.valid and math.sqrt((reciever.position.x - v.transmitter.position.x)^2 + (reciever.position.y - v.transmitter.position.y)^2) <= v.range then
            in_range[#in_range + 1] = v
        end
    end
    return in_range
end

local function onTick(event)
    if event.tick % refresh_rate == 0 then
        for k, v in pairs(transmitters) do
            if v.transmitter.valid and v.transmitter.energy > 0 then
                v.signals = {parameters = {}} -- update the signals being broadcast
                local wire_connected, x = pcall(v.transmitter.get_circuit_condition, 1) -- DEVS PLS
                if wire_connected then
                    for i = 1, #v.broadcasting do -- only check the signals the transmitter is able to broadcast
                        local s = deduceSignalValue(v.transmitter, v.broadcasting[i], 1)
                        if s > 0 then
                            v.signals.parameters[#v.signals.parameters + 1] =
                            {
                                count = s,
                                signal = {type = "virtual", name = v.broadcasting[i]},
                            }
                        end
                    end
                end
            end
        end
        for k, v in pairs(recievers) do
            if v.reciever.valid then
                local unsorted_signals = {}
                local nearby_transmitters = findTransmittersInRange(v.reciever)
                for k1, v1 in pairs(nearby_transmitters) do -- get signal tables from nearby transmitters
                    if #v1.signals.parameters > 0 then
                        unsorted_signals[#unsorted_signals + 1] = v1.signals
                    end
                end
                if #unsorted_signals > 0 then
                    local sorted_signals = concantenateSignals(unsorted_signals) -- merge any duplicates in the list of signals
                    v.reciever.set_circuit_condition(1, sorted_signals)
                else
                    v.reciever.set_circuit_condition(1, broadcastTable())
                end
            end
        end
    end
end

local function onPlaceEntity(event)
    local entity = event.created_entity
    if entity.name == "ws-radio-transmitter-1" then
        entity.operable = false -- disable the UI
        transmitters[#transmitters + 1] =
        {
            transmitter = entity,
            range = 600, -- how far the transmitter can broadcast
            broadcasting = -- the list of signals the transmitter can use
            { -- (only abstract signals allowed - no items)
                "signal-blue",
                "signal-green",
                "signal-yellow",
                "signal-red",
            },
            signals = {parameters = {}} -- the actual signals, will be dynamically updated in OnTick
        }
    elseif entity.name == "ws-radio-transmitter-2" then
        entity.operable = false
        transmitters[#transmitters + 1] =
        {
            transmitter = entity,
            range = 1500,
            broadcasting = broadcast_signals,
            signals = {parameters = {}}
        }
    elseif entity.name == "ws-radio-reciever" then
        entity.operable = false
        recievers[#recievers + 1] =
        {
            reciever = entity,
        }
    end
end


script.on_event(defines.events.on_built_entity, onPlaceEntity)
script.on_event(defines.events.on_robot_built_entity, onPlaceEntity)

script.on_event(defines.events.on_tick, onTick)