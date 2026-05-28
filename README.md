# Snip — URL Shortener

A Rails 8 URL shortener with click analytics. See `NOTES.md` for architectural decisions.

## Setup

```bash
bundle install
bin/rails db:create db:migrate
bin/dev
```

## Run tests

```bash
bundle exec rspec
```

## Routes

| Method | Path           | Description                                       |
|--------|----------------|---------------------------------------------------|
| GET    | `/`            | Dashboard: all links, click counts                |
| GET    | `/links/new`   | Form to create a new link                         |
| POST   | `/links`       | Create a link                                     |
| GET    | `/links/:slug` | Detail: total visits + last 50 with UA, referrer  |
| GET    | `/r/:slug`     | Public redirect — records visit, 302 to target    |

## Key decisions

See **NOTES.md** for full rationale. TL;DR:
- HEAD requests are never recorded (bot probes)
- Bot/previewer visits are stored but flagged and excluded from headline counts
- Auto-generated 6-char slugs; custom slugs accepted; collision → form error
- IPs stored as daily-salted SHA-256 digests only (privacy-by-design)
- 302 redirect (not 301) so every visit hits the server
