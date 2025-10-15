# Phase 4 Helper Methods - Quick Reference Guide

## Quick Start

To use the new helper methods in your MATLAB code:

```matlab
% 1. Format a variable name
var_name = MarcusHelpers.format_variable_name(0.6, 1e-9, 'kLECT');
% Returns: 'kLECT0610'

% 2. Parse a variable name
[lambda, RCT] = MarcusHelpers.parse_variable_name('kLECT0515');
% Returns: lambda = 0.5 eV, RCT = 1.5 nm

% 3. Preallocate a matrix
ket_matrix = MarcusHelpers.preallocate_ket_matrix(F_values, deltaG_values);
% Returns: zeros matrix with correct dimensions

% 4. Create result matrix
result = MarcusHelpers.create_result_matrix(F_values, ket_matrix);
% Returns: [F_values' ket_matrix]
```

## Common Usage Patterns

### Pattern 1: Creating Variable Names in Loops

**Before:**
```matlab
lambda_str = strrep(sprintf('%02.0f', lambda*10), '.', '');
RCT_str = strrep(sprintf('%02.0f', RCT*1e10), '.', '');
kLECT_name = ['kLECT' lambda_str RCT_str];
```

**After:**
```matlab
kLECT_name = MarcusHelpers.format_variable_name(lambda, RCT, 'kLECT');
```

### Pattern 2: Extracting Parameters for Plotting

**Before:**
```matlab
lambda_str = field_name(6:7);
d_ct_str = field_name(8:end);
lambda = str2double(lambda_str)/10;
d_ct = str2double(d_ct_str)/10;
```

**After:**
```matlab
[lambda, d_ct] = MarcusHelpers.parse_variable_name(field_name);
```

### Pattern 3: Matrix Initialization

**Before:**
```matlab
ket_matrix = zeros(length(F_values), length(deltaG_values));
```

**After:**
```matlab
ket_matrix = MarcusHelpers.preallocate_ket_matrix(F_values, deltaG_values);
```

### Pattern 4: Building Result Matrices

**Before:**
```matlab
kLECT = [F_values' ket_matrix];
```

**After:**
```matlab
kLECT = MarcusHelpers.create_result_matrix(F_values, ket_matrix);
```

## Method Reference

| Method | Purpose | Input | Output |
|--------|---------|-------|--------|
| `format_variable_name` | Create field names | lambda (eV), RCT (m), prefix | string |
| `parse_variable_name` | Extract parameters | field_name | lambda (eV), RCT (nm) |
| `preallocate_ket_matrix` | Initialize matrix | F_values, deltaG_values | zeros matrix |
| `create_result_matrix` | Combine results | F_values, ket_matrix | combined matrix |

## Files Using Helper Methods

- ✅ Example1.m
- ✅ Example2.m  
- ✅ kBak_stark.m
- ✅ kDis_stark.m
- ✅ kDisExample2_Angle.m
- ✅ scanFnG.m
- ✅ scanFnG_Angle.m
- ✅ PlotMarcusRate.m
- ✅ PlotMarcusRate_CTLE.m
- ✅ name_test.m

## Testing

Run the test suite to verify functionality:

```matlab
run('test_MarcusHelpers.m')
```

Expected output:
```
Testing MarcusHelpers utility class...
Test 1: format_variable_name - PASS
Test 2: format_variable_name with different values - PASS
Test 3: parse_variable_name - PASS
Test 4: parse_variable_name roundtrip test - PASS
Test 5: create_result_matrix with row vector - PASS
Test 6: create_result_matrix with column vector - PASS
Test 7: preallocate_ket_matrix - PASS
========================================
All tests PASSED!
========================================
```

## Documentation

For detailed documentation, see:
- **HELPER_METHODS_DOC.md** - Complete API documentation
- **PHASE4_SUMMARY.md** - Phase 4 refactoring summary
- **MarcusHelpers.m** - Source code with inline documentation

## Support

If you encounter any issues:
1. Check the test suite passes: `run('test_MarcusHelpers.m')`
2. Review the documentation in HELPER_METHODS_DOC.md
3. Verify your input parameters match the expected types and units

## Benefits

✅ Less code duplication  
✅ Easier maintenance  
✅ Consistent behavior  
✅ Better readability  
✅ Reduced errors  
