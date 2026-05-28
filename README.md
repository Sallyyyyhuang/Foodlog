# Foodlog

A simple food nutrition tracking app built with Ruby on Rails 8. Log your meals, track macros, and review your eating history by day.

## Features

- Log food entries with meal type, calories, and macronutrients (protein, carbs, fats)
- View today's entries at a glance
- Browse historical entries in the archives, grouped by day with daily totals

## Tech Stack

- **Ruby** 3.2.3
- **Rails** 8.0.2
- **SQLite3** (development, test, production)
- **Hotwire** (Turbo + Stimulus) for frontend interactivity
- **Bulma** CSS framework
- **Solid Cache / Solid Queue / Solid Cable**

## Getting Started

### Prerequisites

- Ruby 3.2.3
- Bundler

### Setup

```bash
bin/setup
```

This installs dependencies, creates and migrates the database, and clears logs/tmp.

### Run the development server

```bash
bin/dev
```

The app will be available at `http://localhost:3000`.

## Database

Single `entries` table with the following fields:

| Column        | Type    |
|---------------|---------|
| meal_type     | string  |
| calories      | integer |
| proteins      | integer |
| carbohydrates | integer |
| fats          | integer |
| created_at    | datetime |
| updated_at    | datetime |

## Testing

```bash
bin/rails test              # Unit and controller tests
bin/rails test:system       # System/integration tests (requires Chrome)
```

Screenshots from failed system tests are saved to `tmp/screenshots/`.

## Linting & Security

```bash
bin/rubocop -f github       # Ruby style lint
bin/brakeman -f github      # Security vulnerability scan
bin/importmap audit         # JavaScript dependency audit
```

## CI/CD

GitHub Actions runs on every push and pull request to `main`:

1. **scan_ruby** — Brakeman security scan
2. **scan_js** — ImportMap audit
3. **lint** — RuboCop
4. **test** — Full test suite with Chrome for system tests

Failed test screenshots are uploaded as workflow artifacts.

## Deployment

Deployment is configured with [Kamal](https://kamal-deploy.org/). See `.kamal/` and `config/deploy.yml` for configuration.
