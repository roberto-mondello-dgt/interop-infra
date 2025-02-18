GRANT usage ON SCHEMA interop_dev.domains TO "interop_be_domains_analytics_writer_dev";

GRANT usage ON SCHEMA interop_dev.jwt TO "interop_be_jwt_audit_analytics_writer_dev";

GRANT usage ON SCHEMA tracing_dev.traces TO "tracing_be_enriched_data_handler_dev";

GRANT usage ON SCHEMA interop_dev.domains TO "interop_analytics_readonly";
GRANT SELECT ON ALL TABLES IN SCHEMA interop_dev.domains TO "interop_analytics_readonly";
ALTER DEFAULT PRIVILEGES IN SCHEMA domains GRANT SELECT ON TABLES TO "interop_analytics_readonly";

GRANT usage ON SCHEMA interop_dev.jwt TO "interop_analytics_readonly";
GRANT SELECT ON ALL TABLES IN SCHEMA interop_dev.jwt TO "interop_analytics_readonly";
ALTER DEFAULT PRIVILEGES IN SCHEMA jwt GRANT SELECT ON TABLES TO "interop_analytics_readonly";

GRANT usage ON SCHEMA tracing_dev.traces TO "interop_analytics_readonly";
GRANT SELECT ON ALL TABLES IN SCHEMA tracing_dev.traces TO "interop_analytics_readonly";
ALTER DEFAULT PRIVILEGES IN SCHEMA traces GRANT SELECT ON TABLES TO "interop_analytics_readonly";

GRANT create ON DATABASE interop_dev TO "lorenzo_giorgi", "eduardo_mihalache", "diego_longo", "roberto_taglioni";

GRANT create, usage ON SCHEMA interop_dev.domains, interop_dev.jwt TO "lorenzo_giorgi", "eduardo_mihalache", "diego_longo", "roberto_taglioni";