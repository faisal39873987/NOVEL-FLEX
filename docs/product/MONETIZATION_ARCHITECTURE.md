# NOVELFLEX Monetization Architecture

Date: 2026-06-13
Status: Future phase after launch
Scope: Design only. No implementation.

## 1. Principle

Monetization must not ship in the MVP. NOVELFLEX should first prove the Arabic reading loop: discovery, reading, library, reviews, follows, author publishing, and admin moderation.

This architecture is a future operating model for paid content, subscriptions, author revenue, wallet balances, and withdrawals. It must not be exposed to users until product, legal, tax, payment, App Store, Google Play, and Supabase security readiness are complete.

## 2. Monetization Goals

- Let readers unlock premium chapters safely.
- Let readers subscribe to platform or author plans.
- Let authors earn from eligible premium content.
- Give authors a transparent wallet and payout history.
- Keep all financial actions auditable.
- Keep payment secrets and payout logic server-side only.
- Comply with Apple App Store and Google Play digital goods rules.

## 3. Non-Goals For MVP

- No paid chapters in launch MVP.
- No coins, gems, or wallet UI in launch MVP.
- No withdrawal requests in launch MVP.
- No author revenue dashboard in launch MVP.
- No creator contracts or monetization promises in launch MVP.
- No client-side payment authority.

## 4. Actors

Reader:

- Buys premium access through approved payment flows.
- Views unlocked premium chapters.
- Manages subscription status.

Author:

- Marks eligible chapters as premium after approval.
- Views estimated earnings.
- Requests withdrawals when eligible.

Admin:

- Approves author monetization eligibility.
- Reviews premium content policy compliance.
- Reviews payout and withdrawal risk.
- Handles disputes, refunds, and fraud flags.

Backend:

- Owns entitlements, payment verification, ledger entries, revenue splits, and withdrawal state.
- Receives payment provider webhooks.
- Never trusts client-side purchase claims without provider verification.

## 5. Premium Chapters

### Concept

A premium chapter is a chapter that requires an entitlement before the full content is readable. The public reader may see metadata, title, excerpt, and locked state, but not the paid body or protected file.

### Required Data Model

Future tables or fields:

- `chapters.is_premium`
- `chapters.price_amount` or `chapter_prices`
- `chapters.price_currency`
- `chapters.premium_status`: `draft`, `pending_review`, `approved`, `rejected`, `disabled`
- `chapter_entitlements`
  - `id`
  - `user_id`
  - `book_id`
  - `chapter_id`
  - `source`: `purchase`, `subscription`, `admin_grant`, `promotion`
  - `expires_at`
  - `created_at`

### Access Rules

- Anonymous users can view premium metadata only.
- Authenticated readers can read premium content only with a valid entitlement.
- Authors can preview their own premium drafts.
- Admins can review premium content.
- RLS must prevent direct content reads without entitlement.

### Reader Flow

1. Reader opens novel details.
2. Chapter list shows free and premium chapters.
3. Reader taps locked chapter.
4. App explains unlock requirement.
5. Reader purchases or subscribes through approved platform payment flow.
6. Backend verifies purchase.
7. Backend grants entitlement.
8. Reader opens chapter.

### Production Risks

- App Store and Google Play may require in-app purchases for digital content.
- Web payments and mobile payments may have different rules.
- Refunds must revoke or adjust entitlements.
- Premium content must not leak through public storage URLs.

## 6. Subscriptions

### Subscription Types

Platform subscription:

- Grants access to a defined premium catalog tier.
- May include ad-free or reader convenience benefits if ads exist later.

Author subscription:

- Grants access to premium chapters from one author or author tier.
- Requires clear revenue attribution.

Limited promotional subscription:

- Trial or campaign access.
- Must have explicit expiry.

### Required Data Model

Existing architecture already mentions:

- `plans`
- `user_subscriptions`
- `user_entitlements`
- `purchase_events`

Future plan fields:

- `plans.provider`: `apple`, `google`, `stripe`, `revenuecat`, `manual`
- `plans.scope`: `platform`, `author`, `book`
- `plans.author_id`
- `plans.price_amount`
- `plans.currency`
- `plans.billing_period`
- `plans.is_active`

Subscription state:

