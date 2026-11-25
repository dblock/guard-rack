# Releasing Guard-Rack

There are no particular rules about when to release guard-rack. Release bug fixes frequently, features not so frequently and breaking API changes rarely.

## Release

Run tests, check that all tests succeed locally.

```sh
bundle install
bundle exec rake
```

Check that the current master branch can successfully run [grape-on-rack](https://github.com/dblock/grape-on-rack).

Check that the last build succeeded in [GitHub Actions](https://github.com/dblock/guard-rack/actions) for all supported platforms.

Increment the version, modify [lib/guard/rack/version.rb](lib/guard/rack/version.rb).

* Increment the third number if the release has bug fixes and/or very minor features, only (e.g. change `0.5.1` to `0.5.2`).
* Increment the second number if the release contains major features or breaking API changes (e.g. change `0.5.1` to `0.6.0`).

Change "Next" in [CHANGELOG.md](CHANGELOG.md) to the release date.

```markdown
### 0.6.0 (2014/01/27)
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Commit your changes.

```sh
git add CHANGELOG.md lib/guard/rack/version.rb
git commit -m "Preparing for release, 0.6.0."
git push origin master
```

Release.

```console
$ rake release

guard-rack 0.6.0 built to pkg/guard-rack-0.6.0.gem.
Tagged v0.6.0.
Pushed git commits and tags.
Pushed guard-rack 0.6.0 to rubygems.org.
```

## Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```markdown
### 0.6.1 (Next)

* Your contribution here.
```

Increment the third version number, modify [lib/guard/rack/version.rb](lib/guard/rack/version.rb).

Commit your changes.

```sh
git add CHANGELOG.md lib/guard/rack/version.rb
git commit -m "Preparing for next developer iteration, 0.6.1."
git push origin master
```
