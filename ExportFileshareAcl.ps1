###################################################################################################
# This script will export permissions of a share folder.
# Input is a CSV file with the list of fileshares, Ensure the column is named as fileshares
# output of the file gets stored in a csv format, you can specify the path of the output file at line 24

# Author - Mallikarjuna
# Date created :- 27/03/2020


#####################################################################################################

$sharefile = Import-Csv c:\shares.csv # Give the complete path to the share here
$Report = @()
foreach ($share in $sharefile.fileshares){
$FolderPath = Get-ChildItem -Directory -Path "$share" -Recurse -Force
Foreach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    foreach ($Access in $acl.Access)
        {
            $Properties = [ordered]@{'FolderName'=$Folder.FullName;'AD
Group or User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
            $Report += New-Object -TypeName PSObject -Property $Properties
        }
}
}
$Report | Export-Csv -path "C:\FolderPermissions.csv" -NoTypeInformation
