%% Traffic Signal Follower with RoadRunner Scenario
% This example shows how to design a traffic signal observer in Simulink(R)
% and cosimulate it with RoadRunner Scenario. It then shows how to design
% and cosimulate a traffic signal follower that adjusts the ego vehicle
% speed based on traffic signal data.
% 
% Copyright 2024 The MathWorks, Inc.
%% Introduction
% RoadRunner Scenario is an interactive editor that enables you to design
% scenarios for simulating and testing automated driving systems. You can
% place vehicles, define their paths and interactions in the scenario, and
% then simulate the scenario in the editor. RoadRunner Scenario supports
% in-editor playback for scenario visualization and connecting to other
% simulators, such as MATLAB(R) and Simulink, for cosimulation.
% 
% This example shows how to configure traffic signals in RoadRunner, read
% traffic signal data from RoadRunner Scenario using the MATLAB API, and
% cosimulate RoadRunner Scenario with Simulink to model the behavior of a
% traffic signal observer and a traffic signal follower. A traffic signal
% observer monitors the states of traffic signals, such as red, yellow, or
% green lights, without making any decisions or taking actions based on
% this data. Conversely, a traffic signal follower actively responds to
% these signals, adjusting its behavior accordingly, such as stopping at
% red lights or moving at green.
% 
% In this example, you:
%%
% 
% * *Set Up Environment* &mdash; Configure MATLAB to interact with
% RoadRunner Scenario.
% * *Explore Scene and Scenario* &mdash; Explore the scene and the scenario
% that define actions for the ego vehicle and other actors.
% * *Explore Traffic Signal Observer Model* &mdash; Explore the traffic
% signal observer model, which reads and visualizes traffic signal data.
% * *Simulate Traffic Signal Observer* &mdash; Simulate the traffic signal
% observer, and visualize the traffic signal data.
% * *Explore Traffic Signal Follower Model* &mdash; Explore the traffic
% signal follower model, which interprets traffic signal data and uses
% decision logic to regulate the ego vehicle speed.
% * *Simulate Traffic Signal Follower* &mdash; Simulate the traffic signal
% follower, visualize the traffic signal data, and observe how the ego
% vehicle reacts to the traffic signal follower.
%% Set Up Environment
% This section shows how to set up the RoadRunner environment to cosimulate
% with RoadRunner Scenario.
%
% Start the RoadRunner application interactively by using the
% <docid:driving_ref#mw_3d51e91a-60e4-4490-8989-29d5f7192567
% roadrunnerSetup> function. When the function opens a dialog box, specify
% the *RoadRunner Project Folder* and *RoadRunner Installation Folder*
% locations.
rrApp = roadrunnerSetup;
%%
% The |rrApp| RoadRunner object enables you to interact with RoadRunner
% from the MATLAB workspace. You can open the scenario and update scenario
% variables using this object. For more information on this object, see
% <docid:driving_ref#mw_73408e41-2ad0-473a-935f-553ab153b4cc roadrunner>.
%
% This example uses these files that you must add to the RoadRunner
% project.
%%
% * |FourWayJunctionWithSignal.rrscene| &mdash; Scene file that describes a
% four-way junction.
% * |scenario_01_TrafficSignalObserver.rrscenario| &mdash; RoadRunner
% Scenario file that describes actors and their trajectories in the
% |FourWayJunctionWithSignal| scene. The scenario contains an ego vehicle
% observing a traffic signal from a nearby location.
% * |scenario_02_TrafficSignalFollower.rrscenario| &mdash; RoadRunner
% scenario file that describes actors and their trajectories in the
% |FourWayJunctionWithSignal| scene. The scenario contains five target
% vehicles and one ego vehicle. The target vehicles obey the traffic
% signals by using the |Traffic Signal| condition in the RoadRunner
% Scenario Logic editor. A Simulink model controls the ego vehicle
% adjusting the speed of the vehicle based on the traffic signal state.
% * |TrafficSignalObserver.rrbehavior.rrmeta| &mdash; Behavior file that
% associates the traffic signal observer behavior, implemented using
% Simulink, to the ego vehicle in the RoadRunner scenario.
% * |TrafficSignalFollower.rrbehavior.rrmeta| &mdash; Behavior file that
% associates the traffic signal follower behavior, implemented using
% Simulink, to the ego vehicle in the RoadRunner scenario.
%
% Copy these files to the RoadRunner project.
copyfile("FourWayJunctionWithSignal.rrscene",fullfile(rrApp.status.Project.Filename,"Scenes/"));
copyfile("scenario_01_TrafficSignalObserver.rrscenario",fullfile(rrApp.status.Project.Filename,"Scenarios/"))
copyfile("scenario_02_TrafficSignalFollower.rrscenario",fullfile(rrApp.status.Project.Filename,"Scenarios/"))
copyfile("TrafficSignalFollower.rrbehavior.rrmeta",fullfile(rrApp.status.Project.Filename,"Assets","Behaviors/"))
copyfile("TrafficSignalObserver.rrbehavior.rrmeta",fullfile(rrApp.status.Project.Filename,"Assets","Behaviors/"))
%% Explore Scene and Scenario
% This section explains the scene and scenario. It also shows how to
% configure traffic signals in RoadRunner for cosimulation with Simulink.
%
% Open the scene.
openScene(rrApp,"FourWayJunctionWithSignal.rrscene");
%%
% 
% <<../RoadRunnerSignalTool.jpg>>
% 
%%
% The scene contains a four-way junction with traffic signals. In this
% scene the traffic signal at the junction has three phases: |Left-Turn|,
% |Straight|, and |Straight-UnprotectedLeftTurn|. Each of these phases has
% a |Go|, |Attention|, and |Stop| interval. The interval timing for the
% |Left-Turn| phase consists of an 8-second |Go| interval, a 2-second
% |Attention| interval, and a 1-second |Stop| interval. For the |Straight|
% and |Straight-UnprotectedLeftTurn| phases, the timing includes a
% 10-second |Go| interval, a 3-second |Attention| interval, and a 1-second
% |Stop| interval. You can configure the phase sequence and the timing of
% the phase intervals using the <docid:roadrunner_ref#Signal-Tool Signal
% Tool>. RoadRunner provides tools to design realistic junctions with
% traffic signals that are ready to use in simulation environments. To
% learn more about these tools, see
% <docid:roadrunner_doccenter#mw_93b94654-be7d-454d-aa2c-ef54824bbd52
% Junctions and Traffic Signals>.
%
% Open the |scenario_01_TrafficSignalObserver| scenario.
openScenario(rrApp,"scenario_01_TrafficSignalObserver");
%%
% 
% <<../RoadRunnerCreateSignalActor.jpg>>
% 
%%
% The scenario contains an ego vehicle located a few meters from the
% junction, following a designated path. The speed of the ego vehicle is
% set to |0.1 m/s|, enabling it to move toward the junction very slowly. As
% it moves, the ego vehicle also observes the traffic signals.
% 
% To simulate traffic signals in RoadRunner Scenario, you must convert
% traffic signal heads at the junction of the scene to traffic signal
% actors. For more information on how to convert traffic signal heads to
% traffic signal actors, see
% <docid:scenario_ref#mw_b41254d9-80fb-4230-a3cc-0502710cd70f Traffic
% Signal Tool>.
%
% Open the |scenario_02_TrafficSignalFollower| scenario.
openScenario(rrApp,"scenario_02_TrafficSignalFollower");
%%
% 
% <<../TrafficSignalFollowerScenario.jpg>>
% 
%%
% This scenario contains a blue ego vehicle and five target vehicles. Both
% the ego and target vehicles approach the signal at |8 m/s|. The target
% vehicles obey the traffic signal by using the |Traffic Signal| and
% |Distance To Actor| conditions. The behavior model attached to the ego
% vehicle enables it to follow the given path and adhere to the traffic
% signal.
%%
% Connect to the RoadRunner Scenario server for cosimulation by using the
% |createSimulation| function, and enable data logging.
rrSim = createSimulation(rrApp);
set(rrSim,Logging="on")
%%
% |rrSim| is a |ScenarioSimulation| object. Use this object to set
% variables and to read scenario-related information. Set the simulation to
% run at a step size of |0.1|.
Ts = 0.1;
set(rrSim,StepSize=Ts)
%% Explore Traffic Signal Observer Model
% This example uses the |TrafficSignalObserver| model to show how to read
% and visualize traffic signal data from RoadRunner Scenario. This model
% defines the actor behavior for the ego vehicle, enabling it to follow a
% custom path and observe traffic signal states.
%
% Open the model.
open_system("TrafficSignalObserver.slx")
%%
% The model contains RoadRunner Scenario, RoadRunner Scenario Reader, and
% RoadRunner Scenario Writer blocks, which configure, read from, and write
% to RoadRunner Scenario, as well as these blocks:
% 
% * |All Traffic Signal Spec| &mdash; MATLAB System block of a System
% object(TM) that reads traffic signal static information, such as signal
% position, bulb state, and turn configurations from the RoadRunner
% scenario by using the
% <docid:driving_ref#mw_e4f0260c-db79-403e-a604-361104e7f564 getAttribute>
% function of the
% <docid:driving_ref#mw_978b67f1-10f8-4fcd-938c-27083c124074
% ActorSimulation> object and packs the signal information into a bus,
% |BusTrafficSignalSpec|.
% * |All Traffic Signal Runtime| &mdash; MATLAB System block of a System
% object that reads the traffic signal runtime information, such as bulb
% state and time left from the RoadRunner scenario by using the
% <docid:driving_ref#mw_e4f0260c-db79-403e-a604-361104e7f564 getAttribute>
% function of the
% <docid:driving_ref#mw_978b67f1-10f8-4fcd-938c-27083c124074
% ActorSimulation> object and packs the signal information into a bus,
% |BusTrafficSignalRuntime|.
% * |Path Following| &mdash; This subsystem enables the ego vehicle to
% follow the path specified in the RoadRunner Scenario. It takes the ego
% pose and the path as input and writes back the updated ego pose to
% RoadRunner Scenario.
% * |Visualization| &mdash; This subsystem visualizes the traffic signal
% and vehicle runtime information.
% 
% In addition to the RoadRunner Scenario block, the model contains these
% RoadRunner Scenario Reader blocks and a RoadRunner Scenario Writer block:
% 
% * |Path Action| &mdash; RoadRunner Scenario Reader block that reads the
% path of the ego vehicle.
% * |Ego Vehicle Runtime| &mdash; RoadRunner Scenario Reader block that
% reads the runtime information of ego vehicle.
% * |All Vehicle Runtime| &mdash; RoadRunner Scenario Reader block that
% reads the runtime information of all the vehicles.
% * RoadRunner Scenario Writer &mdash; Writes the ego vehicle runtime
% information to RoadRunner Scenario.
%% Simulate Traffic Signal Observer
% This example uses the |helperSLTrafficSignalExampleSetup| helper function
% to load the scenario and initialize model parameters, such as vehicle
% specifications, actor IDs, and Simulink buses.
helperSLTrafficSignalExampleSetup(rrApp,rrSim,"scenarioFileName","scenario_01_TrafficSignalObserver")
%%
% Simulate the scenario, and visualize the traffic signal states and
% vehicle runtime information.

