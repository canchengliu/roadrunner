function helperSLCreateTrafficSignalBusObjects() 
% helperSLCreateTrafficSignalBusObjects()  initializes the necessary bus
% objects foe this example in the MATLAB base workspace.

% NOTE: This is a helper file for example purposes and 
% may be removed or modified in the future.

% Copyright 2024 The MathWorks, Inc.

% Bus object: BusBulbConfiguration 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'BulbName';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'string';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'BulbState';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'Enum: EnumBulbState';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusBulbConfiguration = Simulink.Bus;
BusBulbConfiguration.HeaderFile = '';
BusBulbConfiguration.Description = '';
BusBulbConfiguration.DataScope = 'Auto';
BusBulbConfiguration.Alignment = -1;
BusBulbConfiguration.PreserveElementDimensions = 0;
BusBulbConfiguration.Elements = elems;
clear elems;
assignin('base','BusBulbConfiguration', BusBulbConfiguration);

% Bus object: BusBulbConfigurations 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'ConfigurationNumber';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'uint32';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'NumBulbConfiguration';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'uint32';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'BulbConfiguration';
elems(3).Dimensions = [1 5];
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'Bus: BusBulbConfiguration';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

BusBulbConfigurations = Simulink.Bus;
BusBulbConfigurations.HeaderFile = '';
BusBulbConfigurations.Description = '';
BusBulbConfigurations.DataScope = 'Auto';
BusBulbConfigurations.Alignment = -1;
BusBulbConfigurations.PreserveElementDimensions = 0;
BusBulbConfigurations.Elements = elems;
clear elems;
assignin('base','BusBulbConfigurations', BusBulbConfigurations);

% Bus object: BusCycleTime 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'Duration';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'TimeLeft';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusCycleTime = Simulink.Bus;
BusCycleTime.HeaderFile = '';
BusCycleTime.Description = '';
BusCycleTime.DataScope = 'Auto';
BusCycleTime.Alignment = -1;
BusCycleTime.PreserveElementDimensions = 0;
BusCycleTime.Elements = elems;
clear elems;
assignin('base','BusCycleTime', BusCycleTime);

% Bus object: BusPhaseInterval 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'IntervalName';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'string';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'IntervalType';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'Enum: EnumIntervalType';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'IntervalTime';
elems(3).Dimensions = [1 1];
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

BusPhaseInterval = Simulink.Bus;
BusPhaseInterval.HeaderFile = '';
BusPhaseInterval.Description = '';
BusPhaseInterval.DataScope = 'Auto';
BusPhaseInterval.Alignment = -1;
BusPhaseInterval.PreserveElementDimensions = 0;
BusPhaseInterval.Elements = elems;
clear elems;
assignin('base','BusPhaseInterval', BusPhaseInterval);

% Bus object: BusPhaseTime 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'Duration';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'TimeLeft';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusPhaseTime = Simulink.Bus;
BusPhaseTime.HeaderFile = '';
BusPhaseTime.Description = '';
BusPhaseTime.DataScope = 'Auto';
BusPhaseTime.Alignment = -1;
BusPhaseTime.PreserveElementDimensions = 0;
BusPhaseTime.Elements = elems;
clear elems;
assignin('base','BusPhaseTime', BusPhaseTime);

% Bus object: BusRuntimeTurnConfiguration 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'TimeLeft';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'TurnType';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'Enum: EnumTurnType';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'ConfigurationType';
elems(3).Dimensions = [1 1];
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'Enum: EnumConfigurationType';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

BusRuntimeTurnConfiguration = Simulink.Bus;
BusRuntimeTurnConfiguration.HeaderFile = '';
BusRuntimeTurnConfiguration.Description = '';
BusRuntimeTurnConfiguration.DataScope = 'Auto';
BusRuntimeTurnConfiguration.Alignment = -1;
BusRuntimeTurnConfiguration.PreserveElementDimensions = 0;
BusRuntimeTurnConfiguration.Elements = elems;
clear elems;
assignin('base','BusRuntimeTurnConfiguration', BusRuntimeTurnConfiguration);

% Bus object: BusSignalConfiguration 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'ConfigurationIndex';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'uint32';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'NumBulbConfiguration';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'uint32';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'BulbConfiguration';
elems(3).Dimensions = [1 6];
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'Bus: BusBulbConfiguration';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'NumTurnConfiguration';
elems(4).Dimensions = [1 1];
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'uint32';
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

elems(5) = Simulink.BusElement;
elems(5).Name = 'TurnConfiguration';
elems(5).Dimensions = [1 5];
elems(5).DimensionsMode = 'Fixed';
elems(5).DataType = 'Bus: BusRuntimeTurnConfiguration';
elems(5).Complexity = 'real';
elems(5).Min = [];
elems(5).Max = [];
elems(5).DocUnits = '';
elems(5).Description = '';

