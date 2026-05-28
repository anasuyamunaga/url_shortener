# NOTES.md

## Decisions

### Test framework: RSpec over Minitest

I prefer RSpec for model-heavy apps — the matchers are more readable and
shoulda-matchers makes validation tests really clean. Minitest is fine but
I find myself writing more boilerplate.

### Database: SQLite

Single user app, no reason to spin up Postgres. Easy to swap later if needed.

### Views: ERB + Tailwind

Kept it simple. No React, no heavy frontend. The pages are straightforward
enough that server-rendered ERB is fine. If I needed live updates I'd reach
for Turbo Streams.

---

## Ambiguity calls

### What counts as a visit?

- HEAD requests I skip entirely — these are just bots checking if the URL
  exists, not real clicks
- Bot user agents (Googlebot, Slack, iMessage previews etc) I record but
  flag them. Didn't want to just throw that data away but also didn't want
  them inflating the click count
- No cookie/session dedup — felt like overkill for a single user app and
  adds GDPR complexity for no real benefit here

### IP addresses

Storing raw IPs felt wrong so I hash them with SHA-256 and a daily salt.
Gives me something for dedup later if needed without keeping personal data.
Salt rotates daily so you can't track the same visitor across days.

### Slugs

Auto-generate 6 chars by default — 36^6 combinations is plenty. Also let
users pick a custom slug. If a custom slug is already taken I just show a
form error rather than silently picking a different one, that would be
confusing.

### 302 not 301

301 gets cached by browsers forever. That would break analytics because
repeat visits would never hit the server. 302 every time.

---

## What I'd do with more time

- Paginate the visits table on the detail page
- Add a simple day-by-day chart on the detail page
- Rate limiting on the redirect and create endpoints
- Async visit recording so the DB write doesn't add latency to the redirect
- Better dedup — same IP digest within 30 mins probably shouldn't count twice

---

## Notes

Started with the data model and migrations before touching controllers,
wanted to get the schema solid first. Bot detection I put on the model so
it's testable in isolation. Went back and forth on whether to store bot
visits at all but keeping them with a flag felt like the safer call —
easier to exclude than to recover data you never stored.