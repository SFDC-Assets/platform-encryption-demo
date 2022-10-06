# Create the demo org
sfdx shane:org:create -f config/project-scratch-def.json -d 1 -s --wait 60 --userprefix platform -o encryption.demo

# Push the metadata into the new scratch org.
sfdx force:source:push

# Assign permission set
sfdx shane:user:permset:assign -l User -g User -n PlatformEncryption

# Set the default password.
sfdx shane:user:password:set -g User -l User -p salesforce1

# Create Tenant Secrets
sfdx force:data:record:create -s TenantSecret -v "Description=ProbabilisticKey"
sfdx force:data:record:create -s TenantSecret -v "Description=SearchKey Type=SearchIndex"
sfdx force:data:record:create -s TenantSecret -v "Description=EventBusKey Type=EventBus"

# Deploy platform encryption settings
sfdx force:mdapi:deploy -d ./src -w 5

sfdx force:data:record:create -s TenantSecret -v "Description=DeterministicKey Type=DeterministicData"

# Open the org.
sfdx force:org:open