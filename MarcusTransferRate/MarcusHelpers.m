classdef MarcusHelpers
    % MarcusHelpers - Utility class for common Marcus rate calculation operations
    %
    % This class provides static helper methods for:
    %   - Variable name formatting and parsing
    %   - Matrix preallocation and result construction
    %
    % Usage:
    %   var_name = MarcusHelpers.format_variable_name(lambda, RCT, 'kLECT');
    %   [lambda, RCT] = MarcusHelpers.parse_variable_name(field_name);
    %   result = MarcusHelpers.create_result_matrix(F_values, ket_matrix);
    %   matrix = MarcusHelpers.preallocate_ket_matrix(F_values, deltaG_values);
    
    methods (Static)
        function var_name = format_variable_name(lambda, RCT, prefix)
            % FORMAT_VARIABLE_NAME Creates a formatted variable name from lambda and RCT
            %
            % Inputs:
            %   lambda - Reorganization energy (eV)
            %   RCT - Transfer distance (m)
            %   prefix - String prefix for the variable name (e.g., 'kLECT', 'kCTLE')
            %
            % Output:
            %   var_name - Formatted variable name string
            %
            % Example:
            %   var_name = MarcusHelpers.format_variable_name(0.6, 1e-9, 'kLECT');
            %   % Returns: 'kLECT0610'
            
            % Format lambda: multiply by 10, format to 2 digits, remove decimal
            lambda_str = strrep(sprintf('%02.0f', lambda*10), '.', '');
            
            % Format RCT: convert to Angstroms (1e10), format to 2 digits, remove decimal
            RCT_str = strrep(sprintf('%02.0f', RCT*1e10), '.', '');
            
            % Construct the variable name
            var_name = [prefix lambda_str RCT_str];
        end
        
        function [lambda, RCT] = parse_variable_name(field_name)
            % PARSE_VARIABLE_NAME Extracts lambda and RCT values from a formatted field name
            %
            % Input:
            %   field_name - Formatted field name string (e.g., 'kLECT0515')
            %
            % Outputs:
            %   lambda - Reorganization energy (eV)
            %   RCT - Transfer distance (nm)
            %
            % Example:
            %   [lambda, RCT] = MarcusHelpers.parse_variable_name('kLECT0515');
            %   % Returns: lambda = 0.5, RCT = 1.5
            
            % Extract lambda string (positions 6-7 for typical field names)
            lambda_str = field_name(6:7);
            
            % Extract RCT string (remaining positions)
            RCT_str = field_name(8:end);
            
            % Convert to numeric values
            lambda = str2double(lambda_str) / 10;  % Convert back to eV
            RCT = str2double(RCT_str) / 10;        % Convert to nm
        end
        
        function result_matrix = create_result_matrix(F_values, ket_matrix)
            % CREATE_RESULT_MATRIX Concatenates F_values and ket_matrix
            %
            % Inputs:
            %   F_values - Column vector or row vector of electric field values
            %   ket_matrix - Matrix of charge transfer rates
            %
            % Output:
            %   result_matrix - Combined matrix with F_values as first column
            %
            % Example:
            %   result = MarcusHelpers.create_result_matrix(F_values, ket_matrix);
            
            % Ensure F_values is a column vector
            if size(F_values, 1) == 1
                F_values = F_values';
            end
            
            % Concatenate F_values with ket_matrix
            result_matrix = [F_values ket_matrix];
        end
        
        function ket_matrix = preallocate_ket_matrix(F_values, deltaG_values)
            % PREALLOCATE_KET_MATRIX Preallocates a zero matrix for ket calculations
            %
            % Inputs:
            %   F_values - Array of electric field values
            %   deltaG_values - Array of Gibbs free energy change values
            %
            % Output:
            %   ket_matrix - Preallocated zero matrix
            %
            % Example:
            %   matrix = MarcusHelpers.preallocate_ket_matrix(F_values, deltaG_values);
            
            ket_matrix = zeros(length(F_values), length(deltaG_values));
        end
    end
end
