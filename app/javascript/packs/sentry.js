import * as Sentry from "@sentry/browser";
import { Integrations } from "@sentry/tracing";

if (typeof Sentry !== 'undefined') {
  Sentry.init({
      dsn: "https://8e3b0c54e017453aa0852630e8d61231@sentry.ds.agency/4",
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
