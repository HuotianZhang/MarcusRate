# MarcusHelpers - Helper Methods Documentation

## Overview

`MarcusHelpers` is a utility class that provides static helper methods for common operations in Marcus rate calculations. This class was created as part of Phase 4 refactoring to eliminate repeated code patterns across the codebase.

## Purpose

The helper methods centralize common operations that were previously duplicated across multiple files, including:
- Variable name formatting based on lambda and RCT values
- Parsing variable names to extract parameters
- Matrix preallocation for efficiency
- Result matrix construction

## Class Methods

### 1. `format_variable_name(lambda, RCT, prefix)`

Creates a formatted variable name from reorganization energy (lambda) and transfer distance (RCT).

**Parameters:**
- `lambda` (double): Reorganization energy in eV
- `RCT` (double): Transfer distance in meters
- `prefix` (string): String prefix for the variable name (e.g., 'kLECT', 'kCTLE')

**Returns:**
- `var_name` (string): Formatted variable name

**Example:**
```matlab
var_name = MarcusHelpers.format_variable_name(0.6, 1e-9, 'kLECT');
% Returns: 'kLECT0610'
```

**Format Details:**
- Lambda is multiplied by 10 and formatted to 2 digits
- RCT is converted to Angstroms (×10¹⁰) and formatted to 2 digits
- Both values have decimal points removed
- Format: `[prefix][lambda_formatted][RCT_formatted]`

---

### 2. `parse_variable_name(field_name)`

Extracts lambda and RCT values from a formatted field name.

**Parameters:**
- `field_name` (string): Formatted field name (e.g., 'kLECT0515')

**Returns:**
- `lambda` (double): Reorganization energy in eV
- `RCT` (double): Transfer distance in nanometers

**Example:**
```matlab
[lambda, RCT] = MarcusHelpers.parse_variable_name('kLECT0515');
% Returns: lambda = 0.5 eV, RCT = 1.5 nm
```

**Note:** This method is the inverse of `format_variable_name`, except RCT is returned in nanometers for convenience in plotting.

---

### 3. `create_result_matrix(F_values, ket_matrix)`

Concatenates electric field values with the charge transfer rate matrix.

**Parameters:**
- `F_values` (array): Column or row vector of electric field values
- `ket_matrix` (matrix): Matrix of charge transfer rates

**Returns:**
- `result_matrix` (matrix): Combined matrix with F_values as first column

**Example:**
```matlab
F_values = 0:1e6:1e8;
ket_matrix = zeros(101, 10);  % After calculations
result = MarcusHelpers.create_result_matrix(F_values, ket_matrix);
% result(:,1) contains F_values
% result(:,2:end) contains ket_matrix
```

**Details:**
- Automatically converts row vectors to column vectors
- Ensures proper concatenation regardless of input format

---

### 4. `preallocate_ket_matrix(F_values, deltaG_values)`

Preallocates a zero matrix for charge transfer rate calculations.

**Parameters:**
- `F_values` (array): Array of electric field values
- `deltaG_values` (array): Array of Gibbs free energy change values

**Returns:**
- `ket_matrix` (matrix): Preallocated zero matrix

**Example:**
```matlab
F_values = 0:1e6:1e8;
deltaG_values = 0:0.05:0.45;
ket_matrix = MarcusHelpers.preallocate_ket_matrix(F_values, deltaG_values);
% Returns: 101×10 zero matrix
```

**Benefits:**
- Improves performance by preallocating memory
- Eliminates repeated `zeros(length(...), length(...))` calls
- Clearer intent in code

---

## Usage in Refactored Files

The helper methods are used in the following files:

### Variable Name Formatting
- `Example1.m`
- `Example2.m`
- `kBak_stark.m`
- `kDis_stark.m`
- `kDisExample2_Angle.m`
- `name_test.m`

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

### Variable Name Parsing
- `PlotMarcusRate.m`
- `PlotMarcusRate_CTLE.m`

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

### Matrix Preallocation
- `Example1.m`
- `kBak_stark.m`
- `kDis_stark.m`
- `scanFnG.m`
- `scanFnG_Angle.m`

**Before:**
```matlab
ket_matrix = zeros(length(F_values), length(deltaG_values));
```

**After:**
```matlab
ket_matrix = MarcusHelpers.preallocate_ket_matrix(F_values, deltaG_values);
```

### Result Matrix Creation
- `Example1.m`
- `kBak_stark.m`
- `kDis_stark.m`
- `scanFnG.m`
- `scanFnG_Angle.m`

**Before:**
```matlab
kLECT = [F_values' ket_matrix];
```

**After:**
```matlab
kLECT = MarcusHelpers.create_result_matrix(F_values, ket_matrix);
```

---

## Testing

A comprehensive test file `test_MarcusHelpers.m` is provided to verify the functionality of all helper methods. The test includes:

1. Variable name formatting with standard values
2. Variable name formatting with different values
3. Variable name parsing
4. Roundtrip test (format → parse → compare)
5. Result matrix creation with row vector
6. Result matrix creation with column vector
7. Matrix preallocation

To run the tests:
```matlab
run('test_MarcusHelpers.m')
```

---

## Benefits of Refactoring

### Code Reduction
- Eliminated ~58 lines of duplicated code across the repository
- Reduced complexity in individual files

### Maintainability
- Single source of truth for common operations
- Changes to logic only need to be made in one place
- Easier to debug and test

### Readability
- Self-documenting method names
- Clear intent of operations
- Reduced cognitive load when reading code

### Consistency
- Ensures all files use the same formatting rules
- Prevents inconsistencies from manual duplication
- Standardized error handling

---

## Implementation Notes

### Design Decisions

1. **Static Methods**: All methods are static because they don't require instance state and can be called directly on the class.

2. **Separate Formatting and Parsing**: Although these are inverse operations, they are kept separate for clarity and single responsibility.

3. **Unit Conversion**: `parse_variable_name` returns RCT in nanometers (not meters) because this is the most common unit used in plotting code.

4. **Input Flexibility**: `create_result_matrix` handles both row and column vectors for F_values to prevent common errors.

### Future Enhancements

Potential additions to the helper class:
- Constants management (Hab, T, etc.)
- Common plotting parameter calculations
- Input validation and error checking
- Support for different variable name prefixes and formats

---

## Version History

- **v1.0** (Phase 4): Initial implementation with four core helper methods
  - `format_variable_name`
  - `parse_variable_name`
  - `create_result_matrix`
  - `preallocate_ket_matrix`

---

## See Also

- `marcus_equation.m` - Main Marcus equation implementation
- `marcus_equation_stark.m` - Stark effect variant
- Phase 4 refactoring documentation