- `trialing`
- `active`
- `past_due`
- `paused`
- `cancelled`
- `expired`
- `refunded`

### Provider Strategy

Mobile:

- Use Apple In-App Purchase for iOS digital reading access.
- Use Google Play Billing for Android digital reading access.
- A provider aggregator such as RevenueCat can normalize receipts and webhooks.

Web:

- Use Stripe only if policy allows web purchases for the target distribution.
- Do not route mobile users to external checkout for digital goods if that violates store rules.

### Entitlement Sync

1. Client starts purchase through platform SDK.
2. Provider returns receipt or transaction state.
3. Backend/webhook verifies with provider.
4. Backend records `purchase_events`.
5. Backend updates `user_subscriptions`.
6. Backend grants or refreshes `user_entitlements`.
7. Client refreshes session/data and unlocks eligible content.

## 7. Author Revenue Sharing

### Revenue Model

Revenue sharing should be ledger-based, not computed directly from UI counters.

Possible inputs:

- Direct chapter unlocks.
- Subscription revenue allocation.
- Promotional grants with no revenue.
- Refunds and chargebacks.
- Platform fees.
- Store fees.
- Tax withholding or VAT/GST handling.

### Required Ledger

Future tables:

- `author_revenue_ledger`
  - `id`
  - `author_id`
  - `source_type`: `chapter_purchase`, `subscription_allocation`, `adjustment`, `refund`, `chargeback`
  - `source_id`
  - `gross_amount`
  - `platform_fee_amount`
  - `store_fee_amount`
  - `tax_amount`
  - `author_amount`
  - `currency`
  - `status`: `pending`, `available`, `held`, `reversed`, `paid`
  - `available_at`
  - `created_at`

### Revenue Split Rules

Split rules must be versioned:

- Avoid changing old ledger calculations retroactively.
- Store the applied split version on each ledger row.
- Keep a separate `revenue_split_rules` table or immutable config record.

Example split dimensions:

- Author tier.
- Contract type.
- Country/payment provider fee.
- Content type.
- Promotion status.

### Author Dashboard

Future author dashboard should show:

- Estimated pending earnings.
- Available balance.
- Paid balance.
- Current month revenue.
- Top earning books/chapters.
- Refund/adjustment notices.
- Withdrawal eligibility.

The dashboard must label estimated values clearly. Only ledger-settled amounts should be withdrawable.

## 8. Wallet

### Reader Wallet

Reader wallet is optional and high-risk. If introduced, it must be treated as stored value or platform credit depending legal/payment interpretation.

Possible reader wallet models:

- No wallet: direct purchase/subscription only.
- Credit wallet: promotional credits only, non-cash, non-withdrawable.
- Coin wallet: purchased coins for chapter unlocks.

Recommendation:

- Avoid reader wallet in the first monetization phase.
- Start with direct entitlements and subscriptions.
- Add coin wallet only after legal, accounting, refund, and app store policy review.

### Author Wallet

Author wallet is an internal payable balance, not a bank account.

Future tables:

- `author_wallets`
  - `author_id`
  - `pending_balance`
  - `available_balance`
  - `paid_balance`
  - `held_balance`
  - `currency`
  - `updated_at`

- `wallet_transactions`
  - `id`
  - `wallet_id`
  - `type`: `earning`, `refund`, `adjustment`, `hold`, `release`, `withdrawal`
  - `amount`
  - `currency`
  - `ledger_id`
  - `withdrawal_id`
  - `created_at`

Wallet rules:

- Wallet balances derive from immutable ledger/transaction rows.
- Do not allow client-side balance mutation.
- Use database functions or Edge Functions for balance transitions.
- Keep all financial writes idempotent.

## 9. Withdrawals

### Eligibility

Author withdrawals should require:

- Approved author profile.
- Completed payout onboarding.
- Verified legal name and payout method where required.
- Minimum available balance.
- No active fraud, abuse, or policy hold.
- Accepted creator terms.

### Withdrawal Flow

1. Author opens withdrawals page.
2. App shows available balance and minimum threshold.
3. Author submits withdrawal request.
4. Backend freezes requested amount as `held`.
5. Admin or automated payout provider reviews request.
6. Payout is processed.
7. Withdrawal is marked `paid`, `failed`, `cancelled`, or `reversed`.
8. Wallet transaction history updates.

