# Setting up `code-server` on an Gitpod workspace image

An basic Dockerfile template to convert an existing Gitpod workspace image into an code-server workspace image.

## Getting started

1. [Fork this repo](https://github.com/code-server-boilerplates/gp-ws-images-with-codeserver/fork) or [use the repository generation method](https://github.com/code-server-boilerplates/gp-ws-images-with-codeserver/generate). The latter is recommended if you want to create an private repo without the mess of manual duplication.
2. Change L3 of `Dockerfile` to your own Gitpod workspace image if you use custom one OR see below for the build args methood.
3. Build and ship it to whatever you want to do.
4. Profit!

## Overriding image via build args

In some PaaS services like Railway which passes your variables in form of Docker build arguments.
You just need to just update this specific line to look like this diff below:

```diff
-FROM gitpod/workspace-full AS final-image
+FROM ${CUSTOM_WORKSPACE_IMAGE} AS final-image
```

You can choose what variable name you use as an Docker build argument, but in this example above we chose `CUSTOM_WORKSPACE_IMAGE`.
