function DP = deviceparams()
  % DEVICEPARAMS Initialize physical constants and device parameters
  % Returns a structure DP containing physical_const with commonly used constants
  % including the cached kBT value for performance optimization.
  
  % Physical constants structure
  DP.physical_const.hbar = 1.0546e-34;  % Reduced Planck constant (J s)
  DP.physical_const.kB = 1.3806e-23;    % Boltzmann constant (J/K)
  DP.physical_const.q = 1.6022e-19;     % Elementary charge (coulomb)
  DP.physical_const.epsilon0 = 8.854e-12; % Permittivity of free space (F/m)
  DP.physical_const.T = 298;            % Temperature (K)
  
  % Cached kBT value for performance optimization
  % Use this throughout the codebase instead of computing kB * T repeatedly
  DP.physical_const.kBT = DP.physical_const.kB * DP.physical_const.T;
  
end
