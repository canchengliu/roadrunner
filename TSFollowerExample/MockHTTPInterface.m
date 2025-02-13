function updatedSignals = MockHTTPInterface(aggInfo)
% MockHTTPInterface simulates a remote HTTP call.
%
% Input:
%   aggInfo - structure array with aggregated traffic signal information.
%           (Each element is assumed to have at least the fields:
%            SignalID, Status, and RemainingTime.)
%
% Output:
%   updatedSignals - structure array with updated signal fields:
%                      SignalID, Status, and RemainingTime.
%
% For demonstration purposes, if a signal is 'Red', it will be toggled to 
% 'Green' and vice versa. Additionally, the RemainingTime is increased 
% by 5 seconds.

numSignals = numel(aggInfo);
updatedSignals = repmat(struct('SignalID', [], 'Status', [], 'RemainingTime', []), numSignals, 1);

for i = 1:numSignals
    updatedSignals(i).SignalID = aggInfo(i).SignalID;
    
    % Toggle the status to simulate a remote update:
    if strcmpi(aggInfo(i).Status, 'Red')
        updatedSignals(i).Status = 'Green';
    else
        updatedSignals(i).Status = 'Red';
    end
    
    % Increase the remaining time by a constant offset (for example, +5 sec)
    updatedSignals(i).RemainingTime = aggInfo(i).RemainingTime + 5;
end

end 