BusSignalConfiguration = Simulink.Bus;
BusSignalConfiguration.HeaderFile = '';
BusSignalConfiguration.Description = '';
BusSignalConfiguration.DataScope = 'Auto';
BusSignalConfiguration.Alignment = -1;
BusSignalConfiguration.PreserveElementDimensions = 0;
BusSignalConfiguration.Elements = elems;
clear elems;
assignin('base','BusSignalConfiguration', BusSignalConfiguration);

% Bus object: BusSignalHead 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'SignalID';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'string';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'ControllerID';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'string';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusSignalHead = Simulink.Bus;
BusSignalHead.HeaderFile = '';
BusSignalHead.Description = '';
BusSignalHead.DataScope = 'Auto';
BusSignalHead.Alignment = -1;
BusSignalHead.PreserveElementDimensions = 0;
BusSignalHead.Elements = elems;
clear elems;
assignin('base','BusSignalHead', BusSignalHead);

% Bus object: BusSignalInterval 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'IntervalName';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'string';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'IntervalType';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'Enum: EnumIntervalType';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusSignalInterval = Simulink.Bus;
BusSignalInterval.HeaderFile = '';
BusSignalInterval.Description = '';
BusSignalInterval.DataScope = 'Auto';
BusSignalInterval.Alignment = -1;
BusSignalInterval.PreserveElementDimensions = 0;
BusSignalInterval.Elements = elems;
clear elems;
assignin('base','BusSignalInterval', BusSignalInterval);

% Bus object: BusSignalPhase 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'PhaseName';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'string';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'PhaseNumber';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'uint32';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusSignalPhase = Simulink.Bus;
BusSignalPhase.HeaderFile = '';
BusSignalPhase.Description = '';
BusSignalPhase.DataScope = 'Auto';
BusSignalPhase.Alignment = -1;
BusSignalPhase.PreserveElementDimensions = 0;
BusSignalPhase.Elements = elems;
clear elems;
assignin('base','BusSignalPhase', BusSignalPhase);

% Bus object: BusSignalPhaseState 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'NumConfigurationIndex';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'uint32';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'ConfigurationIndex';
elems(2).Dimensions = [1 3];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'uint32';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusSignalPhaseState = Simulink.Bus;
BusSignalPhaseState.HeaderFile = '';
BusSignalPhaseState.Description = '';
BusSignalPhaseState.DataScope = 'Auto';
BusSignalPhaseState.Alignment = -1;
BusSignalPhaseState.PreserveElementDimensions = 0;
BusSignalPhaseState.Elements = elems;
clear elems;
assignin('base','BusSignalPhaseState', BusSignalPhaseState);

% Bus object: BusSignalRuntime 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'TrafficControllerRuntime';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'Bus: BusTrafficControllerRuntime';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'TrafficSignalRuntime';
elems(2).Dimensions = [1 10];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'Bus: BusTrafficSignalRuntime';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusSignalRuntime = Simulink.Bus;
BusSignalRuntime.HeaderFile = '';
BusSignalRuntime.Description = '';
BusSignalRuntime.DataScope = 'Auto';
BusSignalRuntime.Alignment = -1;
BusSignalRuntime.PreserveElementDimensions = 0;
BusSignalRuntime.Elements = elems;
clear elems;
assignin('base','BusSignalRuntime', BusSignalRuntime);

% Bus object: BusSignalSpec 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'TrafficControllerSpec';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'Bus: BusTrafficControllerSpec';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'TrafficSignalSpec';
elems(2).Dimensions = [1 10];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'Bus: BusTrafficSignalSpec';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusSignalSpec = Simulink.Bus;
BusSignalSpec.HeaderFile = '';
BusSignalSpec.Description = '';
BusSignalSpec.DataScope = 'Auto';
BusSignalSpec.Alignment = -1;
BusSignalSpec.PreserveElementDimensions = 0;
BusSignalSpec.Elements = elems;
clear elems;
assignin('base','BusSignalSpec', BusSignalSpec);

% Bus object: BusTrafficControllerRuntime 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'ActorID';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'ControllerID';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'string';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'SignalPhase';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'Bus: BusSignalPhase';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'SignalInterval';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'Bus: BusSignalInterval';
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

elems(5) = Simulink.BusElement;
elems(5).Name = 'PhaseTime';
elems(5).Dimensions = 1;
elems(5).DimensionsMode = 'Fixed';
elems(5).DataType = 'Bus: BusPhaseTime';
elems(5).Complexity = 'real';
elems(5).Min = [];
elems(5).Max = [];
elems(5).DocUnits = '';
elems(5).Description = '';

