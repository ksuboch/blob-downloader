$user = 'login'
$pass = ConvertTo-SecureString 'pass' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $pass)
Connect-AzureRmAccount -Credential $cred | Out-Null


foreach ($sa in Get-AzureRMStorageAccount) {
    Write-Host $sa.StorageAccountName
    $key = (Get-AzureRmStorageAccountKey $sa.ResourceGroupName $sa.StorageAccountName)[0].Value
    $ctx = New-AzureStorageContext -StorageAccountName $sa.StorageAccountName -StorageAccountKey $key
    foreach ($sc in Get-AzureRmStorageContainer $sa.ResourceGroupName $sa.StorageAccountName) {
        Write-Host "    $($sc.Name)"
        foreach ($blob in Get-AzureStorageBlob -Context $ctx -Container $sc.Name) {
            Write-Host "        $($blob.Name)"
        }
    }
}