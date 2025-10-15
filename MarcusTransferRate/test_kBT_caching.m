% test_kBT_caching.m
% Unit tests for Phase 3: kBT Caching implementation
%
% This test verifies that:
% 1. kBT is correctly cached in the physical_const structure
% 2. kBT equals kB * T
% 3. Marcus equation functions work with both old (T parameter) and new (DP structure) interfaces
% 4. Results are identical between old and new implementations

function test_kBT_caching()
  fprintf('Running kBT Caching Tests...\n\n');
  
  % Test 1: Verify kBT is correctly cached
  fprintf('Test 1: Verify kBT caching in deviceparams\n');
  DP = deviceparams();
  
  assert(isfield(DP, 'physical_const'), 'DP should have physical_const field');
  assert(isfield(DP.physical_const, 'kB'), 'physical_const should have kB field');
  assert(isfield(DP.physical_const, 'T'), 'physical_const should have T field');
  assert(isfield(DP.physical_const, 'kBT'), 'physical_const should have kBT field');
  
  % Test that kBT = kB * T
  expected_kBT = DP.physical_const.kB * DP.physical_const.T;
  assert(abs(DP.physical_const.kBT - expected_kBT) < 1e-30, ...
    sprintf('kBT should equal kB * T (expected: %.15e, got: %.15e)', expected_kBT, DP.physical_const.kBT));
  fprintf('  PASS: kBT = kB * T = %.15e\n\n', DP.physical_const.kBT);
  
  % Test 2: Verify backward compatibility for marcus_equation
  fprintf('Test 2: Verify marcus_equation backward compatibility\n');
  Hab = 0.01;
  lambda = 0.6;
  deltaG = -0.45;
  T = 298;
  F = 1e6;
  RCT = 1e-9;
  theta = 0;
  
  % Old interface (passing T as scalar)
  ket_old = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta);
  
  % New interface (passing DP structure)
  ket_new = marcus_equation(Hab, lambda, deltaG, DP, F, RCT, theta);
  
  % Results should be identical
  rel_error = abs(ket_new - ket_old) / ket_old;
  assert(rel_error < 1e-10, ...
    sprintf('Results should match (old: %.15e, new: %.15e, rel_error: %.15e)', ket_old, ket_new, rel_error));
  fprintf('  PASS: Old interface result: %.15e\n', ket_old);
  fprintf('  PASS: New interface result: %.15e\n', ket_new);
  fprintf('  PASS: Relative error: %.2e\n\n', rel_error);
  
  % Test 3: Verify backward compatibility for marcus_equation_stark
  fprintf('Test 3: Verify marcus_equation_stark backward compatibility\n');
  d_CT = 1.5e-10;
  
  % Old interface (passing T as scalar)
  ket_stark_old = marcus_equation_stark(Hab, lambda, deltaG, T, F, d_CT);
  
  % New interface (passing DP structure)
  ket_stark_new = marcus_equation_stark(Hab, lambda, deltaG, DP, F, d_CT);
  
  % Results should be identical
  rel_error_stark = abs(ket_stark_new - ket_stark_old) / ket_stark_old;
  assert(rel_error_stark < 1e-10, ...
    sprintf('Results should match (old: %.15e, new: %.15e, rel_error: %.15e)', ket_stark_old, ket_stark_new, rel_error_stark));
  fprintf('  PASS: Old interface result: %.15e\n', ket_stark_old);
  fprintf('  PASS: New interface result: %.15e\n', ket_stark_new);
  fprintf('  PASS: Relative error: %.2e\n\n', rel_error_stark);
  
  % Test 4: Verify kBT consistency across multiple calculations
  fprintf('Test 4: Verify kBT consistency in array calculations\n');
  F_values = [0, 1e6, 1e7, 1e8];
  deltaG_values = [-0.5, -0.3, 0, 0.3];
  
  for i = 1:length(F_values)
    for j = 1:length(deltaG_values)
      ket_old_val = marcus_equation(Hab, lambda, deltaG_values(j), T, F_values(i), RCT, theta);
      ket_new_val = marcus_equation(Hab, lambda, deltaG_values(j), DP, F_values(i), RCT, theta);
      
      rel_err = abs(ket_new_val - ket_old_val) / max(abs(ket_old_val), 1e-20);
      assert(rel_err < 1e-10, sprintf('Mismatch at F=%.2e, deltaG=%.2f', F_values(i), deltaG_values(j)));
    end
  end
  fprintf('  PASS: All %d calculations consistent\n\n', length(F_values) * length(deltaG_values));
  
  % Test 5: Verify other physical constants are accessible
  fprintf('Test 5: Verify all physical constants are available\n');
  assert(isfield(DP.physical_const, 'hbar'), 'physical_const should have hbar field');
  assert(isfield(DP.physical_const, 'q'), 'physical_const should have q field');
  assert(isfield(DP.physical_const, 'epsilon0'), 'physical_const should have epsilon0 field');
  fprintf('  PASS: hbar = %.15e J·s\n', DP.physical_const.hbar);
  fprintf('  PASS: q = %.15e C\n', DP.physical_const.q);
  fprintf('  PASS: epsilon0 = %.15e F/m\n', DP.physical_const.epsilon0);
  fprintf('  PASS: kB = %.15e J/K\n', DP.physical_const.kB);
  fprintf('  PASS: T = %.1f K\n', DP.physical_const.T);
  fprintf('  PASS: kBT = %.15e J\n\n', DP.physical_const.kBT);
  
  fprintf('======================\n');
  fprintf('All tests PASSED!\n');
  fprintf('======================\n');
end
