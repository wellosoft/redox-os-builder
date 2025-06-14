# Redox OS PKGAR Repository Builder

This is an unofficial repo to build [Redox OS](https://www.redox-os.org/faq/) using GitHub CI. However, this doesn't build into an `.img` file &mdash; the final product is to be the personal remote repository of pkgar files similar to [static.redox-os.org/pkg](https://static.redox-os.org/pkg/).

One of example build is in [this repo](https://github.com/wellosoft/redox-os-builder/tree/gh-pages). To use it, run `sudo echo "https://wellosoft.github.io/redox-os-builder" > /etc/pkg.d/40_custom` inside Redox OS terminal, that will add that new repo URL besides the official Redox OS repo. (there's [a caveat](#how-to-use-wellosoftgithubio-or-any-custom-repo-path-to-existing-redox-os-installation) to this behavior) which then can be used for `pkg install <package>`.

## Why?

> Please try [building Redox OS](https://doc.redox-os.org/book/podman-build.html) if you haven't try it before

Redox OS is unstable (0.x as of this written). The quickest way to try the latest version is to spin QEMU in [their latest demo images](https://static.redox-os.org/img/x86_64/) but to involve into Redox OS development one must build images from [the GitLab main repo](https://gitlab.redox-os.org/redox-os/redox/).

This creates a problem if you wanted to try Redox OS in a semi permanent way, like to install it to a bare metal machine or just to keep the OS live a little longer along with your personal files inside &mdash; because every time you made changes, even a simple cookbook recipe, you have to rebuild the disk, hence you'll lost all changes inside the disk previously.

The solution to this problem is you have to setup a pkgar remote endpoint for yourself. A pkgar remote endpoint is similar to  [static.redox-os.org/pkg](https://static.redox-os.org/pkg/), where `pkg`, a Redox OS package manager, fetches the latest changes that is already built by Redox OS maintainers. [static.redox-os.org/pkg](https://static.redox-os.org/pkg/) is the official pkgar remote endpoint but currently it's not linked to any CI, hence waiting maintainers to update it from time to time.

For most people like me that uses Linux to compile Redox OS and doesn't want to nuke the existing Redox OS disk, having a pkgar remote endpoint for myself is essential. It's currently the only way to update Redox OS software without having to maintainers merge your MR let alone updating the official pkgar remote endpoint. This repository will help you *that*, and you don't need any VM, just host it later with GitHub CI is sufficient enough.

## How?

A preview of my personal pkgar remote endpoint is in [the other repo](https://github.com/wellosoft/redox-os-builder/tree/gh-pages), and I only update it when I need it. To make your own version, please fork this repository.

#### Building custom pkgar remote endpoint with GitHub CI

The CI responsible to building pkgar files is in [build.yml](./.github/workflows/build.yml). The build system follows the same principle as you would do by running `make rebuild` in Redox OS repo. The difference is the process stopped once all pkgar cook all software you want to build and all pkgar artifacts is served via GitHub Pages.

The software I want to build is specified in [config](./config) and [setup.sh](./setup.sh) files. The `setup.sh` specifies what Redox OS repo URL and branch to clone from, and  [config](./config) specified what config and arch to choose.

In the `setup.sh` I choose `git clone https://gitlab.redox-os.org/willnode/redox -b personal` because it contains my preferred setup and some yet-to-be-merged patches. You can change the repo URL and branch at your own fork.

After a full build you can do [incremental building](#how-to-do-incremental-build) next time.

#### Trying out the custom pkgar remote endpoint

If you want to use my personal or your own pkgar remote endpoint, you need a build of Redox OS that have [a patched pkgutils](https://gitlab.redox-os.org/redox-os/pkgutils/-/merge_requests/52) that will work with repo URLs other than `static.redox-os.org`. 

The easiest way to do that is use [my prebuilt redox disk](https://drive.google.com/file/d/1d07z7-zyMgQ9VVP0E0QVPDlgus7SbRo6/view?usp=sharing). It's a qcow2 disk for desktop-minimal Redox OS with a shell script to run it with QEMU. (If you found problem: replace cpu spec with `-accel tcg -cpu max`).

After running the disk please first run `sudo pkg install pkgutils relibc` then after that do install any pkgs you want.

Alternatively, you can build the disk locally by `git clone https://gitlab.redox-os.org/willnode/redox -b personal` and perform `make qemu` there. The branch includes
- [Some changes](https://gitlab.redox-os.org/willnode/redox/-/blob/personal/config/base.toml) in the base config to add `https://wellosoft.github.io/redox-os-builder` repo (you can change this to your own repo too)
- Some changes in the base config also, to add `touch /tmp/pkg_download/prefer_cache`, a way to [skip redownloading packages](https://gitlab.redox-os.org/redox-os/pkgutils/-/merge_requests/52) from remote until reboot
- Some changes in the cookbook to include patched pkgutils

## FAQ

#### How to use `wellosoft.github.io` or any custom repo path to existing Redox OS installation?

Currently it's not possible until the required MR merged and compiled.

If you have compiling the patched pkgutils and it's inside that Redox OS, run `sudo echo "https://wellosoft.github.io/redox-os-builder" > /etc/pkg.d/40_custom` in the terminal.

#### How to test this build system locally?

Fork, clone this repo, and run `bash setup.sh`.

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
