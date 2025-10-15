% Example_kBT_usage.m
% Demonstrates the new kBT caching feature (Phase 3)
%
% This example shows how to use the deviceparams structure with cached kBT
% for improved performance in Marcus equation calculations.

% Initialize device parameters with cached kBT
DP = deviceparams();

fprintf('=== Phase 3: kBT Caching Example ===\n\n');
fprintf('Physical Constants from deviceparams:\n');
fprintf('  kB  = %.4e J/K (Boltzmann constant)\n', DP.physical_const.kB);
fprintf('  T   = %.1f K (Temperature)\n', DP.physical_const.T);
fprintf('  kBT = %.4e J (Cached value)\n\n', DP.physical_const.kBT);

% Example parameters
Hab = 0.01;       % Electronic coupling matrix element (eV)
lambda = 0.6;     % Reorganization energy (eV)
deltaG = -0.45;   % Standard Gibbs free energy change (eV)
F = 1e6;          % Electric field (V/m)
RCT = 1e-9;       % Transfer distance (m)
theta = 0;        % Angle between two dipole (degree)

fprintf('Example Calculation Parameters:\n');
fprintf('  Hab    = %.2f eV\n', Hab);
fprintf('  lambda = %.2f eV\n', lambda);
fprintf('  deltaG = %.2f eV\n', deltaG);
fprintf('  F      = %.2e V/m\n', F);
fprintf('  RCT    = %.2e m\n', RCT);
fprintf('  theta  = %.0f degrees\n\n', theta);

% Calculate using the new DP structure (with cached kBT)
ket_new = marcus_equation(Hab, lambda, deltaG, DP, F, RCT, theta);

% For comparison, calculate using the old method (passing T directly)
T = 298;
ket_old = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta);

fprintf('Results:\n');
fprintf('  New method (with kBT caching): ket = %.6e s^-1\n', ket_new);
fprintf('  Old method (computing kB*T):   ket = %.6e s^-1\n', ket_old);
fprintf('  Difference: %.2e (%.4f%%)\n\n', abs(ket_new - ket_old), 100*abs(ket_new - ket_old)/ket_old);

% Demonstrate performance benefit with array calculations
fprintf('Performance Demonstration with Array Calculations:\n');
F_values = 0:1e6:1e8;
deltaG_values = 0:0.05:0.45;

fprintf('  Calculating %d x %d = %d values...\n', ...
  length(F_values), length(deltaG_values), length(F_values)*length(deltaG_values));

% Using new method with cached kBT
tic;
ket_matrix_new = zeros(length(F_values), length(deltaG_values));
for F_idx = 1:length(F_values)
  for dG_idx = 1:length(deltaG_values)
    ket_matrix_new(F_idx, dG_idx) = marcus_equation(Hab, lambda, -deltaG_values(dG_idx), DP, F_values(F_idx), RCT, theta);
  end
end
time_new = toc;

% Using old method (computing kB*T each time)
tic;
ket_matrix_old = zeros(length(F_values), length(deltaG_values));
for F_idx = 1:length(F_values)
  for dG_idx = 1:length(deltaG_values)
    ket_matrix_old(F_idx, dG_idx) = marcus_equation(Hab, lambda, -deltaG_values(dG_idx), T, F_values(F_idx), RCT, theta);
  end
end
time_old = toc;

fprintf('  New method time: %.6f seconds\n', time_new);
fprintf('  Old method time: %.6f seconds\n', time_old);
if time_old > time_new
  fprintf('  Performance improvement: %.2f%%\n\n', 100*(time_old-time_new)/time_old);
else
  fprintf('  Note: Performance difference is minimal for small calculations\n\n');
end

% Verify results are identical
max_diff = max(abs(ket_matrix_new(:) - ket_matrix_old(:)));
fprintf('Maximum difference in results: %.2e\n', max_diff);
fprintf('Results are identical: %s\n\n', iif(max_diff < 1e-10, 'YES', 'NO'));

fprintf('=== Example Complete ===\n');

% Helper function for inline if
function result = iif(condition, true_val, false_val)
  if condition
    result = true_val;
  else
    result = false_val;
  end
end
