# GitLab Runner tutorial

## Create a runner

**First** create a runner with this [link](https://t-dev.epitest.eu/NCY_1/T-DEV-701-Devops/-/runners/new)

When asked, at least add the labels `shared` & `docker`, optionally you can also add your accronym, eg. `gc`

> Optional label might be useful if you don't want to configure the runner for your code only or prevent others from using it.

When you are on the page with the "Runner created" banner, **keep it open**. You will need the token to register the runner.

> If you close it, you will have to delete the runner and create a new one.

Go to your terminal run  the following command:

``` bash
docker compose -f "ext/docker-compose.runner.yml" up -d --build
```

**If you're running the container for the first time**, some additionnal commands are required :

 ```bash
> cd ./ext
> docker compose -f docker-compose.runner.yml exec gitlab-runner /bin/bash # run terminal of container
> gitlab-runner register  --url https://t-dev.epitest.eu  --token xxxxxxxxxxxxxxxxxxx

```

>You're token can be found on **your runner's creation confirmation page**

After that, on your terminal, you will be asked some questions about your runner. Here are the answers you should give :

```bash
> Enter the GitLab instance URL (for example, https://gitlab.com/):
> Press Enter
> Enter a name for the runner. This is stored only in the local config.toml file:
> [fd1cb7995c5a]: 001-gc-dev    # EXAMPLE use 000-name-xxxxxx
> 
> Enter an executor: ssh, parallels, docker, docker-windows, docker+machine, custom, shell, virtualbox, kubernetes, docker-autoscaler, instance:
> docker
> 
> Enter the default Docker image (for example, ruby:2.7):
> debian 
```

If everything worked correctly, you should see your runner on this [page](https://t-dev.epitest.eu/NCY_1/T-DEV-701-Devops/-/settings/ci_cd)

## Run a pipeline

Once you have a pipeline configured in a `.gitlab-ci.yml` file, you can run it with the following command:

```bash
gitlab-runner register -n \
--url https://t-dev.epitest.eu/  \
--token YOUR_TOKEN \
--executor docker  \
--description "t-dev-01 shared runner"  \
--docker-image "docker:27.2.1"  \
--docker-privileged  \
--docker-volumes "/certs/client"
```
