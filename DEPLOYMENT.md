# YatStats deployment runbook

This guide outlines how to deploy the existing YatStats chat stack to Vercel using the already-provisioned Neon database, API integrations, and other managed services.

## Prerequisites
- Vercel project connected to this repository.
- Existing managed resources:
  - Neon Postgres instance (connection string used as `POSTGRES_URL`).
  - Redis/Upstash store for session and rate-limit data (`REDIS_URL`).
  - Vercel Blob store (`BLOB_READ_WRITE_TOKEN`).
  - Vercel AI Gateway access token for non-Vercel environments (`AI_GATEWAY_API_KEY`); Vercel will auto-handle OIDC on the platform.
- Auth secret for NextAuth (`AUTH_SECRET`).
- Vercel CLI installed locally (`npm i -g vercel`).

## Environment variables
Mirror the `.env.example` values in Vercel Project Settings → Environment Variables. At minimum set:

| Variable | Purpose |
| --- | --- |
| `AUTH_SECRET` | NextAuth signing/encryption secret.
| `POSTGRES_URL` | Neon connection string used by Drizzle migrations and the app runtime.
| `REDIS_URL` | Redis/Upstash endpoint for session/state.
| `BLOB_READ_WRITE_TOKEN` | Token for Vercel Blob storage.
| `AI_GATEWAY_API_KEY` | Required when running outside Vercel; on Vercel OIDC is automatic.

Run `vercel env pull` locally to sync the configured values into `.env.local` when needed.

## Database migrations (Neon)
1. Ensure `POSTGRES_URL` points to the Neon database branch you want to use.
2. Generate/apply migrations locally: `pnpm db:migrate` (uses `lib/db/migrate.ts` + Drizzle).
3. For a new environment, run the same command via a Vercel deployment preview or GitHub Action before promoting to production to keep schema in sync.

## Deployment flow (Vercel)
1. Link the project: `vercel link`.
2. Pull environment: `vercel env pull .env.local`.
3. Build locally to validate: `pnpm install && pnpm build`.
4. Deploy:
   - Preview: `vercel --prebuilt` (uses the current `vercel.json` settings).
   - Production: `vercel --prebuilt --prod`.
5. If you want the app to render instead of redirecting to `https://yatstats.godaddysites.com`, adjust or remove `vercel.json` before the production deploy.

## Observability and post-deploy checks
- Confirm database connectivity by opening a session in the app and verifying rows in Neon (Drizzle tables) update.
- Validate file uploads hit Vercel Blob using the configured token.
- Exercise AI chat endpoints to ensure AI Gateway credentials are working in your environment (or that OIDC is being applied automatically on Vercel).
- Monitor the deployment in Vercel for any edge/network errors and roll back if necessary.
