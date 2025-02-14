classdef HelperAggregateTrafficSignalInfo < matlab.System
    % HelperAggregateTrafficSignalInfo Aggregates traffic signal info and
    % controlled vehicle speeds.
    %
    % This System object aggregates all configuration and status information
    % for each traffic signal (from signalSpec and signalRuntime) and also
    % computes the speeds for vehicles that are "assigned" to a given signal.
    %
    % The vehicles are assigned to a traffic signal by comparing the planar 
    % (x-y) distance between the signal's position (from signalSpec) and the
    % vehicle position (extracted from each vehicle's ActorRuntime.Pose). The 
    % vehicle for which the distance is minimum (when compared against all signals)
    % is assumed to be controlled by that signal.
    
    methods (Access = protected)        
        function aggInfo = stepImpl(obj, signalSpec, signalRuntime, allVehicleRuntime)
            % Number of traffic signals in the scenario (assumed to be stored in 
            % signalSpec.TrafficSignalSpec).
            numSignals = numel(signalSpec.TrafficSignalSpec);
            
            % Preallocate structure array for aggregated info with fields:
            % SignalID, Configuration, Status, RemainingTime, ControlledVehicleSpeeds, 
            % BulbColor, CurrentTurnType, and NextTurnType.
            aggInfo = repmat(struct('SignalID', [], ...
                                    'Status', [], ...
                                    'RemainingTime', [], ...
                                    'ControlledVehicleSpeeds', [], ...
                                    'BulbColor', [], ...
                                    'CurrentTurnType', [], ...
                                    'NextTurnType', []), ...
                            numSignals, 1);
            
            % For each traffic signal, store its configuration (static specification)
            % and obtain its current status and remaining time from signalRuntime.
            % Also extract the signal position for later distance calculations.
            signalPositions = zeros(numSignals, 2); % x-y positions for each signal
            for s = 1:numSignals
                % Assume signalSpec.TrafficSignalSpec contains an ActorID and SignalPosition.
                signalID = signalSpec.TrafficSignalSpec(s).ActorID;
                signalPositions(s, :) = signalSpec.TrafficSignalSpec(s).SignalPosition(1:2);
                
                % Find the corresponding runtime entry using the signal ActorID.
                runtimeIdx = find([signalRuntime.TrafficSignalRuntime.ActorID] == signalID, 1);
                if ~isempty(runtimeIdx)
                    % Assume that the last turn configuration is the active one.
                    numTurnConfig = signalRuntime.TrafficSignalRuntime(runtimeIdx).SignalConfiguration.NumTurnConfiguration;
                    currentTurnConfig = signalRuntime.TrafficSignalRuntime(runtimeIdx).SignalConfiguration.TurnConfiguration(numTurnConfig);
                    currentStatus = currentTurnConfig.ConfigurationType;
                    remainingTime = currentTurnConfig.TimeLeft;
                    
                    % Extract bulb color and turn types
                    bulbColorEnum = signalRuntime.TrafficSignalRuntime(runtimeIdx).SignalConfiguration.TurnConfiguration(numTurnConfig-1).ConfigurationType;
                    if bulbColorEnum == EnumConfigurationType.Red || bulbColorEnum == EnumConfigurationType.Green || bulbColorEnum == EnumConfigurationType.Yellow
                        bulbColor = char(bulbColorEnum);
                    else
                        bulbColor = 'none';
                    end
                    
                    % Current and next turn types
                    currentTurnType = char(signalRuntime.TrafficSignalRuntime(runtimeIdx).SignalConfiguration.TurnConfiguration(numTurnConfig-1).TurnType);
                    nextTurnType = char(signalRuntime.TrafficSignalRuntime(runtimeIdx).SignalConfiguration.TurnConfiguration(numTurnConfig).TurnType);
                else
                    currentStatus = '';
                    remainingTime = 0;
                    bulbColor = 'none';
                    currentTurnType = '';
                    nextTurnType = '';
                end
                
                % Store signal data in the aggInfo structure
                aggInfo(s).SignalID = signalID;
                % aggInfo(s).Configuration = signalSpec.TrafficSignalSpec(s);
                aggInfo(s).Status = currentStatus;
                aggInfo(s).RemainingTime = remainingTime;
                aggInfo(s).BulbColor = bulbColor;
                aggInfo(s).CurrentTurnType = currentTurnType;
                aggInfo(s).NextTurnType = nextTurnType;
                aggInfo(s).ControlledVehicleSpeeds = []; % initialize with empty array
            end
            
            % Process all vehicle runtime information.
            numVehicles = numel(allVehicleRuntime);
            vehiclePositions = zeros(numVehicles,2);
            vehicleSpeeds = zeros(numVehicles,1);
            for v = 1:numVehicles
                % Extract vehicle position from the 4x4 pose matrix (x and y coordinates)
                vPose = allVehicleRuntime(v).ActorRuntime.Pose;
                vehiclePositions(v, :) = vPose(1:2, 4)';
                
                % Compute vehicle speed from the velocity vector.
                % (Assuming that ActorRuntime.Velocity is a vector.)
                vVelocity = allVehicleRuntime(v).ActorRuntime.Velocity;
                vehicleSpeeds(v) = norm(vVelocity);
            end
            
            % Two nested loops: For each vehicle, compute the distance from its position
            % to each traffic signal and then assign the vehicle to the signal with the
            % minimum distance.
            for v = 1:numVehicles
                minDistance = Inf;
                assignedSignal = 0;
                for s = 1:numSignals
                    distance = norm(vehiclePositions(v,:) - signalPositions(s,:));
                    if distance < minDistance
                        minDistance = distance;
                        assignedSignal = s;
                    end
                end
                % Append the current vehicle's speed to the ControlledVehicleSpeeds field of the assigned traffic signal.
                aggInfo(assignedSignal).ControlledVehicleSpeeds(end+1) = vehicleSpeeds(v);
            end
        end
        
        function icon = getIconImpl(obj)
            % Define icon for the System block.
            icon = 'AggregateTrafficSignalInfo';
        end
        
        function sts = getSampleTimeImpl(obj)
            % Specify a discrete sample time.
            sts = obj.createSampleTime("Type", "Discrete", "SampleTime", 0.05);
        end
        
    end
    
    methods (Access = protected, Static)
        function simMode = getSimulateUsingImpl
            % Allow only interpreted execution.
            simMode = "Interpreted execution";
        end
    end
end
