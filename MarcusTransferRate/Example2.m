
% Define the range of lambda and deltaG values
lambda_values = 0.4:0.1:0.8; %eV If the step is smaller than 0.1, it will overwrite..
RCT_values = 2:1:20; %nm
RCT_values = RCT_values/1e9; %convert to m

% Create a structure to hold the k_LE2CTs
kLECT_vars = struct();


for lambda_nums = 1:length(lambda_values)
    lambda = lambda_values(lambda_nums);
    lambda_str = strrep(sprintf('%02.0f', lambda*10), '.', ''); % Format Reorganization energy to two digits, remove decimal
    for RCT_nums = 1:length(RCT_values)
        RCT = RCT_values(RCT_nums);
        % Extract the numeric parts for the variable name
        RCT_str = strrep(sprintf('%02.0f', RCT*1e10), '.', ''); % Format transfer distance to two digits, remove decimal
    
        % Construct the variable name
        kLECT_name = ['kLECT' lambda_str RCT_str];
    
        % Calculate ket using the Marcus equation with fixed F and deltaG
        % arrays
        % Assign the value to the field within the structure
        test = scanFnG(lambda, RCT);
        kLECT_vars.(kLECT_name)=test;
    end
end
