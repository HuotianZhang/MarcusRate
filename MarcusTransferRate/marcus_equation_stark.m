function ket = marcus_equation_stark(Hab, lambda, deltaG, T, F, d_CT)
  % MARCUS_EQUATION_STARK Calculate electron transfer rate with Stark effect
  %
  % Usage: ket = marcus_equation_stark(Hab, lambda, deltaG, T, F, d_CT)
  %        ket = marcus_equation_stark(Hab, lambda, deltaG, DP, F, d_CT)
  %
  % For improved performance, pass DP structure from deviceparams() as the 4th argument
  % to use cached kBT value instead of computing kB*T repeatedly.
  
  % Check if T is a structure (DP) or a scalar temperature
  if isstruct(T)
    DP = T;
    epsilon0 = DP.physical_const.epsilon0;
    hbar = DP.physical_const.hbar;
    kBT = DP.physical_const.kBT;  % Use cached kBT for performance
    q = DP.physical_const.q;
  else
    % Backward compatibility: use local constants
    epsilon0 = 8.854e-12; % (F/m)
    hbar = 1.0546e-34;  % Reduced Planck constant (J s)
    k = 1.3806e-23;    % Boltzmann constant (J/K)
    q = 1.6022e-19;   % Elementary charge (coulomb)
    kBT = k * T;  % Compute kBT from temperature
  end
  
  d_TCNQ = 1.5e-10; %(Å) excited state electric dipole length
  alpha_prime_TCNQ = 85; %(Å^3) cgs units ->SI units
  
  alpha_TCNQ = 4*pi*epsilon0*alpha_prime_TCNQ*1e-30; %Å^3 to m^3 (F m^2)
  alpha_CT = alpha_TCNQ*(d_CT/d_TCNQ)^4;
  deltaE_CT = -1/2*alpha_CT*F*abs(F)/q;


  % Calculate the charge transfer rate
  ket = (2*pi/hbar) * abs(Hab*q)^2 * (1/sqrt(4*pi*lambda*kBT*q)) * exp(-(lambda + deltaG + deltaE_CT).^2 / (4*lambda*kBT/q));

end

