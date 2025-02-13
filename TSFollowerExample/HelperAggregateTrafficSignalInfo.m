classdef HelperAggregateTrafficSignalInfo < matlab.System
    % HelperAggregateTrafficSignalInfo aggregates detailed traffic signal info.
    % For each traffic signal in the scene it returns:
    %   - SignalID, current bulb Status, and RemainingTime.
    %   - The ControlledLane (determined via projecting the signal position onto lane geometry).
    %   - For each vehicle in that lane, a structure with VehicleID, Speed, and
    %     DistanceToStop computed along the lane from the vehicle's position.
    %
    % This System object expects:
    %   - signalSpec: static traffic signal specification (from HelperReadTrafficSignalSpec)
    %   - signalRuntime: runtime traffic signal info (from HelperReadTrafficSignalRuntime)
    %   - allVehicleRuntime: an array of vehicle runtime objects (each providing attributes
    %       "LaneLocation", "Velocity", and "Pose").
    %
    % It uses the RoadRunner HD map (RRHDMap) to obtain lane and junction geometric data.
    
    properties (Nontunable)
        RRHDMap = roadrunnerHDMap;  % RoadRunner HD Map object containing Lanes and Junctions.
    end
    
    properties (Access = private)
        AllLaneID      % Array of all lane IDs extracted from RRHDMap.
        JunctionLaneID % Cell array: each cell contains the lane IDs for one junction.
    end
    
    methods (Access = protected)
        function setupImpl(obj)
            % Precompute lane and junction information from the RoadRunner HD map.
            if isprop(obj.RRHDMap, 'Lanes')
                obj.AllLaneID = vertcat(obj.RRHDMap.Lanes.ID);
            else
                obj.AllLaneID = [];
            end
            
            if isprop(obj.RRHDMap, 'Junctions')
                obj.JunctionLaneID = arrayfun(@(jc) vertcat(jc.Lanes.ID), obj.RRHDMap.Junctions, 'UniformOutput', false);
            else
                obj.JunctionLaneID = {};
            end
        end
        
        function aggInfo = stepImpl(obj, signalSpec, signalRuntime, allVehicleRuntime)
            % Aggregates information for each traffic signal.
            %
            % For each signal in signalRuntime, the following info is extracted:
            %   - The current Status and RemainingTime from the last turn configuration.
            %   - The controlled lane, by projecting the signalPos onto available lanes.
            %   - For each vehicle on the controlled lane: VehicleID, computed speed,
            %     and the distance (along the lane) from its location to the stop line.
            %
            % Output:
            %   aggInfo: A structure array, one element per traffic signal.
            
            numSignals = numel(signalRuntime.TrafficSignalRuntime);
            aggInfo = repmat(struct('SignalID', [], 'Status', [], 'RemainingTime', [], ...
                                    'ControlledLane', [], 'Vehicles', []), numSignals, 1);
            
            for i = 1:numSignals
                % Retrieve the runtime info and find the matching static spec.
                currSignalRT = signalRuntime.TrafficSignalRuntime(i);
                currSignalSpec = HelperAggregateTrafficSignalInfo.getSignalSpecForID(signalSpec, currSignalRT.ActorID);
                if isempty(currSignalSpec)
                    continue;
                end
                
                % Use the most recent turn configuration to extract status information.
                numTurnConfig = currSignalRT.SignalConfiguration.NumTurnConfiguration;
                currTurnConfig = currSignalRT.SignalConfiguration.TurnConfiguration(numTurnConfig);
                status = currTurnConfig.ConfigurationType;
                remTime = currTurnConfig.TimeLeft;
                
                % Determine the controlled lane via an improved projection method.
                signalPos = currSignalSpec.SignalPosition;
                controlledLaneId = obj.findClosestLaneID(signalPos);

                % Identify vehicles that are on the controlled lane and aggregate info.
                vehiclesInLane = [];
                for j = 1:numel(allVehicleRuntime)
                    vehRuntime = allVehicleRuntime(j);
                    vehLaneID = [];
                    
                    % 通过车辆位置投影到地图获取车道ID
                    vehPosMat = vehRuntime.ActorRuntime.Pose;
                    vehPos = vehPosMat(1:3, 4)';  % 提取车辆位置坐标
                    vehLaneID = obj.findClosestLaneID(vehPos); % 使用与信号灯相同的投影方法
                    
                    % 确保车道ID有效且匹配受控车道
                    if isempty(vehLaneID) || (vehLaneID ~= controlledLaneId)
                        continue;
                    end
                    
                    % 计算车辆速度和到停止线的距离
                    vehVel = vehRuntime.ActorRuntime.Velocity;
                    speed = norm(vehVel);
                    distanceToStop = obj.computeDistanceToStopLine(vehPos, controlledLaneId);
                    
                    % 收集车辆信息
                    vehicleInfo = struct(...
                        'VehicleID', vehRuntime.ActorRuntime.ActorID, ...
                        'Speed', speed, ...
                        'DistanceToStop', distanceToStop ...
                    );
                    vehiclesInLane = [vehiclesInLane; vehicleInfo];  %#ok<AGROW>
                end

                % Populate the aggregated traffic signal info structure.
                aggInfo(i).SignalID      = currSignalRT.ActorID;
                aggInfo(i).Status        = status;
                aggInfo(i).RemainingTime = remTime;
                aggInfo(i).ControlledLane = controlledLaneId;
                aggInfo(i).Vehicles      = vehiclesInLane;
            end
        end
        
        function laneID = findClosestLaneID(obj, signalPos)
            % Improved method for determining the controlled lane.
            % Instead of using the average (center) of the lane, it evaluates the
            % minimal perpendicular distance from the signalPos to every lane segment.
            lanes = obj.RRHDMap.Lanes;
            minDist = inf;
            laneID  = NaN;
            for idx = 1:numel(lanes)
                laneGeom = lanes(idx).Geometry;  % Assume an N x 3 matrix for [x y z] coordinates.
                for k = 1:size(laneGeom,1)-1
                    d = HelperAggregateTrafficSignalInfo.pointToSegmentDistance(signalPos, laneGeom(k,:), laneGeom(k+1,:));
                    if d < minDist
                        minDist = d;
                        laneID = lanes(idx).ID;
                    end
                end
            end
        end
        
        function dist = computeDistanceToStopLine(obj, vehPos, laneID)
            % Computes the cumulative distance from the vehicle's projected location on
            % the lane (computed via the polyline) until the lane geometry enters a junction
            % region (assumed to be the stop line).
            [~, juncIdx] = obj.getApproachingJunction(laneID);
            if juncIdx == -1
                dist = -1;  % Indicates no junction (and hence no stop line) was found.
                return;
            end
            
            region = obj.RRHDMap.Junctions(juncIdx).Geometry.Polygons.ExteriorRing;
            lane = obj.RRHDMap.Lanes([obj.RRHDMap.Lanes.ID] == laneID);
            path = lane.Geometry;
            
            % Project vehPos onto the lane polyline.
            [projPoint, projIndex, ~, ~] = obj.projectOntoPolyline(vehPos, path);
            dist = 0;
            currentPoint = projPoint;
            numPts = size(path, 1);
            
            if projIndex >= numPts
                return;
            end
            
            % Traverse the lane geometry from the projection point forward.
            for i = projIndex:numPts-1
                nextPoint = path(i+1,:);
                % If the current point is already inside the junction region, exit.
                if obj.checkPointInsideRegion(currentPoint, region)
                    break;
                end
                % Check if the segment from currentPoint to nextPoint intersects the junction region.
                [intersects, intersectionPt] = obj.segmentPolygonIntersection(currentPoint, nextPoint, region);
                if intersects
                    segDist = norm(intersectionPt - currentPoint);
                    dist = dist + segDist;
                    break;
                else
                    segDist = norm(nextPoint - currentPoint);
                    dist = dist + segDist;
                end
                currentPoint = nextPoint;
            end
        end
        
        function [projPoint, idx, t, minDist] = projectOntoPolyline(obj, point, polyline)
            % Projects a given point onto a polyline (an array of 3D coordinates).
            % Returns:
            %   projPoint: The projected point on the polyline.
            %   idx: Index of the segment from which the projection was computed.
            %   t: The interpolation factor on that segment (0 corresponds to the first vertex).
            %   minDist: The minimum distance from the point to any segment on the polyline.
            minDist = inf;
            projPoint = [];
            idx = 1;
            t = 0;
            for i = 1:size(polyline,1)-1
                p1 = polyline(i,:);
                p2 = polyline(i+1,:);
                [proj, tCurr, d] = obj.projectPointToSegment(point, p1, p2);
                if d < minDist
                    minDist = d;
                    projPoint = proj;
                    idx = i;
                    t = tCurr;
                end
            end
        end
        
        function [proj, t, d] = projectPointToSegment(~, point, p1, p2)
            % Projects 'point' onto the segment defined by p1 and p2.
            % Returns:
            %   proj: The projected point.
            %   t: The interpolation factor (0 means p1 and 1 means p2).
            %   d: The Euclidean distance from point to proj.
            v = p2 - p1;
            w = point - p1;
            len2 = dot(v,v);
            if len2 < eps
                t = 0;
                proj = p1;
                d = norm(point - p1);
                return;
            end
            t = dot(w,v) / len2;
            if t < 0
                proj = p1;
            elseif t > 1
                proj = p2;
            else
                proj = p1 + t*v;
            end
            d = norm(point - proj);
        end
        
        function [intersect, pt] = segmentPolygonIntersection(obj, p, q, polygon)
            % Checks if the segment from point p to point q intersects the polygon.
            % Returns:
            %   intersect: True if an intersection occurs.
            %   pt: The intersection point closest to p, if found.
            intersect = false;
            pt = [];
            minParam = inf;
            numVertices = size(polygon, 1);
            for i = 1:numVertices
                if i == numVertices
                    edgeStart = polygon(i, :);
                    edgeEnd = polygon(1, :);
                else
                    edgeStart = polygon(i, :);
                    edgeEnd = polygon(i+1, :);
                end
                [isect, t, ipt] = obj.lineSegmentIntersection2D(p(1:2), q(1:2), edgeStart(1:2), edgeEnd(1:2));
                if isect && t < minParam
                    minParam = t;
                    pt = [ipt, p(3)];  % Preserve the z-coordinate from p.
                    intersect = true;
                end
            end
        end
        
        function [intersect, t, pt] = lineSegmentIntersection2D(~, p, q, r, s)
            % Computes the intersection between segment p->q and segment r->s in 2D.
            % p, q, r, and s are 1x2 vectors.
            % Returns:
            %   intersect: True when an intersection occurs.
            %   t: The interpolation parameter along p->q at which the intersection occurs.
            %   pt: The intersection point.
            dp = q - p;
            dr = s - r;
            denom = dp(1)*dr(2) - dp(2)*dr(1);
            if abs(denom) < eps
                intersect = false;
                t = NaN;
                pt = [];
                return;
            end
            diff = r - p;
            t = (diff(1)*dr(2) - diff(2)*dr(1)) / denom;
            u = (diff(1)*dp(2) - diff(2)*dp(1)) / denom;
            if t >= 0 && t <= 1 && u >= 0 && u <= 1
                intersect = true;
                pt = p + t * dp;
            else
                intersect = false;
                t = NaN;
                pt = [];
            end
        end
        
        function isInside = checkPointInsideRegion(~, point, region)
            % Uses the ray-casting algorithm to check if a 2D point is inside a polygon.
            % Both the point and the polygon vertices are assumed to lie on the same plane.
            x = point(1);
            y = point(2);
            crossings = 0;
            numVertices = size(region, 1);
            for i = 1:numVertices
                vertex1 = region(i,:);
                vertex2 = region(mod(i, numVertices) + 1, :);
                if ((vertex1(2) > y) ~= (vertex2(2) > y))
                    intersectX = (vertex2(1) - vertex1(1))*(y - vertex1(2))/(vertex2(2) - vertex1(2)) + vertex1(1);
                    if x < intersectX
                        crossings = crossings + 1;
                    end
                end
            end
            isInside = mod(crossings, 2) == 1;
        end
        
        function [junctionUUID, juncIdx] = getApproachingJunction(obj, laneID)
            % Determines whether the lane with laneID is associated with a junction.
            % Returns the junction UUID and its index if found; otherwise, juncIdx is -1.
            junctionUUID = "";
            juncIdx = -1;
            for i = 1:numel(obj.JunctionLaneID)
                if ismember(laneID, obj.JunctionLaneID{i})
                    juncIdx = i;
                    junctionUUID = obj.RRHDMap.Junctions(i).ID;
                    return;
                end
            end
        end
    end
    
    methods (Access = protected, Static)
        function simMode = getSimulateUsingImpl()
            % Specifies that this System object uses interpreted execution.
            simMode = "Interpreted execution";
        end
    end
    
    methods (Static, Access = private)
        function spec = getSignalSpecForID(signalSpec, signalID)
            % Retrieves and returns the static signal specification corresponding to signalID.
            spec = [];
            for k = 1:numel(signalSpec.TrafficSignalSpec)
                if signalSpec.TrafficSignalSpec(k).ActorID == signalID
                    spec = signalSpec.TrafficSignalSpec(k);
                    return;
                end
            end
        end
        
        function d = pointToSegmentDistance(pt, p1, p2)
            % Computes the distance from point 'pt' to the line segment defined by p1 and p2.
            v = p2 - p1;
            w = pt - p1;
            c1 = dot(w, v);
            if c1 <= 0
                d = norm(pt - p1);
                return;
            end
            c2 = dot(v, v);
            if c2 <= c1
                d = norm(pt - p2);
                return;
            end
            b = c1 / c2;
            pb = p1 + b * v;
            d = norm(pt - pb);
        end
    end
end 