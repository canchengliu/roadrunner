% Clean up script for the Traffic Signal Follower Example
%
% This script cleans up the base workspace variables created by the example
% model. It is triggered by the CloseFcn callback of
% TrafficSignalObserver.slx and TrafficSignalFollower.slx model.
%
% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2024 The MathWorks, Inc.


clearBuses({'BusActorRuntime', ...
            'BusVehicleRuntime', ...
            'BusTurnState', ...
            'BusTurnConfigurations', ...
            'BusTrafficSignalControllerPhases', ...
            'BusTrafficControllerSpec', ...
            'BusTrafficControllerRuntime', ...
            'BusSignalSpec', ...
            'BusSignalRuntime', ...
            'BusSignalPhaseState', ...
            'BusSignalPhase', ...
            'BusSignalInterval', ...
            'BusSignalHead', ...
            'BusRuntimeTurnConfiguration', ...
            'BusPhaseTime', ...
            'BusPhaseInterval', ...
            'BusCycleTime', ...
            'BusBulbConfigurations', ...
            'BusBulbConfiguration', ...
            'BusSignalConfiguration'});

clear controllerID egoActorID signalID Ts vehicleSpec


function clearBuses(buses)
    matlabshared.tracking.internal.DynamicBusUtilities.removeDefinition(buses);
end