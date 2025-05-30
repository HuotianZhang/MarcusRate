% Extract the numeric parts for the variable name
lambda_str = strrep(sprintf('%02.0f', lambda*10), '.', ''); % Format Reorganization energy to two digits, remove decimal
RCT_str = strrep(sprintf('%02.0f', RCT*1e10), '.', ''); % Format transfer distance to two digits, remove decimal

% Construct the variable name
kLECT_name = ['kLECT' lambda_str RCT_str];

% Now, you can dynamically create the variable
% eval([kLECT_name ' = some_value;']); % Assign 'some_value' to the dynamically created variable

% Example:
some_value = 42;
eval([kLECT_name ' = some_value;']);