Quick start:

1. Install CINC-workstation. 
https://cinc.sh/start/workstation/

2. Validate the test-kitchen configuration.
    /opt/cinc-workstation/bin/kitchen list
	
3. Try to converge both Ubuntu and Debian VMs with a default runlist from the stub `Policyfile.rb` :
    /opt/cinc-workstation/bin/kitchen setup
	
