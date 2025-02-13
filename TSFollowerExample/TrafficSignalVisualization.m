classdef TrafficSignalVisualization < matlab.System
    % TrafficSignalVisualization Displays the traffic signal runtime and vehicle information. 
    %
    % NOTE: This is a helper file for example purposes and 
    % may be removed or modified in the future.

    % Copyright 2024 The MathWorks, Inc.

    % Public, non-tunable properties
    properties(Nontunable)
        % RoadRunner HD Map
        RRHDMap = roadrunnerHDMap;

        % Vehicle Spec
        VehicleSpec = struct;

        % Approaching Controller ID
        EgoControllerID = 17;

        % Approaching Signal ID
        EgoSignalID = 4;

        % Ego Actor ID
        EgoID = 1;

        % Sample Time
        Ts = 0.05;
    end

    properties(Logical)
        % Disable Visualization
        DisableVisualization = false;
    end

    % Pre-computed constants or internal states
    properties (Access = private)
        % Figure properties
        Figure
        SceneAxes

        % Plots 
        TrafficSignalPlot
        EgoTrafficSignalPlot
        AllActorPatch

        % UI Tables
        UITabPhaseInterval
        UITabTrafficSignalRuntime
        UITabTrafficSignalControllerRuntime
        UITabEgoSignal

        % Other properties
        NumVehicles
        VehicleIDs
        TrafficSignalControllerSpec
        ControllerActorIDs
        ControllerIdx
        EgoSignalPos
        Counter = 0;
        RedStyle
        YellowStyle
        GreenStyle
    end

    methods (Access = protected)
        function setupImpl(obj)

            % Create the figure if it doesn't exist already
            figureName = 'Traffic Signal Simulation';
            obj.Figure = findall(0,'Type','figure','tag',figureName);
            if isempty(obj.Figure)
                screenSize = double(get(groot,'ScreenSize'));
                obj.Figure = uifigure('Name',figureName,'Tag',figureName);
                obj.Figure.Position = [screenSize(3)*0.04 screenSize(4)*0.1 screenSize(3)*0.65 screenSize(4)*0.70];
                obj.Figure.NumberTitle = 'off';
                obj.Figure.MenuBar = 'none';
                obj.Figure.ToolBar = 'none';
            end
            
            % Clear figure
            clf(obj.Figure)
            
            % If disable visualization is true, hide the figure.
            if obj.DisableVisualization
                set(obj.Figure,"Visible","off");
            else
                set(obj.Figure,"Visible","on");
            end

            % Define UI panels
            scenePanel = uipanel(obj.Figure,'Units','Normalized','Position',[0 0 0.5 1],'Title','Traffic Signal and Vehicle Plot','ForegroundColor','black','FontWeight','bold');
            hTrafficSignalRuntimePanel = uipanel(obj.Figure,'Units','Normalized','Position',[0.5 0 0.5 0.5],'Title','All Traffic Signal Runtime','FontWeight','bold');
            hPhasePanel = uipanel(obj.Figure,'Units','Normalized','Position',[0.5 0.5 0.5 0.2],'Title','Traffic Phases and Intervals','FontWeight','bold');
            hEgoTrafficSignalPanel = uipanel(obj.Figure,'Units','Normalized','Position',[0.5 0.7 0.5 0.3],'Title','Ego Relevant Traffic Signal','FontWeight','bold');

            % Get scene panel axis
            obj.SceneAxes = axes('Parent',scenePanel);
            
            % Set the figure toolbar
            axtoolbar(obj.SceneAxes, {'datacursor','rotate','pan','zoomin','zoomout','restoreview'});

            % Plot the roadrunnerHDMap (Only the lane boundaries)
            hold(obj.SceneAxes,"on")
            arrayfun(@(lb) plot(lb.Geometry(:,1),lb.Geometry(:,2),"Parent",obj.SceneAxes,"Color",[0.5, 0.5, 0.5]),obj.RRHDMap.LaneBoundaries);
            set(obj.SceneAxes,'DataAspectRatio',[1 1 1]);
            grid(obj.SceneAxes,'on');
            xlabel(obj.SceneAxes,'X (m)');
            ylabel(obj.SceneAxes,'Y (m)');

            % UI Table for ego associated traffic signal runtime. 
            obj.UITabEgoSignal = uitable(hEgoTrafficSignalPanel,'Units','Normalized','FontName','Consolas','FontSize',17,'FontWeight','normal');
            obj.UITabEgoSignal.RowName = {'Controller ID','Signal ID','Bulb Color','Time Left (s)','Turn Type'};
            obj.UITabEgoSignal.ColumnName = {};
            obj.UITabEgoSignal.ColumnWidth = {'auto','auto','auto','auto','auto'};
            obj.UITabEgoSignal.ColumnFormat = {'char','char','char','char','char'};
            obj.UITabEgoSignal.Position = [0 0 1 1];

            % TrafficSignalRuntime UI Table
            obj.UITabTrafficSignalRuntime = uitable(hTrafficSignalRuntimePanel,'Units','Normalized','FontName','Consolas','FontSize',17,'FontWeight','normal');
            obj.UITabTrafficSignalRuntime.ColumnName = {'Signal ID','Bulb Color','Time Left (s)','Turn Type'};
            obj.UITabTrafficSignalRuntime.RowName = {}; 
            obj.UITabTrafficSignalRuntime.ColumnWidth = {'auto','auto','auto','auto'};
            obj.UITabTrafficSignalRuntime.ColumnFormat = {'char','char','char','char'};
            obj.UITabTrafficSignalRuntime.Position = [0 0 1 1];

            % Traffic Phases and Intervals UI Table
            obj.UITabPhaseInterval = uitable(hPhasePanel,'Units','Normalized','FontName','Consolas','FontSize',17,'FontWeight','normal');
            obj.UITabPhaseInterval.ColumnName = {'Phase Number','Phase Name','Green','Yellow','Red'};
            obj.UITabPhaseInterval.RowName = {}; 
            obj.UITabPhaseInterval.ColumnWidth = {'auto','auto','auto','auto','auto','auto'};
            obj.UITabPhaseInterval.ColumnFormat = {'char','char','char','char','char','char'};
            obj.UITabPhaseInterval.Position = [0 0 1 1];

            % Target and Ego vehicle plot 
            % Create vehicle patches
            obj.NumVehicles = numel(obj.VehicleSpec);
            obj.VehicleIDs = vertcat(obj.VehicleSpec.ID);
            for i=1:obj.NumVehicles
                % Plot the patch
                obj.AllActorPatch{i} = patch(obj.SceneAxes,'XData', [], 'YData',[]);
                obj.AllActorPatch{i}.FaceColor = obj.VehicleSpec(i).Color;
                obj.AllActorPatch{i}.EdgeColor = 'black'; 
                obj.AllActorPatch{i}.LineWidth = 0.5;
                obj.AllActorPatch{i}.FaceAlpha = 0.6;
            end

            obj.RedStyle = uistyle;
            obj.RedStyle.BackgroundColor = "red";
            obj.RedStyle.FontColor = "white";

            obj.YellowStyle = uistyle;
            obj.YellowStyle.BackgroundColor = "yellow";

            obj.GreenStyle = uistyle;
            obj.GreenStyle.BackgroundColor = "green";
        end

        function stepImpl(obj,signalRuntime,signalSpec,allVehicleRuntime)
            if ~obj.DisableVisualization
                % === New Functionality: Obtain Aggregate Traffic Signal Info and update signals ===
                % Create an instance of the helper that aggregates traffic signal information.
                aggHelper = HelperAggregateTrafficSignalInfo();
                % Use the helper to produce AggregateTrafficSignalInfo from the available inputs.
                aggInfo = step(aggHelper, signalSpec, signalRuntime, allVehicleRuntime, obj.RRHDMap);
                
                % Send aggInfo to the mock HTTP interface (which simulates a remote call)
                updatedSignals = MockHTTPInterface(aggInfo);
                
                % Use the returned signal status and remaining time to update each traffic signal.
                for i = 1:numel(signalRuntime.TrafficSignalRuntime)
                    % Find the updated info that corresponds to the current signal using its ActorID.
                    signalID = signalRuntime.TrafficSignalRuntime(i).ActorID;
                    idx = find([updatedSignals.SignalID] == signalID, 1);
                    if ~isempty(idx)
                        % Determine the current turn configuration (assumed to be the active one)
                        turnConfigIdx = signalRuntime.TrafficSignalRuntime(i).SignalConfiguration.NumTurnConfiguration;
                        % Reset the traffic signal status and remaining time based on the HTTP return.
                        signalRuntime.TrafficSignalRuntime(i).SignalConfiguration.TurnConfiguration(turnConfigIdx).ConfigurationType = ...
                            updatedSignals(idx).Status;
                        signalRuntime.TrafficSignalRuntime(i).SignalConfiguration.TurnConfiguration(turnConfigIdx).TimeLeft = ...
                            updatedSignals(idx).RemainingTime;
                    end
                end
                % === End of New Functionality ===
                
                % Initialize counter
                obj.Counter = obj.Counter + 1;
                
                % Plot the static information only once at the start.
                if obj.Counter <= 1 
                    % Initialize the traffic signal plot
                    numSigHeads = nnz([signalSpec.TrafficSignalSpec.ActorID]);
                    for i = 1:numSigHeads
                        actorID = signalSpec.TrafficSignalSpec(i).ActorID;
                        pos = signalSpec.TrafficSignalSpec(i).SignalPosition;
                        obj.TrafficSignalPlot{i} = line(obj.SceneAxes, 0, 0,'MarkerEdgeColor','black','MarkerFaceColor','red','Marker','o','MarkerSize', 11,'LineStyle','none','Tag',num2str(actorID));
                        obj.TrafficSignalPlot{i}.XData = pos(1);
                        obj.TrafficSignalPlot{i}.YData = pos(2);
                        text(obj.SceneAxes,pos(1),pos(2),num2str(actorID),'FontSize',9,'FontWeight','normal','HorizontalAlignment','center');
                    end

                    % Initialize the ego signal plot
                    egoIdx = [signalSpec.TrafficSignalSpec.ActorID] == obj.EgoSignalID;
                    egoSignalPos = signalSpec.TrafficSignalSpec(egoIdx).SignalPosition;
                    obj.EgoSignalPos = egoSignalPos;
                    obj.EgoTrafficSignalPlot = line(obj.SceneAxes, egoSignalPos(1), egoSignalPos(2),'MarkerEdgeColor','blue','MarkerFaceColor','none','Marker','hexagram','MarkerSize',16,'LineWidth',1,'LineStyle','none');

                    % Get ego controller position
                    cntlIdx = find([signalSpec.TrafficControllerSpec.ActorID]==obj.EgoControllerID);

                    % Update the phase interval
                    numPhases = signalSpec.TrafficControllerSpec(cntlIdx).NumTrafficSignalControllerPhases;
                    phaseInfo = cell(numPhases,4);
                    for i = 1:numPhases
                        phaseInfo{i,1} = i;                
                        phaseInfo{i,2} = char(signalSpec.TrafficControllerSpec(cntlIdx).TrafficSignalControllerPhases(i).PhaseName);
                        greenIdx = find([signalSpec.TrafficControllerSpec(cntlIdx).TrafficSignalControllerPhases(i).PhaseInterval.IntervalType] == EnumIntervalType.Green);
                        yellowIdx = find([signalSpec.TrafficControllerSpec(cntlIdx).TrafficSignalControllerPhases(i).PhaseInterval.IntervalType] == EnumIntervalType.Yellow);
                        redIdx = find([signalSpec.TrafficControllerSpec(cntlIdx).TrafficSignalControllerPhases(i).PhaseInterval.IntervalType] == EnumIntervalType.Red);
                        phaseInfo{i,3} = signalSpec.TrafficControllerSpec(cntlIdx).TrafficSignalControllerPhases(i).PhaseInterval(greenIdx).IntervalTime; 
                        phaseInfo{i,4} = signalSpec.TrafficControllerSpec(cntlIdx).TrafficSignalControllerPhases(i).PhaseInterval(yellowIdx).IntervalTime;
                        phaseInfo{i,5} = signalSpec.TrafficControllerSpec(cntlIdx).TrafficSignalControllerPhases(i).PhaseInterval(redIdx).IntervalTime;
                    end
                    obj.UITabPhaseInterval.Data = phaseInfo;
                end

                 % Update all signal head runtime information.
                 numSigHeads = nnz([signalRuntime.TrafficSignalRuntime.ActorID]);
                 signalTabInfo = cell(numSigHeads,1);
                 for i = 1:numSigHeads
                     signalActorID = signalRuntime.TrafficSignalRuntime(i).ActorID;
                     turnConfigIdx = signalRuntime.TrafficSignalRuntime(i).SignalConfiguration.NumTurnConfiguration;
                     bulbColorEnum = signalRuntime.TrafficSignalRuntime(i).SignalConfiguration.TurnConfiguration(turnConfigIdx-1).ConfigurationType;
                     if bulbColorEnum == EnumConfigurationType.Red || bulbColorEnum == EnumConfigurationType.Green || bulbColorEnum == EnumConfigurationType.Yellow
                         bulbColor = char(bulbColorEnum);
                     else
                         bulbColor = 'none';
                     end
                     % Update Traffic Signal Plot
                     hSignal = findobj(obj.SceneAxes,'Type','line','Tag',num2str(signalActorID));
                     if ~isempty(hSignal)
                        hSignal.MarkerFaceColor = bulbColor;
                        signalTabInfo{i,1} = signalActorID;
                        signalTabInfo{i,2} = bulbColor;
                        signalTabInfo{i,3} = signalRuntime.TrafficSignalRuntime(i).SignalConfiguration.TurnConfiguration(turnConfigIdx).TimeLeft;
                        signalTabInfo{i,4} = sprintf('%s, %s',char(signalRuntime.TrafficSignalRuntime(i).SignalConfiguration.TurnConfiguration(turnConfigIdx-1).TurnType),...
                                                              char(signalRuntime.TrafficSignalRuntime(i).SignalConfiguration.TurnConfiguration(turnConfigIdx).TurnType));
                     end
                 end
                 obj.UITabTrafficSignalRuntime.Data = signalTabInfo;

                 % Update ego signal head runtime information
                 egoRuntimeIdx = find([signalRuntime.TrafficSignalRuntime.ActorID] == obj.EgoSignalID);
                 egoBulbColor = char(signalRuntime.TrafficSignalRuntime(egoRuntimeIdx).SignalConfiguration.TurnConfiguration(turnConfigIdx-1).ConfigurationType);
                 egoSignalTabInfo = cell(1,1);
                 egoSignalTabInfo{1,1} = obj.EgoControllerID;
                 egoSignalTabInfo{2,1} = obj.EgoSignalID;
                 egoSignalTabInfo{3,1} = egoBulbColor; 
                 egoSignalTabInfo{4,1} = signalRuntime.TrafficSignalRuntime(egoRuntimeIdx).SignalConfiguration.TurnConfiguration(turnConfigIdx).TimeLeft;
                 egoSignalTabInfo{5,1} = sprintf('%s, %s',char(signalRuntime.TrafficSignalRuntime(egoRuntimeIdx).SignalConfiguration.TurnConfiguration(turnConfigIdx-1).TurnType),...
                                                          char(signalRuntime.TrafficSignalRuntime(egoRuntimeIdx).SignalConfiguration.TurnConfiguration(turnConfigIdx).TurnType));
                 obj.UITabEgoSignal.Data = egoSignalTabInfo;

                 removeStyle(obj.UITabEgoSignal);
                 switch lower(egoBulbColor)
                     case 'green'
                         addStyle(obj.UITabEgoSignal,obj.GreenStyle,"cell",[3,1]);
                     case 'yellow'
                         addStyle(obj.UITabEgoSignal,obj.YellowStyle,"cell",[3,1]);
                     case 'red'
                         addStyle(obj.UITabEgoSignal,obj.RedStyle,"cell",[3,1]);
                 end


                % Display vehicles
                egoPos = zeros(1,2);
                for i = 1:obj.NumVehicles
                    id   = allVehicleRuntime(i).ActorRuntime.ActorID;
                    pose = allVehicleRuntime(i).ActorRuntime.Pose;

                    if id==obj.EgoID
                        egoPos = [pose(1,4) pose(2,4)];
                    end

                    k = find(obj.VehicleIDs==id);

                    bbx = obj.VehicleSpec(k).BoundingBox;
                    v = [bbx.Min(1) bbx.Min(1) bbx.Max(1) bbx.Max(1) bbx.Min(1); ...
                        bbx.Min(2) bbx.Max(2) bbx.Max(2) bbx.Min(2) bbx.Min(2); ...
                        0 0 0 0 0; ...
                        1 1 1 1 1];
                    xydata = pose*v;

                    % Plot the patch
                    obj.AllActorPatch{k}.XData = xydata(1,1:4);
                    obj.AllActorPatch{k}.YData = xydata(2,1:4);
                end

                % Auto Zoom in/out depending on ego position
                adjustView(obj,egoPos);     
            end
        end

        function icon = getIconImpl(obj)
            % Define icon for System block
            icon = [mfilename("class")," "," "," "]; 
        end

        function sts = getSampleTimeImpl(obj)
            % Example: specify discrete sample time
            sts = obj.createSampleTime("Type", "Discrete","SampleTime", obj.Ts);
        end

       function interface = getInterfaceImpl(~)
            import matlab.system.interface.*;
            in1 = Input("in1");
            in2 = Input("in2");
            in3 = Input("in3", Message);
            interface = [in1, in2, in3];
        end
    end

    methods(Access=private)       
        function adjustView(obj,egoPos)
        % adjustView adjusts the scene limit based on the ego vehicle and
        % traffic constroller position.

            % Distance between ego position and traffic signal controller
            dist = norm(obj.EgoSignalPos(1:2)-egoPos); 

            % Determine the offset based on the distance
            if dist < 25
                offset = 30;
            elseif dist < 60
                offset = 70;
            else
                offset = 100;
            end

            % Set the limits based on the calculated offset
            obj.SceneAxes.XLim = [obj.EgoSignalPos(1)-offset, obj.EgoSignalPos(1)+offset];
            obj.SceneAxes.YLim = [obj.EgoSignalPos(2)-offset, obj.EgoSignalPos(2)+offset];
        end
    end

    methods (Access = protected, Static)
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog
            simMode = "Interpreted execution";
        end
    end
end
