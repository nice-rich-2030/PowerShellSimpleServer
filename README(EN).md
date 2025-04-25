# PowerShellSimpleServer

A lightweight HTTP server implemented in PowerShell for local web development, requiring no additional software installation.

## Background

When developing HTML, JavaScript, or CSS, you often need a simple web server to properly test your code. Traditional approaches like setting up IIS or manually running commands can be cumbersome:

```
# Traditional approach
# Step 1: Open command prompt
# Step 2: Run Python's HTTP server
python -m http.server 8000
# Step 3: Open browser and navigate to http://localhost:8000/your-file.html
```

PowerShellSimpleServer streamlines this process by providing a single-file solution that works with Windows' built-in capabilities.

## Features

- **Zero Dependencies**: Uses only Windows built-in components
- **Simple Setup**: Single PowerShell script with minimal configuration
- **Directory Browsing**: Automatic directory listing for easier navigation
- **Multiple File Types**: Supports HTML, CSS, JavaScript, images and more
- **Index File Detection**: Automatically serves index.html/default.html when accessing directories
- **URL Decoding**: Properly handles special characters in URLs
- **Lightweight**: Small footprint with minimal system impact

## Usage

### Basic Usage

1. Save the PowerShellSimpleServer.ps1 script to your computer
2. Edit the `$basePath` variable to point to your web project folder
3. Run the script in PowerShell
4. Access your content at http://localhost:8000/

```powershell
# Example: Setting up to serve files from D:\WebProjects\MyApp
$basePath = "D:\WebProjects\MyApp"  # Edit this line in the script
```

### Running the Server

```powershell
# Method 1: Right-click the script and select "Run with PowerShell"

# Method 2: From PowerShell terminal
.\PowerShellSimpleServer.ps1

# Method 3: Create a shortcut to run minimized
# Target: powershell.exe -ExecutionPolicy Bypass -File "C:\Path\To\PowerShellSimpleServer.ps1"
# Set "Run" to "Minimized"
```

### Accessing Your Content

Once the server is running, you can:

- Open a browser and navigate to http://localhost:8000/
- Access specific files like http://localhost:8000/index.html
- Browse subdirectories like http://localhost:8000/css/ or http://localhost:8000/js/

### Stopping the Server

Press `Ctrl+C` in the PowerShell window to stop the server.

## Customization

### Changing the Port

To use a different port (e.g., 8080 instead of 8000), modify this line:

```powershell
$listener.Prefixes.Add("http://localhost:8080/")
```

### Serving from a Different Root Folder

Modify the `$basePath` variable:

```powershell
$basePath = "C:\Your\Project\Path"
```

## Limitations

- **Local Development Only**: This server is intended for development and testing purposes only, not for production use
- **Single-Threaded**: Processes one request at a time
- **Basic Security**: No authentication or HTTPS support
- **Windows Only**: Designed for Windows environments with PowerShell

## Troubleshooting

### Port Already in Use

If you see an error about the port being in use:

```powershell
# Find what's using port 8000
netstat -ano | findstr :8000

# Change the port in the script to an unused port
$listener.Prefixes.Add("http://localhost:8080/")
```

### Execution Policy Restrictions

If you encounter execution policy restrictions:

```powershell
# Run this command in an elevated PowerShell prompt
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### File Not Found Errors

Ensure the file paths are correct and that the PowerShell process has read permissions to the files you're trying to serve.

## License

Copyright (c) 2025 Daily Growth  
https://yourworklifedesign.blogspot.com/  
All rights reserved.

---

Happy coding! 🚀