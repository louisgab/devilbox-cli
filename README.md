# devilbox-cli
> A minimal cli tool to interact with devilbox from anywhere

---

## Description

`devilbox-cli.sh` is a simple and conveniant bash script. It consists of multiple grep and sed in order to easily change the `.env` configuration of devilbox and also a shorthand to start the containers. It has been validated with shellcheck.

## Getting Started

### Requirements
Install devilbox in your home directory:
```sh
cd ~ && git clone https://github.com/cytopia/devilbox
cd devilbox && $ cp env-example .env
```

### Install
Add the cli to your user bin:
```sh
curl -O https://raw.githubusercontent.com/louisgab/devilbox-cli/devilbox-cli.sh
chmod +x devilbox-cli.sh
sudo mv devilbox-cli.sh /usr/local/bin/devilbox
```
If installed successfully, you should see something like this when you run `devilbox -h`:
```sh
Usage: /usr/local/bin/devilbox [OPTION]...

-a=[x.x],--apache=[x.x]     Set a specific apache version
-p=[x.x],--php=[x.x]        Set a specific php version
-m=[x.x],--mysql=[x.x]      Set a specific mysql version
-a=*,--apache=*             Get all available apache versions
-p=*,--php=*                Get all available php versions
-m=*,--mysql=*              Get all available mysql versions
-p,--php                    Get current php version
-a,--apache                 Get current apache version
-m,--mysql                  Get current mysql version
-r=[path],--root=[path]     Set the document root
-r,--root                   Get the current document root
-w=[path],--www=[path]      Set the path to projects
-w,--www                    Get the current path to projects
-d=[path],--database=[path] Set the path to databases
-d,--database               Get the current path to databases
-s,--start                  Start the devilbox docker containers
```

### Usage

The cli provides some basic commands to change settings in your .env file. It also make it easy to see which are the current running settings. Just run any of the commands available according to your needs. Of course its possible to launch multiple commands at once, for example:
```sh
devilbox --apache=2.4 --php=7.2 --mysql=5.7 --start
```
If you run `devilbox --start`, it will use previous settings which are available in `.env` file.

## Contributing
Highly welcomed! The script only implements the basics I needed for myself. It may be useful for others to add missing commands.

## License
[MIT License](LICENSE.md)
