# The release process of Nushell
## 0. Release direct dependencies
> **Note**
> the following procedure is the same for `nu-ansi-term` and `reedline` and needs to be repeated

> **Warning**
> we usually can't include an update to `nu-ansi-term` unless `lscolors` has already updated to the newer version. if there's a major update to `nu-ansi-term` it needs to be done well beforehand. if not, don't bump it for Nushell

> **Warning**
> release `nu-ansi-term` **before** `reedline` and `reedline` **before** Nushell

> **Note**
> `nu-ansi-term` is typically released only when there are changes to publish.
> `reedline` is typically released on the same schedule as Nushell.

> **Note**
> in the following, `dep` denotes either the `reedline` or the `nu-ansi-term` remote
> e.g. `https://github.com/nushell/reedline` or `git@github.com:nushell/nu-ansi-term`,
> depending on the dependency being installed

- [ ] bump the version (example with [`reedline`][reedline bump example] and [`nu-ansi-term`][nu-ansi-term bump example])
- [ ] get the latest revision with `git pull dep main`
- [ ] publish the crate with `cargo publish` (*need to be a member of the publishing team*)
- [ ] tag the project with `git tag v0.xx.0`
- [ ] push the release tag with `git push dep main --tags`
- [ ] publish the release (include the (breaking) changes and take inspiration from the [other releases](https://github.com/nushell/reedline/releases))
- [ ] bump the version on the Nushell side ([example with `reedline`][reedline pin example]) (reference the release notes for courtesy)

## 1. Minor bump of the version ([example][nushell bump example])
- [ ] in the repo of Nushell, run `/path/to/nu_scripts/make_release/bump-version.nu`
- [ ] then, ensure there are no compilation errors with any combination of features by running:
    ```nushell
    cargo hack --all --feature-powerset --at-least-one-of rustls-tls,native-tls --mutually-exclusive-features rustls-tls,native-tls --mutually-exclusive-features rustls-tls,static-link-openssl --skip default-no-clipboard,stable,mimalloc check
    ```
    (this will take a while...)
- [ ] check for build errors by running:
    ```nushell
    cargo hack --all build
    ```
    (this will build each crate with default features)
- [ ] commit changes with bumped versions (this includes changes to `Cargo.lock`)

## 2. Tag the [`nushell`] repo
> **Warning**
> this is maybe the most critical step of the whole release process!!
> this step, once pushed to *GitHub* will trigger the release workflows.

> **Note**
> in the following, `nushell` will be used to pull and push to the [`nushell`] repo,
> e.g. the `nushell` remote would be `https://github.com/nushell/nushell` or `git@github.com:nushell/nushell`

- [ ] get the latest version bump commit with `git pull nushell main`
- [ ] tag the project with `git tag 0.xx.0`
- [ ] :warning: push the release tag to *GitHub* `git push nushell main --tags` :warning:

:point_right: check the [CI jobs](https://github.com/nushell/nushell/actions)
:point_right: check that there is the same number of targets compared to [last release](https://github.com/nushell/nushell/releases/latest)

## 3. Publish `nu` to *crates.io*
- [ ] check the order of dependencies with `nushell/nu_scripts/make_release/nu_deps.nu` from the `nushell` repo
- [ ] release the Nushell crates `nushell/nu_scripts/make_release/nu_release.nu` from the `nushell` repo
- [ ] **Important!** add any new crates to the `github:nushell:publishing` group on crates.io: `cargo owner --add github:nushell:publishing -p <crate>`

> **Note**
> if there is a new crate, you must add it to the `github:nushell:publishing` group (`cargo owner --list`)
> this will make things very difficult for us next time if you don't, as we won't be able to release new versions of any dependent crates either

> **Note**
> if a step fails
> - ask the owner to `cargo owner --add github:nushell:publishing`
> - edit the `nu_release.nu` script to start again where it failed
> - re-run the script

## 4. Publish the release notes on the website

- [ ] follow and finish the TODOs in the release notes file
- [ ] mark as ready for review when uploading to crates.io
- [ ] land when
    - **fully uploaded** to *crates.io*
    - **before** the GitHub release

## 5. Publish the release on *GitHub*
- [ ] go to the draft release on the [release page](https://github.com/nushell/nushell/releases)
- [ ] grab the message of [last one](https://github.com/nushell/nushell/releases/latest)
- [ ] wait for the website to publish the release (in the [actions](https://github.com/nushell/nushell.github.io/actions) tab and on the [website](https://www.nushell.sh/blog/))
- [ ] publish the release on *GitHub*

## 6. social media
- [ ] post a status update on Discord
- [ ] tweet about the new release

## 7. Create the next release note PR on the website
- [ ] run `./make_release/release-note/create-pr 0.xx.0 ((date now) + 4wk | format date "%Y-%m-%d" | into datetime)`

## 8. Bump the version as development
- [ ] bump the patch version on [`nushell`] ([example][nushell dev example]) by running
```nushell
/path/to/nu_scripts/make_release/bump-version.nu --patch
```

## After the release
The main things to do once a release has been published are
- landing PRs marked with the [`wait-until-after-nushell-release`](https://github.com/nushell/nushell/labels/wait-until-after-nushell-release) label which have been already approved
- listening to the community for feedback


[reedline bump example]: https://github.com/nushell/reedline/pull/596/files
[nu-ansi-term bump example]: https://github.com/nushell/nu-ansi-term/pull/45/files
[reedline pin example]: https://github.com/nushell/nushell/pull/9532
[nushell bump example]: https://github.com/nushell/nushell/pull/9530/files
[nushell dev example]: https://github.com/nushell/nushell/pull/9543

[`nushell`]: https://github.com/nushell/nushell
[`reedline`]: https://github.com/nushell/reedline
[`nu-ansi-term`]: https://github.com/nushell/nu-ansi-term
