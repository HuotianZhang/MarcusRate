function ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta)
  % MARCUS_EQUATION - Calculate Marcus electron transfer rate
  %
  % This function uses centralized physical constants from deviceparams class.
  % All constants conform to CODATA 2018 standards.
  %
  % Usage:
  %   ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta)
  %
  % Inputs:
  %   Hab    - Electronic coupling matrix element (eV)
  %   lambda - Reorganization energy (eV)
  %   deltaG - Standard Gibbs free energy change (eV)
  %   T      - Temperature (K)
  %   F      - Electric field (V/m)
  %   RCT    - Transfer distance (m)
  %   theta  - Angle between two dipole (radians)
  %
  % Output:
  %   ket    - Electron transfer rate (s^-1)
  
  % Get physical constants from centralized deviceparams class
  DP = deviceparams();
  hbar = DP.physical_const.hbar;  % Reduced Planck constant (J·s)
  k = DP.physical_const.kB;       % Boltzmann constant (J/K)
  q = DP.physical_const.e;        % Elementary charge (C)
  
  % Calculate the charge transfer rate
  ket = (2*pi/hbar) * abs(Hab*q)^2 * (1/sqrt(4*pi*lambda*k*T*q)) * exp(-(lambda + deltaG - F * RCT * cos(theta))^2 / (4*lambda*k*T/q));
end