### Required Data Model

Future tables:

- `author_payout_accounts`
  - `id`
  - `author_id`
  - `provider`
  - `provider_account_id`
  - `status`
  - `country`
  - `currency`
  - `created_at`

- `withdrawal_requests`
  - `id`
  - `author_id`
  - `amount`
  - `currency`
  - `status`: `requested`, `under_review`, `approved`, `processing`, `paid`, `failed`, `cancelled`, `reversed`
  - `provider`
  - `provider_payout_id`
  - `admin_notes`
  - `requested_at`
  - `processed_at`

### Controls

- Idempotency key for every payout request.
- Manual admin review for first payout.
- Hold period for new revenue before it becomes available.
- Automatic reversal handling for refunds and chargebacks.
- Full audit log for status changes.

## 10. Security Architecture

Client:

- Can request purchase start.
- Can display entitlement and wallet state.
- Cannot grant entitlements.
- Cannot update ledger, wallet, revenue, or withdrawal rows.

Edge Functions:

- Verify receipts and provider webhooks.
- Create payment intents where allowed.
- Grant entitlements after verified payment.
- Write ledger and wallet transactions.
- Submit withdrawal requests.

Supabase RLS:

- Readers can read their own entitlements and subscriptions.
- Authors can read their own ledger summaries and withdrawal requests.
- Admins can review all monetization records.
- Financial write tables should be server-only.

Secrets:

- Provider secret keys stay in Supabase Edge Function secrets or secure server environment.
- Service role key never appears in Flutter or web client.
- Webhook signing secrets must be validated on every webhook request.

## 11. Compliance And Store Policy

Before implementation:

- Review Apple App Store rules for digital content purchases.
- Review Google Play Billing requirements.
- Decide whether RevenueCat, native store SDKs, Stripe, or a hybrid model is legally allowed.
- Prepare creator terms, payout terms, refund policy, and tax policy.
- Update privacy policy and store privacy labels.
- Confirm regional payment and withdrawal availability.

Do not activate:

- External web checkout from mobile apps for digital content unless policy explicitly permits it.
- Withdrawals before KYC/tax/payout provider readiness.
- Coins before refund/accounting treatment is approved.

## 12. Admin Operations

Admin portal future monetization tools:

- Author monetization approval.
- Premium chapter review.
- Revenue ledger audit.
- Refund and chargeback review.
- Withdrawal review.
- Fraud/risk holds.
- Subscription status lookup.
- Manual entitlement grants with reason logging.

Every admin action must write an audit event containing:

- Admin user ID.
- Target user/author/content.
- Before and after state.
- Reason.
- Timestamp.

## 13. Phased Rollout

Phase M1: Entitlements foundation

- Premium metadata.
- Entitlement checks.
- Admin-only manual grants for testing.
- No real payments.

Phase M2: Subscriptions

- Provider integration.
- Webhooks.
- Subscription entitlement sync.
- Real-device purchase sandbox testing.

Phase M3: Premium chapters

- Paid chapter approval.
- Reader unlock flow.
- Refund entitlement handling.

Phase M4: Author revenue

- Ledger.
- Split rules.
- Author revenue dashboard.
- Admin audit tools.

Phase M5: Withdrawals

- Payout provider.
- Author payout onboarding.
- Withdrawal requests.
- Admin review and payout reconciliation.

Phase M6: Optional wallet/coins

- Only after policy, legal, accounting, and refund model approval.

## 14. Launch Gate For Monetization

Monetization is not ready until all are complete:

- Payment provider selected and contract approved.
- App Store and Google Play compliance reviewed.
- Supabase RLS and server-only financial writes tested.
- Webhooks verified with replay protection and signature validation.
- Entitlement revocation tested for refunds.
- Revenue ledger reconciliation tested.
- Withdrawal policy and payout provider ready.
- Privacy policy, terms, and creator agreement updated.
- Admin support workflow ready.
- Error tracking and financial alerts active.

Final status for this phase:

```text
DESIGNED ONLY - DO NOT IMPLEMENT BEFORE POST-LAUNCH APPROVAL
```
