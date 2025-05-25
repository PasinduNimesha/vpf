# Framework for Vulnerability Prioritization Using CVSS, EPSS, and Asset Criticality Multiplier

## Overview
This framework provides a systematic method for prioritizing vulnerabilities by combining:
- **CVSS (Common Vulnerability Scoring System)**: Measures the severity of vulnerabilities.
- **EPSS (Exploit Prediction Scoring System)**: Estimates the likelihood of exploitation.
- **Asset Criticality Multiplier (ACM)**: Reflects the importance of the affected asset.

By integrating these factors, organizations can allocate remediation resources efficiently, focusing on vulnerabilities that pose the greatest risk.

---

## Components of the Framework

### 1. CVSS (Common Vulnerability Scoring System)
- Measures the severity of vulnerabilities on a scale of **0.0 to 10.0**.
- Higher scores indicate more severe vulnerabilities.

### 2. EPSS (Exploit Prediction Scoring System)
- Estimates the likelihood of a vulnerability being exploited in the wild.
- Scores range from **0.00001 to 1.0**.

### 3. Asset Criticality Multiplier (ACM)
- Represents the importance of the affected asset to the organization.
- A multiplier is assigned based on the type and criticality of the asset.

---

## Prioritization Formula

The **Final Combined Score** is calculated as:

```
Final Combined Score = Asset Criticality Multiplier (ACM) × (W1 ⋅ Normalized CVSS + W2 ⋅ Normalized EPSS)
```

Where:
- **Normalized CVSS**: CVSS score scaled to a 0 to 1 range:
  ```
  Normalized CVSS = CVSS Raw Score / 10
  ```
- **Normalized EPSS**: EPSS score is already in the 0 to 1 range.
- **W1 and W2**: Weights assigned to CVSS and EPSS to balance their importance.
- **ACM**: Assigned based on the criticality of the asset (e.g., `2.0` for sensitive databases, `1.0` for public-facing blog sites).

---

## Asset Criticality Multiplier (ACM)

The following table provides suggested ACM values based on asset types:

| **Asset Type**               | **ACM** |
|-------------------------------|---------|
| Database with sensitive data  | 2.0     |
| Internal application server   | 1.5     |
| User-facing e-commerce site   | 1.3     |
| Public blog site              | 1.0     |

> Organizations should customize these values based on their own risk assessments and business priorities.

---

## Prioritization Tiers

After calculating the Final Combined Score, vulnerabilities can be grouped into prioritization tiers for action:

| **Final Combined Score** | **Priority Tier**      | **Action**                   |
|---------------------------|------------------------|------------------------------|
| > 1.5                     | Tier 1: Immediate     | Patch within 24-48 hours.    |
| 1.0 – 1.5                 | Tier 2: High Priority | Patch within 1 week.         |
| 0.5 – 1.0                 | Tier 3: Medium Priority | Schedule patching regularly. |
| < 0.5                     | Tier 4: Monitor       | Monitor for active exploits. |

---

## Customization

Organizations can:
- Adjust the **weights (W1, W2)** to reflect their risk tolerance.
- Modify **ACM values** to align with their specific asset criticality assessments.
- Define **tier actions** to meet internal response timelines.

## Contributing
Feel free to submit issues, suggest enhancements, or fork and create pull requests.

