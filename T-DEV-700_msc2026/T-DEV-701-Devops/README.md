# Repo

## Usage

### back

- nodejs
- fastify
- [openfoodfacts](https://openfoodfacts.github.io/openfoodfacts-server/api/ref-v2/)
- [paypal](https://developer.paypal.com/api/rest/)

### devops technologies

- docker
- gitlab
- gitlab runner

## Command line instructions

You can also upload existing files from your computer using the instructions below.

### Configure your Git identity

Get started with Git and learn how to configure it.

Configure your Git identity locally to use it only for this project:

```bash
git config --local user.name "xxxxxxxxx"
git config --local user.email "xx.xx@xx.xx"```
```

save credential localy permanently `git config --local credential.helper store`

### Add files

Push files to this repository using SSH or HTTPS. If you're unsure, we recommend SSH.

#### HTTPS

Create a new repository

```bash
git clone https://t-dev.epitest.eu/NCY_1/T-DEV-701-Devops.git
cd T-DEV-701-Devops
git switch --create main
touch README.md
git add README.md
git commit -m "add README"
git push --set-upstream origin main
```

Push an existing folder

```bash
cd existing_folder
git init --initial-branch=main
git remote add origin https://t-dev.epitest.eu/NCY_1/T-DEV-701-Devops.git
git add .
git commit -m "Initial commit"
git push --set-upstream origin main
```

Push an existing Git repository

```bash
cd existing_repo
git remote rename origin old-origin
git remote add origin https://t-dev.epitest.eu/NCY_1/T-DEV-701-Devops.git
git push --set-upstream origin --all
git push --set-upstream origin --tags
```

#### SSH

[How to use SSH keys?](https://t-dev.epitest.eu/help/user/ssh.md)

Create a new repository

```bash
git clone git@t-dev.epitest.eu:NCY_1/T-DEV-701-Devops.git
cd T-DEV-701-Devops
git switch --create main
touch README.md
git add README.md
git commit -m "add README"
git push --set-upstream origin main
```

Push an existing folder

```bash
cd existing_folder
git init --initial-branch=main
git remote add origin git@t-dev.epitest.eu:NCY_1/T-DEV-701-Devops.git
git add .
git commit -m "Initial commit"
git push --set-upstream origin main
```

Push an existing Git repository

```bash
cd existing_repo
git remote rename origin old-origin
git remote add origin git@t-dev.epitest.eu:NCY_1/T-DEV-701-Devops.git
git push --set-upstream origin --all
git push --set-upstream origin --tags
```

## helper

### gitlab runner

FIRST [New project runner](https://t-dev.epitest.eu/NCY_1/T-DEV-701-Devops/-/runners/new)

add as mininmum label `shared` and in option your accronyme ex `gc`
> second label is for possibly avoid do bad thing in other computer than your

- run docker-compose `docker compose -f "ext/docker-compose.runner.yml" up -d --build`
- first time:

> ```bash
> docker compose exec gitlab-runner /bin/bash # run terminal of container
> gitlab-runner register  --url https://t-dev.epitest.eu  --token xxxxxxxxxxxxxxxxxxx
> ```
>
> response to questions
>
```bash
> Enter a name for the runner. This is stored only in the local config.toml file:
> [fd1cb7995c5a]: 001-gc-dev    # EXAMPLE use 000-name-xxxxxx
> 
> Enter an executor: ssh, parallels, docker, docker-windows, docker+machine, custom, shell, virtualbox, kubernetes, docker-autoscaler, instance:
> docker
> 
> Enter the default Docker image (for example, ruby:2.7):
> debian 
> ```
