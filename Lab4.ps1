Clear-Host
Write-Output "1. Create bulk users from users.csv"
Write-Output "2. Create bulk users from usersNoMatch.csv"
Write-Output "3. Remove all users created today"
Write-Output ""
$action = Read-Host "Enter the number of your choice, or anything else to cancel"

if ($action -eq 1){
    $pass = ConvertTo-SecureString "Password01" -AsPlainText -Force
    $users = import-csv -Path C:\Users\Administrator\Desktop\Lab4\users.csv
    $users | New-ADUser -AccountPassword $pass -Enabled $true
    Get-ADUser -Filter * -Properties * | Format-List -Property Name,SamAccountName,UserPrincipalName,StreetAddress,City,State,PostalCode,GivenName,SurName,EmailAddress,Company,Department,OfficePhone,Description,Enabled
}
if ($action -eq 2){
    $pass = ConvertTo-SecureString "Password01" -AsPlainText -Force
    $usersList = import-csv -Path C:\Users\Administrator\Desktop\Lab4\usersNoMatch.csv
    foreach ($user in $userslist){
        $params = @{
            Name = $user.Name
            UserPrincipalName = $user.UPName
            SamAccountName = $user.SAName
            StreetAddress = $user.StAddress
            City = $user.City
            State = $user.St
            PostalCode = $user.Zip
            GivenName = $user.First
            SurName = $user.Last
            EmailAddress = $user.Email
            Company = $user.Co
            Department = $user.Dept
            OfficePhone = $user.Phone
            Description = $user.Desc
        }
        New-ADUser @params -AccountPassword $pass -Enabled $true
    }
    Get-ADUser -Filter * -Properties * | Format-List -Property Name,SamAccountName,UserPrincipalName,StreetAddress,City,State,PostalCode,GivenName,SurName,EmailAddress,Company,Department,OfficePhone,Description,Enabled
}
if ($action -eq 3){
    #returns today, at midnight
    $CurrentDate = [DateTime](Get-Date -Format "yyyy-MM-dd")

    Write-Output "These are the users that will be removed: `n"
    Get-ADUser -Filter {Created -ge $CurrentDate} -Properties Created | Format-Table Name, Created

    $answerRemove = Read-Host "`nY [Enter] to Remove, [Enter] to cancel"

    if($answerRemove -eq "Y"){
        Get-ADUser -filter {Created -ge $CurrentDate} | Remove-ADUser
    }
}