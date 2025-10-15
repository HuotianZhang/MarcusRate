% marcus_equation_with_thickness.m
% Example refactored Marcus equation that accepts thickness as parameter
%
% This demonstrates Phase 2 pattern: thickness passed explicitly rather than
% being defined inside the function or retrieved from global state.

function ket = marcus_equation_with_thickness(Hab, lambda, deltaG, T, F, RCT, theta, thickness)
% MARCUS_EQUATION_WITH_THICKNESS Calculate charge transfer rate (Marcus theory)
%   ket = marcus_equation_with_thickness(Hab, lambda, deltaG, T, F, RCT, theta, thickness)
%
%   This is a refactored version that accepts thickness as an explicit parameter
%   rather than relying on global state or internal definitions.
%
%   Inputs:
%       Hab - Electronic coupling matrix element (eV)
%       lambda - Reorganization energy (eV)
%       deltaG - Standard Gibbs free energy change (eV)
%       T - Temperature (K)
%       F - Electric field (V/m)
%       RCT - Transfer distance (m)
%       theta - Angle between dipoles (radians)
%       thickness - Layer thickness (m) - PASSED EXPLICITLY
%
%   Outputs:
%       ket - Charge transfer rate (s^-1)
%
%   Example usage (RECOMMENDED PATTERN):
%       % Create device parameters (single source of truth)
%       dev = deviceparams_example();
%       
%       % Get thickness from centralized location
%       thickness = dev.Layers{1}.tp;
%       
%       % Call function with explicit thickness parameter
%       ket = marcus_equation_with_thickness(0.01, 0.6, -0.45, 298, 1e6, 1e-9, 0, thickness);
%
%   See also: deviceparams_example

    % Validate thickness input
    validateattributes(thickness, {'numeric'}, {'positive', 'scalar', 'finite'}, ...
        'marcus_equation_with_thickness', 'thickness', 8);
    
    % Physical constants (could also be passed from deviceparams)
    hbar = 1.0546e-34;  % Reduced Planck constant (J·s)
    k = 1.3806e-23;     % Boltzmann constant (J/K)
    q = 1.6022e-19;     % Elementary charge (C)
    epsilon0 = 8.854e-12; % Vacuum permittivity (F/m)
    
    % Material-specific parameters (example values)
    d_TCNQ = 1.5e-10;     % TCNQ excited state dipole length (m)
    alpha_prime_TCNQ = 85; % TCNQ polarizability (Å³)
    
    % Calculate polarizability in SI units
    alpha_TCNQ = 4*pi*epsilon0*alpha_prime_TCNQ*1e-30; % (F·m²)
    
    % Calculate CT state polarizability (scales with dipole length)
    d_CT = RCT; % Assume CT dipole length equals transfer distance
    alpha_CT = alpha_TCNQ * (d_CT/d_TCNQ)^4;
    
    % Stark shift correction
    deltaE_stark = -0.5 * alpha_CT * F^2 / q;
    
    % Dipole energy correction (angle-dependent)
    mu_CT = q * d_CT; % CT dipole moment
    deltaE_dipole = -mu_CT * F * cos(theta) / q;
    
    % Total energy correction
    deltaE_total = deltaE_stark + deltaE_dipole;
    
    % NOTE: thickness is now available as a parameter
    % It can be used in any thickness-dependent calculations
    % For this Marcus equation, thickness might affect field distribution
    % or charge density calculations in more complex models
    
    % Example: Field might be modified by thickness in real application
    % F_effective = F * reference_thickness / thickness;
    % For now, we use F directly as in original implementation
    
    % Marcus equation with energy corrections
    prefactor = (2*pi/hbar) * (Hab*q)^2;
    exponential_term = 1/sqrt(4*pi*lambda*k*T*q);
    activation = exp(-(lambda + deltaG + deltaE_total)^2 / (4*lambda*k*T/q));
    
    ket = prefactor * exponential_term * activation;
    
end

% Helper function to demonstrate usage pattern
function demo_usage()
    % DEMO_USAGE Demonstrate correct usage of thickness parameter
    
    fprintf('=== Marcus Equation with Thickness Demo ===\n\n');
    
    % Step 1: Create centralized device parameters
    fprintf('Step 1: Create device parameters (single source of truth)\n');
    dev = deviceparams_example();
    fprintf('  Device created with %d layers\n', length(dev.Layers));
    
    % Step 2: Get thickness from centralized location
    fprintf('\nStep 2: Get thickness from deviceparams.Layers{}.tp\n');
    thickness = dev.Layers{1}.tp;
    fprintf('  Layer 1 thickness: %.2f nm\n', thickness * 1e9);
    
    % Step 3: Define other parameters
    fprintf('\nStep 3: Define calculation parameters\n');
    Hab = 0.01;        % eV
    lambda = 0.6;      % eV
    deltaG = -0.45;    % eV
    T = 298;           % K
    F = 1e6;           % V/m
    RCT = 1e-9;        % m
    theta = 0;         % radians
    
    fprintf('  Hab = %.2f eV\n', Hab);
    fprintf('  lambda = %.2f eV\n', lambda);
    fprintf('  deltaG = %.2f eV\n', deltaG);
    fprintf('  T = %.0f K\n', T);
    fprintf('  F = %.2e V/m\n', F);
    fprintf('  RCT = %.2e m\n', RCT);
    
    % Step 4: Calculate transfer rate WITH thickness parameter
    fprintf('\nStep 4: Calculate transfer rate (passing thickness explicitly)\n');
    ket = marcus_equation_with_thickness(Hab, lambda, deltaG, T, F, RCT, theta, thickness);
    fprintf('  ket = %.4e s^-1\n', ket);
    
    % Step 5: Demonstrate thickness variation
    fprintf('\nStep 5: Demonstrate calculation with different thickness\n');
    thickness_new = 150e-9; % 150 nm
    ket_new = marcus_equation_with_thickness(Hab, lambda, deltaG, T, F, RCT, theta, thickness_new);
    fprintf('  With %.0f nm: ket = %.4e s^-1\n', thickness_new*1e9, ket_new);
    
    fprintf('\n=== Demo Complete ===\n');
    fprintf('\nKey Points:\n');
    fprintf('  ✓ Thickness defined once in deviceparams\n');
    fprintf('  ✓ Thickness passed explicitly to calculation\n');
    fprintf('  ✓ No hardcoded thickness values\n');
    fprintf('  ✓ Easy to vary thickness for parametric studies\n');
end
