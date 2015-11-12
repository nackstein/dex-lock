dex-lock is born to substitute lite-raft (a consensus based replicated state machine)
as the locking mechanism for back-to-work (a failover cluster manager).

dex-lock enable a program (usually a shell script) to get an exclusive lock network wide.
the core logic is derived from Raft (and the lite-raft implementation) with some
modification to better suite its restricted feature set.

the objective of dex-lock is to be portable, small, relatively fast, easier to debug than lite-raft and most of all formally correct in its logic.

Mail me at: luigi |dot| tarenga |at| gmail |dot| com