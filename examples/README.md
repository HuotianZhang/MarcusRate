# Phase 2: Thickness Cleanup Examples

This directory contains example implementations demonstrating the Phase 2 thickness cleanup refactoring pattern.

## Files

### 1. `deviceparams_example.m`
Complete example implementation of centralized device parameters class.

**Features:**
- Centralized `Layers{}.tp` thickness storage
- Physical constants (CODATA 2018)
- Helper methods for accessing and validating thickness
- Comprehensive documentation

**Usage:**
```matlab
% Create device parameters
dev = deviceparams_example();

% Access thickness (recommended pattern)
thickness = dev.Layers{1}.tp;

% Use helper methods
thickness = dev.getLayerThickness(1);
total = dev.getTotalThickness();

% Run built-in demo
deviceparams_example.example();
```

### 2. `marcus_equation_with_thickness.m`
Refactored Marcus equation that accepts thickness as an explicit parameter.

**Key Changes:**
- Thickness passed as function argument (not hardcoded)
- Validates thickness input
- Documents recommended usage pattern

**Usage:**
```matlab
% Get thickness from centralized location
dev = deviceparams_example();
thickness = dev.Layers{1}.tp;

% Call function with explicit thickness
ket = marcus_equation_with_thickness(Hab, lambda, deltaG, T, F, RCT, theta, thickness);
```

### 3. `test_thickness_handling.m`
Comprehensive unit test suite for thickness handling.

**Tests:**
- ✓ Thickness exists in deviceparams
- ✓ Thickness values are positive and realistic
- ✓ Getter/setter methods work correctly
- ✓ Invalid values are rejected
- ✓ Calculation methods accept thickness parameter
- ✓ Data flow is one-way (deviceparams → methods)

**Usage:**
```matlab
% Run all tests
runtests('test_thickness_handling')

% Or use test suite
results = test_thickness_handling();
table(results)
```

## Quick Start

### Run the Complete Demo

```matlab
% Add examples directory to path
addpath('examples');

% 1. See deviceparams in action
deviceparams_example.example();

% 2. Run thickness handling tests
runtests('test_thickness_handling');

% 3. Try the refactored Marcus equation
dev = deviceparams_example();
thickness = dev.Layers{1}.tp;
ket = marcus_equation_with_thickness(0.01, 0.6, -0.45, 298, 1e6, 1e-9, 0, thickness);
fprintf('Transfer rate: %.4e s^-1\n', ket);
```

## Design Patterns Demonstrated

### ✅ DO: Single Source of Truth
```matlab
% Define thickness once
dev = deviceparams_example();
dev.Layers{1}.tp = 100e-9;

% Use everywhere
thickness = dev.Layers{1}.tp;
result = calculation(params, thickness);
```

### ✅ DO: Pass Thickness Explicitly
```matlab
% Function signature includes thickness
function result = my_calculation(params, thickness)
    validateattributes(thickness, {'numeric'}, {'positive', 'scalar'});
    % Use thickness in calculation
    result = params.value * thickness;
end
```

### ✅ DO: One-Way Data Flow
```matlab
deviceparams → methods → results
   (source)    (read)    (output)
```

### ❌ DON'T: Hardcode Thickness
```matlab
% BAD - hardcoded magic number
function result = bad_calculation(params)
    thickness = 100e-9;  % Where did this come from?
    result = params.value * thickness;
end
```

### ❌ DON'T: Duplicate Thickness
```matlab
% BAD - thickness stored in multiple places
params.thickness = 100e-9;
device.thickness = 100e-9;  % Duplication!
```

### ❌ DON'T: Create Circular Dependencies
```matlab
% BAD - circular reference
paramsRec.deviceparams = dev;
dev.paramsRec = paramsRec;  % Circular!
```

## Refactoring Checklist

When applying this pattern to existing code:

- [ ] Create `deviceparams` class with `Layers{}.tp` property
- [ ] Remove `thickness` property from `paramsRec` and other classes
- [ ] Update method signatures to accept `thickness` parameter
- [ ] Update all callers to pass thickness from `deviceparams`
- [ ] Remove hardcoded thickness values
- [ ] Ensure one-way data flow (deviceparams → methods)
- [ ] Write unit tests for thickness handling
- [ ] Update documentation

## Testing Philosophy

The test suite (`test_thickness_handling.m`) verifies:

1. **Existence**: Thickness exists in the right place (deviceparams)
2. **Validity**: Thickness values are positive and realistic
3. **Accessibility**: Methods for getting/setting thickness work
4. **Rejection**: Invalid values are properly rejected
5. **Integration**: Calculation methods work with thickness parameter
6. **Architecture**: Data flows one way (no circular dependencies)

## Benefits of This Pattern

1. ✅ **Single Source of Truth** - Thickness defined once
2. ✅ **No Duplication** - Eliminates redundant definitions
3. ✅ **Clear Data Flow** - Easy to trace where thickness comes from
4. ✅ **Easier Maintenance** - Update in one place
5. ✅ **Better Testing** - Easy to test with different values
6. ✅ **No Circular Dependencies** - Clean architecture
7. ✅ **Type Safety** - Validation ensures correct values

## Integration with Existing Code

To integrate this pattern with your existing MarcusRate code:

1. **Create deviceparams class** (use `deviceparams_example.m` as template)
2. **Identify thickness usage** in existing files
3. **Refactor methods** to accept thickness parameter
4. **Update callers** to pass thickness from deviceparams
5. **Run tests** to verify correctness
6. **Update documentation**

## See Also

- `../PHASE2_THICKNESS_CLEANUP.md` - Complete refactoring guide
- `../MarcusTransferRate/marcus_equation.m` - Original Marcus equation
- `../MarcusTransferRate/marcus_equation_stark.m` - Marcus equation with Stark effect

## Questions or Issues?

This is example/reference code demonstrating the Phase 2 refactoring pattern.
Adapt it to your specific needs and existing code structure.