% set(rrSim,SimulationCommand="Start")
% while strcmp(get(rrSim,"SimulationStatus"),"Running")
%    pause(1)
% end

%%
% The visualization displays these plots and tables:
%
% * *Traffic Signal and Vehicle Plot* &mdash; Displays the positions of
% vehicles and the traffic signal states overlaid on a
% <docid:roadrunner_ref#mw_4c2c3892-0e15-47ed-8b55-9121de0f3f2d
% roadrunnerHDMap>. The plot displays traffic signal linked to the lane
% that contains the ego vehicle using a hexagon marker, and displays all
% the traffic signals using circular markers.
% * *All Traffic Signal Runtime* &mdash; Displays the actor ID, traffic
% signal state, time left for the current state, and the turn configuration
% for each traffic signal head.
% * *Traffic Phases and Intervals* &mdash; Displays the phases and
% intervals of the traffic signal controller associated with the ego
% vehicle.
% * *Ego Relevant Traffic Signal* &mdash; Displays the actor ID, current
% state, time left for the current state, and turn configuration for the
% traffic signal head linked to the lane that contains the ego vehicle.
% 
% During the simulation, the ego vehicle approaches the junction very
% slowly while observing the traffic signal as it changes states. The
% observer model does not have any decision logic that enables it to
% interact with the traffic signals. The visualization displays all runtime
% information related to the traffic signal. The traffic signal head with
% actor ID 6, displayed in the plot as a hexagon marker, indicates the
% current state of the traffic signal linked to the ego vehicle lane.
%% Explore Traffic Signal Follower Model
% This section introduces the traffic signal follower model, which shows
% how to use traffic signal data to apply decision logic that controls the
% speed of the ego vehicle, ensuring that it adheres to traffic signals.
% 
% Open the |TrafficSignalFollower| model.
open_system("TrafficSignalFollower.slx")
%% 
% The |TrafficSignalFollower| model shows how to use traffic signal
% information to design a traffic signal follower. In addition to the
% blocks used in the |TrafficSignalObserver| model, this model contain
% these blocks:
% 
% * |Ego Traffic Signal| &mdash; MATLAB System block of a System object
% that reads the traffic signal data relevant to the ego vehicle.
% * |Traffic Signal Follower| &mdash; MATLAB System block of a System
% object that processes the traffic signal information to adjust the speed
% of the ego vehicle by passing it to the |Path Following| block.
%% Simulate Traffic Signal Follower
% Initialize the |TrafficSignalFollower| model using the
% |helperSLTrafficSignalExampleSetup| function, and load the
% |scenario_02_TrafficSignalFollower| scenario.
helperSLTrafficSignalExampleSetup(rrApp,rrSim,"scenarioFileName","scenario_02_TrafficSignalFollower");
%%
% Simulate the scenario, and visualize the traffic signal states and
% vehicle runtime information.

