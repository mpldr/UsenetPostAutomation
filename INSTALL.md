# Installation
##Requirements
- par2cmdline
    - for creating par2 Parity Files
- rar
    - for creating rar Archives
- php
    - for generating nzblnk
- nyuu
    - for uploading
- pwgen
    - for random strings

### manual Installation
1. Install all required Packages (see you package-manager)
2. download all scripts and extract them to some place
3. create valid `~/.nyuu.config` (see [here](https://github.com/animetosho/Nyuu/blob/master/config-sample.json))
4. create `~/.usenetpwd` (i.e. `$pwgen -s 16 1 > ~/.usenetpwd`)
5. either create symlinks to the scriptfiles in a directory in `$PATH`, copy them to a directory in `$PATH` or add the directory you extracted them to to `$PATH`
6. Happy Posting

### automatic Installation (WIP)
1. run `curl -sSL https://download.my-co.de/upa | bash`
2. follow the instructions on your screen
3. Happy Posting