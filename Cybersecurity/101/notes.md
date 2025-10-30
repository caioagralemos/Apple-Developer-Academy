# 🛡 Cybersecurity for iOS — Notes

This repository collects condensed notes on iOS and Apple-centric cybersecurity principles — from authentication best practices to secure app design, the CIA triad, and STRIDE threat modeling.

---

## 🔍 1. Overview
Insights from **Cybersecurity 101** sessions and Apple’s security culture.  
Focus: *privacy-first design, risk mitigation, and secure development workflows.*

---

## 🧩 2. Core Concepts — CIA Triad

| Principle | Goal | Example |
|------------|------|----------|
| **Confidentiality** | Keep data secret | Encrypt sensitive info, restrict access |
| **Integrity** | Keep data trustworthy | Safeguards against tampering |
| **Availability** | Keep data accessible | Ensure uptime for critical services |

**Implementation tips**
- Protect API keys, track version control  
- Follow **NIST CSF 2.0**  
- Patch packages and dependencies  
- Use **syntactic & strict validation**  
- Maintain **API allowlists**

---

## ⚠️ 3. STRIDE Threats

| Threat | Description |
|--------|--------------|
| **S**poofing | Impersonating a user or service |
| **T**ampering | Altering data or code |
| **R**epudiation | Denying performed actions |
| **I**nformation Disclosure | Exposing sensitive data |
| **D**enial of Service | Making resources unavailable |
| **E**levation of Privilege | Gaining unauthorized permissions |

---

## 🔐 4. Authentication Practices
- ✅ **MFA (Multi-Factor Authentication)**
- ✅ **Strong password policies**
- ✅ **Security questions / Captcha**
- ❌ DIY login storing plaintext passwords

---

## ⚙️ 5. Secure Software Development Lifecycle (SSDLC)

**Shift-Left Principle:** address security from the *first stage*.

**Phases**
1. Requirements → What data do you collect?  
   - If unnecessary, don’t collect it.  
   - Think authentication early.  
2. Design → Decide on Apple defaults and frameworks.  
3. Implementation → Check API encryption, MFA first.  
4. Testing → Peer + external reviews.  
5. Deployment → Continuous patching & monitoring.

---

## 🧱 6. OWASP Mobile Top 10 Highlights
- Secrets in repos/logs  
- Weak sessions / over-permissions  
- Insecure or outdated SDKs  
- Excessive data sharing  
- Unsafe notifications  
- Missing feature flags or rollbacks  
- “AI in general” — high unpredictability  

---

## 🧠 7. Secure vs Insecure Patterns

| ✅ Secure | ❌ Insecure |
|------------|-------------|
| Sign in with Apple | DIY login storing passwords |
| Face ID / Touch ID | Custom biometric prompts |
| Keychain | UserDefaults / plist for secrets |

---

## 📘 8. Glossary
- **CIA Triad** – Confidentiality, Integrity, Availability  
- **STRIDE** – Threat model framework  
- **SSDLC** – Secure Software Development Lifecycle  
- **MFA** – Multi-Factor Authentication  

---

## 💬 9. Discussion Prompts
- Is Apple’s privacy focus slowing down AI innovation?  
- Will that same foundation make Apple *win long-term*?  
- Why are jailbreaks rare today? *(Matt Kehoe — Apple Security Director)*  

---

## 🧩 10. References
- **OWASP Mobile Top 10**  
- **NIST Cybersecurity Framework 2.0**  
- **Apple Developer Security Documentation**  

---

> “Cybersecurity isn’t a stage — it’s a **cycle**.” 🔁