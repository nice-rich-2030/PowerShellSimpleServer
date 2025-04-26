<#
Copyright (c) 2025 Daily Growth
https://yourworklifedesign.blogspot.com/
All rights reserved.
#>

# Load System.Web assembly
Add-Type -AssemblyName System.Web

# Create and start the listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8000/")
$listener.Start()

# Set the folder path to serve
$basePath = "C:\src\"  # Change this to your actual folder path

try {
    while ($listener.IsListening) {
        # Wait for a request
        Write-Host "Waiting for requests at http://localhost:8000/..."
        $context = $listener.GetContext()
        
        # Get request and response objects
        $request = $context.Request
        $response = $context.Response
        
        # Get the requested URL path (URL decode)
        $requestedFile = [System.Web.HttpUtility]::UrlDecode($request.Url.AbsolutePath)
        Write-Host "Request: $requestedFile"
        # Convert URL path to file system path (replace slashes with backslashes)
        $relativePath = $requestedFile.TrimStart("/").Replace("/", "\")
        
        
        $filePath = Join-Path $basePath $relativePath
        
        
        
        
        Write-Host "File path: $filePath"
        
        # Default page processing (if directory only)
        if ((Test-Path $filePath -PathType Container) -or $requestedFile -eq "/") {
            $possibleIndexFiles = @("index.html", "index.htm", "default.html", "default.htm")
            $indexFound = $false
            
            foreach ($indexFile in $possibleIndexFiles) {
                $indexPath = Join-Path $filePath $indexFile
                if (Test-Path $indexPath) {
                    $filePath = $indexPath
                    $indexFound = $true
                    break
                }
            }
            
            if (-not $indexFound) {
                # Generate directory listing
                $dirListingHtml = "<!DOCTYPE html><html><head><title>Directory Listing</title></head><body><h1>Directory Listing</h1><ul>"
                $currentDir = $requestedFile.TrimEnd("/")
                
                # Link to parent directory
                if ($currentDir -ne "") {
                    $parentDir = $currentDir.Substring(0, $currentDir.LastIndexOf("/"))
                    if ($parentDir -eq "") { $parentDir = "/" }
                    $dirListingHtml += "<li><a href='$parentDir'>..</a> (Up)</li>"
                }
                
                # List of files and folders
                Get-ChildItem $filePath | ForEach-Object {
                    $itemName = $_.Name
                    $itemPath = "$currentDir/$itemName"
                    if ($_.PSIsContainer) {
                        $itemPath = "$itemPath/"
                        $itemName = "$itemName/"
                    }
                    $dirListingHtml += "<li><a href='$itemPath'>$itemName</a></li>"
                }
                
                $dirListingHtml += "</ul></body></html>"
                
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($dirListingHtml)
                $response.ContentLength64 = $buffer.Length
                $response.ContentType = "text/html"
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
                $response.OutputStream.Close()
                continue
            }
        }
        
        # Check if file exists
        if (Test-Path $filePath -PathType Leaf) {
            # Read file content
            $content = [System.IO.File]::ReadAllBytes($filePath)
            
            # Set content type
            $extension = [System.IO.Path]::GetExtension($filePath)
            switch ($extension) {
                ".html" { $contentType = "text/html" }
                ".htm"  { $contentType = "text/html" }
                ".js"   { $contentType = "application/javascript" }
                ".css"  { $contentType = "text/css" }
                ".jpg"  { $contentType = "image/jpeg" }
                ".jpeg" { $contentType = "image/jpeg" }
                ".png"  { $contentType = "image/png" }
                ".gif"  { $contentType = "image/gif" }
                ".svg"  { $contentType = "image/svg+xml" }
                ".json" { $contentType = "application/json" }
                ".xml"  { $contentType = "application/xml" }
                ".txt"  { $contentType = "text/plain" }
                default { $contentType = "application/octet-stream" }
            }
            
            # Set response
            $response.ContentLength64 = $content.Length
            $response.ContentType = $contentType
            $response.OutputStream.Write($content, 0, $content.Length)
        } else {
            # 404 error
            $response.StatusCode = 404
            $notFoundMessage = "<!DOCTYPE html><html><head><title>404 Not Found</title></head><body><h1>404 - File Not Found</h1><p>The requested file was not found: $requestedFile</p></body></html>"
            $content = [System.Text.Encoding]::UTF8.GetBytes($notFoundMessage)
            $response.ContentLength64 = $content.Length
            $response.ContentType = "text/html"
            $response.OutputStream.Write($content, 0, $content.Length)
            
            Write-Host "404 Error: File not found: $filePath" -ForegroundColor Red
        }
        
        # Close the response
        $response.OutputStream.Close()
    }
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
finally {
    # Stop the listener
    $listener.Stop()
    Write-Host "Server stopped." -ForegroundColor Yellow
}