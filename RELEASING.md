Releasing Guard-Rack
====================

There're no particular rules about when to release guard-rack. Release bug fixes frequenty, features not so frequently and breaking API changes rarely.

### Release

Run tests, check that all tests succeed locally.

```
bundle install
rake
```

Check that the last build succeeded in [Travis CI](https://travis-ci.org/dblock/guard-rack) for all supported platforms.

Increment the version, modify [lib/guard/rack/version.rb](lib/guard/rack/version.rb).

*  Increment the third number if the release has bug fixes and/or very minor features, only (eg. change `0.5.1` to `0.5.2`).
*  Increment the second number if the release contains major features or breaking API changes (eg. change `0.5.1` to `0.2.0`).

Change "Next Release" in [CHANGELOG.md](CHANGELOG.md) to the new version.

```
0.2.0 (2014-01-27)
==================
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Commit your changes.

```
git add CHANGELOG.md lib/guard/rack/version.rb
git commit -m "Preparing for release, 0.2.0."
git push origin master
```

Release.

```
$ rake release

guard-rack 0.2.0 built to pkg/guard-rack-0.2.0.gem.
Tagged v0.2.0.
Pushed git commits and tags.
Pushed guard-rack 0.2.0 to rubygems.org.
```

### Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```
Next Release
============

* Your contribution here.
```

Increment the minor version, modify [lib/guard/rack/version.rb](lib/guard/rack/version.rb).

Comit your changes.

```
git add CHANGELOG.md lib/guard/rack/version.rb
git commit -m "Preparing for next release, 0.2.1."
git push origin master
```
