% TEST_CONSTANTS_CONSISTENCY - Unit tests for physical constants consistency
%
% This test script verifies that all classes and functions use the same
% physical constants from the centralized deviceparams class.
%
% Tests performed:
%   1. Constants are accessible from deviceparams
%   2. Constants match CODATA 2018 standard values
%   3. marcus_equation uses centralized constants (no local definitions)
%   4. marcus_equation_stark uses centralized constants (no local definitions)
%   5. Consistency check across all usage
%
% Usage:
%   Run this script in MATLAB: test_constants_consistency
%
% Expected Output:
%   All tests should pass with "PASS" messages

fprintf('\n=== Testing Physical Constants Consistency ===\n\n');

% Initialize test counter
total_tests = 0;
passed_tests = 0;

%% Test 1: Verify deviceparams class is accessible and returns correct structure
fprintf('Test 1: Verify deviceparams class initialization...\n');
total_tests = total_tests + 1;
try
    DP = deviceparams();
    if isstruct(DP.physical_const)
        fprintf('  PASS: deviceparams initialized successfully\n');
        passed_tests = passed_tests + 1;
    else
        fprintf('  FAIL: physical_const is not a structure\n');
    end
catch ME
    fprintf('  FAIL: Error initializing deviceparams: %s\n', ME.message);
end

%% Test 2: Verify all required constants are present
fprintf('\nTest 2: Verify all required constants are present...\n');
required_fields = {'kB', 'T', 'e', 'hbar', 'c', 'epsilon0', 'h'};
total_tests = total_tests + 1;
try
    DP = deviceparams();
    all_present = true;
    for i = 1:length(required_fields)
        if ~isfield(DP.physical_const, required_fields{i})
            fprintf('  FAIL: Missing constant: %s\n', required_fields{i});
            all_present = false;
        end
    end
    if all_present
        fprintf('  PASS: All required constants present\n');
        passed_tests = passed_tests + 1;
    end
catch ME
    fprintf('  FAIL: Error checking constants: %s\n', ME.message);
end

%% Test 3: Verify constants match CODATA 2018 values
fprintf('\nTest 3: Verify constants match CODATA 2018 standards...\n');
total_tests = total_tests + 1;
try
    DP = deviceparams();
    codata_correct = true;
    
    % Check Boltzmann constant (exact value from CODATA 2018)
    if abs(DP.physical_const.kB - 1.380649e-23) > 1e-30
        fprintf('  FAIL: kB value incorrect\n');
        codata_correct = false;
    end
    
    % Check elementary charge (exact value from CODATA 2018)
    if abs(DP.physical_const.e - 1.602176634e-19) > 1e-28
        fprintf('  FAIL: e value incorrect\n');
        codata_correct = false;
    end
    
    % Check reduced Planck constant (CODATA 2018)
    if abs(DP.physical_const.hbar - 1.054571817e-34) > 1e-42
        fprintf('  FAIL: hbar value incorrect\n');
        codata_correct = false;
    end
    
    % Check vacuum permittivity (CODATA 2018)
    if abs(DP.physical_const.epsilon0 - 8.8541878128e-12) > 1e-20
        fprintf('  FAIL: epsilon0 value incorrect\n');
        codata_correct = false;
    end
    
    % Check speed of light (exact value)
    if DP.physical_const.c ~= 299792458
        fprintf('  FAIL: c value incorrect\n');
        codata_correct = false;
    end
    
    if codata_correct
        fprintf('  PASS: All constants match CODATA 2018 values\n');
        passed_tests = passed_tests + 1;
    end
catch ME
    fprintf('  FAIL: Error verifying CODATA values: %s\n', ME.message);
end

%% Test 4: Verify marcus_equation function uses centralized constants
fprintf('\nTest 4: Verify marcus_equation uses centralized constants...\n');
total_tests = total_tests + 1;
try
    % Read the marcus_equation.m file
    fid = fopen('marcus_equation.m', 'r');
    if fid == -1
        fprintf('  FAIL: Cannot open marcus_equation.m\n');
    else
        file_content = fread(fid, '*char')';
        fclose(fid);
        
        % Check that it references deviceparams
        has_deviceparams = contains(file_content, 'deviceparams()');
        
        % Check that it doesn't have hardcoded constants (old values)
        no_hardcoded_hbar = ~contains(file_content, '1.0546e-34');
        no_hardcoded_k = ~contains(file_content, '1.3806e-23');
        no_hardcoded_q = ~contains(file_content, '1.6022e-19');
        
        if has_deviceparams && no_hardcoded_hbar && no_hardcoded_k && no_hardcoded_q
            fprintf('  PASS: marcus_equation uses centralized constants\n');
            passed_tests = passed_tests + 1;
        else
            fprintf('  FAIL: marcus_equation still has hardcoded constants or missing deviceparams reference\n');
            if ~has_deviceparams
                fprintf('    - Missing deviceparams() call\n');
            end
            if ~no_hardcoded_hbar
                fprintf('    - Contains hardcoded hbar value\n');
            end
            if ~no_hardcoded_k
                fprintf('    - Contains hardcoded k value\n');
            end
            if ~no_hardcoded_q
                fprintf('    - Contains hardcoded q value\n');
            end
        end
    end
