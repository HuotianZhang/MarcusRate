% test_MarcusHelpers.m
% Test script for MarcusHelpers utility class
%
% This script tests all helper methods in the MarcusHelpers class

fprintf('Testing MarcusHelpers utility class...\n\n');

%% Test 1: format_variable_name
fprintf('Test 1: format_variable_name\n');
lambda = 0.6;
RCT = 1e-9;
prefix = 'kLECT';
var_name = MarcusHelpers.format_variable_name(lambda, RCT, prefix);
expected = 'kLECT0610';
assert(strcmp(var_name, expected), 'Test 1 failed: Variable name mismatch');
fprintf('  Input: lambda=%.1f, RCT=%.0e, prefix=%s\n', lambda, RCT, prefix);
fprintf('  Output: %s\n', var_name);
fprintf('  Expected: %s\n', expected);
fprintf('  PASS\n\n');

%% Test 2: format_variable_name with different values
fprintf('Test 2: format_variable_name with different values\n');
lambda = 0.5;
RCT = 1.5e-9;
prefix = 'kCTLE';
var_name = MarcusHelpers.format_variable_name(lambda, RCT, prefix);
expected = 'kCTLE0515';
assert(strcmp(var_name, expected), 'Test 2 failed: Variable name mismatch');
fprintf('  Input: lambda=%.1f, RCT=%.1e, prefix=%s\n', lambda, RCT, prefix);
fprintf('  Output: %s\n', var_name);
fprintf('  Expected: %s\n', expected);
fprintf('  PASS\n\n');

%% Test 3: parse_variable_name
fprintf('Test 3: parse_variable_name\n');
field_name = 'kLECT0515';
[lambda, RCT] = MarcusHelpers.parse_variable_name(field_name);
expected_lambda = 0.5;
expected_RCT = 1.5;
assert(abs(lambda - expected_lambda) < 1e-10, 'Test 3 failed: Lambda mismatch');
assert(abs(RCT - expected_RCT) < 1e-10, 'Test 3 failed: RCT mismatch');
fprintf('  Input: %s\n', field_name);
fprintf('  Output: lambda=%.1f, RCT=%.1f\n', lambda, RCT);
fprintf('  Expected: lambda=%.1f, RCT=%.1f\n', expected_lambda, expected_RCT);
fprintf('  PASS\n\n');

%% Test 4: parse_variable_name roundtrip
fprintf('Test 4: parse_variable_name roundtrip test\n');
original_lambda = 0.6;
original_RCT = 1e-9;
var_name = MarcusHelpers.format_variable_name(original_lambda, original_RCT, 'kLECT');
[parsed_lambda, parsed_RCT_nm] = MarcusHelpers.parse_variable_name(var_name);
parsed_RCT = parsed_RCT_nm * 1e-9; % Convert nm back to m
assert(abs(parsed_lambda - original_lambda) < 1e-10, 'Test 4 failed: Lambda roundtrip');
assert(abs(parsed_RCT - original_RCT) < 1e-10, 'Test 4 failed: RCT roundtrip');
fprintf('  Original: lambda=%.1f, RCT=%.0e\n', original_lambda, original_RCT);
fprintf('  After roundtrip: lambda=%.1f, RCT=%.0e\n', parsed_lambda, parsed_RCT);
fprintf('  PASS\n\n');

%% Test 5: create_result_matrix with row vector
fprintf('Test 5: create_result_matrix with row vector\n');
F_values = [0, 1e6, 2e6, 3e6];
ket_matrix = rand(4, 3);
result = MarcusHelpers.create_result_matrix(F_values, ket_matrix);
assert(size(result, 1) == 4, 'Test 5 failed: Row count mismatch');
assert(size(result, 2) == 4, 'Test 5 failed: Column count mismatch');
assert(all(result(:, 1) == F_values'), 'Test 5 failed: F_values not in first column');
fprintf('  Input: F_values size [1x%d], ket_matrix size [%dx%d]\n', ...
    length(F_values), size(ket_matrix, 1), size(ket_matrix, 2));
fprintf('  Output size: [%dx%d]\n', size(result, 1), size(result, 2));
fprintf('  PASS\n\n');

%% Test 6: create_result_matrix with column vector
fprintf('Test 6: create_result_matrix with column vector\n');
F_values = (0:1e6:3e6)';
ket_matrix = rand(4, 3);
result = MarcusHelpers.create_result_matrix(F_values, ket_matrix);
assert(size(result, 1) == 4, 'Test 6 failed: Row count mismatch');
assert(size(result, 2) == 4, 'Test 6 failed: Column count mismatch');
assert(all(result(:, 1) == F_values), 'Test 6 failed: F_values not in first column');
fprintf('  Input: F_values size [%dx1], ket_matrix size [%dx%d]\n', ...
    length(F_values), size(ket_matrix, 1), size(ket_matrix, 2));
fprintf('  Output size: [%dx%d]\n', size(result, 1), size(result, 2));
fprintf('  PASS\n\n');

%% Test 7: preallocate_ket_matrix
fprintf('Test 7: preallocate_ket_matrix\n');
F_values = 0:1e6:1e8;
deltaG_values = 0:0.05:0.45;
ket_matrix = MarcusHelpers.preallocate_ket_matrix(F_values, deltaG_values);
expected_rows = length(F_values);
expected_cols = length(deltaG_values);
assert(size(ket_matrix, 1) == expected_rows, 'Test 7 failed: Row count mismatch');
assert(size(ket_matrix, 2) == expected_cols, 'Test 7 failed: Column count mismatch');
assert(all(ket_matrix(:) == 0), 'Test 7 failed: Matrix not all zeros');
fprintf('  Input: F_values length=%d, deltaG_values length=%d\n', ...
    expected_rows, expected_cols);
fprintf('  Output size: [%dx%d]\n', size(ket_matrix, 1), size(ket_matrix, 2));
fprintf('  PASS\n\n');

%% Summary
fprintf('========================================\n');
fprintf('All tests PASSED!\n');
fprintf('========================================\n');
