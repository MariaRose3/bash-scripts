#!/bin/bash

# Ensure that the script executes only if sudo/root access available
if [[ "$UID" -ne 0 ]]
then
    echo "Please run with sudo or as root."
    exit 1
fi

# User should provide atleast one argument as username while running to command
if [[ ${#} -lt 1 ]]
then 
    echo "Usage: ${0} USER_NAME [COMMENT]"
    echo "Create a user with name USER_NAME and give your commentsmafter that"
    exit 1
fi

# Store the 1st argument as the username
USER_NAME="${1}"
# echo $USER_NAME

# If there are multiple arguments, store the rest as account comments
shift
COMMENT="${@}";
# echo $COMMENT

# Create a password for the new user
# echo $RANDOM
PASSWORD=$(data +%s%N)
# echo $PASSWORD

# Create the new user
useradd -c "$COMMENT" -m $USER_NAME

# Check if the user is successfully created
if [[ $? -ne 0 ]]
then 
    echo "The account was not created."
    exit 1
fi

# Set the password for the user
echo $PASSWORD | passwd --stdin $USER_NAME

# Check if password is successfully set or not
if [[ $? -ne 0 ]]
then
    echo "Password could not be set"
    exit 1
fi

# Force password change on first login
passwd -e $USER_NAME

# Display the username, password, and the host name where the user is created
echo
echo "Username: $USER_NAME"
echo
echo "Password: $PASSWORD"
echo
echo "Hostname: ${hostname}"

# improvements, enable logging