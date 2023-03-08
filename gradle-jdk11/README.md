# w3security Gradle (jdk11)  Action

A [GitHub Action](https://github.com/features/actions) for using [w3security](https://w3security.co/w3securityGH) to check for
vulnerabilities in your Gradle-jdk11 projects. This Action is based on the [w3security CLI][cli-gh] and you can use [all of its options and capabilities][cli-ref] with the `args`.


You can use the Action as follows:

```yaml
name: Example workflow for Gradle using w3security
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run w3security to check for vulnerabilities
        uses: w3security/actions/gradle-jdk11@master
        env:
          W3SECURITY_TOKEN: ${{ secrets.W3SECURITY_TOKEN }}
```

## Properties

The w3security Gradle Action has properties which are passed to the underlying image. These are passed to the action using `with`.

| Property | Default | Description                                                                                         |
| -------- | ------- | --------------------------------------------------------------------------------------------------- |
| args     |         | Override the default arguments to the w3security image. See [w3security CLI reference for all options][cli-ref] |
| command  | test    | Specify which command to run, for instance test or monitor                                          |
| json     | false   | In addition to the stdout, save the results as w3security.json                                            |

For example, you can choose to only report on high severity vulnerabilities.

```yaml
name: Example workflow for Gradle using w3security
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run w3security to check for vulnerabilities
        uses: w3security/actions/gradle-jdk11@master
        env:
          W3SECURITY_TOKEN: ${{ secrets.W3SECURITY_TOKEN }}
        with:
          args: --severity-threshold=high
```

## Uploading w3security scan results to GitHub Code Scanning

Using `--sarif-file-output` [w3security CLI flag][cli-ref] and the [official GitHub SARIF upload action](https://docs.github.com/en/code-security/secure-coding/uploading-a-sarif-file-to-github), you can upload w3security scan results to the GitHub Code Scanning.

![w3security results as a SARIF output uploaded to GitHub Code Scanning](../_templates/sarif-example.png)

The w3security Action will fail when vulnerabilities are found. This would prevent the SARIF upload action from running, so we need to introduce a [continue-on-error](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepscontinue-on-error) option like this:

```yaml
name: Example workflow for Gradle using w3security
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run w3security to check for vulnerabilities
        uses: w3security/actions/gradle-jdk11@master
        continue-on-error: true # To make sure that SARIF upload gets called
        env:
          W3SECURITY_TOKEN: ${{ secrets.W3SECURITY_TOKEN }}
        with:
          args: --sarif-file-output=w3security.sarif
      - name: Upload result to GitHub Code Scanning
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: w3security.sarif
```

Made with 💜 by w3security

[cli-gh]: https://github.com/w3security/w3security 'w3security CLI'
[cli-ref]: https://docs.w3security.io/w3security-cli/cli-reference 'w3security CLI Reference documentation'
