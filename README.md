# Redox OS PKGAR Repository Builder

Unofficial Redox OS Repository Builder, builds these in GitHub CI:
- Packages similar to [static.redox-os.org/pkg](https://static.redox-os.org/pkg/)
- Toolchains similar to [static.redox-os.org/toolchain](https://static.redox-os.org/toolchain/)

My personal repo is at [wellosoft/redox-os-builder](https://github.com/wellosoft/redox-os-builder). To use my repo, run `sudo echo "https://wellosoft.github.io/redox-os-builder" > /etc/pkg.d/40_custom` inside Redox OS terminal

As of June 2025, Redox OS supports custom repository.

## Why?

- I have forks and I wanted to test it without waiting the official build server
- I don't want to compile heavy packages in my own laptop

## How?

A preview of my personal pkgar remote endpoint is in [the other repo](https://github.com/wellosoft/redox-os-builder/tree/gh-pages), and I only update it when I need it. To make your own version, please fork this repository.

#### Trying out

You can use [my prebuilt redox disk](https://drive.google.com/file/d/1d07z7-zyMgQ9VVP0E0QVPDlgus7SbRo6/view?usp=sharing). It's a qcow2 disk for desktop-minimal Redox OS with a shell script to run it with QEMU. (If you found problem: replace cpu spec with `-accel tcg -cpu max`).

After running the disk please first run `sudo pkg install pkgutils relibc` then after that do install any pkgs you want.

## FAQ

#### How to use `wellosoft.github.io` or any custom repo path to existing Redox OS installation?

If you have compiling the patched pkgutils and it's inside that Redox OS, run `sudo echo "https://wellosoft.github.io/redox-os-builder" > /etc/pkg.d/40_custom` in the terminal.

#### How to test this build system locally?

Fork, clone this repo, and run `bash setup-full.sh`.

#### I made a fork and made adjustments, how to retrigger build?

Go to `Actions` tab and enable CI there. Then, go to `Run setup.sh` and click `Run Workflow`.

Make sure the GitHub action [has read and write](https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication#modifying-the-permissions-for-the-github_token) access (the menu is in Settings > Actions > \[scroll down\] Read and write permissions).

#### The build is finished, how to make it available to GitHub Pages?

First, make sure that there are files in `gh-pages` branch.

Go to settings, pages, Choose deploy from branch and set the branch as `gh-pages`.

#### What is `id_ed25519.pub.toml`?

It's a public key for `pkg` utils verifiying signatures in `.pkgar` files. By default, it's generated and changed every time you want to rebuild.

To persist it across builds, add `PRIVATE_KEY` and `PUBLIC_KEY` to action secrets. The value can be obtained from `cookbook/build/id_ed25519.toml` and `cookbook/build/id_ed25519.pub.toml` after doing local build. 

Note that GitHub secrets can't have multi line so you need to replace it with commas. With that, the typical format for `PRIVATE_KEY` value should be:

```
salt = "XXX", nonce = "YYY", skey = "ZZZ"
```

#### Can I cook all recipes with GitHub CI?

Interesting question. [The last build](https://github.com/wellosoft/redox-os-builder/actions/runs/15524250457/job/43701576712) took 90 minutes with 25GB storage on `/mnt` storage. The GitHub CI is generous enough even without subscription. Free GitHub account gives you free 2000 minutes CI and apparently 70GB in `/mnt` storage. [Just read here](https://docs.github.com/en/actions/using-github-hosted-runners/using-github-hosted-runners/about-github-hosted-runners#standard-github-hosted-runners-for-public-repositories) for GitHub runners.

Generally I think you can cook all recipes if you wish, but it will definitely take longer. Currently I don't cook compilers like LLVM, Cargo and RustPython or even other stuff like games because it's not necessary to me yet.

Of 90 minutes cook recipe from last build, it consist of 8 minutes building tooling and 7 minutes on fetching. It's counting about 66 recipes. The detailed timeline is this:

```
2025-06-09T00:41:32.5758317Z - start
2025-06-09T00:49:36.7999268Z - prefix done
2025-06-09T00:56:27.9442671Z - fetch.sh done
2025-06-09T02:09:39.2612776Z - repo.sh done
2025-06-09T02:09:47.8987185Z - done
```

#### How to do incremental build?

Incremental builds requires `PRIVATE_KEY` and `PUBLIC_KEY` set since initial full build. You can't set it after initial full build otherwise the public keys will be invalid for old pkgar files.

After pushing your own changes in the repo, you can run `Run setup-partial.sh` GitHub Action. There will be an input about list of recipes you want to update &mdash; for example if you put "nano vim" then the CI will run `make prefix f.nano r.nano f.vim r.vim` and updates the repo files and repo.toml accordingly.

#### How to extract pkgar files manually?

I think there's no tool for that yet, but I made [online viewer](https://willnode.github.io/pkgar-analyzer/) for it.
