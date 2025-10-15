function ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta)
  % MARCUS_EQUATION Calculate electron transfer rate using Marcus theory
  %
  % Usage: ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta)
  %        ket = marcus_equation(Hab, lambda, deltaG, DP, F, RCT, theta)
  %
  % For improved performance, pass DP structure from deviceparams() as the 4th argument
  % to use cached kBT value instead of computing kB*T repeatedly.
  
  % Check if T is a structure (DP) or a scalar temperature
  if isstruct(T)
    DP = T;
    hbar = DP.physical_const.hbar;
    kBT = DP.physical_const.kBT;  % Use cached kBT for performance
    q = DP.physical_const.q;
  else
    % Backward compatibility: use local constants
    hbar = 1.0546e-34;  % Reduced Planck constant (J s)
    k = 1.3806e-23;    % Boltzmann constant (J/K)
    q = 1.6022e-19;   % Elementary charge (coulomb)
    kBT = k * T;  % Compute kBT from temperature
  end
  
  % Calculate the charge transfer rate
  ket = (2*pi/hbar) * abs(Hab*q)^2 * (1/sqrt(4*pi*lambda*kBT*q)) * exp(-(lambda + deltaG - F * RCT * cos(theta))^2 / (4*lambda*kBT/q));
end

