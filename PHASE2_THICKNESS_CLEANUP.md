# Phase 2: Thickness Cleanup

## Overview
This document describes the refactoring pattern for cleaning up thickness parameter handling in the MarcusRate codebase. The goal is to eliminate redundant thickness definitions and centralize thickness management in the `deviceparams` class.

## Problem Statement
Currently, thickness parameters may be defined in multiple locations:
- `paramsRec.m` (duplicated definitions)
- Individual calculation methods
- Workflow scripts

This creates:
- **Redundancy**: Same parameter defined in multiple places
- **Inconsistency**: Potential for different values across classes
- **Circular Dependencies**: Classes depending on each other for thickness data
- **Maintenance Issues**: Updates required in multiple locations

## Solution: Centralized Thickness Management

### 1. Single Source of Truth
**Centralize thickness in `deviceparams.Layers{}.tp`**

```matlab
% deviceparams.m - Centralized thickness definition
classdef deviceparams
    properties
        Layers  % Cell array of layer structures
    end
    
    methods
        function obj = deviceparams()
            % Initialize layers with thickness property (tp)
            obj.Layers{1}.tp = 100e-9;  % Layer 1 thickness in meters
            obj.Layers{2}.tp = 50e-9;   % Layer 2 thickness in meters
        end
    end
end
```

### 2. Remove Thickness from paramsRec.m
**Before:**
```matlab
% paramsRec.m - BAD: Duplicated thickness definition
classdef paramsRec
    properties
        tickness  % Typo in original
        thickness
    end
    
    methods
        function obj = paramsRec()
            obj.tickness = 100e-9;
            obj.thickness = 100e-9;
        end
    end
end
```

**After:**
```matlab
% paramsRec.m - GOOD: No thickness definitions
classdef paramsRec
    properties
        % Other properties, but NO thickness
    end
    
    methods
        function obj = paramsRec(deviceparams)
            % Access thickness from deviceparams if needed
            % but don't store it locally
        end
    end
end
```

### 3. Update Methods to Accept Thickness

**Before:**
```matlab
% calculation_method.m - BAD: Hardcoded thickness
function result = calculate_something(params)
    thickness = 100e-9;  % Hardcoded
    result = params.value * thickness;
end
```

**After:**
```matlab
% calculation_method.m - GOOD: Thickness as parameter
function result = calculate_something(params, thickness)
    % Accept thickness as input parameter
    result = params.value * thickness;
end

% Usage:
% result = calculate_something(params, deviceparams.Layers{1}.tp);
```

### 4. Update Workflow Scripts

**Before:**
```matlab
% workflow.m - BAD: Defines thickness locally
thickness = 100e-9;
params = paramsRec();
params.thickness = thickness;
result = calculate_something(params);
```

**After:**
```matlab
% workflow.m - GOOD: Uses centralized thickness
dev = deviceparams();
params = paramsRec(dev);
result = calculate_something(params, dev.Layers{1}.tp);
```

## Implementation Checklist

### Task 1: Identify All Thickness References
- [ ] Search for all instances of `thickness` or `tickness` in `paramsRec.m`
- [ ] Search for all instances in method files
- [ ] Search for all instances in workflow scripts
- [ ] Document each occurrence and its usage

### Task 2: Remove from paramsRec.m
- [ ] Delete `thickness` property from `paramsRec.m`
- [ ] Delete `tickness` property (typo) from `paramsRec.m`
- [ ] Remove any thickness initialization in constructor
- [ ] Remove any thickness-related methods

### Task 3: Centralize in deviceparams
- [ ] Ensure `deviceparams.m` has `Layers` property
- [ ] Ensure each layer in `Layers` has `tp` (thickness) property
- [ ] Document expected units (meters recommended)
- [ ] Add validation for positive thickness values

### Task 4: Update Method Signatures
- [ ] Add thickness parameter to methods that need it
- [ ] Update method documentation to specify thickness parameter
- [ ] Ensure backward compatibility if needed

### Task 5: Update All Callers
- [ ] Update workflow scripts to pass thickness from `deviceparams`
- [ ] Update test scripts
- [ ] Update example scripts
- [ ] Ensure no hardcoded thickness values remain

### Task 6: Remove Circular Dependencies
- [ ] Trace data flow: deviceparams → methods (one direction only)
- [ ] Ensure paramsRec doesn't write back to deviceparams
- [ ] Document the one-way dependency chain