elems(6) = Simulink.BusElement;
elems(6).Name = 'CycleTime';
elems(6).Dimensions = 1;
elems(6).DimensionsMode = 'Fixed';
elems(6).DataType = 'Bus: BusCycleTime';
elems(6).Complexity = 'real';
elems(6).Min = [];
elems(6).Max = [];
elems(6).DocUnits = '';
elems(6).Description = '';

elems(7) = Simulink.BusElement;
elems(7).Name = 'ControllerStatus';
elems(7).Dimensions = [1 1];
elems(7).DimensionsMode = 'Fixed';
elems(7).DataType = 'Enum: EnumControllerStatus';
elems(7).Complexity = 'real';
elems(7).Min = [];
elems(7).Max = [];
elems(7).DocUnits = '';
elems(7).Description = '';

BusTrafficControllerRuntime = Simulink.Bus;
BusTrafficControllerRuntime.HeaderFile = '';
BusTrafficControllerRuntime.Description = '';
BusTrafficControllerRuntime.DataScope = 'Auto';
BusTrafficControllerRuntime.Alignment = -1;
BusTrafficControllerRuntime.PreserveElementDimensions = 0;
BusTrafficControllerRuntime.Elements = elems;
clear elems;
assignin('base','BusTrafficControllerRuntime', BusTrafficControllerRuntime);

% Bus object: BusTrafficControllerSpec 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'ActorID';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'ControllerID';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'string';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'NumTrafficSignalControllerPhases';
elems(3).Dimensions = [1 1];
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'uint32';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'TrafficSignalControllerPhases';
elems(4).Dimensions = [1 3];
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'Bus: BusTrafficSignalControllerPhases';
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

BusTrafficControllerSpec = Simulink.Bus;
BusTrafficControllerSpec.HeaderFile = '';
BusTrafficControllerSpec.Description = '';
BusTrafficControllerSpec.DataScope = 'Auto';
BusTrafficControllerSpec.Alignment = -1;
BusTrafficControllerSpec.PreserveElementDimensions = 0;
BusTrafficControllerSpec.Elements = elems;
clear elems;
assignin('base','BusTrafficControllerSpec', BusTrafficControllerSpec);

% Bus object: BusTrafficSignalControllerPhases 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'PhaseName';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'string';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'NumPhaseInterval';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'uint32';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'PhaseInterval';
elems(3).Dimensions = [1 3];
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'Bus: BusPhaseInterval';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

BusTrafficSignalControllerPhases = Simulink.Bus;
BusTrafficSignalControllerPhases.HeaderFile = '';
BusTrafficSignalControllerPhases.Description = '';
BusTrafficSignalControllerPhases.DataScope = 'Auto';
BusTrafficSignalControllerPhases.Alignment = -1;
BusTrafficSignalControllerPhases.PreserveElementDimensions = 0;
BusTrafficSignalControllerPhases.Elements = elems;
clear elems;
assignin('base','BusTrafficSignalControllerPhases', BusTrafficSignalControllerPhases);

% Bus object: BusTrafficSignalRuntime 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'ActorID';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'SignalHead';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'Bus: BusSignalHead';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'SignalConfiguration';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'Bus: BusSignalConfiguration';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

BusTrafficSignalRuntime = Simulink.Bus;
BusTrafficSignalRuntime.HeaderFile = '';
BusTrafficSignalRuntime.Description = '';
BusTrafficSignalRuntime.DataScope = 'Auto';
BusTrafficSignalRuntime.Alignment = -1;
BusTrafficSignalRuntime.PreserveElementDimensions = 0;
BusTrafficSignalRuntime.Elements = elems;
clear elems;
assignin('base','BusTrafficSignalRuntime', BusTrafficSignalRuntime);

% Bus object: BusTrafficSignalSpec 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'ActorID';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'SignalHead';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'Bus: BusSignalHead';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'SignalPosition';
elems(3).Dimensions = [1 3];
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'SignalStatus';
elems(4).Dimensions = [1 1];
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'Enum: EnumTrafficSignalStatus';
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

elems(5) = Simulink.BusElement;
elems(5).Name = 'NumSignalPhaseState';
elems(5).Dimensions = [1 1];
elems(5).DimensionsMode = 'Fixed';
elems(5).DataType = 'uint32';
elems(5).Complexity = 'real';
elems(5).Min = [];
elems(5).Max = [];
elems(5).DocUnits = '';
elems(5).Description = '';

elems(6) = Simulink.BusElement;
elems(6).Name = 'SignalPhaseState';
elems(6).Dimensions = [1 5];
elems(6).DimensionsMode = 'Fixed';
elems(6).DataType = 'Bus: BusSignalPhaseState';
elems(6).Complexity = 'real';
elems(6).Min = [];
elems(6).Max = [];
elems(6).DocUnits = '';
elems(6).Description = '';

