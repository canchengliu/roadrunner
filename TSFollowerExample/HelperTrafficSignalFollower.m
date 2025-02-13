classdef HelperTrafficSignalFollower < matlab.System
%HelperTrafficSignalFollower Controls vehicle speed based on current state of ego vehicle and traffic signal.
%
% NOTE: This is a helper file for example purposes and may be removed or
% modified in the future.
%
% Copyright 2024 The MathWorks, Inc.

    properties (Access = private)    
        EgoControl % -1(STOP), 0(NOACTION), 1(START)
        StopLineThreshold = 2;
    end

    properties(Nontunable)
        % Deceleration value to stop (m/s^2)
        Decel = 8;

        % Acceleration value to start (m/s^2)
        Accel = 2;

        % Target speed to start (m/s)
        TargetSpeed = 20;

        % Sample time (sec)
        Ts = 0.02;              
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Initialize ego control to zero (NOACTION).
            obj.EgoControl = 0;
        end

        function speed = stepImpl(obj,egoPose,signalState,timeLeft,distToStop)
            % Get current speed
            speed = norm(egoPose.ActorRuntime.Velocity);

            % Calculate distance to stop
            distToStop = max(0,distToStop-obj.StopLineThreshold);

            % Cacualte time to stop line
            if speed == 0
                % Set timeToStop to infinity as stopping time is undefined
                % at zero speed.
                timeToStop = Inf; 
            else
                timeToStop = distToStop / speed;
            end
 
            % Initialize start and stop action.
            stopAction  = false;
            startAction = false;

            if distToStop>0 && speed>1e-5 % ego is moving toward junction
                switch signalState % traffic bulb color associated with ego
                    case EnumConfigurationType.Red
                        if timeLeft > timeToStop % red light stays when ego vehcile reaches the stop line
                            stopAction = true; % then, stop in advance
                        end
                    case {EnumConfigurationType.Green, EnumConfigurationType.Yellow}
                        if timeLeft < timeToStop % green or yellow light will be expired when ego vehcile reaches the stop line
                            stopAction = true; % then, stop in advance
                        end
                end
            end

            % If ego is currently stationary
            if speed<1e-5 
                if signalState == EnumConfigurationType.Green % and, green light
                    startAction = true; % then, start to move
                end
            end

            % Check conditions for taking control action
            if startAction && (obj.EgoControl == 0)  % need to start?
                obj.EgoControl = 1; % take action to accel to start
            end

            if stopAction && (obj.EgoControl == 0) % need to stop?
                brakeDistance = (speed)^2/(2*obj.Decel); % braking distance at decel

                if distToStop <= brakeDistance % if distance 2 stop is equal or less than braking distance
                    obj.EgoControl = -1; % take action to brake to stop
                end
            end

            % Change ego speed depending on required action
            switch obj.EgoControl
                case -1 % If required action is STOP
                    [speed,release] = decelToStop(obj,speed); % reduce speed until stop

                    if release % when speed becomes zero
                        obj.EgoControl = 0; 
                    end
                case 1 % If required action is START
                    [speed,release] = accelToStart(obj,speed); % increase speed until target speed

                    if release % when speed reach to target speed
                        obj.EgoControl = 0; 
                    end
            end
        end
        %%-----------------------------------------------------------------
        function [speed,release] = decelToStop(obj,currSpeed)
            speed = currSpeed - obj.Decel*obj.Ts;
            if speed <= 0
                speed = 0;
                release = true;
            else
                release = false;
            end
        end
        %%-----------------------------------------------------------------
        function [speed,release] = accelToStart(obj,currSpeed)
            speed = currSpeed + obj.Accel*obj.Ts;
            if speed >= obj.TargetSpeed
                speed = obj.TargetSpeed;
                release = true;
            else
                release = false;
            end
        end
        %%-----------------------------------------------------------------
        function speed = getOutputSizeImpl(obj) %#ok<MANU>
            % Return size for each output port
            speed = [1 1];
        end
        
        function speed = getOutputDataTypeImpl(obj) %#ok<MANU>
            % Return data type for each output port
            speed = 'double';
        end
        
        function speed = isOutputComplexImpl(obj) %#ok<MANU>
            % Return true for each output port with complex data
            speed = false;            
        end
        
        function speed = isOutputFixedSizeImpl(obj) %#ok<MANU>
            % Return true for each output port with fixed size
            speed = true;
        end
    end

    methods (Access = protected, Static)
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog
            simMode = "Interpreted execution";
        end
    end
end
