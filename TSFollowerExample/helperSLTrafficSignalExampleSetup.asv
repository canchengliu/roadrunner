function helperSLTrafficSignalExampleSetup(rrAppObj,rrSimObj, nvp)
%helperSLTrafficSignalExampleSetup creates required variables and buses
% for simulating a traffic Signal application in RoadRunner Scenario.
%
% This helper function initializes the TrafficSignalObserver and
% TrafficSignalFollower models by creating necessary data in base workspace.
% It also loads the model and sets up the buses required.
%
% Optional inputs
%   scenarioFcnName:
%     - Name of the scenario which is compatible with this example
%     - Valid values are:
%           "scenario_01_TrafficSignalObserver"
%           "scenario_02_TrafficSignalFollower"
%
% Examples of calling this function:
%
%    helperSLTrafficSignalExampleSetup(rrAppObj, rrSimObj,scenarioFcnName= "scenario_02_TrafficSignalFollower")
%
%
%   This is a helper function for example purposes and may be removed or
%   modified in the future.

% Copyright 2024 The MathWorks, Inc.
arguments
rrAppObj = [];
rrSimObj =[];
nvp.scenarioFileName {mustBeMember(nvp.scenarioFileName,["scenario_01_TrafficSignalObserver", ...
                                                         "scenario_02_TrafficSignalFollower"])} = "scenario_01_TrafficSignalObserver";
end

if ~isempty(rrSimObj)
    % Open Scenario
    openScenario(rrAppObj, strjoin([nvp.scenarioFileName, '.rrscenario'],""));

    % Load model
    if nvp.scenarioFileName == "scenario_01_TrafficSignalObserver"
        modelName = "TrafficSignalObserver";
    else
        modelName = "TrafficSignalFollower";
    end
    
    wasModelLoaded = bdIsLoaded(modelName);
    if ~wasModelLoaded
        load_system(modelName)
    end

    % Get the vehicle color and dimension for visualization
    world = rrSimObj.getScenario();
    vehicleSpec = getVehicleSpec(world.actor_spec.world_spec);
    assignin("base","vehicleSpec",vehicleSpec);

    % Get RoadRunner HD Map
    rrHDMap = rrSimObj.get("Map");
    assignin("base","rrHDMap",rrHDMap);
end

% Initialize the ID for Traffic Signal Controller, Traffic Signal Head and
% Ego Actor.
egoActorID = 1;
signalID = 6;
if nvp.scenarioFileName == "scenario_01_TrafficSignalObserver"
    controllerID = 12;
else
    controllerID = 17;
end
assignin("base","egoActorID",egoActorID)
assignin("base","controllerID",controllerID)
assignin("base","signalID",signalID)
    

% Load bus objects
helperSLCreateTrafficSignalBusObjects()


end


function vehicleSpec = getVehicleSpec(world)
%getVehicleSpec Extracts vehicle specifications from the world actors.
%   This function iterates through the actors in the given world structure,
%   extracts their specifications, and organizes them into a structure.

% Extract actors from the world structure
actors = world.actors;
numActors = length(actors);

% Define a template for the vehicle specification structure
bbxTemplate = struct('Min', zeros(1, 3), 'Max', zeros(1, 3));
vehicleSpecTemplate = struct('ID', 0, 'Name', '', 'Length', 0, 'Width', 0, 'Height', 0, 'Color', zeros(1, 3), 'BoundingBox', bbxTemplate);

% Preallocate the VehicleSpec array with default values for efficiency
vehicleSpec = repmat(vehicleSpecTemplate, 1, numActors);
k = 0; % Counter for vehicles with specifications

% Iterate through each actor to extract vehicle specifications
for i = 1:numActors
    currVehicleSpec = actors(i).actor_spec.vehicle_spec;

    % Process only actors with non-empty vehicle specifications
    if ~isempty(currVehicleSpec)
        k = k + 1; % Increment the counter
        id = str2double(actors(i).actor_spec.id);
        color = currVehicleSpec.paint_color;
        r = double(color.r) / 255;
        g = double(color.g) / 255;
        b = double(color.b) / 255;
        min = actors(i).actor_spec.bounding_box.min;
        max = actors(i).actor_spec.bounding_box.max;

        % Update the structure with the extracted specifications
        vehicleSpec(k).ID = id;
        vehicleSpec(k).Name = actors(i).actor_spec.name;
        vehicleSpec(k).Length = max.y - min.y;
        vehicleSpec(k).Width = max.x - min.x;
        vehicleSpec(k).Height = max.z;
        vehicleSpec(k).Color = [r, g, b];
        vehicleSpec(k).BoundingBox.Min = [min.x, min.y, min.z];
        vehicleSpec(k).BoundingBox.Max = [max.x, max.y, max.z];
    end
end

% Remove unused preallocated elements if any
if k < numActors
    vehicleSpec(k+1:end) = [];
end

end