catch ME
    fprintf('  FAIL: Error checking marcus_equation: %s\n', ME.message);
end

%% Test 5: Verify marcus_equation_stark function uses centralized constants
fprintf('\nTest 5: Verify marcus_equation_stark uses centralized constants...\n');
total_tests = total_tests + 1;
try
    % Read the marcus_equation_stark.m file
    fid = fopen('marcus_equation_stark.m', 'r');
    if fid == -1
        fprintf('  FAIL: Cannot open marcus_equation_stark.m\n');
    else
        file_content = fread(fid, '*char')';
        fclose(fid);
        
        % Check that it references deviceparams
        has_deviceparams = contains(file_content, 'deviceparams()');
        
        % Check that it doesn't have hardcoded constants (old values)
        no_hardcoded_epsilon0 = ~contains(file_content, '8.854e-12');
        no_hardcoded_hbar = ~contains(file_content, '1.0546e-34');
        no_hardcoded_k = ~contains(file_content, '1.3806e-23');
        no_hardcoded_q = ~contains(file_content, '1.6022e-19');
        
        if has_deviceparams && no_hardcoded_epsilon0 && no_hardcoded_hbar && no_hardcoded_k && no_hardcoded_q
            fprintf('  PASS: marcus_equation_stark uses centralized constants\n');
            passed_tests = passed_tests + 1;
        else
            fprintf('  FAIL: marcus_equation_stark still has hardcoded constants or missing deviceparams reference\n');
            if ~has_deviceparams
                fprintf('    - Missing deviceparams() call\n');
            end
            if ~no_hardcoded_epsilon0
                fprintf('    - Contains hardcoded epsilon0 value\n');
            end
            if ~no_hardcoded_hbar
                fprintf('    - Contains hardcoded hbar value\n');
            end
            if ~no_hardcoded_k
                fprintf('    - Contains hardcoded k value\n');
            end
            if ~no_hardcoded_q
                fprintf('    - Contains hardcoded q value\n');
            end
        end
    end
catch ME
    fprintf('  FAIL: Error checking marcus_equation_stark: %s\n', ME.message);
end

%% Test 6: Functional test - verify marcus_equation still produces reasonable output
fprintf('\nTest 6: Functional test - marcus_equation produces reasonable output...\n');
total_tests = total_tests + 1;
try
    % Test parameters from Example1.m
    Hab = 0.01;       % Electronic coupling matrix element (eV)
    lambda = 0.6;     % Reorganization energy (eV)
    deltaG = -0.45;   % Standard Gibbs free energy change (eV)
    T = 298;          % Temperature (K)
    F = 1e6;          % Electric field (V/m)
    RCT = 1e-9;       % Transfer distance (m)
    theta = 0;        % Angle between two dipole (radians)
    
    ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta);
    
    % Check that result is a positive number (rate should be positive)
    if isfinite(ket) && ket > 0
        fprintf('  PASS: marcus_equation returns valid rate (%.3e s^-1)\n', ket);
        passed_tests = passed_tests + 1;
    else
        fprintf('  FAIL: marcus_equation returns invalid rate: %.3e\n', ket);
    end
catch ME
    fprintf('  FAIL: Error calling marcus_equation: %s\n', ME.message);
end

%% Test 7: Functional test - verify marcus_equation_stark still produces reasonable output
fprintf('\nTest 7: Functional test - marcus_equation_stark produces reasonable output...\n');
total_tests = total_tests + 1;
try
    % Test parameters
    Hab = 0.01;       % Electronic coupling matrix element (eV)
    lambda = 0.6;     % Reorganization energy (eV)
    deltaG = -0.45;   % Standard Gibbs free energy change (eV)
    T = 298;          % Temperature (K)
    F = 1e6;          % Electric field (V/m)
    d_CT = 1e-9;      % Charge transfer distance (m)
    
    ket = marcus_equation_stark(Hab, lambda, deltaG, T, F, d_CT);
    
    % Check that result is a positive number (rate should be positive)
    if isfinite(ket) && ket > 0
        fprintf('  PASS: marcus_equation_stark returns valid rate (%.3e s^-1)\n', ket);
        passed_tests = passed_tests + 1;
    else
        fprintf('  FAIL: marcus_equation_stark returns invalid rate: %.3e\n', ket);
    end
catch ME
    fprintf('  FAIL: Error calling marcus_equation_stark: %s\n', ME.message);
end

%% Summary
fprintf('\n=== Test Summary ===\n');
fprintf('Passed: %d/%d tests\n', passed_tests, total_tests);
if passed_tests == total_tests
    fprintf('SUCCESS: All constants consistency tests passed!\n\n');
else
    fprintf('FAILURE: Some tests failed. Please review the output above.\n\n');
end
