% deviceparams_example.m
% Example implementation of centralized device parameters with thickness
%
% This file demonstrates the recommended pattern for managing thickness
% and other device parameters in a centralized class structure.

classdef deviceparams_example
    % DEVICEPARAMS_EXAMPLE Centralized device parameters
    %   This class serves as the single source of truth for all device
    %   parameters including layer thicknesses, material properties, and
    %   physical constants.
    %
    %   Example usage:
    %       dev = deviceparams_example();
    %       thickness = dev.Layers{1}.tp;  % Get layer 1 thickness
    %       % Use thickness in calculations
    
    properties
        % Layers - Cell array of layer structures
        %   Each layer contains:
        %     .tp - thickness in meters
        %     .material - material name
        %     .properties - material-specific properties
        Layers
        
        % Physical constants (CODATA 2018 values)
        physical_const
    end
    
    methods
        function obj = deviceparams_example()
            % Constructor - Initialize all device parameters
            %
            % Initialize physical constants
            obj.physical_const = struct();
            obj.physical_const.kB = 1.380649e-23;      % Boltzmann constant (J/K)
            obj.physical_const.T = 298;                 % Temperature (K)
            obj.physical_const.e = 1.602176634e-19;    % Elementary charge (C)
            obj.physical_const.epsilon0 = 8.8541878128e-12;  % Vacuum permittivity (F/m)
            obj.physical_const.hbar = 1.054571817e-34; % Reduced Planck constant (J·s)
            obj.physical_const.c = 299792458;          % Speed of light (m/s)
            
            % Initialize layers
            % Layer 1: Example organic semiconductor layer
            obj.Layers{1} = struct();
            obj.Layers{1}.tp = 100e-9;              % Thickness: 100 nm
            obj.Layers{1}.material = 'Organic-1';
            obj.Layers{1}.properties.lambda = 0.6;  % Reorganization energy (eV)
            obj.Layers{1}.properties.Hab = 0.01;    % Electronic coupling (eV)
            
            % Layer 2: Example acceptor layer
            obj.Layers{2} = struct();
            obj.Layers{2}.tp = 50e-9;               % Thickness: 50 nm
            obj.Layers{2}.material = 'TCNQ';
            obj.Layers{2}.properties.d_CT = 1.5e-10; % CT dipole length (m)
            obj.Layers{2}.properties.alpha = 85;     % Polarizability (Å³)
        end
        
        function thickness = getLayerThickness(obj, layer_index)
            % GETLAYERTHICKNESS Get thickness of specified layer
            %   thickness = dev.getLayerThickness(1) returns thickness of layer 1
            %
            %   Inputs:
            %       layer_index - Index of layer (1-based)
            %
            %   Outputs:
            %       thickness - Layer thickness in meters
            
            if layer_index < 1 || layer_index > length(obj.Layers)
                error('Invalid layer index: %d', layer_index);
            end
            
            thickness = obj.Layers{layer_index}.tp;
            
            % Validate thickness
            if thickness <= 0
                error('Layer %d has invalid thickness: %e', layer_index, thickness);
            end
        end
        
        function total_thickness = getTotalThickness(obj)
            % GETTOTALTHICKNESS Calculate total device thickness
            %   total = dev.getTotalThickness() sums all layer thicknesses
            %
            %   Outputs:
            %       total_thickness - Sum of all layer thicknesses (m)
            
            total_thickness = 0;
            for i = 1:length(obj.Layers)
                total_thickness = total_thickness + obj.Layers{i}.tp;
            end
        end
        
        function validateThickness(obj)
            % VALIDATETHICKNESS Validate all thickness values
            %   dev.validateThickness() checks that all layer thicknesses
            %   are positive and realistic
            
            for i = 1:length(obj.Layers)
                thickness = obj.Layers{i}.tp;
                
                % Check positive
                if thickness <= 0
                    error('Layer %d thickness must be positive: %e', i, thickness);
                end
                
                % Check realistic range (1 nm to 10 mm)
                if thickness < 1e-9 || thickness > 1e-2
                    warning('Layer %d thickness may be unrealistic: %e m', i, thickness);
                end
            end
        end
        
        function obj = setLayerThickness(obj, layer_index, thickness)
            % SETLAYERTHICKNESS Set thickness of specified layer
            %   dev = dev.setLayerThickness(1, 150e-9) sets layer 1 to 150 nm
            %
            %   Inputs:
            %       layer_index - Index of layer (1-based)
            %       thickness - New thickness in meters (must be positive)
            %
            %   Outputs:
            %       obj - Updated deviceparams object
            
            % Validate inputs
            validateattributes(thickness, {'numeric'}, ...
                {'positive', 'scalar', 'finite'}, ...
                'setLayerThickness', 'thickness');
            
            if layer_index < 1 || layer_index > length(obj.Layers)
                error('Invalid layer index: %d', layer_index);
            end
            
            % Set thickness
            obj.Layers{layer_index}.tp = thickness;
        end
    end
    
    methods (Static)
        function example()
            % EXAMPLE Demonstrate usage of deviceparams_example
            %
            %   deviceparams_example.example() runs demonstration
            
            fprintf('=== deviceparams_example Usage Demo ===\n\n');
            
            % Create device parameters
            dev = deviceparams_example();
            
            % Access layer thickness (RECOMMENDED WAY)
            fprintf('Layer 1 thickness: %.2f nm\n', dev.Layers{1}.tp * 1e9);
            fprintf('Layer 2 thickness: %.2f nm\n', dev.Layers{2}.tp * 1e9);
            
            % Use helper method
            fprintf('Layer 1 thickness (via method): %.2f nm\n', ...
                dev.getLayerThickness(1) * 1e9);
            
            % Total thickness
            fprintf('Total device thickness: %.2f nm\n', ...
                dev.getTotalThickness() * 1e9);
            
            % Access physical constants
            fprintf('\nPhysical Constants:\n');
            fprintf('  kB = %.4e J/K\n', dev.physical_const.kB);
            fprintf('  T = %.1f K\n', dev.physical_const.T);
            fprintf('  e = %.4e C\n', dev.physical_const.e);
            
            % Validate thickness
            fprintf('\nValidating thicknesses...\n');
            dev.validateThickness();
            fprintf('All thicknesses valid!\n');
            
            % Demonstrate updating thickness
            fprintf('\nUpdating layer 1 thickness to 150 nm...\n');
            dev = dev.setLayerThickness(1, 150e-9);
            fprintf('New layer 1 thickness: %.2f nm\n', dev.Layers{1}.tp * 1e9);
            
            fprintf('\n=== Demo Complete ===\n');
        end
    end
end
