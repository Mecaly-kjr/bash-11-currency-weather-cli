# 💱 bash-11-currency-weather-cli

A Bash command-line application that converts currencies using live exchange rates and displays current weather information for any city.

---

## 📌 Problem Statement

Freelancers in Cameroon receive payments in different currencies and need reliable exchange rates. They also need weather updates to plan their daily activities. This project provides both services directly from the terminal.

---

## 🎯 Project Goals

- Convert currencies using live exchange rates.
- Support USD, EUR, XAF and other supported currencies.
- Display current weather for any city.
- Validate user inputs and handle network errors.
- Provide a simple command-line experience.

---

## 🛠 Tech Stack

- **Language:** Bash
- **HTTP Requests:** curl
- **JSON Processing:** jq
- **Calculations:** awk
- **Version Control:** Git & GitHub
- **APIs:** ExchangeRate API and wttr.in

---

## 🖥 Features

- Live currency conversion.
- Uppercase and lowercase currency codes.
- Amount and currency validation.
- Weather information for any city.
- City names with spaces supported.
- Default weather city using `METEO_CITY` or Yaounde.
- Network error handling.
- Shared functions in `lib.sh`.

---

## 📷 Screenshots

![alt text](<asset/images/Screenshot From 2026-11-02 16-20-47.png>)
![alt text](<asset/images/Screenshot From 2026-11-02 16-21-12.png>)
![alt text](<asset/images/Screenshot From 2026-11-02 16-21-25.png>)
![alt text](<asset/images/Screenshot From 2026-11-02 16-22-13.png>)

---

## ⚙ Installation & Setup

Clone the repository:

```bash
git clone https://github.com/Mecaly-kjr/bash-11-currency-weather-cli.git
cd bash-11-currency-weather-cli
```

Install dependencies:

```bash
sudo apt update
sudo apt install curl jq gawk -y
```

Make scripts executable:

```bash
chmod +x fx.sh meteo.sh
```

---

## 🚀 Usage

**Currency conversion:**

```bash
./fx.sh 250 USD XAF
./fx.sh 100 EUR XAF
```

**Weather information:**

```bash
./meteo.sh
./meteo.sh Bamenda
./meteo.sh "New York"
```

**Set default city:**

```bash
METEO_CITY=Bamenda ./meteo.sh
```

---

## 🧠 Challenges Faced

- Connecting Bash scripts to external APIs.
- Processing JSON responses using jq.
- Handling network failures.
- Validating currency codes and amounts.

---

## 📚 What I Learned

- Bash functions and reusable libraries.
- Making HTTP requests with curl.
- Processing JSON with jq.
- Performing calculations with awk.
- Handling errors and exit codes.

---

## 🔮 Future Improvements

- Add more currency conversion features.
- Display weather forecasts.
- Improve error messages.
- Add automated tests.

---

## 👨🏽‍💻 Author

Mecaly Luther Bobbilla

[mecalyluther64@gmail.com](mailto:mecalyluther64@gmail.com)

Junior Developer | Software Engineering

Based in Cameroon.
