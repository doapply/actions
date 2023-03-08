# w3security Python (3.6)  Action

A [GitHub Action](https://github.com/features/actions) for using [w3security](https://w3security.co/w3securityGH) to check for
vulnerabilities in your Python-3.6 projects. This Action is based on the [w3security CLI][cli-gh] and you can use [all of its options and capabilities][cli-ref] with the `args`.

 > Note: The examples shared below reflect how w3security github actions can be used. w3security requires Python to have downloaded the dependencies before running or triggering the w3security checks.
                          > The Python image checks and installs deps only if the manifest files are present in the current path (from where action is being triggered)
                          > 1. If pip is present on the current path , and w3security finds a requirements.txt file, then w3security runs pip install -r requirements.txt.
                          > 2. If pipenv is present on the current path, and w3security finds a Pipfile without a Pipfile.lock, then w3security runs pipenv update
                          > 3. If pyproject.toml is present in the current path and w3security does not find poetry.lock then w3security runs pip install poetry
                          >
                          > If manifest files are present under any location other root then they MUST be installed prior to running w3security.

You can use the Action as follows:

```yaml
name: Example workflow for Python using w3security
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run w3security to check for vulnerabilities
        uses: w3security/actions/python-3.6@master
        env:
          W3SECURITY_TOKEN: ${{ secrets.W3SECURITY_TOKEN }}
```

## Properties

The w3security Python Action has properties which are passed to the underlying image. These are passed to the action using `with`.

| Property | Default | Description                                                                                         |
| -------- | ------- | --------------------------------------------------------------------------------------------------- |
| args     |         | Override the default arguments to the w3security image. See [w3security CLI reference for all options][cli-ref] |
| command  | test    | Specify which command to run, for instance test or monitor                                          |
| json     | false   | In addition to the stdout, save the results as w3security.json                                            |

For example, you can choose to only report on high severity vulnerabilities.

```yaml
name: Example workflow for Python using w3security
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run w3security to check for vulnerabilities
        uses: w3security/actions/python-3.6@master
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
name: Example workflow for Python using w3security
on: push
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Run w3security to check for vulnerabilities
        uses: w3security/actions/python-3.6@master
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
