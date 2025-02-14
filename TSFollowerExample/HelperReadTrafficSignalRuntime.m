classdef HelperReadTrafficSignalRuntime < matlab.System
    % HelperReadTrafficSignalRuntime Reads all the traffic signal runtime
    % information.
    %
    % NOTE: This is a helper file for example purposes and
    % may be removed or modified in the future.

    % Copyright 2024 The MathWorks, Inc.

    % Public, non-tunable properties
    properties(Nontunable)
        % Sample Time
        Ts = 0.02;
        % Output Struct
        OutputStruct = struct;
    end

    % Pre-computed constants or internal states
    properties (Access = private)
        % Variable to store all traffic controller actor simulation object.
        TrafficContollerActorSimulation

        % Variable to store all traffic signal actor simulation object.
        TrafficSignalActorSimulation

        % RoadRunner Simulation Object
        RRSimObj
    end

    methods (Access = protected)
        function setupImpl(obj)
            % Get the RoadRunner Scenario Simulation object 
            obj.RRSimObj = Simulink.ScenarioSimulation.find('ScenarioSimulation', 'SystemObject', obj);

            % Get all actor simulation object
            actorSim = obj.RRSimObj.get("ActorSimulation");

            % Get all actor type
            allActorType = cellfun(@(c) c.getAttribute("ActorType"),actorSim,'UniformOutput',false);

            % Filter traffic signal controllers
            trafficControllerIdx = cellfun(@(c) strcmp(char(c),'TrafficSignalController'),allActorType);

            % Get the ActorSImulation object for all traffic signal
            % controllers.
            obj.TrafficContollerActorSimulation = actorSim(trafficControllerIdx);

            % Filter traffic signal controllers
            trafficSignalIdx = cellfun(@(c) strcmp(char(c),'TrafficSignal'),allActorType);

            % Get the ActorSImulation object for all traffic signal
            % controllers.
            obj.TrafficSignalActorSimulation = actorSim(trafficSignalIdx);
        end

        function signalRuntime = stepImpl(obj)
            % Initialize output
            signalRuntime = obj.OutputStruct;

            %% Traffic Signal Controllers

            % Set the traffic controller runtime info
            for ctrlIdx = 1:numel(obj.TrafficContollerActorSimulation)
                % Set the traffic controller actorID
                signalRuntime.TrafficControllerRuntime(ctrlIdx).ActorID = double(obj.TrafficContollerActorSimulation{ctrlIdx}.getAttribute("ID"));

                % Get current controller runtime
                currControllerRuntime = obj.TrafficContollerActorSimulation{ctrlIdx}.getAttribute("TrafficSignalControllerRuntime");

                % Set controller ID
                signalRuntime.TrafficControllerRuntime(ctrlIdx).ControllerID = string(char(currControllerRuntime.ControllerID));

                % Set controller Status
                signalRuntime.TrafficControllerRuntime(ctrlIdx).ControllerStatus = currControllerRuntime.ControllerStatus;

                % Set signal phase
                currControllerRuntime.SignalPhase.PhaseName = string(char(currControllerRuntime.SignalPhase.PhaseName));
                signalRuntime.TrafficControllerRuntime(ctrlIdx).SignalPhase = currControllerRuntime.SignalPhase;

                % Set signal interval
                currControllerRuntime.SignalInterval.IntervalName = string(char(currControllerRuntime.SignalInterval.IntervalName));
                signalRuntime.TrafficControllerRuntime(ctrlIdx).SignalInterval = currControllerRuntime.SignalInterval;

                % Set phase time
                signalRuntime.TrafficControllerRuntime(ctrlIdx).PhaseTime = currControllerRuntime.PhaseTime;

                % Set cycle time
                signalRuntime.TrafficControllerRuntime(ctrlIdx).CycleTime = currControllerRuntime.CycleTime;
            end

            %% Traffic Signals
            % Set the traffic signal runtime info
            for signalIdx = 1:numel(obj.TrafficSignalActorSimulation)
                 % Set the traffic signal actorID
                signalRuntime.TrafficSignalRuntime(signalIdx).ActorID = double(obj.TrafficSignalActorSimulation{signalIdx}.getAttribute("ID"));

                % Get current controller runtime
                currSignalRuntime = obj.TrafficSignalActorSimulation{signalIdx}.getAttribute("TrafficSignalRuntime");

                % Set the signal head info
                currSignalRuntime.SignalHead.SignalID = string(char(currSignalRuntime.SignalHead.SignalID));
                currSignalRuntime.SignalHead.ControllerID = string(char(currSignalRuntime.SignalHead.ControllerID));
                signalRuntime.TrafficSignalRuntime(signalIdx).SignalHead = currSignalRuntime.SignalHead;

                % Set signal configurations
                % Set configuration Index
                signalRuntime.TrafficSignalRuntime(signalIdx).SignalConfiguration.ConfigurationIndex = currSignalRuntime.SignalConfiguration.ConfigurationIndex;
                for configIdx = 1:currSignalRuntime.SignalConfiguration.NumBulbConfiguration
                    currSignalRuntime.SignalConfiguration.BulbConfiguration(configIdx).BulbName = string(char(currSignalRuntime.SignalConfiguration.BulbConfiguration(configIdx).BulbName));
                end
                % Set bulb configuration
                signalRuntime.TrafficSignalRuntime(signalIdx).SignalConfiguration.NumBulbConfiguration = currSignalRuntime.SignalConfiguration.NumBulbConfiguration;
                signalRuntime.TrafficSignalRuntime(signalIdx).SignalConfiguration.BulbConfiguration(1:currSignalRuntime.SignalConfiguration.NumBulbConfiguration) = currSignalRuntime.SignalConfiguration.BulbConfiguration;

                % Set turn configuration
                signalRuntime.TrafficSignalRuntime(signalIdx).SignalConfiguration.NumTurnConfiguration = currSignalRuntime.SignalConfiguration.NumTurnConfiguration;
                signalRuntime.TrafficSignalRuntime(signalIdx).SignalConfiguration.TurnConfiguration(1:currSignalRuntime.SignalConfiguration.NumTurnConfiguration) = currSignalRuntime.SignalConfiguration.TurnConfiguration;
            end

            %% Update TimeLeft for each traffic signal
            % For each traffic signal, subtract the sample time from each turn configuration's TimeLeft
            for signalIdx = 1:numel(obj.TrafficSignalActorSimulation)
                numTurns = signalRuntime.TrafficSignalRuntime(signalIdx).SignalConfiguration.NumTurnConfiguration;
                for turnIdx = 1:numTurns
                    currentTimeLeft = signalRuntime.TrafficSignalRuntime(signalIdx).SignalConfiguration.TurnConfiguration(turnIdx).TimeLeft;
                    newTimeLeft = max(0, currentTimeLeft - obj.Ts);
                    signalRuntime.TrafficSignalRuntime(signalIdx).SignalConfiguration.TurnConfiguration(turnIdx).TimeLeft = newTimeLeft;
                end
            end
        end

        function icon = getIconImpl(obj)
            % Define icon for System block
            icon = [mfilename("class")," "," "," "];
        end

        function out = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];
        end

        function out = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "BusSignalRuntime";
        end

        function out = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
        end

        function out = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
        end

        function sts = getSampleTimeImpl(obj)
            % Example: specify discrete sample time
            sts = obj.createSampleTime("Type", "Discrete","SampleTime",obj.Ts);
        end
    end

    methods (Access = protected, Static)
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog
            simMode = "Interpreted execution";
        end
    end
end
