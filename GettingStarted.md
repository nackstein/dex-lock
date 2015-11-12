an introduction to dex-lock

# Getting Started #

dex-lock implement a distributed lock manager functionalities in posix shell. It's the lock manager used in [back-to-work](https://code.google.com/p/back-to-work/), a failover cluster manager written in posix shell.

dex-lock is very portable. It works on Linux, HP-UX, OpenBSD, CYGWIN (tested on WinXP), ESXi (tested on 5.5) and many others operating system. It require a posix shell interpreter, an ssh client and some basic file system utilities like mv, mkdir, rmdir (mostly posix).

# Installation #

Installing dex-lock is simple as download the source (tar or zip) and explode it in the directory of choice on every lock server and every client.

Important: the directory choosed for each lock server must be the same. Clients can use a different directory.

# Configuration #

The configuration is needed only on client side. Move to the installation folder and edit the file conf/lock\_servers with a space separated list of the lock server DNS name. It's suggested that you configure in your /etc/hosts the resolution of these hostname in order to not rely on DNS for locking porpuse.
Now edit the file conf/remote\_path with the full path name choosed as installation directory on the lock servers.
However there is an important step on client side: you should configure your boot procedure to run the script lock-server-init. This script should run BEFORE you start sshd on the server. It's job is to delete any serialization lock (not those used by clients) that can exist if your lock server crashed while a serialization lock was held.

# Using dex-lock #

dex-lock is meant to be used in shell scripting. Usually your script should do the following:
  * init a lock
  * try to get it
  * do some jobs...
  * release the lock on exit

The initialization is done calling the init-lock script like this:
```
init-lock <lock_name> <timeout> <timeout2>
```

all parameters are optional, the default values are: default, 30, 0.
The lock name is self explanatory, the timeout value is the timeout for who keep the lock, if he cannot reach a majority of lock servers for that much seconds it will automatically lose the lock. timeout2 parameter is used by waiters, the wait for a total of timeout+timeout2 before trying to get the lock with a new race (election term). timeout2 is used in back-to-work as the "stop timeout" of a package. in case of network problem you will have that after "timeout" second who keep the lock lose it and begin the stop package procedure while the waiters do another "timeout2" pause. In other context maybe you need to use only "timeout".

Getting a lock is done with the get-lock script:
```
get-lock <lock_name> <timeout> <timeout2> <step>
```

the defaults value are: default, 30, 0, 1.
the "step" parameters is the number of seconds that pass between each call to get-lock. Usually you will call get-lock inside a loop (a for or a while or until)
and you will have a sleep or some form of delay inside the loop to not go in busy loop, you should use that delay as "step" parameters. here an example:
```
while ! get-lock mylock 10 0 2; do
   echo waiting for lock...
   sleep 2
done
```

get-lock return true (0) when you got it and return false (1) if you have to wait or you have lost it.

In the end of your script you should release the lock with:
```
release-lock <lock_name> <timeout> <timeout2>
```

releasing a lock is important to let other host get it faster than waiting for it to timeout (timeout+timeout2 on waiters).