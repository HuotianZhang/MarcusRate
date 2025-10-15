% Test variable name generation using MarcusHelpers
% Assuming lambda and RCT are defined
kLECT_name = MarcusHelpers.format_variable_name(lambda, RCT, 'kLECT');

% Now, you can dynamically create the variable
% eval([kLECT_name ' = some_value;']); % Assign 'some_value' to the dynamically created variable

% Example:
some_value = 42;
eval([kLECT_name ' = some_value;']);