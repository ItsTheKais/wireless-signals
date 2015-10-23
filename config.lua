require "defines"
-- no you fool don't touch this!


signal_refresh_rate = 4
-- each transmitter will update its broadcasted signals this many times per second
-- each reciever will listen for signals from nearby transmitters this many times per second
-- can be any whole number from 1 to 60
-- higher values will make signals propagate more quickly
-- higher values may cause performance issues, especially with large quantities of transmitters
-- handle with care!