# Security Policy

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, report them privately through
[GitHub Security Advisories](https://github.com/pyuan07/meza-helper/security/advisories/new).

Please include:

- The type of issue and where it occurs
- Steps to reproduce, ideally with a proof of concept
- The platform and app version affected
- The impact you believe it has

You can expect an initial response within 7 days. Confirmed issues will be fixed as soon as
practical, and you'll be credited in the advisory unless you'd rather not be.

## Supported Versions

Security fixes are applied to the default branch and released in the next build. Only the latest
release is supported.

## Security Model

MezaHelper is a local-first, offline application:

- All data (trainer passes, tag collection, settings) is stored **on-device** with Hive
- There is **no backend, no account system, and no analytics**
- No user data is transmitted anywhere by the app

The permissions the app requests are for local features only:

| Permission | Used for |
| --- | --- |
| Camera | Scanning QR codes |
| Photo library | Importing a trainer pass from a screenshot |
| Screen brightness | Boosting brightness so arcade scanners can read QR codes |

If you find the app transmitting data, requesting permissions it doesn't need, or storing
sensitive data insecurely, please report it through the process above.

## For Contributors

- Never commit API keys, signing keys, keystores, or `key.properties`
- Android signing configuration must stay out of version control
- Don't add dependencies that phone home or collect analytics without discussion in an issue first
