classdef deviceparams
    % DEVICEPARAMS - Central repository for physical constants and device parameters
    % This class provides standardized physical constants based on CODATA 2018 values
    % and device-specific parameters for Marcus electron transfer rate calculations.
    %
    % Usage:
    %   DP = deviceparams();
    %   kb = DP.physical_const.kB;
    %   e = DP.physical_const.e;
    %
    % Properties:
    %   physical_const - Structure containing fundamental physical constants
    %
    % Physical Constants (CODATA 2018):
    %   kB       - Boltzmann constant (J/K)
    %   T        - Default temperature (K)
    %   e        - Elementary charge (C)
    %   hbar     - Reduced Planck constant (J·s)
    %   c        - Speed of light in vacuum (m/s)
    %   epsilon0 - Vacuum permittivity (F/m)
    %   h        - Planck constant (J·s)
    
    properties (Constant)
        physical_const = struct(...
            'kB', 1.380649e-23, ...        % Boltzmann constant (J/K) - CODATA 2018
            'T', 298, ...                   % Default temperature (K) - room temperature
            'e', 1.602176634e-19, ...       % Elementary charge (C) - CODATA 2018 exact
            'hbar', 1.054571817e-34, ...    % Reduced Planck constant (J·s) - CODATA 2018
            'c', 299792458, ...             % Speed of light in vacuum (m/s) - CODATA 2018 exact
            'epsilon0', 8.8541878128e-12, ...  % Vacuum permittivity (F/m) - CODATA 2018
            'h', 6.62607015e-34 ...         % Planck constant (J·s) - CODATA 2018 exact
        );
    end
    
    methods
        function obj = deviceparams()
            % Constructor for deviceparams class
            % No initialization needed as all constants are defined as class properties
        end
        
        function disp_constants(obj)
            % Display all physical constants with their values and units
            fprintf('Physical Constants (CODATA 2018):\n');
            fprintf('  kB       = %.10e J/K   (Boltzmann constant)\n', obj.physical_const.kB);
            fprintf('  T        = %.2f K          (Default temperature)\n', obj.physical_const.T);
            fprintf('  e        = %.10e C    (Elementary charge)\n', obj.physical_const.e);
            fprintf('  hbar     = %.10e J·s  (Reduced Planck constant)\n', obj.physical_const.hbar);
            fprintf('  c        = %.10e m/s  (Speed of light)\n', obj.physical_const.c);
            fprintf('  epsilon0 = %.10e F/m  (Vacuum permittivity)\n', obj.physical_const.epsilon0);
            fprintf('  h        = %.10e J·s  (Planck constant)\n', obj.physical_const.h);
        end
    end
end
