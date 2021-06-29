# Description

A simple submodule version checker github action.

When used, this will check a submodule dependency against

## Parameters

Just look at the `action.yml` itself, it's <30 lines of code, and will stay up to date.

## How to (by example)

```yaml
name: Check rive-ios sub modules

on:
  # lets check it when we push to master (we've just done something in android, its a good time to see about this)
  push:
    branches:
      - master
  
  schedule:
    # 8am UTC every day
    - cron:  '0 8 * * *'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v2

      - name: Run cpp version check
        uses: rive-app/github-actions-submodule-check@v5
        with:
          SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK }}
          SUBMODULE_GIT_URL: https://github.com/rive-app/rive-cpp.git
```

## Gotchas

This does magic to figure out the submodule repository name, its probably fragile
and will need tweaking when using with repositories with the same name from different organizations.
