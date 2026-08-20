# Turning on sync

Until you do this, Trace runs exactly as it does now: a local file, boards saved in
this browser. Nothing below is required to keep using it.

Two things have to exist for "log in from any device" to mean anything:
a **database with accounts** (Supabase), and the app **on the web** rather than on
your hard drive (a phone can't open a file that lives on your Mac).

Roughly 10 minutes. I can't do these steps for you — they need your email and your
accounts.

---

## 1. Make the database — ~4 min

1. Go to **https://supabase.com** and sign up (free tier is plenty).
2. **New project**. Any name. Pick a region near you. It takes ~2 min to boot.
3. Left sidebar → **SQL Editor** → **New query**.
4. Open `schema.sql` from this folder, paste the whole thing in, press **Run**.
   You should see "Success. No rows returned."
5. Left sidebar → **Settings** (gear) → **API**. Copy two values:
   - **Project URL** — looks like `https://abcdefghijklm.supabase.co`
   - **anon public** key — a very long string starting with `ey...`
6. Open `config.js` in this folder and paste them between the quotes. Save.

> The anon key is *meant* to be public — it's in every visitor's browser. The SQL you
> just ran is what actually protects the data: every query is filtered to the signed-in
> user's own rows, so the key alone gets nobody anything.

## 2. Let Supabase email you the sign-in link — ~1 min

Still in Supabase: **Authentication → URL Configuration**.

- **Site URL**: for now `http://localhost:8000`. Once step 3 gives you a real
  address, change this to that address.
- **Redirect URLs**: add both the localhost one and your real address.

Free-tier email is rate-limited (a few per hour) — fine for you, not for a crowd.
If you ever hit it, that same screen lets you plug in your own SMTP.

## 3. Put it on the web — ~5 min

Sync needs a real URL. Pick one:

**Netlify Drop** — fastest, no account needed to try
1. Go to https://app.netlify.com/drop
2. Drag this whole `tracenotes` folder onto the page.
3. You get a URL like `https://something-random.netlify.app`. That's it.

**GitHub Pages** — you already have GitHub
```bash
cd ~/tracenotes
git init && git add -A && git commit -m "Trace"
gh repo create tracenotes --private --source=. --push
```
Then on github.com → repo → **Settings → Pages** → Source: `main`, folder: `/ (root)`.
Your URL is `https://<your-username>.github.io/tracenotes/`.
(Private repos need GitHub Pro for Pages; make it `--public` if not — the anon key
is safe to publish, but your *notes* are in the database, never in the repo.)

Whichever you pick, go back to **step 2** and put that URL in Site URL + Redirect URLs.

## 4. Use it

Open your new URL → **Sign in** (top right) → type your email → check your inbox →
click the link. The dot next to the button turns green when everything's saved.

Open the same URL on your phone, sign in with the same email, and your boards are there.

---

## How it behaves

- **Offline-first.** The browser copy is the working copy. Lose your connection and
  you keep writing; it uploads when you're back.
- **Last write wins, per board.** Edit the same board on two devices at once and the
  most recent save of that board is the one that survives. Different boards never
  collide.
- **It pulls when you focus the tab** — switch back from your phone and hit the tab,
  and it catches up.
- **Nothing leaves your machine until you sign in.** No account, no upload.
