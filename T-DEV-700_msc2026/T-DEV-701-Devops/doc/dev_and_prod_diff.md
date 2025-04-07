# Differences between devlopment & production environments

![Drag Racing](dev_vs_prod.png){style="display: block; margin: 0 auto"}

## Dev environement

This will be the heavier container because it will contain all useful tools for debugging such as:

- debugger
- breakpoints management
- available debug logs in terminal
- etc

Moreover, this container will have a watcher. It's a tool that will watch for changes in the code and automatically restart the server. This feature is also called "hot reload".

Finally, the dev container will be hosted on port 3000 and not avaible in https.

## Prod environement

This container will be lighter than the dev one. It will not contain any debugging tools. It will be hosted on port 80 and will be available in https.

The dependencies will be installed with locked versions to avoid any compatibility issues (package-lock.json).

The prod container will not have a watcher. It will be necessary to restart the server manually after each modification.

Sensitive data will be stored in environment variables and not in the code, and .env files will be ignored in the .dockerignore and .gitignore files. Moreover, they will be censored in the logs.
