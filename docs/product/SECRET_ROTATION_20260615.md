# NOVELFLEX Secret Rotation

Date: 2026-06-15

## Action Taken

Sensitive credential files were removed from the project workspace and moved to
a temporary local quarantine outside the repository:

```text
/private/tmp/novelflex-secrets-quarantine/key/
```

Files moved:

- `key/google sign in keys/client_secret_*.json`
- `key/apple signe in/AuthKey_*.p8`
- `key/web key shh/novelflex.pub`

The public SSH key is not a private secret, but it was moved with the rest of
the local key material so the application workspace no longer contains a
credentials folder.

## Git Ignore Protection

`.gitignore` now blocks:

- `.env`
- `.env.*`
- `key/`
- `client_secret_*.json`
- `AuthKey_*.p8`
- private key-like extensions: `.p8`, `.pem`, `.key`

## Required External Rotation

Because the Google OAuth client secret and Apple private key existed inside the
project workspace, treat them as exposed:

1. Revoke/regenerate the Google OAuth web client secret in Google Cloud Console.
2. Revoke/regenerate the Apple Sign in with Apple private key in Apple Developer.
3. Update Supabase Auth provider settings with the new secrets.
4. Store new secrets only in the deployment/secret manager, never in the app
   workspace.

## Verification

After the move, the project workspace no longer contains:

- `BEGIN PRIVATE KEY`
- `client_secret_*.json`
- `AuthKey_*.p8`
