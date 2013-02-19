# PowerShell Build Script for PayPal Donations
#
# @author       Johan Steen
# @date         18 Feb 2013
# @version      1.0


# ------------------------------------------------------------------------------
# Variables and Setup
# ------------------------------------------------------------------------------

# Make the script culture independent (ie, don't give me Swedish month names!)
$currentThread = [System.Threading.Thread]::CurrentThread
$culture = [System.Globalization.CultureInfo]::InvariantCulture
$currentThread.CurrentCulture = $culture
$currentThread.CurrentUICulture = $culture

# Generic
$VERSION = '1.0'
$DATE    = get-date -format "d MMM yyyy"
$FILES   = @('paypal-donations.php', 'readme.txt')

# ------------------------------------------------------------------------------
# Build
# Replaces Version and Date in the plugin. 
# ------------------------------------------------------------------------------
function build_plugin
{
    Write-Host '--------------------------------------------'
    Write-Host 'Building plugin...'
    # cd $LESS_FOLDER

    # Replace Date and Version
    foreach ($file in $FILES)
    {
        cat $file `
            | %{$_ -replace "@BUILD_DATE", $DATE} `
            | %{$_ -replace "@DEV_HEAD", $VERSION} `
            | Set-Content $file'.tmp' 

        # Set UNIX line endings and UTF-8 encoding.
        Get-ChildItem $file'.tmp' | ForEach-Object {
          # get the contents and replace line breaks by U+000A
          $contents = [IO.File]::ReadAllText($_) -replace "`r`n?", "`n"
          # create UTF-8 encoding without signature
          $utf8 = New-Object System.Text.UTF8Encoding $false
          # write the text back
          [IO.File]::WriteAllText($_, $contents, $utf8)
        }

        cp $file'.tmp' $file
        Remove-Item $file'.tmp'
    }
    Write-Host "Plugin successfully built! - $DATE"
}

$VERSION = Read-Host 'New version number'
build_plugin