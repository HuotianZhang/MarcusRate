% Example usage:
Hab = 0.01;       % Electronic coupling matrix element (eV)
lambda = 0.6;      % Reorganization energy (eV)
deltaG = -0.45;     % Standard Gibbs free energy change (eV)
T = 298;          % Temperature (K)
F = 1e6;              % Electric field (V/m)
RCT = 1e-9;             % Transfer distance (m)
theta = 0;           % Angle between two dipole (degree)

% Define the range of lambda and deltaG values
F_values = 0:1e6:1e8;
deltaG_values = 0:0.05:0.45;

% Preallocate the output matrix for efficiency
ket_matrix = zeros(length(F_values), length(deltaG_values));

for F_nums = 1:length(F_values)
for deltaG_nums = 1:length(deltaG_values)
  F = F_values(F_nums);
  deltaG = - deltaG_values(deltaG_nums);
  
  % Calculate ket using the Marcus equation
  % function ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta)
  ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta);
  ket_matrix(F_nums, deltaG_nums) = 0.1*ket;
end
end

% Extract the numeric parts for the variable name
lambda_str = strrep(sprintf('%02.0f', lambda*10), '.', ''); % Format Reorganization energy to two digits, remove decimal
RCT_str = strrep(sprintf('%02.0f', RCT*1e10), '.', ''); % Format transfer distance to two digits, remove decimal

% Construct the variable name
kLECT_name = ['kLECT' lambda_str RCT_str];

% Create a structure to hold the variables
kLECT_vars = struct();

% Assign the value to the field within the structure
kLECT_vars.(kLECT_name) = [F_values' ket_matrix];