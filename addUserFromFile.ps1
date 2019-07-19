# Add AD user by reading csv file

Import-Module activedirectory

$csv = Import-Csv -Path .\newUsers.csv
# $csv.FirstName

# create file to write errors.
if (Test-Path '.\error.txt'){
	Write-Warning "error.txt file already exist"
}
else{
	New-Item -ItemType File error.txt
	Write-Host "error.txt file has been created"
}


ForEach ($user in $csv){
    #$user  
    $firstName = $user.FirstName
    $lastName = $user.LastName
    $Name = $firstName + " " + $lastName
    $GivenName = $Name.Split(" ")[0]
    $AccountPassword = (ConvertTo-SecureString "mitr@2018" -AsPlainText -Force)
    $EmailAddress = $Name.Split(" ")[0].ToLower() + $Name.Split(" ")[1].ToLower()[0] + "@mitrmedia.com"
    $Surname = $Name.Split(" ")[1]
    $SamAccountName = $Name.Split(" ")[0].ToLower() + $Name.Split(" ")[1].ToLower()[0]
    $UserPrincipalName = $Name.Split(" ")[0].ToLower() + $Name.Split(" ")[1].ToLower()[0] + "@MITRMUM.COM"

    # check if user exist in AD
    if (Get-ADUser -F {SamAccountName -eq $SamAccountName})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $Name already exist in Active Directory, Check error.txt file in the same directory."
		 Add-Content .\error.txt "A user account with username $Name already exist in Active Directory, Please create manualy."
	}
    else{

        #User does not exist create new account
        New-ADUser -Name $Name -GivenName $GivenName -PasswordNeverExpires $True -AccountPassword (ConvertTo-SecureString "mitr@2019" -AsPlainText -Force) -CannotChangePassword $True -DisplayName $Name -EmailAddress $EmailAddress -Surname $Surname -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName -Enabled $True
		
    }

    Write-Host '#######################################'
}