elems(7) = Simulink.BusElement;
elems(7).Name = 'NumSupportedTurnTypes';
elems(7).Dimensions = [1 1];
elems(7).DimensionsMode = 'Fixed';
elems(7).DataType = 'uint32';
elems(7).Complexity = 'real';
elems(7).Min = [];
elems(7).Max = [];
elems(7).DocUnits = '';
elems(7).Description = '';

elems(8) = Simulink.BusElement;
elems(8).Name = 'SupportedTurnTypes';
elems(8).Dimensions = [5 1];
elems(8).DimensionsMode = 'Fixed';
elems(8).DataType = 'Enum: EnumTurnType';
elems(8).Complexity = 'real';
elems(8).Min = [];
elems(8).Max = [];
elems(8).DocUnits = '';
elems(8).Description = '';

elems(9) = Simulink.BusElement;
elems(9).Name = 'NumBulbConfigurations';
elems(9).Dimensions = [1 1];
elems(9).DimensionsMode = 'Fixed';
elems(9).DataType = 'uint32';
elems(9).Complexity = 'real';
elems(9).Min = [];
elems(9).Max = [];
elems(9).DocUnits = '';
elems(9).Description = '';

elems(10) = Simulink.BusElement;
elems(10).Name = 'BulbConfigurations';
elems(10).Dimensions = [1 5];
elems(10).DimensionsMode = 'Fixed';
elems(10).DataType = 'Bus: BusBulbConfigurations';
elems(10).Complexity = 'real';
elems(10).Min = [];
elems(10).Max = [];
elems(10).DocUnits = '';
elems(10).Description = '';

elems(11) = Simulink.BusElement;
elems(11).Name = 'NumTurnConfigurations';
elems(11).Dimensions = [1 1];
elems(11).DimensionsMode = 'Fixed';
elems(11).DataType = 'uint32';
elems(11).Complexity = 'real';
elems(11).Min = [];
elems(11).Max = [];
elems(11).DocUnits = '';
elems(11).Description = '';

elems(12) = Simulink.BusElement;
elems(12).Name = 'TurnConfigurations';
elems(12).Dimensions = [1 5];
elems(12).DimensionsMode = 'Fixed';
elems(12).DataType = 'Bus: BusTurnConfigurations';
elems(12).Complexity = 'real';
elems(12).Min = [];
elems(12).Max = [];
elems(12).DocUnits = '';
elems(12).Description = '';

BusTrafficSignalSpec = Simulink.Bus;
BusTrafficSignalSpec.HeaderFile = '';
BusTrafficSignalSpec.Description = '';
BusTrafficSignalSpec.DataScope = 'Auto';
BusTrafficSignalSpec.Alignment = -1;
BusTrafficSignalSpec.PreserveElementDimensions = 0;
BusTrafficSignalSpec.Elements = elems;
clear elems;
assignin('base','BusTrafficSignalSpec', BusTrafficSignalSpec);

% Bus object: BusTurnConfigurations 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'ConfigurationNumber';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'uint32';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'NumTurnState';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'uint32';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'TurnState';
elems(3).Dimensions = [1 6];
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'Bus: BusTurnState';
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

BusTurnConfigurations = Simulink.Bus;
BusTurnConfigurations.HeaderFile = '';
BusTurnConfigurations.Description = '';
BusTurnConfigurations.DataScope = 'Auto';
BusTurnConfigurations.Alignment = -1;
BusTurnConfigurations.PreserveElementDimensions = 0;
BusTurnConfigurations.Elements = elems;
clear elems;
assignin('base','BusTurnConfigurations', BusTurnConfigurations);

% Bus object: BusTurnState 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'TurnTypes';
elems(1).Dimensions = [1 1];
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'Enum: EnumTurnType';
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'ConfigurationType';
elems(2).Dimensions = [1 1];
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'Enum: EnumConfigurationType';
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

BusTurnState = Simulink.Bus;
BusTurnState.HeaderFile = '';
BusTurnState.Description = '';
BusTurnState.DataScope = 'Auto';
BusTurnState.Alignment = -1;
BusTurnState.PreserveElementDimensions = 0;
BusTurnState.Elements = elems;
clear elems;
assignin('base','BusTurnState', BusTurnState);

rrInterfaceBuses = load(fullfile(matlabroot,'toolbox','driving','drivingdata','rrScenarioSimTypes.mat'));
BusVehicleRuntime = rrInterfaceBuses.BusVehicleRuntime;
BusActorRuntime = rrInterfaceBuses.BusActorRuntime;
assignin("base","BusActorRuntime",BusActorRuntime);
assignin("base","BusVehicleRuntime",BusVehicleRuntime);
clear rrInterfaceBuses
