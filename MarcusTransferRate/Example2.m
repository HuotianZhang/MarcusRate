% Example usage:
Hab = 0.01;       % Electronic coupling matrix element (eV)
lambda = 0.6;      % Reorganization energy (eV)
deltaG = -0.45;     % Standard Gibbs free energy change (eV)
T = 298;          % Temperature (K)
F = 1e6;              % Electric field (V/m)
RCT = 1e-9;             % Transfer distance (m)
theta = 0;           % Angle between two dipole (degree)

% Define the range of lambda and deltaG values
lambda_values = 0.4:0.05:0.8; %eV
RCT_values = 2:1:20; %nm
RCT_values = RCT_values/1e9; %convert to m

% Create a structure to hold the k_LE2CTs
kLECT_vars = struct();


for lambda_nums = 1:length(lambda_values)
for RCT_nums = 1:length(RCT_values)
    lambda = lambda_values(lambda_nums);
    RCT = RCT_values(RCT_nums);
    % Extract the numeric parts for the variable name
    lambda_str = strrep(sprintf('%02.0f', lambda*10), '.', ''); % Format Reorganization energy to two digits, remove decimal
    RCT_str = strrep(sprintf('%02.0f', RCT*1e10), '.', ''); % Format transfer distance to two digits, remove decimal

    % Construct the variable name
    kLECT_name = ['kLECT' lambda_str RCT_str];

    % Calculate ket using the Marcus equation with fixed F and deltaG
    % arrays
    % Assign the value to the field within the structure
    kLECT_vars.(kLECT_name) = scanFnG(lambda, RCT);
end
end
