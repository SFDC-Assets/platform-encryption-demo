# Create the demo org
sf demoutil org create scratch -f config/project-scratch-def.json -d 1 -s --wait 60 -p platform -e encryption.demo

# Push the metadata into the new scratch org.
sf project deploy start

# Assign permission set
sf org assign permset -n PlatformEncryption

# Set the default password.
sf demoutil user password set -p salesforce1 -g User -l User

# Create Tenant Secrets
sf data record create -s TenantSecret -v "Description=ProbabilisticKey"

# sf data record create -s TenantSecret -v "Description=SearchKey Type=SearchIndex"
sf data record create -s TenantSecret -v "Description=EventBusKey Type=EventBus"

# Deploy platform encryption settings
sf project deploy start -d ./src -w 5

sf data record create -s TenantSecret -v "Description=DeterministicKey Type=DeterministicData"

# Push sample data for demo
sf automig load --inputdir ./data --deletebeforeload

#sfdx shane:data:file:upload -f ./attachment/wp-platform-encryption-architecture.pdf -p `sfdx shane:data:id:query -o Case -w "Type='Electrical'"`
sf data create file --file ./attachment/wp-platform-encryption-architecture.pdf --parent-id `sf data query --query "SELECT Id FROM Case WHERE Type = 'Electrical'" --json`


# Open the org.
sf org open
