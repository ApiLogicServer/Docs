# VS Code Python Virtual Environment Activation Workarounds

## Problem Summary

**Issue**: VS Code Python extension (version 1.102.0) fails to automatically activate virtual environments in both terminal and application execution contexts, despite correct configuration settings.

**Impact**: 
- New users cannot run generated projects without manual venv activation
- Breaks the "computed default virtual environments" feature that solves the "default venv for new users" problem
- Affects both terminal activation and Python application execution
- Represents a critical regression in VS Code Python extension functionality

## Root Cause

The VS Code Python extension has a regression where standard settings like `python.defaultInterpreterPath` and `python.terminal.activateEnvironment` are not reliably working. This is documented in GitHub issue [#22879](https://github.com/microsoft/vscode-python/issues/22879).

## VS Code Background

### How VS Code Handles Virtual Environments

**Project Opening**:
- VS Code reads `.vscode/settings.json` and applies workspace settings
- Python extension detects interpreter path and configures IntelliSense
- `.env` file is loaded for environment variables
- Terminal profiles are configured but not executed
- **No scripts run automatically** - the project is ready but no terminal activation occurs

**Terminal Creation**:
- When you open a new terminal (Terminal → New Terminal), VS Code uses the default terminal profile
- Our custom "venv" profile executes: `source .vscode/venv_init.sh && exec zsh --no-rcs`
- The `venv_init.sh` script runs, activates the virtual environment, and sets the prompt
- A new shell starts with the virtual environment already activated

**Key Point**: Virtual environment activation is "lazy loaded" - it only happens when you actually create a terminal, not when the project opens.

## Comprehensive Solution

### 1. Enhanced VS Code Settings Template

**File**: `api_logic_server_cli/prototypes/base/.vscode/settings.json`

**Key Changes**:
```jsonc
{
    "python.defaultInterpreterPath": "ApiLogicServerPython",
    "python.terminal.activateEnvironment": true,
    "python.terminal.activateEnvInCurrentTerminal": true,
    "python.envFile": "${workspaceFolder}/.env",
    "python.analysis.autoImportCompletions": true,
    "python.analysis.extraPaths": ["ApiLogicServerVenvSitePackages"],
    
    // Custom terminal profiles for reliable venv activation
    "terminal.integrated.profiles.osx": {
        "venv": {
            "path": "/bin/zsh",
            "args": ["-c", "source ${workspaceFolder}/.vscode/venv_init.sh && exec zsh --no-rcs"]
        }
    },
    "terminal.integrated.profiles.linux": {
        "venv": {
            "path": "/bin/bash",
            "args": ["-c", "source ${workspaceFolder}/.vscode/venv_init.sh && exec bash --noprofile --norc"]
        }
    },
    "terminal.integrated.defaultProfile.osx": "venv",
    "terminal.integrated.defaultProfile.linux": "venv"
}
```

### 2. Generated Project Files

The project generator now creates additional files to ensure reliable virtual environment activation:

#### `.env` File
**Purpose**: Explicit Python path configuration for VS Code Python extension
**Content**: 
```bash
PYTHONPATH=<computed_python_path>
```

#### `.vscode/venv_init.sh` Script
**Purpose**: Reliable terminal virtual environment activation with optional debugging
**Content**:
```bash
#!/bin/bash
# Virtual Environment Initialization Script
# This script activates the virtual environment for terminal use

# Set DEBUG_VENV_INIT=1 to enable debug output
DEBUG_VENV_INIT=0

if [ "$DEBUG_VENV_INIT" = "1" ]; then
    echo "=== VENV INIT DEBUG ==="
    echo "Shell: $0"
    echo "ZSH_VERSION: $ZSH_VERSION"
    echo "BASH_VERSION: $BASH_VERSION"
    echo "Current PS1: $PS1"
    echo "VIRTUAL_ENV before: $VIRTUAL_ENV"
fi

# Source the virtual environment activation script
if [ -f "<venv_path>/bin/activate" ]; then
    if [ "$DEBUG_VENV_INIT" = "1" ]; then
        echo "Found activation script: <venv_path>/bin/activate"
    fi
    source <venv_path>/bin/activate
    echo "Virtual environment activated: <venv_name>"
    
    if [ "$DEBUG_VENV_INIT" = "1" ]; then
        echo "VIRTUAL_ENV after activation: $VIRTUAL_ENV"
    fi
    
    # Don't let virtualenv override the prompt
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    if [ "$DEBUG_VENV_INIT" = "1" ]; then
        echo "Set VIRTUAL_ENV_DISABLE_PROMPT=1"
    fi
    
    # Override the prompt to ensure (venv) shows
    if [ -n "${ZSH_VERSION}" ]; then
        if [ "$DEBUG_VENV_INIT" = "1" ]; then
            echo "Setting zsh prompt"
        fi
        export PS1="(venv) %n@%m %1~ %# "
    elif [ -n "${BASH_VERSION}" ]; then
        if [ "$DEBUG_VENV_INIT" = "1" ]; then
            echo "Setting bash prompt"
        fi
        export PS1="(venv) \\u@\\h \\W \\$ "
    else
        if [ "$DEBUG_VENV_INIT" = "1" ]; then
            echo "Unknown shell - trying generic prompt"
        fi
        export PS1="(venv) $ "
    fi
    
    if [ "$DEBUG_VENV_INIT" = "1" ]; then
        echo "Final PS1: $PS1"
        echo "Final VIRTUAL_ENV: $VIRTUAL_ENV"
    fi
    
else
    echo "Warning: Virtual environment activation script not found at <venv_path>/bin/activate"
fi

if [ "$DEBUG_VENV_INIT" = "1" ]; then
    echo "=== END DEBUG ==="
fi
```

### 3. Template Placeholder System

**Placeholders in settings.json**:
- `ApiLogicServerPython` → Replaced with actual Python interpreter path
- `ApiLogicServerVenvSitePackages` → Replaced with venv site-packages path

**Generation Code Integration**:
- Enhanced `api_logic_server.py` to create `.env` files
- Added logic to generate `venv_init.sh` scripts
- Implemented robust path computation and replacement

## Technical Implementation Details

### Path Computation Logic
```python
# Compute virtual environment paths
venv_python_path = os.path.join(venv_directory, 'bin', 'python')
venv_site_packages = os.path.join(venv_directory, 'lib', f'python{python_version}', 'site-packages')

# Generate .env file
env_content = f"PYTHONPATH={venv_site_packages}\n"
with open(os.path.join(project_directory, '.env'), 'w') as f:
    f.write(env_content)

# Generate venv_init.sh
init_script = f"""#!/bin/bash
if [ -f "{venv_python_path}" ]; then
    source {os.path.join(venv_directory, 'bin', 'activate')}
    export PYTHONPATH="{venv_site_packages}"
    echo "Virtual environment activated"
else
    echo "Warning: Virtual environment not found"
fi
"""
with open(os.path.join(project_directory, '.vscode', 'venv_init.sh'), 'w') as f:
    f.write(init_script)
```

### Cross-Platform Compatibility
- **macOS**: Uses `zsh` with custom terminal profile
- **Linux**: Uses `bash` with custom terminal profile  
- **Windows**: Inherits default behavior (not affected by the regression)

## Testing and Validation

### Validation Steps
1. **Terminal Activation**: Open new terminal → Should show `(venv)` prefix
2. **Python Execution**: Run Python files → Should use venv interpreter
3. **Package Access**: Import project packages → Should work without PYTHONPATH issues
4. **Debug Configuration**: VS Code debugging → Should use correct interpreter

### Known Limitations
- Requires VS Code restart after project generation for full effect
- Custom terminal profiles may need user acknowledgment on first use
- Some VS Code Python extension features may still be unreliable
- Terminal starts without loading user's shell configuration files (zsh/bash rc files)

### Troubleshooting
If virtual environment activation is not working:

1. **Enable Debug Mode**: Edit `.vscode/venv_init.sh` and change `DEBUG_VENV_INIT=0` to `DEBUG_VENV_INIT=1`
2. **Open New Terminal**: The debug output will show exactly what's happening
3. **Check Debug Output**: Look for:
   - Whether the activation script is found
   - Which shell is being detected
   - Whether the virtual environment variables are set correctly
   - Whether the prompt is being set properly

Common issues and solutions:
- **Script not found**: Check that the virtual environment path is correct
- **Wrong shell detected**: The script should detect zsh on macOS
- **Prompt not showing**: Ensure `--no-rcs` is working and not loading conflicting configurations

## Future Considerations

### Issue Tracking
- Reported to Microsoft: [vscode-python #22879](https://github.com/microsoft/vscode-python/issues/22879)
- Monitoring for official fix from VS Code Python extension team
- Workarounds can be removed once regression is resolved

### Maintenance Strategy
1. **Short-term**: Maintain comprehensive workarounds
2. **Medium-term**: Monitor VS Code Python extension updates
3. **Long-term**: Simplify back to standard settings when regression is fixed

## User Experience Impact

### Before Workarounds
- Users had to manually activate virtual environments
- Python execution used system interpreter
- Import errors and dependency issues
- Poor new user experience

### After Workarounds
- Automatic virtual environment activation
- Correct Python interpreter usage
- Seamless package imports
- Improved new user onboarding

## Documentation Updates

### README Updates
Add section explaining:
- Virtual environment is automatically configured
- No manual activation required
- Troubleshooting steps if issues occur

### Developer Documentation
- Document the template system enhancements
- Explain placeholder replacement mechanism
- Provide debugging guide for environment issues

## Conclusion

These workarounds provide a robust solution to the VS Code Python extension regression while maintaining the goal of "computed default virtual environments for new users." The implementation is comprehensive enough to handle the current issues while being designed for easy removal once the upstream regression is resolved.

The solution ensures that generated projects work out-of-the-box for new users, which is critical for the ApiLogicServer user experience and adoption.
