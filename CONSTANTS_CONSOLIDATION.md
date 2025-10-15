# Physical Constants Consolidation - Documentation

## Overview

This document describes the consolidation of physical constants in the MarcusRate project. All physical constants have been centralized in the `deviceparams.m` class to ensure consistency, maintainability, and compliance with CODATA 2018 standards.

## Centralized Constants Class: `deviceparams.m`

### Purpose
The `deviceparams` class serves as the single source of truth for all physical constants used in Marcus electron transfer rate calculations.

### Usage

```matlab
% Initialize the deviceparams class
DP = deviceparams();

% Access physical constants
kB = DP.physical_const.kB;          % Boltzmann constant (J/K)
e = DP.physical_const.e;            % Elementary charge (C)
hbar = DP.physical_const.hbar;      % Reduced Planck constant (J·s)
epsilon0 = DP.physical_const.epsilon0;  % Vacuum permittivity (F/m)

% Display all constants
DP.disp_constants();
```

### Available Constants

All constants conform to **CODATA 2018** standards:

| Constant | Symbol | Value | Units | Description |
|----------|--------|-------|-------|-------------|
| `kB` | k_B | 1.380649×10⁻²³ | J/K | Boltzmann constant (exact) |
| `e` | e | 1.602176634×10⁻¹⁹ | C | Elementary charge (exact) |
| `hbar` | ℏ | 1.054571817×10⁻³⁴ | J·s | Reduced Planck constant |
| `epsilon0` | ε₀ | 8.8541878128×10⁻¹² | F/m | Vacuum permittivity |
| `c` | c | 299792458 | m/s | Speed of light in vacuum (exact) |
| `h` | h | 6.62607015×10⁻³⁴ | J·s | Planck constant (exact) |
| `T` | T | 298 | K | Default temperature (room temp) |

## Refactored Functions

### 1. `marcus_equation.m`

**Before:**
```matlab
function ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta)
  % Constants
  hbar = 1.0546e-34;  % Reduced Planck constant (J s)
  k = 1.3806e-23;    % Boltzmann constant (J/K)
  q = 1.6022e-19;   % Elementary charge (coulomb)
  ...
```

**After:**
```matlab
function ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta)
  % Get physical constants from centralized deviceparams class
  DP = deviceparams();
  hbar = DP.physical_const.hbar;  % Reduced Planck constant (J·s)
  k = DP.physical_const.kB;       % Boltzmann constant (J/K)
  q = DP.physical_const.e;        % Elementary charge (C)
  ...
```

### 2. `marcus_equation_stark.m`

**Before:**
```matlab
function ket = marcus_equation_stark(Hab, lambda, deltaG, T, F, d_CT)
  % Constants
  epsilon0 = 8.854e-12; % (F/m)
  hbar = 1.0546e-34;  % Reduced Planck constant (J s)
  k = 1.3806e-23;    % Boltzmann constant (J/K)
  q = 1.6022e-19;   % Elementary charge (coulomb)
  ...
```

**After:**
```matlab
function ket = marcus_equation_stark(Hab, lambda, deltaG, T, F, d_CT)
  % Get physical constants from centralized deviceparams class
  DP = deviceparams();
  epsilon0 = DP.physical_const.epsilon0;  % Vacuum permittivity (F/m)
  hbar = DP.physical_const.hbar;          % Reduced Planck constant (J·s)
  k = DP.physical_const.kB;               % Boltzmann constant (J/K)
  q = DP.physical_const.e;                % Elementary charge (C)
  ...
```

## Changes from Previous Values

The following constants were updated to match CODATA 2018 standards:

| Constant | Old Value | New Value (CODATA 2018) | Change |
|----------|-----------|-------------------------|--------|
| hbar | 1.0546×10⁻³⁴ | 1.054571817×10⁻³⁴ | More precise |
| kB | 1.3806×10⁻²³ | 1.380649×10⁻²³ | More precise (exact) |
| e | 1.6022×10⁻¹⁹ | 1.602176634×10⁻¹⁹ | More precise (exact) |
| epsilon0 | 8.854×10⁻¹² | 8.8541878128×10⁻¹² | More precise |

Note: The changes are very small (less than 0.01%) and should not significantly affect existing calculations.

## Testing

### Unit Tests: `test_constants_consistency.m`

A comprehensive test suite verifies:

1. ✅ `deviceparams` class initializes correctly
2. ✅ All required constants are present
3. ✅ Constants match CODATA 2018 values
4. ✅ `marcus_equation` uses centralized constants (no hardcoded values)
5. ✅ `marcus_equation_stark` uses centralized constants (no hardcoded values)
6. ✅ Functions produce valid numerical outputs
7. ✅ Backward compatibility is maintained

**Running the tests:**
```matlab
cd MarcusTransferRate
test_constants_consistency
```

## Benefits of Consolidation

1. **Consistency**: All functions use identical constant values
2. **Maintainability**: Constants defined in one location only
3. **Standards Compliance**: All values conform to CODATA 2018
4. **Precision**: Higher precision values available when needed
5. **Documentation**: Clear documentation of constant sources
6. **Extensibility**: Easy to add new constants in the future

## Backward Compatibility

The refactoring maintains full backward compatibility:
- Function signatures unchanged
- Function behavior unchanged (within numerical precision)
- Existing scripts continue to work without modification
- Results differ by less than 0.01% due to increased precision

## Future Enhancements

Potential future improvements:
1. Add material-specific constants (e.g., TCNQ parameters) to `deviceparams`
2. Support for multiple temperature defaults
3. Version tracking for constant values (CODATA year)
4. Unit conversion utilities

## References

- [CODATA 2018 Fundamental Physical Constants](https://physics.nist.gov/cuu/Constants/)
- Marcus, R. A. (1956). "On the Theory of Oxidation‐Reduction Reactions Involving Electron Transfer. I". *Journal of Chemical Physics*. 24 (5): 966–978.

## Revision History

| Date | Version | Changes |
|------|---------|---------|
| 2025-10-15 | 1.0 | Initial consolidation of physical constants |
