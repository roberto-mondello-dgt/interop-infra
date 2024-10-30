GRANT usage ON SCHEMA "interop_dev.domain" TO "interop-be-analytics-domain-consumer-dev-es1";

GRANT usage ON SCHEMA "interop_dev.jwt" TO "interop-be-analytics-jwt-consumer-dev-es1";

GRANT usage ON SCHEMA "tracing_dev.traces" TO "tracing-be-enriched-data-handler-dev-es1";

GRANT usage ON SCHEMA "interop_dev.domain" TO "interop-analytics-readonly";
GRANT SELECT ON ALL TABLES IN SCHEMA "interop_dev.domain" TO "interop-analytics-readonly";
ALTER DEFAULT PRIVILEGES IN SCHEMA "interop_dev.domain" GRANT SELECT ON TABLES TO "interop-analytics-readonly";

GRANT usage ON SCHEMA "interop_dev.jwt" TO "interop-analytics-readonly";
GRANT SELECT ON ALL TABLES IN SCHEMA "interop_dev.jwt" TO "interop-analytics-readonly";
ALTER DEFAULT PRIVILEGES IN SCHEMA "interop_dev.jwt" GRANT SELECT ON TABLES TO "interop-analytics-readonly";

GRANT usage ON SCHEMA "tracing_dev.traces" TO "interop-analytics-readonly";
GRANT SELECT ON ALL TABLES IN SCHEMA "tracing_dev.traces" TO "interop-analytics-readonly";
ALTER DEFAULT PRIVILEGES IN SCHEMA "tracing_dev.traces" GRANT SELECT ON TABLES TO "interop-analytics-readonly";