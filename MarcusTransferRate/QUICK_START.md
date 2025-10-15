# Quick Start Guide - Phase 3: kBT Caching

## What Changed?

Phase 3 introduces **kBT caching** to improve performance by pre-computing the thermal energy (Boltzmann constant × Temperature) instead of calculating it repeatedly.

## For Users: How to Use

### Option 1: Use New Interface (Recommended)

```matlab
% Initialize device parameters once
DP = deviceparams();

% Use DP instead of T in Marcus equation calls
ket = marcus_equation(Hab, lambda, deltaG, DP, F, RCT, theta);
ket_stark = marcus_equation_stark(Hab, lambda, deltaG, DP, F, d_CT);
```

**Benefits**: Faster execution, consistent constants, easier temperature changes

### Option 2: Keep Using Old Interface

```matlab
% Your existing code still works without any changes!
T = 298;
ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta);
ket_stark = marcus_equation_stark(Hab, lambda, deltaG, T, F, d_CT);
```

**Note**: No breaking changes - all existing code continues to work

## Testing Your Code

Run the test suite to verify everything works:

```matlab
% In MATLAB:
cd MarcusTransferRate
run_tests
```

Expected output: All 5 tests should PASS

## Example Usage

See a complete working example:

```matlab
% In MATLAB:
cd MarcusTransferRate
Example_kBT_usage
```

This will:
- Show how to use the new DP structure
- Compare old vs new methods
- Benchmark performance
- Verify identical results

## Files to Know About

| File | Purpose |
|------|---------|
| `deviceparams.m` | Creates DP structure with cached kBT |
| `test_kBT_caching.m` | Test suite (5 tests) |
| `run_tests.m` | Easy test runner |
| `Example_kBT_usage.m` | Working example with benchmarks |
| `kBT_CACHING_README.md` | Full documentation |
| `IMPLEMENTATION_SUMMARY.md` | Technical details |
| `REQUIREMENTS_CHECKLIST.md` | Verification of requirements |

## What's in deviceparams?

```matlab
DP = deviceparams();
DP.physical_const
```

Returns:
- `hbar` - Reduced Planck constant (J·s)
- `kB` - Boltzmann constant (J/K)
- `q` - Elementary charge (C)
- `epsilon0` - Permittivity (F/m)
- `T` - Temperature (K, default 298)
- `kBT` - **Cached thermal energy (J)** ← New!

## Migration Path

### Migrating Existing Scripts

**Before:**
```matlab
T = 298;
for i = 1:n
    ket = marcus_equation(Hab, lambda, deltaG, T, F, RCT, theta);
    % ... use ket ...
end
```

**After:**
```matlab
DP = deviceparams();  % Initialize once
for i = 1:n
    ket = marcus_equation(Hab, lambda, deltaG, DP, F, RCT, theta);
    % ... use ket ...
end
```

**Benefit**: Faster execution in loops (no repeated k*T calculations)

## Need Help?

1. **Read the full guide**: `kBT_CACHING_README.md`
2. **Check the example**: `Example_kBT_usage.m`
3. **Run the tests**: `run_tests`
4. **Review implementation**: `IMPLEMENTATION_SUMMARY.md`

## FAQ

**Q: Do I need to change my existing code?**  
A: No! Backward compatibility is maintained. But migrating is recommended for better performance.

**Q: What if I want a different temperature?**  
A: Edit `deviceparams.m` line 11, or create your own DP structure:
```matlab
DP = deviceparams();
DP.physical_const.T = 350;  % Your temperature
DP.physical_const.kBT = DP.physical_const.kB * DP.physical_const.T;
```

**Q: How much faster is the new method?**  
A: Run `Example_kBT_usage.m` to benchmark on your system. Performance gain depends on loop iterations.

**Q: Are the results identical?**  
A: Yes! Tests verify that both methods produce identical results (within numerical precision).

**Q: Can I use both interfaces in the same script?**  
A: Yes! The functions automatically detect which interface you're using.

## Summary

✅ **No action required** - existing code works  
✅ **Optional migration** - for better performance  
✅ **Fully tested** - 5 comprehensive tests  
✅ **Well documented** - multiple guides available  

Enjoy the improved performance! 🚀
