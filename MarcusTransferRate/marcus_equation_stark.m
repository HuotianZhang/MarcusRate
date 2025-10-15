function ket = marcus_equation_stark(Hab, lambda, deltaG, T, F, d_CT)
  % MARCUS_EQUATION_STARK - Calculate Marcus electron transfer rate with Stark effect
  %
  % This function uses centralized physical constants from deviceparams class.
  % All constants conform to CODATA 2018 standards.
  %
  % Usage:
  %   ket = marcus_equation_stark(Hab, lambda, deltaG, T, F, d_CT)
  %
  % Inputs:
  %   Hab    - Electronic coupling matrix element (eV)
  %   lambda - Reorganization energy (eV)
  %   deltaG - Standard Gibbs free energy change (eV)
  %   T      - Temperature (K)
  %   F      - Electric field (V/m)
  %   d_CT   - Charge transfer distance (m)
  %
  % Output:
  %   ket    - Electron transfer rate (s^-1)
  
  % Get physical constants from centralized deviceparams class
  DP = deviceparams();
  epsilon0 = DP.physical_const.epsilon0;  % Vacuum permittivity (F/m)
  hbar = DP.physical_const.hbar;          % Reduced Planck constant (J·s)
  k = DP.physical_const.kB;               % Boltzmann constant (J/K)
  q = DP.physical_const.e;                % Elementary charge (C)
  
  % Material-specific constants for TCNQ
  d_TCNQ = 1.5e-10; %(m) excited state electric dipole length
  alpha_prime_TCNQ = 85; %(Å^3) cgs units ->SI units
  
  alpha_TCNQ = 4*pi*epsilon0*alpha_prime_TCNQ*1e-30; %Å^3 to m^3 (F m^2)
  alpha_CT = alpha_TCNQ*(d_CT/d_TCNQ)^4;
  deltaE_CT = -1/2*alpha_CT*F*abs(F)/q;


  % Calculate the charge transfer rate
  ket = (2*pi/hbar) * abs(Hab*q)^2 * (1/sqrt(4*pi*lambda*k*T*q)) * exp(-(lambda + deltaG + deltaE_CT).^2 / (4*lambda*k*T/q));

end

