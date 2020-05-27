# Devilbox CLI

![npm](https://img.shields.io/npm/v/devilbox-cli.svg?style=flat-square)
![npm](https://img.shields.io/npm/dt/devilbox-cli.svg?style=flat-square)
![GitHub file size in bytes](https://img.shields.io/github/size/louisgab/devilbox-cli/dist/devilbox-cli.sh.svg?style=flat-square)
[![GitHub license](https://img.shields.io/github/license/louisgab/devilbox-cli.svg?style=flat-square)](https://github.com/louisgab/devilbox-cli/blob/master/LICENSE)

> A simple and conveniant command line to manage devilbox from anywhere

---

## Getting Started

### Requirements

You need [Devilbox](https://github.com/cytopia/devilbox#quick-start) to be installed somewhere on your computer.

By default, the script will use the path `$HOME/.devilbox`.
If you have cloned devilbox somewhere else, add the following to your profile and change `##PATH_TO_DEVILBOX##` accordingly:

```sh
export DEVILBOX_PATH="$HOME/##PATH_TO_DEVILBOX##"
```

Then reload your terminal or run `source ~/.zshrc` if you use zsh.

### Install

As simple as :

```
npm install -g devilbox-cli
```

If installed successfully, you should see something like this when you run `devilbox -v`:

```sh
devilbox-cli v0.3.2 (2020-05-27)
A simple and conveniant cli to manage devilbox from anywhere
https://github.com/louisgab/devilbox-cli
```

### Usage

devilbox-cli provides all basic command to manage your installation:

```sh
devilbox run     # Start the containers
devilbox enter   # Enter the php container with shell.sh script
devilbox open    # Open the devilbox intranet
devilbox stop    # Stop all containers
devilbox restart # Stop and restart all containers
devilbox update  # Update to latest devilbox version
```

To see containers current versions defined in devilbox `.env` file, use the `config` command:

```sh
devilbox config --apache --php --mysql
# [!] Apache current version is 2.4
# [!] PHP current version is 7.2
# [!] MySql current version is 5.6
```

It can also list available versions of any container:

```sh
devilbox config --mysql=*
# [!] MySql available versions:
# 5.5
# 5.6
# 5.7
# 8.0
```

And of course, it can change any version:

```sh
devilbox config --php=7.3
# [✔] PHP version updated to 7.3
```

You can also point devilbox to your projects folder:

```sh
devilbox config --www=../Documents/Projects/www
# [✔] Projects path config updated to ../Documents/Projects/wwww
```

And if you dont remember a command, `devilbox help` is your best friend :)

### Optional Configuration

By default, the `run` command will start the default LAMP stack containers `php httpd mysql`. The command can be customized by configuring your desired services via the `$DEVILBOX_CONTAINERS` variable. For example, if you'd like to also run the NOSQL stack, you would define the following:

```sh
export DEVILBOX_CONTAINERS="php httpd mysql redis memcd mongo"
```

Then reload your terminal or run `source ~/.zshrc` if you use zsh.

### Important notes

The script was tested on zsh and bash on linux. Use at your own risk on other platforms.

## Contributing

Highly welcomed! The script only implements the basics I needed for myself (LAMP). It may be useful for others to add missing commands, test it on macOS and Windows, and test in on other shells.

## License

[MIT License](LICENSE.md)