set(rrSim,SimulationCommand="Start")

% while strcmp(get(rrSim,"SimulationStatus"),"Running")
%     pause(1)
% end

%%
% 
% <<../TrafficSignalFollowerScenarioSimulation.gif>>
% 
%%
% During the simulation, the ego vehicle follows the specified path at a
% set speed of |8 m/s|. The ego vehicle adjusts its speed based on the
% signal state read from the RoadRunner scenario. When the ego vehicle
% approaches the junction and the signal is red, the traffic signal
% follower reduces the speed of the ego vehicle, bringing it to a stop near
% the stop line. After the signal turns green, the traffic signal follower
% increases the speed of the ego vehicle, enabling it to cross the junction
% and continue following the specified path. All the target vehicles in the
% scenario |scenario_02_TrafficSignalFollower| follow the traffic signals
% according to the states of their respective signals.


%% Main Simulation Loop with HTTP Interface Integration
% (Assuming that signalSpec, signalRuntime, and allVehicleRuntime have 
% been updated by the simulation at each step.)

% Create an instance of the HelperAggregateTrafficSignalInfo System object.
aggTrafficSignalInfo = HelperAggregateTrafficSignalInfo();
setup(aggTrafficSignalInfo);  % Call setup if required

while strcmp(get(rrSim, "SimulationStatus"), "Running")
    pause(1);  % Simulate a time step

    %--------------------------------------------------------------------------
    % Step 1: Aggregate the current traffic signal info.
    %--------------------------------------------------------------------------
    % For example, the aggregated info is computed from the current signal
    % specifications, runtime, and vehicle runtime data.
    aggInfo = step(aggTrafficSignalInfo, signalSpec, signalRuntime, allVehicleRuntime);
    
    %--------------------------------------------------------------------------
    % Step 2: Send the aggregated info to the (mock) HTTP interface.
    %--------------------------------------------------------------------------
    updatedSignals = MockHTTPInterface(aggInfo);
    
    %--------------------------------------------------------------------------
    % Step 3: Update traffic signal runtime information with the new data.
    %--------------------------------------------------------------------------
    % Loop over each updated signal returned by the HTTP interface,
    % find the matching signal in signalRuntime, and update the corresponding
    % status and remaining time.
    for idx = 1:numel(updatedSignals)
        signalId = updatedSignals(idx).SignalID;
        % Find the matching signal in the runtime structure.
        sigIndex = find([signalRuntime.TrafficSignalRuntime.ActorID] == signalId, 1);
        if ~isempty(sigIndex)
            % Assume we update the latest turn configuration in the signal's runtime.
            numTurnConfig = signalRuntime.TrafficSignalRuntime(sigIndex).SignalConfiguration.NumTurnConfiguration;
            signalRuntime.TrafficSignalRuntime(sigIndex).SignalConfiguration.TurnConfiguration(numTurnConfig).ConfigurationType = updatedSignals(idx).Status;
            signalRuntime.TrafficSignalRuntime(sigIndex).SignalConfiguration.TurnConfiguration(numTurnConfig).TimeLeft = updatedSignals(idx).RemainingTime;
        end
    end
    
    % (Optional) Call visualization update routines or additional simulation logic.
    
end