# Yii2 bash completion script
-----------------------------

Completion for yii2 console commands

Script parse output of the `./yii help` command and complete commands and options 

----

### To use these routines:

1. Copy this file to somewhere (e.g. `~/yii2-completion.bash`).
2. Add the following line to your .bashrc: `source ~/yii2-completion.bash`

or you can put this file in `/etc/bash_completion.d/`

or simply type `. yii2-completion.bash` for one time using

### Features

1. It can complete all commands defined in app, for example, `migrate/create` or `asset/compress` 
2. It can complete all options options of the commands, for example, `--migrationPath` or `--interactive`

### Todo list

1. Add completion of the command params, for example, `name` for `migrate/create` or `configFile` `bundleFile` for `asset/compress`
2. Add completion of the specific commands, for example, list of migrations for `migrate/mark` or path for `--migrationPath`
