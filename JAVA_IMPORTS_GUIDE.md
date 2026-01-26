# Java Imports Management with Wildcards

## Overview

Neovim configuration now automatically collapses Java imports to wildcards when there are 3 or more classes from the same package.

## Features

### Automatic Wildcard Collapse

When you have multiple imports from the same package:

**Before:**
```java
import com.example.foo.Clase1;
import com.example.foo.Clase2;
import com.example.foo.Clase3;
```

**After `:OrganizeImports` or `<leader>jo`:**
```java
import com.example.foo.*;
```

### Threshold Configuration

Default threshold: **3 imports** from the same package triggers wildcard collapse.

## Commands

### `:OrganizeImports`
**Description**: Organize imports and collapse to wildcards (Java only)

**Behavior**:
- Java files: Uses JDTLS to organize imports, then collapses packages with 3+ imports to wildcards
- Other languages: Uses standard LSP code action `source.organizeImports`

**Example**:
```vim
:OrganizeImports
```

### `:CollapseImports [threshold]`
**Description**: Manually collapse imports to wildcards without organizing first

**Arguments**:
- `threshold` (optional): Minimum number of imports to collapse (default: 3)

**Examples**:
```vim
:CollapseImports      " Use default threshold (3)
:CollapseImports 2    " Collapse with 2+ imports
:CollapseImports 5    " Only collapse with 5+ imports
```

**Use case**: When you want to collapse imports without running full organize imports.

## Keymaps

### `<leader>jo`
**Description**: Organize imports with wildcard collapse (Java files only)

**Mode**: Normal

**Equivalent to**: `:OrganizeImports` in Java files

## How It Works

### Two-Step Process

1. **JDTLS Organize**: First, JDTLS organizes imports (removes unused, sorts, etc.)
2. **Wildcard Collapse**: Then, custom Lua function analyzes imports and collapses packages with 3+ imports

### Technical Implementation

**Files involved**:
- `lua/utils/java_imports.lua`: Core wildcard collapse logic
- `lua/config/jdtls_fixes.lua`: Command definitions
- `lua/plugins/jdtls.lua`: JDTLS configuration and keymaps

**Functions**:
```lua
-- Main function: organize + collapse
require('utils.java_imports').organize_imports_with_wildcards(3)

-- Direct collapse only
require('utils.java_imports').collapse_imports_to_wildcard(3)
```

## Examples

### Example 1: Standard Organize

**Input file**:
```java
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import com.example.Unused;
import com.example.foo.Clase1;
import com.example.foo.Clase2;
```

**Run**: `<leader>jo` or `:OrganizeImports`

**Result**:
```java
import java.util.*;
import com.example.foo.Clase1;
import com.example.foo.Clase2;
```

**Explanation**:
- `java.util.*`: 4 imports → collapsed
- `com.example.foo.*`: Only 2 imports → NOT collapsed
- `com.example.Unused`: Removed (unused)

### Example 2: Custom Threshold

**Input file**:
```java
import com.example.foo.Clase1;
import com.example.foo.Clase2;
```

**Run**: `:CollapseImports 2`

**Result**:
```java
import com.example.foo.*;
```

**Explanation**: With threshold=2, even 2 imports get collapsed.

### Example 3: Mixed Packages

**Input file** (`/tmp/TestImports.java`):
```java
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import com.example.foo.Clase1;
import com.example.foo.Clase2;
import com.example.foo.Clase3;
import com.example.bar.Service1;
import com.example.bar.Service2;
```

**Run**: `:OrganizeImports`

**Expected result**:
```java
import java.util.*;

import com.example.bar.Service1;
import com.example.bar.Service2;
import com.example.foo.*;
```

**Explanation**:
- `java.util.*`: 5 imports → collapsed
- `com.example.foo.*`: 3 imports → collapsed
- `com.example.bar.*`: Only 2 imports → NOT collapsed

## Limitations

### Static Imports
Currently, static imports are **not collapsed** by the custom function. This is intentional to maintain explicit static member references.

**Example** (will NOT collapse):
```java
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;
```

**Reason**: Static imports often benefit from being explicit for code readability.

### JDTLS Configuration
The JDTLS configuration includes `starThreshold = 3`, but this setting may not be fully supported by all JDTLS versions. The custom Lua function ensures consistent behavior regardless of JDTLS version.

## Comparison with Spotless/google-java-format

### In Neovim (This Configuration)
✅ **Collapses imports to wildcards** when 3+ classes from same package

### In Gradle Spotless with google-java-format
❌ **Does NOT collapse** - google-java-format always expands wildcards to explicit imports

### Why the Difference?

**google-java-format philosophy**: Explicit imports are better for code review and understanding dependencies.

**Personal preference**: You prefer wildcards for cleaner code.

**Solution**: This Neovim configuration gives you wildcards locally. When you commit code, Spotless will expand them back. This is intentional and allows you to work with your preferred style while maintaining project consistency.

## Integration with conform.nvim

Java formatting is configured in `lua/plugins/conform.lua`:

```lua
formatters_by_ft = {
  java = { "google_java_format" },
}
```

**Auto-format on save**: Currently **disabled** for Java files.

**Manual format**: Use `<leader>f` or `:Format`

**Recommended workflow**:
1. Write code with automatic import organization (`<leader>jo` or save in other editors)
2. Manually format when needed: `<leader>f`
3. Organize imports with wildcards: `<leader>jo`
4. Before commit: Run `./gradlew spotlessApply` (will expand wildcards)

## Troubleshooting

### Imports not collapsing

**Check**:
1. Verify file is Java: `:echo &filetype` should show `java`
2. Verify JDTLS is attached: `:LspInfo`
3. Check threshold: You need 3+ imports from same package
4. Check for errors: `:messages`

**Test utility directly**:
```vim
:lua require('utils.java_imports').collapse_imports_to_wildcard(3)
```

### Organize imports not working

**Check JDTLS status**:
```vim
:LspInfo
```

**Fallback**: Use `:CollapseImports` to only collapse without organizing.

### Wildcard collapse too aggressive

**Increase threshold**:
```vim
:CollapseImports 5  " Only collapse with 5+ imports
```

**Or modify default** in `lua/config/jdtls_fixes.lua`:
```lua
java_imports.organize_imports_with_wildcards(5)  -- Change 3 to 5
```

## Related Files

- `lua/utils/java_imports.lua`: Core logic
- `lua/config/jdtls_fixes.lua`: Commands and LSP fixes
- `lua/plugins/jdtls.lua`: JDTLS configuration and keymaps
- `lua/plugins/conform.lua`: Formatting configuration
- `KNOWN_ISSUES.md`: Known issues and limitations
- `KEYMAPS.md`: Complete keymap reference

## References

- [JDTLS Documentation](https://github.com/eclipse/eclipse.jdt.ls)
- [nvim-jdtls Plugin](https://github.com/mfussenegger/nvim-jdtls)
- [google-java-format](https://github.com/google/google-java-format)
- Eclipse JDT Import Settings

## Testing

Use the provided test file:

```bash
nvim /tmp/TestImports.java
```

**In Neovim**:
1. Open file: `:e /tmp/TestImports.java`
2. Organize imports: `<leader>jo` or `:OrganizeImports`
3. Verify wildcards for packages with 3+ imports

**Expected behavior**:
- `java.util.*` (5 imports)
- `com.example.foo.*` (3 imports)
- `com.example.bar.Service1` and `Service2` (2 imports - not collapsed)
