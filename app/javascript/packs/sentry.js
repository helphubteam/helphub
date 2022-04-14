import * as Sentry from "@sentry/browser";
import { Integrations } from "@sentry/tracing";

if (typeof Sentry !== 'undefined') {
  const sentryMeta = document.querySelector('meta[name="sentry"]');
  if (sentryMeta && sentryMeta.content) {
    Sentry.init({
        dsn: sentryMeta.content,
        integrations: [
            new Integrations.BrowserTracing(),
            new Sentry.Integrations.GlobalHandlers()
        ],
        tracesSampleRate: 1.0,
        environment: window.jsEnv,
        sendDefaultPii: true,
        autoSessionTracking: true
    });
  }
}
