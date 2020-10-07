## Test-Kitchen Quick Start

1. Install CINC-workstation.  
https://cinc.sh/start/workstation/

2. Validate the test-kitchen configuration.  
```
/opt/cinc-workstation/bin/kitchen list
```	
3. Try to converge both Ubuntu and Debian VMs with a default runlist from the stub `Policyfile.rb` :  
```
/opt/cinc-workstation/bin/kitchen setup -c 2 default
```	

## Deployment

1. Install CINC-workstation on the workstation  
https://cinc.sh/start/workstation/

2. Install CINC-client on the target  
https://cinc.sh/start/client

3. Using the workstation, export to a directory:  
```
/opt/cinc-workstation/bin/cinc export /tmp/chef-desktop
```
	
4. Copy that directory from the workstation to the target

5. On the target, converge a default runlist with the generated config:  
```
/opt/cinc/bin/cinc-client -c .chef/config.rb -z
```

6. Or, converge a named runlist specified in `Policyfile.rb`:  
```
/opt/cinc/bin/cinc-client -c .chef/config.rb -z -n wine
```	
