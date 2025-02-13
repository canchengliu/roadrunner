classdef HelperReadTrafficSignalSpec < matlab.System
    % HelperReadTrafficSignalSpec Reads all the traffic signal spec
    % information and packs it into a bus.
    %
    % NOTE: This is a helper file for example purposes and 
    % may be removed or modified in the future.

    % Copyright 2024 The MathWorks, Inc.

    % Public, non-tunable properties
    properties(Nontunable)
        % Sample Time
        Ts = 0.02;
        % Output Struct
        SignalSpec = struct;
    end

    properties(Access=private)
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

            %% Traffic Signal Controllers
            
            % Filter traffic signal controllers
            trafficSignalControllerIdx = cellfun(@(c) strcmp(char(c),'TrafficSignalController'),allActorType);
            
            % Get the ActorSImulation object for all traffic signal
            % controllers.
            trafficContollerActorSim = actorSim(trafficSignalControllerIdx);
            
            % Iterate through each traffic signal controller and set the
            % values in the output struct.
            for ctrlIdx = 1:numel(trafficContollerActorSim)
                % Set actor ID
                obj.SignalSpec.TrafficControllerSpec(ctrlIdx).ActorID = double(trafficContollerActorSim{ctrlIdx}.getAttribute("ID"));

                % Get the traffic signal controller spec
                currControllerSpec = trafficContollerActorSim{ctrlIdx}.get("ActorModel").getAttribute("TrafficSignalControllerSpec");

                % Set controller ID
                obj.SignalSpec.TrafficControllerSpec(ctrlIdx).ControllerID = string(char(currControllerSpec.ControllerID));

                % Set controller phases
                obj.SignalSpec.TrafficControllerSpec(ctrlIdx).NumTrafficSignalControllerPhases = currControllerSpec.NumTrafficSignalControllerPhases;
                for phaseIdx = 1:currControllerSpec.NumTrafficSignalControllerPhases
                    % Convert names to string
                    currControllerSpec.TrafficSignalControllerPhases(phaseIdx).PhaseName = string(char(currControllerSpec.TrafficSignalControllerPhases(phaseIdx).PhaseName));
                    for intervalIdx = 1:currControllerSpec.TrafficSignalControllerPhases(phaseIdx).NumPhaseInterval
                        currControllerSpec.TrafficSignalControllerPhases(phaseIdx).PhaseInterval(intervalIdx).IntervalName = string(char(currControllerSpec.TrafficSignalControllerPhases(phaseIdx).PhaseInterval(intervalIdx).IntervalName)); 
                    end
                    % Set the traffic controller phases
                    obj.SignalSpec.TrafficControllerSpec(ctrlIdx).TrafficSignalControllerPhases(phaseIdx) = currControllerSpec.TrafficSignalControllerPhases(phaseIdx);
                end
            end

            %% Traffic Signals

            % Filter traffic signal controllers
            trafficSignalIdx = cellfun(@(c) strcmp(char(c),'TrafficSignal'),allActorType);
            
            % Get the ActorSImulation object for all traffic signal
            % controllers.
            trafficSignalActorSim = actorSim(trafficSignalIdx);

            % Iterate through each traffic signal and set the values in the
            % output struct.
            for signalIdx = 1:numel(trafficSignalActorSim)
                % Get current signal spec
                currSignalSpec = trafficSignalActorSim{signalIdx}.get("ActorModel").getAttribute("TrafficSignalSpec");

                % Set actor ID
                obj.SignalSpec.TrafficSignalSpec(signalIdx).ActorID = double(trafficSignalActorSim{signalIdx}.getAttribute("ID"));

                % Set signal head
                currSignalSpec.SignalHead.SignalID = string(char(currSignalSpec.SignalHead.SignalID));
                currSignalSpec.SignalHead.ControllerID = string(char(currSignalSpec.SignalHead.ControllerID));
                obj.SignalSpec.TrafficSignalSpec(signalIdx).SignalHead = currSignalSpec.SignalHead;

                % Set signal position
                obj.SignalSpec.TrafficSignalSpec(signalIdx).SignalPosition = currSignalSpec.SignalPosition;

                % Set signal status
                obj.SignalSpec.TrafficSignalSpec(signalIdx).SignalStatus = currSignalSpec.SignalStatus;

                % Set phase state
                obj.SignalSpec.TrafficSignalSpec(signalIdx).NumSignalPhaseState = currSignalSpec.NumSignalPhaseState;
                for idx = 1:currSignalSpec.NumSignalPhaseState
                    obj.SignalSpec.TrafficSignalSpec(signalIdx).SignalPhaseState(idx) = currSignalSpec.SignalPhaseState(idx);
                end

                % Set turn types
                obj.SignalSpec.TrafficSignalSpec(signalIdx).NumSupportedTurnTypes = currSignalSpec.NumSupportedTurnTypes;
                supportedTurnTypes = vertcat(currSignalSpec.SupportedTurnTypes(:));
                obj.SignalSpec.TrafficSignalSpec(signalIdx).SupportedTurnTypes = [supportedTurnTypes;repmat(EnumTurnType.Unspecified,5-numel(supportedTurnTypes),1)];

                % Set bulb configuration
                obj.SignalSpec.TrafficSignalSpec(signalIdx).NumBulbConfigurations = currSignalSpec.NumBulbConfigurations;
                for idx = 1:currSignalSpec.NumBulbConfigurations
                    obj.SignalSpec.TrafficSignalSpec(signalIdx).BulbConfigurations(idx).ConfigurationNumber = currSignalSpec.BulbConfigurations(idx).ConfigurationNumber;
                    obj.SignalSpec.TrafficSignalSpec(signalIdx).BulbConfigurations(idx).NumBulbConfiguration = currSignalSpec.BulbConfigurations(idx).NumBulbConfiguration;
                    for configIdx = 1:currSignalSpec.BulbConfigurations(idx).NumBulbConfiguration
                        bulbConfig = currSignalSpec.BulbConfigurations(idx).BulbConfiguration(configIdx);
                        bulbConfig.BulbName = string(char(bulbConfig.BulbName));
                        obj.SignalSpec.TrafficSignalSpec(signalIdx).BulbConfigurations(idx).BulbConfiguration(configIdx) = bulbConfig;
                    end
                end

                % Set turn configuration
                obj.SignalSpec.TrafficSignalSpec(signalIdx).NumTurnConfigurations = currSignalSpec.NumTurnConfigurations;
                for idx = 1:currSignalSpec.NumTurnConfigurations
                    obj.SignalSpec.TrafficSignalSpec(signalIdx).TurnConfigurations(idx) = currSignalSpec.TurnConfigurations(idx);
                end
            end

        end

        function signalSpec = stepImpl(obj)
            signalSpec = obj.SignalSpec;
        end

        function icon = getIconImpl(obj)
            % Define icon for System block
            icon = [mfilename("class")," "," "," "]; 
        end

        function out = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function out = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "BusSignalSpec";
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
