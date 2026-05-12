# Security Policy — Charmed Airflow Solutions

## Reporting a Vulnerability

The easiest way to report a security issue is through a [GitHub Private Security Report](https://github.com/canonical/charmed-airflow-solutions/security/advisories/new) with a description of the issue, the steps you took to create the issue, affected versions, and, if known, mitigations for the issue.

Alternatively, to report a security issue via email, please email [security@ubuntu.com](mailto:security@ubuntu.com) with a description of the issue, the steps you took to create the issue, affected versions, and, if known, mitigations for the issue.

The [Ubuntu Security disclosure and embargo policy](https://ubuntu.com/security/disclosure-policy) contains more information about what you can expect when you contact us and what we expect from you.

## Supported Versions

This repository provides Terraform modules for deploying Charmed Airflow. It follows the same support lifecycle as the underlying Charmed Airflow charms. The product currently ships interim releases; no LTS commitment is made at this time.

| Module Version | Charmed Airflow Track | Status          | End of Standard Support |
| -------------- | --------------------- | --------------- | ----------------------- |
| 3.1.x          | 3.1/edge              | **Pre-release** | TBD                     |

Older module versions receive no further security updates. Users are encouraged to upgrade to a supported version.

## Product Lifetime and Support Phases

| Phase                    | Description                                                       |
| ------------------------ | ----------------------------------------------------------------- |
| **Standard Support**     | Active bug fixes, security patches, and new features.             |
| **Security Maintenance** | Security patches only; no new features or non-critical bug fixes. |
| **End of Life (EOL)**    | No further updates. Users must upgrade to a supported version.    |

Support periods are defined in the Workflows team support policy. The current `3.1` series is in **Pre-release** and will transition to Standard Support upon stable promotion, followed by Security Maintenance prior to its End of Standard Support date.
