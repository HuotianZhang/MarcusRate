function ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta)
  % Constants
  hbar = 1.0546e-34;  % Reduced Planck constant (J s)
  k = 1.3806e-23;    % Boltzmann constant (J/K)
  q = 1.6022e-19;   % Elementary charge (coulomb)
  
  % Calculate the charge transfer rate
  ket = (2*pi/hbar) * abs(Hab*q)^2 * (1/sqrt(4*pi*lambda*k*T*q)) * exp(-(lambda + deltaG - F * RCT * cos(theta))^2 / (4*lambda*k*T/q));
end