### Task 7: Testing
- [ ] Write unit test for thickness consistency
- [ ] Verify calculations produce same results
- [ ] Test with different thickness values
- [ ] Verify no circular dependency exists

### Task 8: Documentation
- [ ] Update inline comments
- [ ] Update method documentation
- [ ] Add examples of proper thickness usage
- [ ] Reference this refactoring document

## Data Flow Architecture

```
deviceparams.Layers{}.tp (Source of Truth)
          |
          v
    Methods/Functions (Read-only access)
          |
          v
      Calculations
          |
          v
       Results
```

**Key Principle**: Thickness flows ONE WAY from `deviceparams` outward.

## Testing Strategy

### Unit Test Example
```matlab
% test_thickness_handling.m
function tests = test_thickness_handling
    tests = functiontests(localfunctions);
end

function testThicknessConsistency(testCase)
    % Create deviceparams
    dev = deviceparams();
    
    % Verify thickness is accessible
    thickness = dev.Layers{1}.tp;
    testCase.verifyGreaterThan(thickness, 0, 'Thickness must be positive');
    
    % Verify paramsRec doesn't have thickness
    params = paramsRec(dev);
    testCase.verifyFalse(isprop(params, 'thickness'), ...
        'paramsRec should not have thickness property');
    testCase.verifyFalse(isprop(params, 'tickness'), ...
        'paramsRec should not have tickness property');
end

function testCalculationWithThickness(testCase)
    % Test that calculations work with new pattern
    dev = deviceparams();
    params = paramsRec(dev);
    
    % Example calculation passing thickness explicitly
    result = calculate_something(params, dev.Layers{1}.tp);
    
    % Verify result is reasonable
    testCase.verifyNotEmpty(result);
end
```

### Integration Test
```matlab
% test_thickness_integration.m
function testFullWorkflow(testCase)
    % Test complete workflow with centralized thickness
    dev = deviceparams();
    params = paramsRec(dev);
    
    % Run full simulation
    results = run_simulation(params, dev);
    
    % Verify results match expected behavior
    testCase.verifyEqual(results.thickness_used, dev.Layers{1}.tp);
end
```

## Migration Path

### Step 1: Dual Support (Temporary)
```matlab
% Support both old and new patterns temporarily
function result = calculate_something(params, thickness)
    if nargin < 2
        % Fallback for old callers (deprecated)
        warning('Please pass thickness explicitly');
        thickness = params.thickness;  % Old way
    end
    result = params.value * thickness;
end
```

### Step 2: Deprecation Warning
```matlab
% Add deprecation warnings
if isprop(params, 'thickness')
    warning('THICKNESS:DEPRECATED', ...
        'Thickness in paramsRec is deprecated. Use deviceparams.Layers{}.tp');
end
```

### Step 3: Complete Migration
```matlab
% Remove all backward compatibility code
function result = calculate_something(params, thickness)
    % thickness must be provided
    validateattributes(thickness, {'numeric'}, {'positive', 'scalar'});
    result = params.value * thickness;
end
```

## Common Pitfalls

### ❌ DON'T: Copy thickness to multiple objects
```matlab
params.thickness = dev.Layers{1}.tp;  % Creates duplicate
```

### ✅ DO: Pass thickness when needed
```matlab
result = method(params, dev.Layers{1}.tp);  % One source
```

### ❌ DON'T: Hardcode thickness values
```matlab
thickness = 100e-9;  % Magic number
```

### ✅ DO: Define in deviceparams only
```matlab
dev.Layers{1}.tp = 100e-9;  % Centralized
```

### ❌ DON'T: Create circular references
```matlab
paramsRec.deviceparams = dev;
dev.paramsRec = params;  % Circular!
```

### ✅ DO: One-way dependency
```matlab
% deviceparams is independent
% paramsRec can reference deviceparams
% but deviceparams doesn't reference paramsRec
```

## Benefits After Refactoring

1. **Single Source of Truth**: Thickness defined in one place only
2. **No Duplication**: Eliminates redundant thickness properties
3. **Clear Data Flow**: Easy to trace where thickness comes from
4. **Easier Maintenance**: Update thickness in one location
5. **No Circular Dependencies**: Clean architecture
6. **Better Testing**: Easy to test with different thickness values
7. **Consistent Values**: Impossible to have conflicting thickness values

## References

- CODATA recommended values for physical constants
- MATLAB best practices for object-oriented design
- Clean Code principles for reducing duplication

## Revision History

- 2025-10-15: Initial documentation created for Phase 2 refactoring
