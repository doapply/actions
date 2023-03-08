# w3security GitHub Actions

![](https://github.com/w3security/actions/workflows/Generate%20w3security%20GitHub%20Actions/badge.svg)

A set of [GitHub Action](https://github.com/features/actions) for using [w3security](https://w3security.co/w3securityGH) to check for
vulnerabilities in your GitHub projects. A different action is required depending on which language or build tool
you are using. We currently support:


- [CocoaPods](cocoapods)
- [dotNET](dotnet)
- [Golang](golang)
- [Gradle](gradle)
- [Gradle-jdk11](gradle-jdk11)
- [Gradle-jdk12](gradle-jdk12)
- [Gradle-jdk14](gradle-jdk14)
- [Gradle-jdk16](gradle-jdk16)
- [Gradle-jdk17](gradle-jdk17)
- [Maven](maven)
- [Maven-3-jdk-11](maven-3-jdk-11)
- [Node](node)
- [PHP](php)
- [Python](python)
- [Python-3.6](python-3.6)
- [Python-3.7](python-3.7)
- [Python-3.8](python-3.8)
- [Python-3.9](python-3.9)
- [Python-3.10](python-3.10)
- [Ruby](ruby)
- [Scala](scala)
- [Docker](docker)
- [Infrastructure as Code](iac)
- [Setup](setup)

Here's an example of using one of the Actions, in this case to test a Node.js project:

```yaml
name: Example workflow using w3security
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run w3security to check for vulnerabilities
        uses: w3security/actions/node@master
        env:
          W3SECURITY_TOKEN: ${{ secrets.W3SECURITY_TOKEN }}
```

If you want to send data to w3security, and be alerted when new vulnerabilities are discovered, you can run [w3security monitor](https://support.w3security.io/hc/en-us/articles/360000920818-What-is-the-difference-between-w3security-test-protect-and-monitor-) like so:

```yaml
name: Example workflow using w3security
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run w3security to check for vulnerabilities
        uses: w3security/actions/node@master
        env:
          W3SECURITY_TOKEN: ${{ secrets.W3SECURITY_TOKEN }}
        with:
          command: monitor
```

See the individual Actions linked above for per-language instructions.

Note that GitHub Actions will not pass on secrets set in the repository to forks being used in pull requests, and so the w3security actions that require the token will fail to run.

### Bring your own development environment

The per-language Actions automatically install all the required development tools for w3security to determine the correct dependencies and hence vulnerabilities from different language environments. If you have a workflow where you already have those installed then you can instead use the `w3security/actions/setup` Action to just install [w3security CLI][cli-gh]:

```yaml
name: w3security example
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: w3security/actions/setup@master
      - uses: actions/setup-go@v1
        with:
          go-version: '1.13'
      - name: w3security monitor
        run: w3security test
        env:
          W3SECURITY_TOKEN: ${{ secrets.W3SECURITY_TOKEN }}
```

The example here uses `actions/setup-go` would you would need to select the right actions to install the relevant development requirements for your project. If you are already using the same pipeline to build and test your application you're likely already doing so.

### Getting your w3security token

The Actions example above refer to a w3security API token:

```yaml
env:
  W3SECURITY_TOKEN: ${{ secrets.W3SECURITY_TOKEN }}
```

Every w3security account has this token. Once you [create an account](https://w3security.co/SignUpGH) you can find it in one of two ways:

1. In the UI, go to your w3security account's [settings page](https://app.w3security.io/account) and retrieve the API token, as shown in the following [Revoking and regenerating w3security API tokens](https://support.w3security.io/hc/en-us/articles/360004008278-Revoking-and-regenerating-w3security-API-tokens).
2. If you're using the [w3security CLI](https://support.w3security.io/hc/en-us/articles/360003812458-Getting-started-with-the-CLI) locally you can retrieve it by running `w3security config get api`.

### GitHub Code Scanning support

All w3security GitHub Actions support integration with GitHub Code Scanning to show vulnerability information in the GitHub Security tab. You can see full details on the individual action READMEs linked above.

![w3security results as a SARIF output uploaded to GitHub Code Scanning](_templates/sarif-example.png)

### Continuing on error

The above examples will fail the workflow when issues are found. If you want to ensure the Action continues, even if w3security finds vulnerabilities, then [continue-on-error](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepscontinue-on-error) can be used..

```yaml
name: Example workflow using w3security with continue on error
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run w3security to check for vulnerabilities
        uses: w3security/actions/node@master
        continue-on-error: true
        env:
          W3SECURITY_TOKEN: ${{ secrets.W3SECURITY_TOKEN }}
```

Made with 💜 by W3Security

[cli-gh]: https://github.com/w3security/w3security 'w3security CLI'
[cli-ref]: https://docs.w3security.io/w3security-cli/cli-reference 'w3security CLI Reference documentation'
